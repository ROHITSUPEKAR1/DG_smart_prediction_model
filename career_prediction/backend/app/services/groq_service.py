"""
Groq AI Service — All LLM interactions for career prediction.
Uses llama-3.3-70b-versatile model via the Groq Python SDK.
"""

import os
import json
import re
from dotenv import load_dotenv

load_dotenv()

MODEL = "llama-3.3-70b-versatile"
_client = None
IS_MOCK = os.getenv("MOCK_AI", "false").lower() == "true" or \
          os.getenv("GROQ_API_KEY") in [None, "", "gsk_your_groq_api_key_here"]


def _get_client():
    """Lazy initialization of the Groq client."""
    global _client
    if IS_MOCK:
        return None
    if _client is None:
        from groq import Groq
        _client = Groq(api_key=os.getenv("GROQ_API_KEY"))
    return _client


def _clean_json_response(text: str) -> str:
    """Strip markdown code fences and extra whitespace from Groq response."""
    text = text.strip()
    text = re.sub(r'^```(?:json)?\s*', '', text)
    text = re.sub(r'\s*```$', '', text)
    return text.strip()


def _parse_json_response(text: str) -> dict | list:
    """Parse JSON from Groq response, handling common formatting issues."""
    cleaned = _clean_json_response(text)
    try:
        return json.loads(cleaned)
    except json.JSONDecodeError:
        # Try to find JSON object or array in the response
        json_match = re.search(r'[\[{].*[\]}]', cleaned, re.DOTALL)
        if json_match:
            return json.loads(json_match.group())
        raise ValueError(f"Could not parse JSON from Groq response: {cleaned[:200]}")


def get_grade_group(grade: int) -> str:
    """Convert grade number to grade group label."""
    if grade <= 5:
        return "primary"
    elif grade <= 8:
        return "middle"
    elif grade <= 10:
        return "high_school"
    else:
        return "junior_college"


def get_years_to_career(grade: int) -> int:
    """Calculate approximate years from current grade to career start."""
    return max(12 - grade + 4, 3)


def generate_test1_questions(
    student_name: str,
    grade: int,
    grade_group: str,
    subjects: list[str],
    academic_score: float
) -> list[dict]:
    """Generate 20 questions for Test 1 (Interest Discovery)."""
    if IS_MOCK:
        from app.services.mock_ai_data import MOCK_TEST1_QUESTIONS
        return MOCK_TEST1_QUESTIONS

    age_language_map = {
        "primary": "Use VERY simple language, fun stories, and imaginative scenarios. Write as if talking to a 6-10 year old child. Use emojis and playful tone.",
        "middle": "Use relatable teenage language with moderate complexity. Reference school life, friendships, and hobbies.",
        "high_school": "Use career-aware, analytical language. Reference subjects, exams (like SSC/CBSE boards), and real-world applications.",
        "junior_college": "Use mature, career-focused language. Reference entrance exams (JEE, NEET, CLAT), competitive fields, and skill assessment."
    }

    prompt = f"""You are an expert child psychologist and career counselor in India.

Generate exactly 20 psychometric test questions for a student with these details:
- Name: {student_name}
- Grade: {grade} ({grade_group})
- Subjects: {', '.join(subjects) if subjects else 'General'}
- Academic Score: {academic_score}%

Language Style: {age_language_map.get(grade_group, age_language_map['middle'])}

Question Distribution (EXACTLY follow this):
- Questions 1-5: Academic Interest (subject preferences, favorite topics, study habits)
- Questions 6-10: Personality & Behavior (how they react, social preferences, daily habits)
- Questions 11-15: Creative & Logical Thinking (problem solving, imagination, patterns)
- Questions 16-20: Situational / Future Questions (dream scenarios, "what would you do if...")

Question Types — mix these across the 20 questions:
- "mcq": Multiple choice with exactly 4 options (A, B, C, D) — use for at least 10 questions
- "scale": 1-5 Likert scale — use for at least 5 questions
- "open_ended": Free text — use for at least 3 questions

Return ONLY valid JSON array. Each question object must have:
{{
  "sequence_number": 1-20,
  "question_text": "...",
  "question_category": "academic" | "personality" | "creative" | "situational",
  "question_type": "mcq" | "scale" | "open_ended",
  "options": ["A) ...", "B) ...", "C) ...", "D) ..."] or null,
  "scale_labels": {{"1": "Not at all like me", "5": "Exactly like me"}} or null
}}

IMPORTANT: Return ONLY the JSON array, no markdown, no explanation."""

    response = _get_client().chat.completions.create(
        model=MODEL,
        messages=[
            {"role": "system", "content": "You are a psychometric test question generator. Return ONLY valid JSON arrays. No markdown formatting."},
            {"role": "user", "content": prompt}
        ],
        temperature=0.7,
        max_tokens=3000
    )

    return _parse_json_response(response.choices[0].message.content)


