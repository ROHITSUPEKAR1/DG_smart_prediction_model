"""
Mock AI Data — High quality sample data for career prediction demo mode.
"""

MOCK_TEST1_QUESTIONS = [
    {
        "sequence_number": 1,
        "question_text": "How much do you enjoy solving complex mathematical puzzles or logical brain teasers?",
        "question_category": "academic",
        "question_type": "scale",
        "scale_labels": {"1": "Not at all", "5": "Very much"}
    },
    {
        "sequence_number": 2,
        "question_text": "When you see a new gadget or machine, do you wonder how it works inside?",
        "question_category": "academic",
        "question_type": "mcq",
        "options": ["A) Yes, I want to take it apart!", "B) Sometimes, if it's cool", "C) I just like using it", "D) I don't care at all"]
    },
    {
        "sequence_number": 3,
        "question_text": "If you could build a school project on any topic, which would you pick?",
        "question_category": "academic",
        "question_type": "mcq",
        "options": ["A) Designing a video game", "B) Writing a short story", "C) Building a solar car model", "D) Organising a charity event"]
    },
    {
        "sequence_number": 4,
        "question_text": "I like to spend my free time drawing, painting, or designing things.",
        "question_category": "creative",
        "question_type": "scale"
    },
    {
        "sequence_number": 5,
        "question_text": "Describe a problem in the world you would like to solve using technology.",
        "question_category": "situational",
        "question_type": "open_ended"
    },
    {
        "sequence_number": 6,
        "question_text": "Do you prefer working alone on a project or as part of a large team?",
        "question_category": "personality",
        "question_type": "mcq",
        "options": ["A) Alone (Deep focus)", "B) Small group (2-3 friends)", "C) Large team (Leadership)", "D) Doesn't matter"]
    },
    {
        "sequence_number": 7,
        "question_text": "I find it easy to explain complex ideas to my friends.",
        "question_category": "personality",
        "question_type": "scale"
    },
    {
        "sequence_number": 8,
        "question_text": "Which of these sounds like a dream job to you?",
        "question_category": "situational",
        "question_type": "mcq",
        "options": ["A) Software Architect", "B) Creative Director", "C) Rocket Scientist", "D) Social Entrepreneur"]
    },
    {
        "sequence_number": 9,
        "question_text": "If you had to invent a new app, what would be its main purpose?",
        "question_category": "creative",
        "question_type": "open_ended"
    },
    {
        "sequence_number": 10,
        "question_text": "I enjoy reading books about science and technology.",
        "question_category": "academic",
        "question_type": "scale"
    },
    {
        "sequence_number": 11,
        "question_text": "When you have a difficult task, do you keep trying until you succeed?",
        "question_category": "personality",
        "question_type": "scale"
    },
    {
        "sequence_number": 12,
        "question_text": "I am interested in how the human mind works.",
        "question_category": "personality",
        "question_type": "scale"
    },
    {
        "sequence_number": 13,
        "question_text": "What is your favorite way to spend a weekend?",
        "question_category": "personality",
        "question_type": "mcq",
        "options": ["A) Coding or Gaming", "B) Reading or Painting", "C) Playing Sports", "D) Volunteering"]
    },
    {
        "sequence_number": 14,
        "question_text": "I like to keep my study notes very organized and neat.",
        "question_category": "academic",
        "question_type": "scale"
    },
    {
        "sequence_number": 15,
        "question_text": "If you could talk to any famous person from history, who would it be?",
        "question_category": "creative",
        "question_type": "open_ended"
    },
    {
        "sequence_number": 16,
        "question_text": "I am curious about the future of Artificial Intelligence.",
        "question_category": "academic",
        "question_type": "scale"
    },
    {
        "sequence_number": 17,
        "question_text": "Do you enjoy helping others with their problems?",
        "question_category": "situational",
        "question_type": "scale"
    },
    {
        "sequence_number": 18,
        "question_text": "Which of these subjects is your favorite?",
        "question_category": "academic",
        "question_type": "mcq",
        "options": ["A) Mathematics/Physics", "B) Literature/Arts", "C) Biology/Chemistry", "D) History/Civics"]
    },
    {
        "sequence_number": 19,
        "question_text": "I would love to travel to the moon one day.",
        "question_category": "situational",
        "question_type": "scale"
    },
    {
        "sequence_number": 20,
        "question_text": "What do you want to be remembered for?",
        "question_category": "situational",
        "question_type": "open_ended"
    }
]

