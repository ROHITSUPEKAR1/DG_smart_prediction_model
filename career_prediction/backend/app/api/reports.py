"""
Report retrieval API routes.
"""

import json
from fastapi import APIRouter, Depends, HTTPException
import aiosqlite

from app.db.db import get_db

router = APIRouter(prefix="/api/reports", tags=["Reports"])


@router.get("/student/{student_id}", response_model=list)
async def get_student_reports(student_id: int, db: aiosqlite.Connection = Depends(get_db)):
    """Get all reports for a student."""
    cursor = await db.execute(
        "SELECT * FROM reports WHERE student_id = ? ORDER BY generated_at DESC",
        (student_id,)
    )
    reports = []
    for row in await cursor.fetchall():
        report = dict(row)
        try:
            report["report_data"] = json.loads(report["report_data"]) if report["report_data"] else None
        except (json.JSONDecodeError, TypeError):
            report["report_data"] = None
        reports.append(report)
    return reports


@router.get("/{report_id}", response_model=dict)
async def get_report(report_id: int, db: aiosqlite.Connection = Depends(get_db)):
    """Get a specific report by ID."""
    cursor = await db.execute("SELECT * FROM reports WHERE id = ?", (report_id,))
    row = await cursor.fetchone()
    if not row:
        raise HTTPException(status_code=404, detail="Report not found")

    report = dict(row)
    try:
        report["report_data"] = json.loads(report["report_data"]) if report["report_data"] else None
    except (json.JSONDecodeError, TypeError):
        report["report_data"] = None
    return report


@router.get("/student/{student_id}/combined", response_model=dict)
async def get_combined_report(student_id: int, db: aiosqlite.Connection = Depends(get_db)):
    """Get combined Test 1 + Test 2 comparison report."""

    # Get student info
    cursor = await db.execute("SELECT * FROM students WHERE id = ?", (student_id,))
    student = await cursor.fetchone()
    if not student:
        raise HTTPException(status_code=404, detail="Student not found")

    subjects = []
    try:
        subjects = json.loads(student["subjects"]) if student["subjects"] else []
    except (json.JSONDecodeError, TypeError):
        subjects = []

    # Get all interest analyses
    cursor = await db.execute(
        "SELECT * FROM interest_analysis WHERE student_id = ? ORDER BY analyzed_at ASC",
        (student_id,)
    )
    analyses = []
    for row in await cursor.fetchall():
        analysis = dict(row)
        for key in ["secondary_interests", "personality_traits", "strength_areas", "weakness_areas"]:
            try:
                analysis[key] = json.loads(analysis[key]) if analysis[key] else []
            except (json.JSONDecodeError, TypeError):
                analysis[key] = []
        analyses.append(analysis)

    # Get all career predictions
    cursor = await db.execute(
        "SELECT * FROM career_predictions WHERE student_id = ? ORDER BY predicted_at ASC",
        (student_id,)
    )
    predictions = []
    for row in await cursor.fetchall():
        pred = dict(row)
        try:
            pred["roadmap"] = json.loads(pred["roadmap"]) if pred["roadmap"] else []
        except (json.JSONDecodeError, TypeError):
            pred["roadmap"] = []
        predictions.append(pred)

    # Get all reports
    cursor = await db.execute(
        "SELECT * FROM reports WHERE student_id = ? ORDER BY generated_at ASC",
        (student_id,)
    )
    reports = []
    for row in await cursor.fetchall():
        report = dict(row)
        try:
            report["report_data"] = json.loads(report["report_data"]) if report["report_data"] else None
        except (json.JSONDecodeError, TypeError):
            report["report_data"] = None
        reports.append(report)

    # Build comparison
    test1_analysis = analyses[0] if len(analyses) > 0 else None
    test2_analysis = analyses[1] if len(analyses) > 1 else None

    interest_progression = None
    if test1_analysis and test2_analysis:
        interest_progression = {
            "test1_primary": test1_analysis.get("primary_interest"),
            "test2_primary": test2_analysis.get("primary_interest"),
            "interest_changed": test1_analysis.get("primary_interest") != test2_analysis.get("primary_interest"),
            "confidence_change": (test2_analysis.get("confidence_score", 0) or 0) - (test1_analysis.get("confidence_score", 0) or 0)
        }

    return {
        "student": {
            "id": student["id"],
            "name": student["name"],
            "grade": student["grade"],
            "grade_group": student["grade_group"],
            "school_name": student["school_name"],
            "subjects": subjects
        },
        "test1_analysis": test1_analysis,
        "test2_analysis": test2_analysis,
        "interest_progression": interest_progression,
        "career_predictions": predictions,
        "reports": reports
    }