def generate_test2_questions(
    student_name: str,
    grade: int,
    grade_group: str,
    previous_interests: list[str],
    primary_interest: str
) -> list[dict]:
    """Generate 20 questions for Test 2 (Follow-Up/Validation)."""
    if IS_MOCK:
        from app.services.mock_ai_data import MOCK_TEST1_QUESTIONS
        # Return test1 questions as base mock for test 2 too for now
        return MOCK_TEST1_QUESTIONS

    prompt = f"""You are an expert child psychologist and career counselor in India.

Generate exactly 20 follow-up test questions for a student:
- Name: {student_name}
- Grade: {grade} ({grade_group})
- Previous Primary Interest: {primary_interest}
- Previous Secondary Interests: {', '.join(previous_interests)}

CRITICAL DISTRIBUTION:
- Questions 1-6 (30%): DEEPER exploration of "{primary_interest}" — go deeper into WHY they like it.
  Mark these with "is_from_previous_interest": true
- Questions 7-20 (70%): Completely NEW interest domains NOT explored before.
  Explore: Arts, Sports, Technology, Business, Social Work, Science, Medicine, Law, Agriculture, Design, Music, Writing.
  Mark these with "is_from_previous_interest": false

Question Types — mix across all 20:
- "mcq": At least 10 questions with 4 options
- "scale": At least 5 questions with 1-5 rating
- "open_ended": At least 3 questions

Return ONLY valid JSON array. Each question must have:
{{
  "sequence_number": 1-20,
  "question_text": "...",
  "question_category": "academic" | "personality" | "creative" | "situational",
  "question_type": "mcq" | "scale" | "open_ended",
  "options": ["A) ...", "B) ...", "C) ...", "D) ..."] or null,
  "is_from_previous_interest": true | false
}}

Return ONLY JSON. No markdown."""

    response = _get_client().chat.completions.create(
        model=MODEL,
        messages=[
            {"role": "system", "content": "You are a psychometric test question generator. Return ONLY valid JSON arrays."},
            {"role": "user", "content": prompt}
        ],
        temperature=0.7,
        max_tokens=3000
    )

    return _parse_json_response(response.choices[0].message.content)


def analyze_student_psychology(
    student_name: str,
    grade: int,
    grade_group: str,
    academic_score: float,
    qa_list: list[dict],
    test_number: int
) -> dict:
    """Analyze student psychology from test Q&A and return structured analysis."""
    if IS_MOCK:
        from app.services.mock_ai_data import MOCK_PSYCHOLOGY_ANALYSIS
        return MOCK_PSYCHOLOGY_ANALYSIS

    qa_formatted = "\n".join([
        f"Q{i+1} [{q.get('question_category', 'general')}] ({q.get('question_type', 'mcq')}): {q.get('question_text', '')}\n"
        f"   Answer: {q.get('answer_text', '') or q.get('selected_option', 'N/A')}"
        for i, q in enumerate(qa_list)
    ])

    prompt = f"""You are an expert educational psychologist in India analyzing a student's psychometric test responses.

Student Details:
- Name: {student_name}
- Grade: {grade} ({grade_group})
- Academic Score: {academic_score}%
- Test Number: {test_number}

Questions and Answers:
{qa_formatted}

Based on this data, provide a comprehensive psychology analysis. Return ONLY a JSON object with:
{{
  "primary_interest": "single label e.g. Technology, Arts, Science, Medicine, Business, Law, Sports, Design, Social Work",
  "secondary_interests": ["Interest2", "Interest3", "Interest4"],
  "personality_traits": ["Trait1", "Trait2", "Trait3", "Trait4"],
  "learning_style": "visual | auditory | kinesthetic | reading-writing",
  "strength_areas": ["Strength1", "Strength2", "Strength3"],
  "weakness_areas": ["Weakness1", "Weakness2"],
  "psychology_analysis": "3-4 paragraphs of encouraging, age-appropriate analysis text. Be positive and inspiring. Explain what you observed about the student's interests, personality, and potential. Use simple language for younger students.",
  "confidence_score": 75.0
}}

RULES:
- Be ENCOURAGING and POSITIVE — never discouraging
- Make the analysis age-appropriate for a {grade_group} student
- Include India-specific educational context
- Confidence score: 60-95 range based on how clear the responses are
- Return ONLY JSON, no markdown."""

    response = _get_client().chat.completions.create(
        model=MODEL,
        messages=[
            {"role": "system", "content": "You are an educational psychologist. Return ONLY valid JSON. No markdown."},
            {"role": "user", "content": prompt}
        ],
        temperature=0.7,
        max_tokens=2500
    )

    return _parse_json_response(response.choices[0].message.content)