MOCK_PSYCHOLOGY_ANALYSIS = {
    "primary_interest": "Technology & Engineering",
    "secondary_interests": ["Artificial Intelligence", "Rocket Science", "Product Design"],
    "personality_traits": ["Analytical", "Creative", "Persistent", "Curious"],
    "learning_style": "visual",
    "strength_areas": ["Logical Reasoning", "Problem Solving", "Spatial Intelligence"],
    "weakness_areas": ["Time Management", "Public Speaking"],
    "psychology_analysis": "The student exhibits a strong inclination towards structural and logical thinking. They possess a natural curiosity about how complex systems work, particularly in the digital and aerospace domains. Their responses suggest a high level of persistence when faced with technical challenges. They are a visual learner who benefits from seeing diagrams and prototypes. We recommend fostering their interest in programming and physics, as they show significant potential in these areas.",
    "confidence_score": 92.0
}

MOCK_CAREER_PREDICTIONS = {
    "career_options": [
        {
            "title": "Software Architect",
            "description": "Designing complex digital systems and leading engineering teams to build next-generation applications.",
            "probability": 94.0,
            "required_skills": ["System Design", "Cloud Computing", "Team Leadership", "Advanced Programming"],
            "roadmap": [
                "Step 1: Master Python and Data Structures in school.",
                "Step 2: Crack JEE Mains/Advanced for Tier-1 engineering colleges.",
                "Step 3: Pursue Computer Science at IIT or BITS Pilani.",
                "Step 4: Internship at a top tech company like Google or NVIDIA.",
                "Step 5: Gain experience as a Senior Dev before moving into Architecture."
            ],
            "salary_range": "₹35L – ₹80L LPA",
            "top_colleges": ["IIT Bombay, Mumbai", "IIT Delhi, Delhi", "BITS Pilani, Pilani"]
        },
        {
            "title": "Aerospace Engineer",
            "description": "Designing and building aircraft, spacecraft, and satellites. Perfect for your interest in physics and space.",
            "probability": 82.0,
            "required_skills": ["Physics", "CAD Design", "Mathematics", "Thermodynamics"],
            "roadmap": [
                "Step 1: Focus heavily on Physics and Math in Class 11-12.",
                "Step 2: Appear for IIST Entrance Exam.",
                "Step 3: Complete B.Tech in Aerospace Engineering.",
                "Step 4: Research project in Propulsion or Aerodynamics.",
                "Step 5: Join ISRO or a private space-tech startup like Skyroot."
            ],
            "salary_range": "₹15L – ₹45L LPA",
            "top_colleges": ["IIST, Thiruvananthapuram", "IIT Madras, Chennai", "MIT, Manipal"]
        },
        {
            "title": "Data Scientist",
            "description": "Using mathematical models and AI to extract insights from vast amounts of data.",
            "probability": 78.0,
            "required_skills": ["Statistics", "Machine Learning", "Python/R", "Data Visualization"],
            "roadmap": [
                "Step 1: Build a strong foundation in Statistics.",
                "Step 2: Take online courses in Machine Learning.",
                "Step 3: Pursue B.Sc/B.Tech in Data Science or Mathematics.",
                "Step 4: Portfolio projects on Kaggle.",
                "Step 5: Entry-level role in Fintech or E-commerce analytics."
            ],
            "salary_range": "₹20L – ₹55L LPA",
            "top_colleges": ["ISI, Kolkata", "IIT Kanpur, Kanpur", "CMI, Chennai"]
        }
    ],
    "future_prediction": "In the year 2032, you will likely be leading a team at a major tech hub or space agency. Your unique blend of logical reasoning and creative problem solving will allow you to build systems that solve real-world problems. You have a very bright future ahead in the India tech ecosystem.",
    "immediate_action_items": [
        "Action 1: Start a basic Python course on Coursera or YouTube.",
        "Action 2: Join a school Robotics or Coding club.",
        "Action 3: Read 'Wings of Fire' by APJ Abdul Kalam for inspiration."
    ]
}

MOCK_REPORT_SUMMARY = """Aaryan is a highly analytical and curious student with a deep-seated interest in technology and complex systems. His psychometric evaluation reveals a personality characterized by persistence and a love for structured problem-solving. He is naturally drawn to fields that combine mathematical rigor with creative innovation.

The predicted career paths—Software Architect, Aerospace Engineer, and Data Scientist—perfectly align with his core strengths in logical reasoning and spatial awareness. He shows the potential to excel in competitive academic environments and lead technical projects in the future.

We encourage Aaryan to continue exploring hands-on projects and deepening his understanding of physics and computer science. His future in the technology sector is exceptionally promising."""
