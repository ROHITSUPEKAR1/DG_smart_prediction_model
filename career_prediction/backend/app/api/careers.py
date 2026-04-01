"""
Career predictions and interest history API routes.
"""

import json
from fastapi import APIRouter, Depends, HTTPException
import aiosqlite

from app.db.db import get_db

router = APIRouter(prefix="/api/careers", tags=["Careers"])


@router.get("/student/{student_id}", response_model=list)
async def get_student_careers(student_id: int, db: aiosqlite.Connection = Depends(get_db)):
    """Get all career predictions for a student across all tests."""
    cursor = await db.execute(
        "SELECT * FROM career_predictions WHERE student_id = ? ORDER BY predicted_at DESC",
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
    return predictions


@router.get("/student/{student_id}/interest-history", response_model=list)
async def get_interest_history(student_id: int, db: aiosqlite.Connection = Depends(get_db)):
    """Get full interest analysis history for a student."""
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
    return analyses