def predict_career_options(
    student_name: str,
    grade: int,
    grade_group: str,
    academic_score: float,
    subjects: list[str],
    primary_interest: str,
    secondary_interests: list[str],
    personality_traits: list[str],
    strength_areas: list[str]
) -> dict:
    """Predict 3 career options with roadmaps, salary ranges, and colleges."""
    if IS_MOCK:
        from app.services.mock_ai_data import MOCK_CAREER_PREDICTIONS
        return MOCK_CAREER_PREDICTIONS

    years_to_career = get_years_to_career(grade)

    prompt = f"""You are India's top career counselor for students. Predict career options for:

Student: {student_name}
Grade: {grade} ({grade_group})
Academic Score: {academic_score}%
Subjects: {', '.join(subjects) if subjects else 'General'}
Primary Interest: {primary_interest}
Secondary Interests: {', '.join(secondary_interests)}
Personality Traits: {', '.join(personality_traits)}
Strengths: {', '.join(strength_areas)}
Years to Career: ~{years_to_career} years

Return ONLY a JSON object:
{{
  "career_options": [
    {{
      "title": "Career Title",
      "description": "2-3 sentences on why this suits the student",
      "probability": 85.0,
      "required_skills": ["Skill1", "Skill2", "Skill3", "Skill4"],
      "roadmap": [
        "Step 1: What to do now in Grade {grade}",
        "Step 2: Next academic milestone",
        "Step 3: Higher education path",
        "Step 4: Skill development phase",
        "Step 5: Career entry path"
      ],
      "salary_range": "₹X – ₹Y LPA",
      "top_colleges": ["College1, City", "College2, City", "College3, City"]
    }},
    {{ ... career option 2 ... }},
    {{ ... career option 3 ... }}
  ],
  "future_prediction": "2-3 inspiring paragraphs about the student's potential future. Be vivid and encouraging. Mention the year they'd likely start their career.",
  "immediate_action_items": [
    "Action 1: Something specific the student can do RIGHT NOW",
    "Action 2: A resource or activity to explore",
    "Action 3: A habit to build"
  ]
}}

RULES:
- EXACTLY 3 career options, ranked by probability (highest first)
- EXACTLY 5 roadmap steps per career
- Salary ranges realistic for India 2024-2025
- Top colleges must be REAL Indian institutions
- Be age-appropriate and encouraging
- Include relevant Indian entrance exams (JEE, NEET, CLAT, CAT, etc.)
- Career option 1 probability: 70-95%, option 2: 50-80%, option 3: 40-70%
- Return ONLY JSON."""

    response = _get_client().chat.completions.create(
        model=MODEL,
        messages=[
            {"role": "system", "content": "You are a career prediction expert. Return ONLY valid JSON. No markdown."},
            {"role": "user", "content": prompt}
        ],
        temperature=0.7,
        max_tokens=3000
    )

    return _parse_json_response(response.choices[0].message.content)


def generate_report_summary(
    student_name: str,
    grade: int,
    test_number: int,
    interest_analysis: dict,
    career_predictions: dict,
    previous_report: dict | None = None
) -> str:
    """Generate human-readable report summary text."""
    if IS_MOCK:
        from app.services.mock_ai_data import MOCK_REPORT_SUMMARY
        return MOCK_REPORT_SUMMARY

    comparison_context = ""
    if previous_report and test_number == 2:
        comparison_context = f"""
This is Test 2 (follow-up). The student's Test 1 results were:
- Previous Primary Interest: {previous_report.get('primary_interest', 'N/A')}
- Previous Top Career: {previous_report.get('top_career', 'N/A')}

Compare and note any PROGRESSION or CHANGES in interests."""

    prompt = f"""Write a professional, encouraging career assessment report summary for:

Student: {student_name}
Grade: {grade}
Test: {test_number}

Psychology Analysis: {json.dumps(interest_analysis, indent=2)}
Career Predictions: {json.dumps(career_predictions, indent=2)}
{comparison_context}

Write 3 paragraphs:
1. Overview of the student's personality and interests discovered
2. Career potential and why the predicted careers match
3. Encouragement and next steps

Tone: Professional yet warm, encouraging, age-appropriate.
Length: ~200-300 words total.

Return ONLY the text. No JSON, no markdown headers."""

    response = _get_client().chat.completions.create(
        model=MODEL,
        messages=[
            {"role": "system", "content": "You are a career report writer. Return ONLY plain text paragraphs."},
            {"role": "user", "content": prompt}
        ],
        temperature=0.7,
        max_tokens=1000
    )

    return response.choices[0].message.content.strip()
