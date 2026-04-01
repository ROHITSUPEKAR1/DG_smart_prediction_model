import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ArrowLeft, ArrowRight, Send, Brain } from 'lucide-react';
import Badge from '../../components/ui/Badge';
import LoadingSpinner from '../../components/ui/LoadingSpinner';
import { useAppContext } from '../../context/AppContext';
import { getTest, submitAnswers } from '../../lib/api/testsApi';

const AI_MESSAGES = [
  "🧠 Analyzing your responses...",
  "🔍 Discovering your strengths...",
  "🌟 Mapping your future...",
  "📊 Preparing your career report...",
  "✨ Almost there — finalizing insights...",
];

export default function TestTaker() {
  const { testId } = useParams();
  const navigate = useNavigate();
  const { addToast } = useAppContext();

  const [test, setTest] = useState(null);
  const [questions, setQuestions] = useState([]);
  const [answers, setAnswers] = useState({});
  const [currentQ, setCurrentQ] = useState(0);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [aiMessage, setAiMessage] = useState('');
  const [showConfirm, setShowConfirm] = useState(false);

  useEffect(() => {
    async function fetchTest() {
      try {
        const res = await getTest(testId);
        setTest(res.data);
        setQuestions(res.data.questions || []);
      } catch (err) {
        addToast('Failed to load test', 'error');
      } finally {
        setLoading(false);
      }
    }
    fetchTest();
  }, [testId]);

  useEffect(() => {
    if (!submitting) return;
    let i = 0;
    setAiMessage(AI_MESSAGES[0]);
    const interval = setInterval(() => {
      i = (i + 1) % AI_MESSAGES.length;
      setAiMessage(AI_MESSAGES[i]);
    }, 3000);
    return () => clearInterval(interval);
  }, [submitting]);

  const setAnswer = (questionId, value, type) => {
    setAnswers(prev => ({
      ...prev,
      [questionId]: type === 'open_ended'
        ? { answer_text: value, selected_option: null }
        : { answer_text: null, selected_option: value }
    }));
  };

  const isAnswered = (qId) => {
    const a = answers[qId];
    return a && (a.answer_text?.trim() || a.selected_option);
  };

  const allAnswered = questions.every(q => isAnswered(q.id));
  const answeredCount = questions.filter(q => isAnswered(q.id)).length;

  const handleSubmit = async () => {
    setShowConfirm(false);
    setSubmitting(true);
    try {
      const payload = {
        test_id: parseInt(testId),
        student_id: test.student_id,
        answers: questions.map(q => ({
          question_id: q.id,
          answer_text: answers[q.id]?.answer_text || null,
          selected_option: answers[q.id]?.selected_option || null,
        })),
      };
      await submitAnswers(payload);
      addToast('Test submitted and analyzed!', 'success');
      navigate(`/tests/${testId}/result`);
    } catch (err) {
      addToast(err.message || 'Submission failed', 'error');
      setSubmitting(false);
    }
  };

  if (loading) return <LoadingSpinner fullPage text="Loading test..." />;

  if (submitting) {
    return (
      <div className="page-wrapper">
        <div className="ai-loading">
          <div className="brain-icon">🧠</div>
          <h2>AI Analysis in Progress</h2>
          <p>{aiMessage}</p>
          <div className="dots">
            <div className="dot" /><div className="dot" /><div className="dot" />
          </div>
          <div style={{ marginTop: '2rem', width: '300px' }}>
            <div className="progress-bar" style={{ height: '4px' }}>
              <div className="progress-fill" style={{ width: '100%', animation: 'shimmer 2s infinite' }} />
            </div>
          </div>
        </div>
      </div>
    );
  }

  if (!questions.length) {
    return <div className="page-wrapper"><div className="empty-state"><h3>No questions found</h3></div></div>;
  }

  const q = questions[currentQ];

  return (
    <div className="page-wrapper" style={{ maxWidth: 800, margin: '0 auto' }}>
      {/* Progress */}
      <div style={{ marginBottom: 'var(--spacing-lg)' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.5rem' }}>
          <span style={{ fontSize: '0.85rem', color: 'var(--color-text-muted)' }}>
            Question {currentQ + 1} of {questions.length}
          </span>
          <span style={{ fontFamily: 'var(--font-mono)', fontSize: '0.8rem', color: 'var(--color-accent)' }}>
            {answeredCount}/{questions.length} answered
          </span>
        </div>
        <div className="progress-bar">
          <div className="progress-fill" style={{ width: `${((currentQ + 1) / questions.length) * 100}%` }} />
        </div>
      </div>

      {/* Question Dots */}
      <div style={{ display: 'flex', gap: '4px', flexWrap: 'wrap', marginBottom: 'var(--spacing-lg)' }}>
        {questions.map((question, i) => (
          <button key={i} onClick={() => setCurrentQ(i)} style={{
            width: 24, height: 24, borderRadius: '50%', border: 'none', cursor: 'pointer', fontSize: '0.65rem', fontWeight: 700,
            background: i === currentQ ? 'var(--color-accent)' : isAnswered(question.id) ? 'var(--color-success)' : 'var(--color-secondary)',
            color: i === currentQ ? 'white' : isAnswered(question.id) ? '#0a0a0a' : 'var(--color-text-muted)',
            transition: 'all 0.15s ease',
          }}>
            {i + 1}
          </button>
        ))}
      </div>

      {/* Question Card */}
      <div className="card animate-fade-in" key={currentQ} style={{ marginBottom: 'var(--spacing-lg)' }}>
        <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '1rem', flexWrap: 'wrap' }}>
          <Badge status={q.question_category}>{q.question_category}</Badge>
          <span className="badge" style={{ background: 'var(--color-secondary)', color: 'var(--color-text-muted)', border: '1px solid var(--color-border)' }}>
            {q.question_type === 'mcq' ? '🔘 Multiple Choice' : q.question_type === 'scale' ? '📊 Scale (1-5)' : '✍️ Open Ended'}
          </span>
          {q.is_from_previous_interest && (
            <span className="badge badge-interest">🔗 Based on your previous interest</span>
          )}
        </div>

        <h3 style={{ fontFamily: 'var(--font-display)', fontSize: '1.15rem', lineHeight: 1.5, marginBottom: '1.5rem' }}>
          {q.question_text}
        </h3>

        {/* MCQ Options */}
        {q.question_type === 'mcq' && q.options && (
          <div style={{ display: 'grid', gap: '0.6rem' }}>
            {q.options.map((opt, oi) => {
              const optLetter = opt.charAt(0) === 'A' || opt.charAt(0) === 'B' || opt.charAt(0) === 'C' || opt.charAt(0) === 'D' ? opt : `${String.fromCharCode(65 + oi)}) ${opt}`;
              const selected = answers[q.id]?.selected_option === opt;
              return (
                <button key={oi} onClick={() => setAnswer(q.id, opt, 'mcq')} style={{
                  padding: '0.8rem 1rem',
                  borderRadius: 'var(--radius-md)',
                  border: `2px solid ${selected ? 'var(--color-accent)' : 'var(--color-border)'}`,
                  background: selected ? 'rgba(108,99,255,0.1)' : 'var(--color-secondary)',
                  color: selected ? 'var(--color-accent)' : 'var(--color-text-secondary)',
                  textAlign: 'left',
                  cursor: 'pointer',
                  fontSize: '0.9rem',
                  fontWeight: selected ? 600 : 400,
                  transition: 'all 0.2s ease',
                  fontFamily: 'var(--font-body)',
                }}>
                  {optLetter}
                </button>
              );
            })}
          </div>
        )}

        {/* Scale Options */}
        {q.question_type === 'scale' && (
          <div>
            <div style={{ display: 'flex', justifyContent: 'space-between', gap: '0.5rem' }}>
              {[1, 2, 3, 4, 5].map(val => {
                const selected = answers[q.id]?.selected_option === String(val);
                return (
                  <button key={val} onClick={() => setAnswer(q.id, String(val), 'scale')} style={{
                    flex: 1,
                    padding: '1rem 0',
                    borderRadius: 'var(--radius-md)',
                    border: `2px solid ${selected ? 'var(--color-accent)' : 'var(--color-border)'}`,
                    background: selected ? 'rgba(108,99,255,0.15)' : 'var(--color-secondary)',
                    color: selected ? 'var(--color-accent)' : 'var(--color-text-muted)',
                    cursor: 'pointer',
                    fontWeight: 700,
                    fontSize: '1.1rem',
                    fontFamily: 'var(--font-mono)',
                    transition: 'all 0.2s ease',
                  }}>
                    {val}
                  </button>
                );
              })}
            </div>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '0.4rem', fontSize: '0.72rem', color: 'var(--color-text-muted)' }}>
              <span>Not at all like me</span>
              <span>Exactly like me</span>
            </div>
          </div>
        )}

        {/* Open Ended */}
        {q.question_type === 'open_ended' && (
          <textarea
            className="form-textarea"
            placeholder="Type your answer here..."
            value={answers[q.id]?.answer_text || ''}
            onChange={(e) => setAnswer(q.id, e.target.value, 'open_ended')}
            style={{ minHeight: '120px' }}
          />
        )}
      </div>

      {/* Navigation */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <button className="btn btn-secondary" disabled={currentQ === 0} onClick={() => setCurrentQ(currentQ - 1)}>
          <ArrowLeft size={16} /> Previous
        </button>

        {currentQ < questions.length - 1 ? (
          <button className="btn btn-primary" onClick={() => setCurrentQ(currentQ + 1)}>
            Next <ArrowRight size={16} />
          </button>
        ) : (
          <button className="btn btn-success btn-lg" disabled={!allAnswered} onClick={() => setShowConfirm(true)}>
            <Send size={16} /> Submit Test
          </button>
        )}
      </div>

      {/* Confirmation Modal */}
      {showConfirm && (
        <div className="modal-overlay" onClick={() => setShowConfirm(false)}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <h3 style={{ fontFamily: 'var(--font-display)', marginBottom: '0.75rem' }}>Submit Test?</h3>
            <p style={{ color: 'var(--color-text-muted)', marginBottom: '1.5rem', fontSize: '0.9rem' }}>
              You've answered all {questions.length} questions. Once submitted, AI will analyze your responses and generate your career prediction report. This may take 15-30 seconds.
            </p>
            <div style={{ display: 'flex', gap: '0.75rem', justifyContent: 'flex-end' }}>
              <button className="btn btn-secondary" onClick={() => setShowConfirm(false)}>Cancel</button>
              <button className="btn btn-success" onClick={handleSubmit}>
                <Brain size={16} /> Yes, Submit & Analyze
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
