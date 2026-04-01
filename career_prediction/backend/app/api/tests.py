"""
Test generation, answer submission, and AI analysis pipeline.
"""

import json
from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException
import aiosqlite

from app.db.db import get_db
from app.models.schemas import TestGenerateRequest, SubmitAnswersRequest, TestResponse, QuestionResponse
from app.services.groq_service import (
    generate_test1_questions,
    generate_test2_questions,
    analyze_student_psychology,
    predict_career_options,
    generate_report_summary,
    get_grade_group
)

router = APIRouter(prefix="/api/tests", tags=["Tests"])


@router.post("/generate", response_model=dict)
async def generate_test_questions(req: TestGenerateRequest, db: aiosqlite.Connection = Depends(get_db)):
    """Generate AI questions for Test 1 or Test 2."""

    # Get student
    cursor = await db.execute("SELECT * FROM students WHERE id = ?", (req.student_id,))
    student = await cursor.fetchone()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    # Get the test record
    cursor = await db.execute(
        "SELECT * FROM tests WHERE student_id = ? AND test_number = ?",
        (req.student_id, req.test_number)
    )
    test = await cursor.fetchone()
    if not test:
        raise HTTPException(status_code=404, detail=f"Test {req.test_number} not found for this student")

    test_id = test["id"]

    # Check if questions already exist (idempotent)
    cursor = await db.execute("SELECT COUNT(*) FROM questions WHERE test_id = ?", (test_id,))
    existing_count = (await cursor.fetchone())[0]
    if existing_count > 0:
        # Return existing questions
        cursor = await db.execute(
            "SELECT * FROM questions WHERE test_id = ? ORDER BY sequence_number", (test_id,)
        )
        questions = []
        for row in await cursor.fetchall():
            options = None
            try:
                options = json.loads(row["options"]) if row["options"] else None
            except (json.JSONDecodeError, TypeError):
                options = None
            questions.append({
                "id": row["id"],
                "question_text": row["question_text"],
                "question_category": row["question_category"],
                "question_type": row["question_type"],
                "options": options,
                "is_from_previous_interest": bool(row["is_from_previous_interest"]),
                "sequence_number": row["sequence_number"]
            })
        return {"test_id": test_id, "test_number": req.test_number, "questions": questions, "status": "existing"}

    # Parse student data
    subjects = []
    try:
        subjects = json.loads(student["subjects"]) if student["subjects"] else []
    except (json.JSONDecodeError, TypeError):
        subjects = []

    grade_group = student["grade_group"]
    academic_score = student["academic_score"] or 0

    if req.test_number == 2:
        # Test 2 requires Test 1 completed
        cursor = await db.execute(
            "SELECT status FROM tests WHERE student_id = ? AND test_number = 1",
            (req.student_id,)
        )
        test1 = await cursor.fetchone()
        if not test1 or test1["status"] != "completed":
            raise HTTPException(status_code=400, detail="Test 1 must be completed before generating Test 2")

        # Fetch Test 1 interest analysis
        cursor = await db.execute(
            "SELECT * FROM interest_analysis WHERE student_id = ? ORDER BY analyzed_at DESC LIMIT 1",
            (req.student_id,)
        )
        analysis = await cursor.fetchone()
        if not analysis:
            raise HTTPException(status_code=400, detail="No interest analysis found from Test 1")

        primary_interest = analysis["primary_interest"] or "General"
        secondary_interests = []
        try:
            secondary_interests = json.loads(analysis["secondary_interests"]) if analysis["secondary_interests"] else []
        except (json.JSONDecodeError, TypeError):
            secondary_interests = []

        # Generate Test 2 questions
        try:
            ai_questions = generate_test2_questions(
                student_name=student["name"],
                grade=student["grade"],
                grade_group=grade_group,
                previous_interests=secondary_interests,
                primary_interest=primary_interest
            )
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"AI question generation failed: {str(e)}")
    else:
        # Generate Test 1 questions
        try:
            ai_questions = generate_test1_questions(
                student_name=student["name"],
                grade=student["grade"],
                grade_group=grade_group,
                subjects=subjects,
                academic_score=academic_score
            )
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"AI question generation failed: {str(e)}")

    # Save questions to DB
    saved_questions = []
    for i, q in enumerate(ai_questions):
        options_json = json.dumps(q.get("options")) if q.get("options") else None
        is_prev = 1 if q.get("is_from_previous_interest", False) else 0
        seq = q.get("sequence_number", i + 1)

        cursor = await db.execute(
            """INSERT INTO questions (test_id, student_id, question_text, question_category, 
               question_type, options, is_from_previous_interest, sequence_number)
               VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
            (test_id, req.student_id, q.get("question_text", ""),
             q.get("question_category", "general"), q.get("question_type", "mcq"),
             options_json, is_prev, seq)
        )
        q_id = cursor.lastrowid
        saved_questions.append({
            "id": q_id,
            "question_text": q.get("question_text", ""),
            "question_category": q.get("question_category", "general"),
            "question_type": q.get("question_type", "mcq"),
            "options": q.get("options"),
            "is_from_previous_interest": bool(is_prev),
            "sequence_number": seq
        })

    # Update test status
    await db.execute(
        "UPDATE tests SET status = 'in_progress' WHERE id = ?", (test_id,)
    )
    await db.commit()

    return {"test_id": test_id, "test_number": req.test_number, "questions": saved_questions, "status": "generated"}


@router.post("/submit-answers", response_model=dict)
async def submit_answers(req: SubmitAnswersRequest, db: aiosqlite.Connection = Depends(get_db)):
    """Submit all answers, trigger AI analysis pipeline, and return results."""

    # Step 1: Verify test
    cursor = await db.execute(
        "SELECT * FROM tests WHERE id = ? AND student_id = ?",
        (req.test_id, req.student_id)
    )
    test = await cursor.fetchone()
    if not test:
        raise HTTPException(status_code=404, detail="Test not found for this student")

    test_number = test["test_number"]

    # Get student
    cursor = await db.execute("SELECT * FROM students WHERE id = ?", (req.student_id,))
    student = await cursor.fetchone()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    subjects = []
    try:
        subjects = json.loads(student["subjects"]) if student["subjects"] else []
    except (json.JSONDecodeError, TypeError):
        subjects = []

    # Step 2: Save all answers
    for ans in req.answers:
        score = None
        if ans.selected_option and ans.selected_option.isdigit():
            score = int(ans.selected_option)
        
        await db.execute(
            """INSERT INTO answers (question_id, test_id, student_id, answer_text, selected_option, answer_score)
               VALUES (?, ?, ?, ?, ?, ?)""",
            (ans.question_id, req.test_id, req.student_id,
             ans.answer_text, ans.selected_option, score)
        )
    await db.commit()

    # Step 3: Fetch all Q&A for this test
    cursor = await db.execute(
        """SELECT q.question_text, q.question_category, q.question_type,
                  a.answer_text, a.selected_option
           FROM questions q
           JOIN answers a ON q.id = a.question_id
           WHERE q.test_id = ? AND a.test_id = ?
           ORDER BY q.sequence_number""",
        (req.test_id, req.test_id)
    )
    qa_rows = await cursor.fetchall()
    qa_list = [dict(row) for row in qa_rows]

    # Step 4: Psychology Analysis (Groq AI)
    try:
        psychology_result = analyze_student_psychology(
            student_name=student["name"],
            grade=student["grade"],
            grade_group=student["grade_group"],
            academic_score=student["academic_score"] or 0,
            qa_list=qa_list,
            test_number=test_number
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Psychology analysis failed: {str(e)}")

    # Step 5: Save interest analysis
    cursor = await db.execute(
        """INSERT INTO interest_analysis 
           (student_id, test_id, primary_interest, secondary_interests, personality_traits,
            learning_style, strength_areas, weakness_areas, psychology_analysis, confidence_score)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
        (req.student_id, req.test_id,
         psychology_result.get("primary_interest", ""),
         json.dumps(psychology_result.get("secondary_interests", [])),
         json.dumps(psychology_result.get("personality_traits", [])),
         psychology_result.get("learning_style", ""),
         json.dumps(psychology_result.get("strength_areas", [])),
         json.dumps(psychology_result.get("weakness_areas", [])),
         psychology_result.get("psychology_analysis", ""),
         psychology_result.get("confidence_score", 0))
    )
    analysis_id = cursor.lastrowid
    await db.commit()

    # Step 6: Career Prediction (Groq AI)
    try:
        career_result = predict_career_options(
            student_name=student["name"],
            grade=student["grade"],
            grade_group=student["grade_group"],
            academic_score=student["academic_score"] or 0,
            subjects=subjects,
            primary_interest=psychology_result.get("primary_interest", "General"),
            secondary_interests=psychology_result.get("secondary_interests", []),
            personality_traits=psychology_result.get("personality_traits", []),
            strength_areas=psychology_result.get("strength_areas", [])
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Career prediction failed: {str(e)}")

    # Step 7: Save career predictions
    career_options = career_result.get("career_options", [])
    while len(career_options) < 3:
        career_options.append({"title": "Exploring...", "description": "", "probability": 0})

    cursor = await db.execute(
        """INSERT INTO career_predictions
           (student_id, test_id, career_option_1, career_desc_1, career_probability_1,
            career_option_2, career_desc_2, career_probability_2,
            career_option_3, career_desc_3, career_probability_3,
            future_prediction, roadmap)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
        (req.student_id, req.test_id,
         career_options[0].get("title", ""), career_options[0].get("description", ""),
         career_options[0].get("probability", 0),
         career_options[1].get("title", ""), career_options[1].get("description", ""),
         career_options[1].get("probability", 0),
         career_options[2].get("title", ""), career_options[2].get("description", ""),
         career_options[2].get("probability", 0),
         career_result.get("future_prediction", ""),
         json.dumps(career_result.get("immediate_action_items", [])))
    )
    prediction_id = cursor.lastrowid
    await db.commit()

    # Step 8: Generate report summary
    try:
        previous_report = None
        if test_number == 2:
            cursor = await db.execute(
                """SELECT ia.primary_interest, cp.career_option_1 as top_career
                   FROM interest_analysis ia
                   JOIN career_predictions cp ON ia.student_id = cp.student_id AND ia.test_id = cp.test_id
                   WHERE ia.student_id = ? AND ia.test_id != ?
                   ORDER BY ia.analyzed_at ASC LIMIT 1""",
                (req.student_id, req.test_id)
            )
            prev_row = await cursor.fetchone()
            if prev_row:
                previous_report = dict(prev_row)

        report_summary = generate_report_summary(
            student_name=student["name"],
            grade=student["grade"],
            test_number=test_number,
            interest_analysis=psychology_result,
            career_predictions=career_result,
            previous_report=previous_report
        )
    except Exception as e:
        report_summary = f"Report generation encountered an issue: {str(e)}"

    # Step 9: Save report
    report_type = "test1_report" if test_number == 1 else "test2_report"
    full_report_data = {
        "student": {"name": student["name"], "grade": student["grade"], "grade_group": student["grade_group"]},
        "interest_analysis": psychology_result,
        "career_predictions": career_result,
        "test_number": test_number
    }

    cursor = await db.execute(
        """INSERT INTO reports (student_id, test_id, report_type, report_data, summary)
           VALUES (?, ?, ?, ?, ?)""",
        (req.student_id, req.test_id, report_type,
         json.dumps(full_report_data), report_summary)
    )
    report_id = cursor.lastrowid

    # Step 10: Update test status
    await db.execute(
        "UPDATE tests SET status = 'completed', completed_at = ? WHERE id = ?",
        (datetime.now().isoformat(), req.test_id)
    )
    await db.commit()

    # Step 11: Return complete result
    return {
        "message": "Test submitted and analyzed successfully!",
        "test_id": req.test_id,
        "student_id": req.student_id,
        "interest_analysis": {
            "id": analysis_id,
            **psychology_result
        },
        "career_predictions": {
            "id": prediction_id,
            "career_options": career_options,
            "future_prediction": career_result.get("future_prediction", ""),
            "immediate_action_items": career_result.get("immediate_action_items", [])
        },
        "report": {
            "id": report_id,
            "report_type": report_type,
            "summary": report_summary
        }
    }


@router.get("/{test_id}", response_model=dict)
async def get_test(test_id: int, db: aiosqlite.Connection = Depends(get_db)):
    """Get test with all questions."""
    cursor = await db.execute("SELECT * FROM tests WHERE id = ?", (test_id,))
    test = await cursor.fetchone()
    if not test:
        raise HTTPException(status_code=404, detail="Test not found")

    cursor = await db.execute(
        "SELECT * FROM questions WHERE test_id = ? ORDER BY sequence_number", (test_id,)
    )
    questions = []
    for row in await cursor.fetchall():
        options = None
        try:
            options = json.loads(row["options"]) if row["options"] else None
        except (json.JSONDecodeError, TypeError):
            options = None
        questions.append({
            "id": row["id"],
            "question_text": row["question_text"],
            "question_category": row["question_category"],
            "question_type": row["question_type"],
            "options": options,
            "is_from_previous_interest": bool(row["is_from_previous_interest"]),
            "sequence_number": row["sequence_number"]
        })

    return {
        "id": test["id"],
        "student_id": test["student_id"],
        "test_number": test["test_number"],
        "test_type": test["test_type"],
        "status": test["status"],
        "scheduled_date": test["scheduled_date"],
        "completed_at": test["completed_at"],
        "questions": questions
    }


@router.get("/student/{student_id}", response_model=list)
async def get_student_tests(student_id: int, db: aiosqlite.Connection = Depends(get_db)):
    """Get all tests for a student."""
    cursor = await db.execute(
        "SELECT * FROM tests WHERE student_id = ? ORDER BY test_number", (student_id,)
    )
    tests = [dict(row) for row in await cursor.fetchall()]
    return tests
