"""
Antigravity — Student Career Prediction AI
FastAPI Application Entry Point
"""

from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.db.db import init_db
from app.api import students, tests, reports, careers


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Initialize database on startup."""
    await init_db()
    yield


app = FastAPI(
    title="Antigravity — Career Prediction AI",
    description="AI-powered career counseling and prediction platform for students Grade 1-12",
    version="1.0.0",
    lifespan=lifespan
)

# CORS — allow frontend dev server
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register routers
app.include_router(students.router)
app.include_router(tests.router)
app.include_router(reports.router)
app.include_router(careers.router)


@app.get("/")
async def root():
    return {
        "app": "Antigravity — Career Prediction AI",
        "version": "1.0.0",
        "docs": "/docs",
        "status": "running"
    }


@app.get("/api/health")
async def health_check():
    return {"status": "healthy"}
