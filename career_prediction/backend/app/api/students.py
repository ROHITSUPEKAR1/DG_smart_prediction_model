"""
Student CRUD API routes.
"""

import json
from datetime import date, timedelta
from fastapi import APIRouter, Depends, HTTPException
import aiosqlite

from app.db.db import get_db
from app.models.schemas import StudentCreate, StudentResponse, StudentListResponse, DashboardStats
from app.services.groq_service import get_grade_group

router = APIRouter(prefix="/api/students", tags=["Students"])


@router.post("/", response_model=dict)
async def register_student(student: StudentCreate, db: aiosqlite.Connection = Depends(get_db)):
    """Register a new student and auto-create Test 1 (today) and Test 2 (+15 days)."""
    
    grade_group = get_grade_group(student.grade)
    subjects_json = json.dumps(student.subjects) if student.subjects else "[]"

    # Duplicate check
    cursor = await db.execute(
        "SELECT id FROM students WHERE name = ? AND grade = ? AND school_name = ?",
        (student.name, student.grade, student.school_name or "")
    )
    existing = await cursor.fetchone()
    if existing:
        raise HTTPException(status_code=400, detail="A student with the same name, grade, and school already exists.")

    # Insert student
    cursor = await db.execute(
        """INSERT INTO students (name, grade, grade_group, school_name, age, gender, academic_score, subjects)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
        (student.name, student.grade, grade_group, student.school_name,
         student.age, student.gender, student.academic_score, subjects_json)
    )
    student_id = cursor.lastrowid

    # Auto-create Test 1 (today) and Test 2 (+15 days)
    today = date.today()
    test2_date = today + timedelta(days=15)

    await db.execute(
        """INSERT INTO tests (student_id, test_number, test_type, status, scheduled_date)
           VALUES (?, 1, 'interest_discovery', 'pending', ?)""",
        (student_id, today.isoformat())
    )
    await db.execute(
        """INSERT INTO tests (student_id, test_number, test_type, status, scheduled_date)
           VALUES (?, 2, 'follow_up', 'pending', ?)""",
        (student_id, test2_date.isoformat())
    )

    await db.commit()

    return {
        "message": "Student registered successfully",
        "student_id": student_id,
        "test1_date": today.isoformat(),
        "test2_date": test2_date.isoformat()
    }


@router.get("/", response_model=StudentListResponse)
async def list_students(db: aiosqlite.Connection = Depends(get_db)):
    """List all students with their test statuses."""
    
    cursor = await db.execute("""
        SELECT s.*,
               (SELECT t.status FROM tests t WHERE t.student_id = s.id AND t.test_number = 1 LIMIT 1) as test1_status,
               (SELECT t.status FROM tests t WHERE t.student_id = s.id AND t.test_number = 2 LIMIT 1) as test2_status
        FROM students s
        ORDER BY s.created_at DESC
    """)
    rows = await cursor.fetchall()

    students = []
    for row in rows:
        subjects = []
        try:
            subjects = json.loads(row["subjects"]) if row["subjects"] else []
        except (json.JSONDecodeError, TypeError):
            subjects = []

        students.append(StudentResponse(
            id=row["id"],
            name=row["name"],
            grade=row["grade"],
            grade_group=row["grade_group"],
            school_name=row["school_name"],
            age=row["age"],
            gender=row["gender"],
            academic_score=row["academic_score"],
            subjects=subjects,
            created_at=row["created_at"],
            updated_at=row["updated_at"],
            test1_status=row["test1_status"],
            test2_status=row["test2_status"]
        ))

    return StudentListResponse(students=students, total=len(students))


@router.get("/dashboard-stats", response_model=DashboardStats)
async def get_dashboard_stats(db: aiosqlite.Connection = Depends(get_db)):
    """Get dashboard statistics."""
    cursor = await db.execute("SELECT COUNT(*) FROM students")
    total_students = (await cursor.fetchone())[0]

    cursor = await db.execute("SELECT COUNT(*) FROM tests WHERE status = 'completed'")
    tests_completed = (await cursor.fetchone())[0]

    cursor = await db.execute("SELECT COUNT(*) FROM reports")
    reports_generated = (await cursor.fetchone())[0]

    cursor = await db.execute("SELECT COUNT(*) FROM tests WHERE status = 'pending'")
    tests_pending = (await cursor.fetchone())[0]

    return DashboardStats(
        total_students=total_students,
        tests_completed=tests_completed,
        reports_generated=reports_generated,
        tests_pending=tests_pending
    )


@router.get("/{student_id}", response_model=dict)
async def get_student(student_id: int, db: aiosqlite.Connection = Depends(get_db)):
    """Get student profile with test history, interest analysis, and career predictions."""
    
    cursor = await db.execute("SELECT * FROM students WHERE id = ?", (student_id,))
    student = await cursor.fetchone()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    subjects = []
    try:
        subjects = json.loads(student["subjects"]) if student["subjects"] else []
    except (json.JSONDecodeError, TypeError):
        subjects = []

    # Get tests
    cursor = await db.execute(
        "SELECT * FROM tests WHERE student_id = ? ORDER BY test_number", (student_id,)
    )
    tests = [dict(row) for row in await cursor.fetchall()]

    # Get interest analyses
    cursor = await db.execute(
        "SELECT * FROM interest_analysis WHERE student_id = ? ORDER BY analyzed_at DESC", (student_id,)
    )
    analyses_rows = await cursor.fetchall()
    analyses = []
    for row in analyses_rows:
        analysis = dict(row)
        for key in ["secondary_interests", "personality_traits", "strength_areas", "weakness_areas"]:
            try:
                analysis[key] = json.loads(analysis[key]) if analysis[key] else []
            except (json.JSONDecodeError, TypeError):
                analysis[key] = []
        analyses.append(analysis)

    # Get career predictions
    cursor = await db.execute(
        "SELECT * FROM career_predictions WHERE student_id = ? ORDER BY predicted_at DESC", (student_id,)
    )
    predictions_rows = await cursor.fetchall()
    predictions = []
    for row in predictions_rows:
        pred = dict(row)
        try:
            pred["roadmap"] = json.loads(pred["roadmap"]) if pred["roadmap"] else []
        except (json.JSONDecodeError, TypeError):
            pred["roadmap"] = []
        predictions.append(pred)

    return {
        "id": student["id"],
        "name": student["name"],
        "grade": student["grade"],
        "grade_group": student["grade_group"],
        "school_name": student["school_name"],
        "age": student["age"],
        "gender": student["gender"],
        "academic_score": student["academic_score"],
        "subjects": subjects,
        "created_at": student["created_at"],
        "updated_at": student["updated_at"],
        "tests": tests,
        "interest_analyses": analyses,
        "career_predictions": predictions
    }


@router.delete("/{student_id}")
async def delete_student(student_id: int, db: aiosqlite.Connection = Depends(get_db)):
    """Delete a student and all cascaded data."""
    cursor = await db.execute("SELECT id FROM students WHERE id = ?", (student_id,))
    if not await cursor.fetchone():
        raise HTTPException(status_code=404, detail="Student not found")

    await db.execute("DELETE FROM students WHERE id = ?", (student_id,))
    await db.commit()
    return {"message": "Student and all related data deleted successfully"}
