import { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { ArrowLeft, FileText, TrendingUp, Sparkles } from 'lucide-react';
import LoadingSpinner from '../../components/ui/LoadingSpinner';
import { useAppContext } from '../../context/AppContext';
import { getTest } from '../../lib/api/testsApi';
import { getStudentReports } from '../../lib/api/reportsApi';
import { getStudentCareers } from '../../lib/api/careersApi';
import { getInterestHistory } from '../../lib/api/careersApi';

function Confetti() {
  const pieces = Array.from({ length: 40 }, (_, i) => ({
    id: i,
    left: Math.random() * 100,
    delay: Math.random() * 2,
    color: ['#6C63FF', '#FF6B6B', '#43E97B', '#FFA62B', '#38F9D7', '#B06AFF'][Math.floor(Math.random() * 6)],
    size: 6 + Math.random() * 8,
    duration: 2 + Math.random() * 2,
  }));

  return (
    <div className="confetti-container">
      {pieces.map(p => (
        <div key={p.id} className="confetti-piece" style={{
          left: `${p.left}%`,
          width: p.size,
          height: p.size,
          background: p.color,
          borderRadius: Math.random() > 0.5 ? '50%' : '2px',
          animationDelay: `${p.delay}s`,
          animationDuration: `${p.duration}s`,
        }} />
      ))}
    </div>
  );
}

export default function TestResult() {
  const { testId } = useParams();
  const { addToast } = useAppContext();
  const [test, setTest] = useState(null);
  const [analysis, setAnalysis] = useState(null);
  const [careers, setCareers] = useState(null);
  const [report, setReport] = useState(null);
  const [loading, setLoading] = useState(true);
  const [showConfetti, setShowConfetti] = useState(true);

  useEffect(() => {
    async function fetchResults() {
      try {
        const testRes = await getTest(testId);
        setTest(testRes.data);

        const studentId = testRes.data.student_id;

        const [interestRes, careerRes, reportRes] = await Promise.all([
          getInterestHistory(studentId),
          getStudentCareers(studentId),
          getStudentReports(studentId),
        ]);

        // Get analysis for this test
        const allAnalyses = interestRes.data || [];
        const thisAnalysis = allAnalyses.find(a => a.test_id === parseInt(testId)) || allAnalyses[allAnalyses.length - 1];
        setAnalysis(thisAnalysis);

        // Get career prediction for this test
        const allCareers = careerRes.data || [];
        const thisCareer = allCareers.find(c => c.test_id === parseInt(testId)) || allCareers[allCareers.length - 1];
        setCareers(thisCareer);

        // Get report
        const allReports = reportRes.data || [];
        const thisReport = allReports.find(r => r.test_id === parseInt(testId)) || allReports[allReports.length - 1];
        setReport(thisReport);
      } catch (err) {
        addToast('Failed to load results', 'error');
      } finally {
        setLoading(false);
      }
    }
    fetchResults();

    // Stop confetti after 4 seconds
    const timer = setTimeout(() => setShowConfetti(false), 4000);
    return () => clearTimeout(timer);
  }, [testId]);

  if (loading) return <LoadingSpinner fullPage text="Loading your results..." />;

  return (
    <div className="page-wrapper" style={{ maxWidth: 900, margin: '0 auto' }}>
      {showConfetti && <Confetti />}

      {/* Back Link */}
      {test && (
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 'var(--spacing-lg)' }}>
          <Link to={`/students/${test.student_id}`} className="btn btn-ghost btn-sm back-link">
            <ArrowLeft size={14} /> Back to Profile
          </Link>
          <button className="btn btn-primary btn-sm btn-print" onClick={() => window.print()}>
            <FileText size={14} /> Download PDF Report
          </button>
        </div>
      )}

      {/* Celebration Header */}
      <div className="card animate-slide-up" style={{
        textAlign: 'center',
        padding: '2.5rem',
        marginBottom: 'var(--spacing-lg)',
        background: 'linear-gradient(135deg, rgba(108,99,255,0.1), rgba(255,107,107,0.1))',
        border: '1px solid rgba(108,99,255,0.2)',
      }}>
        <div style={{ fontSize: '3rem', marginBottom: '0.5rem' }}>🎉</div>
        <h2 style={{ fontFamily: 'var(--font-display)', fontSize: '1.6rem', marginBottom: '0.5rem' }}>
          Test {test?.test_number} Complete!
        </h2>
        <p style={{ color: 'var(--color-text-muted)', marginBottom: '1.5rem' }}>
          Your AI-powered career analysis is ready
        </p>

        {analysis && (
          <div className="animate-glow" style={{
            display: 'inline-block',
            padding: '0.75rem 2rem',
            background: 'var(--gradient-primary)',
            borderRadius: 'var(--radius-full)',
            fontSize: '1.2rem',
            fontFamily: 'var(--font-display)',
            fontWeight: 700,
            color: 'white',
          }}>
            🎯 Primary Interest: {analysis.primary_interest}
          </div>
        )}
      </div>

      {/* Personality Traits */}
      {analysis && (
        <div className="card animate-slide-up" style={{ marginBottom: 'var(--spacing-lg)', animationDelay: '0.1s' }}>
          <h3 style={{ fontFamily: 'var(--font-display)', marginBottom: '1rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <Sparkles size={18} style={{ color: 'var(--color-accent)' }} /> Your Personality Profile
          </h3>

          <div className="grid-2" style={{ marginBottom: '1rem' }}>
            <div>
              <div style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)', marginBottom: '0.4rem' }}>Personality Traits</div>
              <div style={{ display: 'flex', flexWrap: 'wrap', gap: '0.3rem' }}>
                {analysis.personality_traits?.map((t, i) => (
                  <span key={i} className="badge badge-trait" style={{ animationDelay: `${i * 0.1}s` }}>{t}</span>
                ))}
              </div>
            </div>
            <div>
              <div style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)', marginBottom: '0.4rem' }}>Learning Style</div>
              <span className="badge badge-interest" style={{ textTransform: 'capitalize' }}>
                📚 {analysis.learning_style}
              </span>
            </div>
          </div>

          <div className="grid-2" style={{ marginBottom: '1rem' }}>
            <div>
              <div style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)', marginBottom: '0.4rem' }}>💪 Strengths</div>
              {analysis.strength_areas?.map((s, i) => (
                <div key={i} style={{ display: 'flex', alignItems: 'center', gap: '0.4rem', fontSize: '0.85rem', marginBottom: '0.2rem' }}>
                  <span style={{ color: 'var(--color-success)' }}>✓</span> {s}
                </div>
              ))}
            </div>
            <div>
              <div style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)', marginBottom: '0.4rem' }}>📈 Areas to Develop</div>
              {analysis.weakness_areas?.map((w, i) => (
                <div key={i} style={{ display: 'flex', alignItems: 'center', gap: '0.4rem', fontSize: '0.85rem', marginBottom: '0.2rem' }}>
                  <span style={{ color: 'var(--color-warning)' }}>→</span> {w}
                </div>
              ))}
            </div>
          </div>

          <div style={{ fontSize: '0.8rem', color: 'var(--color-text-muted)', marginBottom: '0.3rem' }}>Confidence Score</div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
            <div className="progress-bar" style={{ flex: 1 }}>
              <div className="progress-fill green" style={{ width: `${analysis.confidence_score || 0}%` }} />
            </div>
            <span style={{ fontFamily: 'var(--font-mono)', fontWeight: 700, color: 'var(--color-success)' }}>
              {analysis.confidence_score?.toFixed(0)}%
            </span>
          </div>
        </div>
      )}

      {/* Career Options */}
      {careers && (
        <div className="animate-slide-up" style={{ marginBottom: 'var(--spacing-lg)', animationDelay: '0.2s' }}>
          <h3 style={{ fontFamily: 'var(--font-display)', marginBottom: 'var(--spacing-md)', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <TrendingUp size={18} style={{ color: 'var(--color-accent)' }} /> Career Predictions
          </h3>

          <div className="grid-3">
            {[
              { title: careers.career_option_1, desc: careers.career_desc_1, prob: careers.career_probability_1, emoji: '🥇', color: '#FFD700' },
              { title: careers.career_option_2, desc: careers.career_desc_2, prob: careers.career_probability_2, emoji: '🥈', color: '#C0C0C0' },
              { title: careers.career_option_3, desc: careers.career_desc_3, prob: careers.career_probability_3, emoji: '🥉', color: '#CD7F32' },
            ].map((c, i) => (
              <div key={i} className="card" style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '2.5rem', marginBottom: '0.5rem' }}>{c.emoji}</div>
                <h4 style={{ fontFamily: 'var(--font-display)', marginBottom: '0.5rem', fontSize: '1rem' }}>{c.title}</h4>
                <p style={{ fontSize: '0.82rem', color: 'var(--color-text-muted)', marginBottom: '1rem', minHeight: '2.5rem' }}>{c.desc}</p>
                <div className="progress-bar" style={{ marginBottom: '0.3rem' }}>
                  <div className="progress-fill" style={{ width: `${c.prob || 0}%`, transition: 'width 1.5s ease', transitionDelay: `${i * 0.3}s` }} />
                </div>
                <span style={{ fontFamily: 'var(--font-mono)', fontWeight: 700, color: 'var(--color-accent)', fontSize: '1.1rem' }}>
                  {c.prob?.toFixed(0) || 0}%
                </span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Future Vision */}
      {careers?.future_prediction && (
        <div className="card animate-slide-up" style={{ marginBottom: 'var(--spacing-lg)', animationDelay: '0.3s' }}>
          <h3 style={{ fontFamily: 'var(--font-display)', marginBottom: '1rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            ✨ Your Future Vision
          </h3>
          <p style={{ fontSize: '0.92rem', lineHeight: 1.8, color: 'var(--color-text-secondary)' }}>
            {careers.future_prediction}
          </p>
        </div>
      )}

      {/* Action Items */}
      {careers?.roadmap?.length > 0 && (
        <div className="card animate-slide-up" style={{ marginBottom: 'var(--spacing-lg)', animationDelay: '0.4s' }}>
          <h3 style={{ fontFamily: 'var(--font-display)', marginBottom: '1rem' }}>
            🎯 Immediate Action Items
          </h3>
          {careers.roadmap.map((item, i) => (
            <div key={i} style={{
              display: 'flex', alignItems: 'flex-start', gap: '0.75rem',
              padding: '0.75rem',
              background: i % 2 === 0 ? 'rgba(108,99,255,0.04)' : 'transparent',
              borderRadius: 'var(--radius-md)',
              marginBottom: '0.25rem',
            }}>
              <span style={{
                width: 24, height: 24, borderRadius: '50%',
                background: 'var(--gradient-success)',
                color: '#0a0a0a',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontSize: '0.7rem', fontWeight: 700, flexShrink: 0,
              }}>
                {i + 1}
              </span>
              <span style={{ fontSize: '0.88rem', color: 'var(--color-text-secondary)' }}>{item}</span>
            </div>
          ))}
        </div>
      )}

      {/* Report Summary */}
      {report?.summary && (
        <div className="card animate-slide-up" style={{ marginBottom: 'var(--spacing-lg)', animationDelay: '0.5s' }}>
          <h3 style={{ fontFamily: 'var(--font-display)', marginBottom: '1rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
            <FileText size={18} style={{ color: 'var(--color-accent)' }} /> Report Summary
          </h3>
          <p style={{ fontSize: '0.9rem', lineHeight: 1.8, color: 'var(--color-text-secondary)', whiteSpace: 'pre-line' }}>
            {report.summary}
          </p>
        </div>
      )}

      {/* Psychology Analysis */}
      {analysis?.psychology_analysis && (
        <div className="card animate-slide-up" style={{ animationDelay: '0.6s' }}>
          <h3 style={{ fontFamily: 'var(--font-display)', marginBottom: '1rem' }}>
            🧠 Full Psychology Analysis
          </h3>
          <p style={{ fontSize: '0.9rem', lineHeight: 1.8, color: 'var(--color-text-secondary)', whiteSpace: 'pre-line' }}>
            {analysis.psychology_analysis}
          </p>
        </div>
      )}
    </div>
  );
}
