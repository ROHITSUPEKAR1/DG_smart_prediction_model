"""
Pydantic v2 request/response schemas for all API endpoints.
"""

from pydantic import BaseModel, Field
from typing import Optional
from datetime import date, datetime


# ─── Student Schemas ───

class StudentCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=200)
    grade: int = Field(..., ge=1, le=12)
    school_name: Optional[str] = None
    age: Optional[int] = Field(None, ge=4, le=25)
    gender: Optional[str] = None
    academic_score: Optional[float] = Field(None, ge=0, le=100)
    subjects: Optional[list[str]] = None


class StudentResponse(BaseModel):
    id: int
    name: str
    grade: int
    grade_group: str
    school_name: Optional[str]
    age: Optional[int]
    gender: Optional[str]
    academic_score: Optional[float]
    subjects: Optional[list[str]]
    created_at: Optional[str]
    updated_at: Optional[str]
    test1_status: Optional[str] = None
    test2_status: Optional[str] = None


class StudentListResponse(BaseModel):
    students: list[StudentResponse]
    total: int


# ─── Test Schemas ───

class TestGenerateRequest(BaseModel):
    student_id: int
    test_number: int = Field(..., ge=1, le=2)


class QuestionResponse(BaseModel):
    id: int
    question_text: str
    question_category: Optional[str]
    question_type: Optional[str]
    options: Optional[list[str]]
    is_from_previous_interest: bool = False
    sequence_number: Optional[int]


class TestResponse(BaseModel):
    id: int
    student_id: int
    test_number: int
    test_type: str
    status: str
    scheduled_date: str
    completed_at: Optional[str]
    questions: list[QuestionResponse] = []


class AnswerSubmission(BaseModel):
    question_id: int
    answer_text: Optional[str] = None
    selected_option: Optional[str] = None


class SubmitAnswersRequest(BaseModel):
    test_id: int
    student_id: int
    answers: list[AnswerSubmission]


# ─── Interest Analysis Schema ───

class InterestAnalysisResponse(BaseModel):
    id: int
    student_id: int
    test_id: int
    primary_interest: Optional[str]
    secondary_interests: Optional[list[str]]
    personality_traits: Optional[list[str]]
    learning_style: Optional[str]
    strength_areas: Optional[list[str]]
    weakness_areas: Optional[list[str]]
    psychology_analysis: Optional[str]
    confidence_score: Optional[float]
    analyzed_at: Optional[str]


# ─── Career Prediction Schema ───

class CareerOptionDetail(BaseModel):
    title: str
    description: str
    probability: float
    required_skills: Optional[list[str]] = []
    roadmap: Optional[list[str]] = []
    salary_range: Optional[str] = ""
    top_colleges: Optional[list[str]] = []


class CareerPredictionResponse(BaseModel):
    id: int
    student_id: int
    test_id: int
    career_options: list[CareerOptionDetail] = []
    future_prediction: Optional[str]
    roadmap: Optional[list[str]]
    predicted_at: Optional[str]


# ─── Report Schema ───

class ReportResponse(BaseModel):
    id: int
    student_id: int
    test_id: int
    report_type: Optional[str]
    report_data: Optional[dict] = None
    summary: Optional[str]
    generated_at: Optional[str]


# ─── Submit Result Schema ───

class SubmitResultResponse(BaseModel):
    message: str
    test_id: int
    student_id: int
    interest_analysis: Optional[InterestAnalysisResponse] = None
    career_predictions: Optional[CareerPredictionResponse] = None
    report: Optional[ReportResponse] = None


# ─── Dashboard Stats Schema ───

class DashboardStats(BaseModel):
    total_students: int
    tests_completed: int
    reports_generated: int
    tests_pending: int
