import { useState, useEffect } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import { BookOpen, Brain, TrendingUp, Trash2, Play, Eye, Lock } from 'lucide-react';
import Badge from '../../components/ui/Badge';
import LoadingSpinner from '../../components/ui/LoadingSpinner';
import { useAppContext } from '../../context/AppContext';
import { getStudent, deleteStudent } from '../../lib/api/studentsApi';
import { generateTest } from '../../lib/api/testsApi';

export default function StudentProfile() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { addToast } = useAppContext();
  const [student, setStudent] = useState(null);
  const [loading, setLoading] = useState(true);
  const [generating, setGenerating] = useState(null);

  useEffect(() => {
    fetchStudent();
  }, [id]);

  async function fetchStudent() {
    try {
      const res = await getStudent(id);
      setStudent(res.data);
    } catch (err) {
      addToast('Failed to load student profile', 'error');
    } finally {
      setLoading(false);
    }
  }

  async function handleGenerateTest(testNumber) {
    setGenerating(testNumber);
    try {
      const res = await generateTest({ student_id: parseInt(id), test_number: testNumber });
      addToast(`Test ${testNumber} questions generated!`, 'success');
      const testId = res.data.test_id;
      navigate(`/tests/${testId}/take`);
    } catch (err) {
      addToast(err.message || `Failed to generate Test ${testNumber}`, 'error');
    } finally {
      setGenerating(null);
    }
  }

  async function handleDelete() {
    if (!window.confirm(`Delete ${student?.name}? This will remove all their data permanently.`)) return;
    try {
      await deleteStudent(id);
      addToast('Student deleted', 'success');
      navigate('/students');
    } catch (err) {
      addToast('Delete failed', 'error');
    }
  }

  if (loading) return <LoadingSpinner fullPage text="Loading student profile..." />;
  if (!student) return <div className="page-wrapper"><div className="empty-state"><h3>Student not found</h3></div></div>;

  const tests = student.tests || [];
  const test1 = tests.find(t => t.test_number === 1);
  const test2 = tests.find(t => t.test_number === 2);
  const analyses = student.interest_analyses || [];
  const predictions = student.career_predictions || [];

  return (
    <div className="page-wrapper">
      {/* Profile Header */}
      <div className="card" style={{ marginBottom: 'var(--spacing-lg)', display: 'flex', alignItems: 'center', gap: '1.5rem', flexWrap: 'wrap' }}>
        <div className="avatar avatar-xl animate-float" style={{
          background: `hsl(${(student.name?.charCodeAt(0) || 0) * 5}, 55%, 45%)`,
          color: 'white',
          boxShadow: `0 0 30px hsla(${(student.name?.charCodeAt(0) || 0) * 5}, 55%, 45%, 0.3)`,
        }}>
          {student.name?.charAt(0)}
        </div>
        <div style={{ flex: 1 }}>
          <h2 style={{ fontFamily: 'var(--font-display)', fontSize: '1.5rem', marginBottom: '0.25rem' }}>{student.name}</h2>
          <div style={{ display: 'flex', gap: '1rem', flexWrap: 'wrap', alignItems: 'center', marginBottom: '0.5rem' }}>
            <span style={{ fontFamily: 'var(--font-mono)', fontWeight: 600, color: 'var(--color-accent)' }}>Grade {student.grade}</span>
            <Badge status={student.grade_group?.replace('_', ' ')} />
            {student.school_name && <span style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>🏫 {student.school_name}</span>}
            {student.age && <span style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>Age: {student.age}</span>}
          </div>
          {student.subjects && student.subjects.length > 0 && (
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: '0.3rem' }}>
              {student.subjects.map(sub => <span key={sub} className="chip">{sub}</span>)}
            </div>
          )}
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem', alignItems: 'flex-end' }}>
          {student.academic_score != null && (
            <div style={{ textAlign: 'center', padding: '0.5rem 1rem', background: 'var(--color-secondary)', borderRadius: 'var(--radius-md)' }}>
              <div style={{ fontFamily: 'var(--font-mono)', fontSize: '1.5rem', fontWeight: 700, color: 'var(--color-accent)' }}>{student.academic_score}%</div>
              <div style={{ fontSize: '0.7rem', color: 'var(--color-text-muted)' }}>Academic Score</div>
            </div>
          )}
          <button className="btn btn-danger btn-sm" onClick={handleDelete}>
            <Trash2 size={14} /> Delete
          </button>
        </div>
      </div>

      {/* Test Cards */}
      <h3 style={{ fontFamily: 'var(--font-display)', fontSize: '1.1rem', marginBottom: 'var(--spacing-md)' }}>📋 Test History</h3>
      <div className="grid-2" style={{ marginBottom: 'var(--spacing-2xl)' }}>
        {/* Test 1 Card */}
        <div className="card">
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.75rem' }}>
            <h4 style={{ fontFamily: 'var(--font-display)', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
              <BookOpen size={18} style={{ color: 'var(--color-accent)' }} />
              Test 1 — Interest Discovery
            </h4>
            <Badge status={test1?.status || 'pending'} />
          </div>
          <p style={{ fontSize: '0.82rem', color: 'var(--color-text-muted)', marginBottom: '0.75rem' }}>
            Scheduled: {test1?.scheduled_date || 'Today'}
          </p>
          {test1?.status === 'completed' ? (
            <Link to={`/tests/${test1.id}/result`} className="btn btn-secondary btn-sm" style={{ width: '100%' }}>
              <Eye size={14} /> View Results
            </Link>
          ) : (
            <button className="btn btn-primary btn-sm" style={{ width: '100%' }} disabled={generating === 1}
              onClick={() => handleGenerateTest(1)}>
              {generating === 1 ? '🧠 Generating Questions...' : <><Play size={14} /> Generate & Take Test</>}
            </button>
          )}
        </div>

        {/* Test 2 Card */}
        <div className="card" style={{ opacity: test1?.status !== 'completed' ? 0.5 : 1 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.75rem' }}>
            <h4 style={{ fontFamily: 'var(--font-display)', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
              <Brain size={18} style={{ color: 'var(--color-accent-alt)' }} />
              Test 2 — Follow-Up
            </h4>
            <Badge status={test2?.status || 'pending'} />
          </div>
          <p style={{ fontSize: '0.82rem', color: 'var(--color-text-muted)', marginBottom: '0.75rem' }}>
            Scheduled: {test2?.scheduled_date || '15 days after registration'}
          </p>
          {test1?.status !== 'completed' ? (
            <button className="btn btn-secondary btn-sm" disabled style={{ width: '100%' }}>
              <Lock size={14} /> Complete Test 1 First
            </button>
          ) : test2?.status === 'completed' ? (
            <Link to={`/tests/${test2.id}/result`} className="btn btn-secondary btn-sm" style={{ width: '100%' }}>
              <Eye size={14} /> View Results
            </Link>
          ) : (
            <button className="btn btn-primary btn-sm" style={{ width: '100%' }} disabled={generating === 2}
              onClick={() => handleGenerateTest(2)}>
              {generating === 2 ? '🧠 Generating Questions...' : <><Play size={14} /> Generate & Take Test</>}
            </button>
          )}
        </div>
      </div>

      {/* Interest Analysis */}
      {analyses.length > 0 && (
        <>
          <h3 style={{ fontFamily: 'var(--font-display)', fontSize: '1.1rem', marginBottom: 'var(--spacing-md)' }}>🧠 Interest Analysis</h3>
          {analyses.map((analysis, i) => (
            <div key={analysis.id} className="card animate-slide-up" style={{ marginBottom: 'var(--spacing-md)', animationDelay: `${i * 100}ms` }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1rem' }}>
                <span className="badge badge-interest" style={{ fontSize: '1rem', padding: '0.5rem 1.5rem' }}>
                  🎯 {analysis.primary_interest}
                </span>
                <span style={{ fontFamily: 'var(--font-mono)', fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>
                  Confidence: <span style={{ color: 'var(--color-success)', fontWeight: 700 }}>{analysis.confidence_score?.toFixed(0)}%</span>
                </span>
              </div>

              {analysis.secondary_interests?.length > 0 && (
                <div style={{ marginBottom: '0.75rem' }}>
                  <span style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>Secondary Interests: </span>
                  {analysis.secondary_interests.map(si => <span key={si} className="badge badge-trait" style={{ marginLeft: '0.3rem' }}>{si}</span>)}
                </div>
              )}

              {analysis.personality_traits?.length > 0 && (
                <div style={{ marginBottom: '0.75rem' }}>
                  <span style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)' }}>Personality: </span>
                  {analysis.personality_traits.map(t => <span key={t} className="chip" style={{ marginLeft: '0.3rem' }}>{t}</span>)}
                </div>
              )}

              {analysis.learning_style && (
                <div style={{ marginBottom: '0.75rem', fontSize: '0.85rem' }}>
                  <span style={{ color: 'var(--color-text-muted)' }}>Learning Style: </span>
                  <span style={{ color: 'var(--color-accent)', fontWeight: 600, textTransform: 'capitalize' }}>{analysis.learning_style}</span>
                </div>
              )}

              {analysis.psychology_analysis && (
                <div style={{ marginTop: '1rem', padding: '1rem', background: 'var(--color-secondary)', borderRadius: 'var(--radius-md)', fontSize: '0.88rem', lineHeight: 1.7, color: 'var(--color-text-secondary)' }}>
                  {analysis.psychology_analysis}
                </div>
              )}
            </div>
          ))}
        </>
      )}

      {/* Career Predictions */}
      {predictions.length > 0 && (
        <>
          <h3 style={{ fontFamily: 'var(--font-display)', fontSize: '1.1rem', marginBottom: 'var(--spacing-md)' }}>🚀 Career Predictions</h3>
          {predictions.map((pred) => (
            <div key={pred.id} className="card animate-slide-up" style={{ marginBottom: 'var(--spacing-md)' }}>
              <div className="grid-3">
                {[
                  { title: pred.career_option_1, desc: pred.career_desc_1, prob: pred.career_probability_1, emoji: '🥇' },
                  { title: pred.career_option_2, desc: pred.career_desc_2, prob: pred.career_probability_2, emoji: '🥈' },
                  { title: pred.career_option_3, desc: pred.career_desc_3, prob: pred.career_probability_3, emoji: '🥉' },
                ].map((career, i) => (
                  <div key={i} style={{ padding: '1rem', background: 'var(--color-secondary)', borderRadius: 'var(--radius-md)' }}>
                    <div style={{ fontSize: '1.5rem', marginBottom: '0.3rem' }}>{career.emoji}</div>
                    <div style={{ fontFamily: 'var(--font-display)', fontWeight: 600, marginBottom: '0.3rem' }}>{career.title}</div>
                    <div style={{ fontSize: '0.82rem', color: 'var(--color-text-muted)', marginBottom: '0.75rem' }}>{career.desc}</div>
                    <div className="progress-bar">
                      <div className="progress-fill" style={{ width: `${career.prob || 0}%` }} />
                    </div>
                    <div style={{ fontSize: '0.75rem', color: 'var(--color-accent)', fontFamily: 'var(--font-mono)', marginTop: '0.3rem', fontWeight: 600 }}>
                      {career.prob?.toFixed(0) || 0}% match
                    </div>
                  </div>
                ))}
              </div>

              {pred.future_prediction && (
                <div style={{ marginTop: '1rem', padding: '1rem', background: 'rgba(108,99,255,0.05)', borderRadius: 'var(--radius-md)', border: '1px solid rgba(108,99,255,0.1)' }}>
                  <div style={{ fontSize: '0.8rem', fontWeight: 600, color: 'var(--color-accent)', marginBottom: '0.5rem' }}>✨ Future Vision</div>
                  <p style={{ fontSize: '0.88rem', color: 'var(--color-text-secondary)', lineHeight: 1.7 }}>{pred.future_prediction}</p>
                </div>
              )}

              {pred.roadmap?.length > 0 && (
                <div style={{ marginTop: '1rem' }}>
                  <div style={{ fontSize: '0.8rem', fontWeight: 600, color: 'var(--color-success)', marginBottom: '0.5rem' }}>🎯 Immediate Action Items</div>
                  {pred.roadmap.map((item, i) => (
                    <div key={i} style={{ display: 'flex', alignItems: 'flex-start', gap: '0.5rem', marginBottom: '0.3rem', fontSize: '0.85rem' }}>
                      <span style={{ color: 'var(--color-success)' }}>✓</span>
                      <span style={{ color: 'var(--color-text-secondary)' }}>{item}</span>
                    </div>
                  ))}
                </div>
              )}
            </div>
          ))}
        </>
      )}
    </div>
  );
}
