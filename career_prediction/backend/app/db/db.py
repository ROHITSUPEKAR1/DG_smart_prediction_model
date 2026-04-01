"""
Database initialization and connection management for SQLite.
Uses aiosqlite for async operations with WAL journal mode.
"""

import os
import aiosqlite

DB_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(DB_DIR, "career_prediction.db")

SQL_CREATE_TABLES = """
PRAGMA journal_mode=WAL;
PRAGMA foreign_keys=ON;

CREATE TABLE IF NOT EXISTS students (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    name            TEXT NOT NULL,
    grade           INTEGER NOT NULL,
    grade_group     TEXT NOT NULL,
    school_name     TEXT,
    age             INTEGER,
    gender          TEXT,
    academic_score  REAL,
    subjects        TEXT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tests (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id      INTEGER NOT NULL,
    test_number     INTEGER NOT NULL,
    test_type       TEXT NOT NULL,
    status          TEXT DEFAULT 'pending',
    scheduled_date  DATE NOT NULL,
    completed_at    TIMESTAMP,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS questions (
    id                          INTEGER PRIMARY KEY AUTOINCREMENT,
    test_id                     INTEGER NOT NULL,
    student_id                  INTEGER NOT NULL,
    question_text               TEXT NOT NULL,
    question_category           TEXT,
    question_type               TEXT,
    options                     TEXT,
    is_from_previous_interest   INTEGER DEFAULT 0,
    sequence_number             INTEGER,
    created_at                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (test_id) REFERENCES tests(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS answers (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    question_id     INTEGER NOT NULL,
    test_id         INTEGER NOT NULL,
    student_id      INTEGER NOT NULL,
    answer_text     TEXT,
    selected_option TEXT,
    answer_score    INTEGER,
    answered_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE,
    FOREIGN KEY (test_id) REFERENCES tests(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS interest_analysis (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id          INTEGER NOT NULL,
    test_id             INTEGER NOT NULL,
    primary_interest    TEXT,
    secondary_interests TEXT,
    personality_traits  TEXT,
    learning_style      TEXT,
    strength_areas      TEXT,
    weakness_areas      TEXT,
    psychology_analysis TEXT,
    confidence_score    REAL,
    analyzed_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (test_id) REFERENCES tests(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS career_predictions (
    id                    INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id            INTEGER NOT NULL,
    test_id               INTEGER NOT NULL,
    career_option_1       TEXT NOT NULL,
    career_desc_1         TEXT,
    career_probability_1  REAL,
    career_option_2       TEXT NOT NULL,
    career_desc_2         TEXT,
    career_probability_2  REAL,
    career_option_3       TEXT NOT NULL,
    career_desc_3         TEXT,
    career_probability_3  REAL,
    future_prediction     TEXT,
    roadmap               TEXT,
    predicted_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (test_id) REFERENCES tests(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS reports (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id    INTEGER NOT NULL,
    test_id       INTEGER NOT NULL,
    report_type   TEXT,
    report_data   TEXT,
    summary       TEXT,
    generated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (test_id) REFERENCES tests(id) ON DELETE CASCADE
);
"""


async def init_db():
    """Initialize the database and create all tables."""
    async with aiosqlite.connect(DB_PATH) as db:
        await db.executescript(SQL_CREATE_TABLES)
        await db.commit()
    print(f"✅ Database initialized at {DB_PATH}")


async def get_db():
    """Dependency: yields an async database connection."""
    db = await aiosqlite.connect(DB_PATH)
    db.row_factory = aiosqlite.Row
    await db.execute("PRAGMA foreign_keys=ON")
    try:
        yield db
    finally:
        await db.close()
