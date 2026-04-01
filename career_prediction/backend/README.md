# 🚀 Antigravity — Student Career Prediction AI

AI-powered career counseling and prediction platform for students from Grade 1 to Grade 12.

## ✨ Features

- **Two-Test Psychometric System** — Interest Discovery (Test 1) + Follow-Up Validation (Test 2)
- **AI-Powered Analysis** — Groq LLaMA 3.3 70B generates questions, analyzes psychology, and predicts careers
- **20 Questions per Test** — Mix of MCQ, Scale (1-5), and Open-Ended questions
- **Psychology Analysis** — Primary/secondary interests, personality traits, learning style, strengths/weaknesses
- **Career Predictions** — 3 ranked career options with roadmaps, salary ranges, and top Indian colleges
- **Beautiful Dashboard** — Premium dark UI with glassmorphism and micro-animations

## 🏗️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | React 18 + Vite |
| Backend | FastAPI (Python 3.10+) |
| Database | SQLite (async via aiosqlite) |
| AI Model | Groq LLaMA 3.3 70B Versatile |
| Styling | Custom CSS Design System |

## 🚀 Quick Start

### 1. Backend Setup

```bash
cd career_prediction

# Install dependencies
pip install -r requirements.txt

# Set your Groq API key
# Edit .env file and replace with your actual key from console.groq.com
# GROQ_API_KEY=gsk_your_actual_key_here

# Start backend server
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

API docs available at: http://localhost:8000/docs

### 2. Frontend Setup

```bash
cd career_prediction/frontend

# Install dependencies (already done if you cloned fresh)
npm install

# Start dev server
npm run dev
```

App available at: http://localhost:5173

## 📂 Project Structure

```
career_prediction/
├── main.py                    # FastAPI entry point
├── requirements.txt           # Python dependencies
├── .env                       # Environment variables
├── database/
│   ├── db.py                  # DB init, schema, connection management
│   └── career_prediction.db   # Auto-created SQLite database
├── app/
│   ├── api/
│   │   ├── students.py        # CRUD + dashboard stats
│   │   ├── tests.py           # Question generation + answer submission pipeline
│   │   ├── reports.py         # Report retrieval + combined reports
│   │   └── careers.py         # Career predictions + interest history
│   ├── models/
│   │   └── schemas.py         # Pydantic v2 request/response models
│   └── services/
│       └── groq_service.py    # All Groq AI interactions (5 functions)
└── frontend/
    ├── src/
    │   ├── App.jsx            # Router + layout
    │   ├── index.css          # Complete design system
    │   ├── api/               # Axios API layer
    │   ├── context/           # React Context (global state)
    │   ├── components/        # Layout + common components
    │   └── pages/             # Dashboard, Students, Tests, Reports
    └── package.json
```

## 🔑 Environment Variables

### Backend (.env)
```
GROQ_API_KEY=gsk_your_groq_api_key_here
```

### Frontend (.env)
```
VITE_API_BASE_URL=http://localhost:8000
```

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/students/` | Register student (auto-creates 2 tests) |
| GET | `/api/students/` | List all students |
| GET | `/api/students/{id}` | Student profile + full history |
| GET | `/api/students/dashboard-stats` | Dashboard statistics |
| DELETE | `/api/students/{id}` | Delete student + cascade |
| POST | `/api/tests/generate` | Generate AI questions for test |
| POST | `/api/tests/submit-answers` | Submit answers → full AI pipeline |
| GET | `/api/tests/{id}` | Get test with questions |
| GET | `/api/reports/student/{id}` | All reports for student |
| GET | `/api/reports/student/{id}/combined` | Test 1 vs Test 2 comparison |
| GET | `/api/careers/student/{id}` | All career predictions |
| GET | `/api/careers/student/{id}/interest-history` | Interest analysis history |

## 🤖 AI Pipeline (on answer submission)

1. Save all answers to database
2. 🧠 Analyze student psychology (Groq AI)
3. 🚀 Predict 3 career options with roadmaps (Groq AI)
4. 📄 Generate human-readable report summary (Groq AI)
5. Update test status to completed

## License

Part of the Antigravity ERP Suite. Internal use only.
