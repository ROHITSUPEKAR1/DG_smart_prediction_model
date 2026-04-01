import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { User, BookOpen, CheckCircle, ArrowRight, ArrowLeft, Sparkles } from 'lucide-react';
import { useAppContext } from '../../context/AppContext';
import { registerStudent } from '../../lib/api/studentsApi';

const GRADE_GROUPS = {
  1: 'Primary', 2: 'Primary', 3: 'Primary', 4: 'Primary', 5: 'Primary',
  6: 'Middle', 7: 'Middle', 8: 'Middle',
  9: 'High School', 10: 'High School',
  11: 'Junior College', 12: 'Junior College',
};

const ALL_SUBJECTS = [
  'Mathematics', 'Science', 'English', 'Hindi', 'Marathi', 'History',
  'Geography', 'Civics', 'Physics', 'Chemistry', 'Biology', 'Computer Science',
  'Economics', 'Accounts', 'Business Studies', 'Art', 'Music', 'Physical Education',
];

export default function StudentRegister() {
  const navigate = useNavigate();
  const { addToast } = useAppContext();
  const [step, setStep] = useState(1);
  const [submitting, setSubmitting] = useState(false);
  const [result, setResult] = useState(null);

  const [form, setForm] = useState({
    name: '', grade: '', age: '', gender: '',
    school_name: '', academic_score: 50, subjects: [],
  });

  const updateForm = (field, value) => setForm(prev => ({ ...prev, [field]: value }));

  const toggleSubject = (subject) => {
    setForm(prev => ({
      ...prev,
      subjects: prev.subjects.includes(subject)
        ? prev.subjects.filter(s => s !== subject)
        : [...prev.subjects, subject],
    }));
  };

  const canProceed = () => {
    if (step === 1) return form.name.trim() && form.grade;
    if (step === 2) return true;
    return true;
  };

  const handleSubmit = async () => {
    setSubmitting(true);
    try {
      const payload = {
        name: form.name.trim(),
        grade: parseInt(form.grade),
        age: form.age ? parseInt(form.age) : null,
        gender: form.gender || null,
        school_name: form.school_name.trim() || null,
        academic_score: parseFloat(form.academic_score),
        subjects: form.subjects.length > 0 ? form.subjects : null,
      };
      const res = await registerStudent(payload);
      setResult(res.data);
      addToast('Student registered successfully!', 'success');
    } catch (err) {
      addToast(err.message || 'Registration failed', 'error');
    } finally {
      setSubmitting(false);
    }
  };

  if (result) {
    return (
      <div className="page-wrapper">
        <div style={{ maxWidth: 550, margin: '2rem auto', textAlign: 'center' }}>
          <div className="card animate-slide-up" style={{ padding: '3rem 2rem' }}>
            <div style={{ fontSize: '3.5rem', marginBottom: '1rem' }}>🎉</div>
            <h2 style={{ fontFamily: 'var(--font-display)', fontSize: '1.5rem', marginBottom: '0.5rem' }}>
              Student Registered!
            </h2>
            <p style={{ color: 'var(--color-text-muted)', marginBottom: '1.5rem' }}>
              {form.name} has been successfully registered. Their career assessment journey begins now.
            </p>

            <div style={{
              background: 'var(--color-secondary)',
              borderRadius: 'var(--radius-md)',
              padding: '1rem',
              marginBottom: '1.5rem',
              textAlign: 'left',
            }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '0.5rem' }}>
                <span style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>Student ID</span>
                <span style={{ fontFamily: 'var(--font-mono)', fontWeight: 600 }}>#{result.student_id}</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '0.5rem' }}>
                <span style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>Test 1 Date</span>
                <span style={{ fontWeight: 500, color: 'var(--color-success)' }}>{result.test1_date}</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <span style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>Test 2 Date</span>
                <span style={{ fontWeight: 500, color: 'var(--color-warning)' }}>{result.test2_date}</span>
              </div>
            </div>

            <button onClick={() => navigate(`/students/${result.student_id}`)} className="btn btn-primary btn-lg" style={{ width: '100%' }}>
              <Sparkles size={18} /> View Student Profile
            </button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="page-wrapper">
      <div style={{ maxWidth: 650, margin: '0 auto' }}>
        <div className="page-header" style={{ textAlign: 'center' }}>
          <h1>Register New Student</h1>
          <p>Begin their career discovery journey</p>
        </div>

        {/* Step Indicators */}
        <div style={{ display: 'flex', justifyContent: 'center', gap: '0.5rem', marginBottom: '2rem' }}>
          {[
            { num: 1, icon: User, label: 'Basic Info' },
            { num: 2, icon: BookOpen, label: 'Academics' },
            { num: 3, icon: CheckCircle, label: 'Confirm' },
          ].map(({ num, icon: Icon, label }) => (
            <div key={num} style={{
              display: 'flex', alignItems: 'center', gap: '0.4rem',
              padding: '0.4rem 1rem',
              borderRadius: 'var(--radius-full)',
              background: step === num ? 'rgba(108,99,255,0.15)' : step > num ? 'rgba(67,233,123,0.1)' : 'var(--color-secondary)',
              border: `1px solid ${step === num ? 'var(--color-accent)' : step > num ? 'rgba(67,233,123,0.3)' : 'var(--color-border)'}`,
              color: step === num ? 'var(--color-accent)' : step > num ? 'var(--color-success)' : 'var(--color-text-muted)',
              fontSize: '0.8rem', fontWeight: 600,
              transition: 'all 0.25s ease',
            }}>
              <Icon size={14} />
              {label}
            </div>
          ))}
        </div>

        <div className="card animate-fade-in" key={step}>
          {/* Step 1: Basic Info */}
          {step === 1 && (
            <>
              <div className="form-group">
                <label className="form-label">Full Name *</label>
                <input className="form-input" type="text" placeholder="Enter student's full name" value={form.name} onChange={(e) => updateForm('name', e.target.value)} />
              </div>
              <div className="grid-2">
                <div className="form-group">
                  <label className="form-label">Grade *</label>
                  <select className="form-select" value={form.grade} onChange={(e) => updateForm('grade', e.target.value)}>
                    <option value="">Select Grade</option>
                    {Array.from({ length: 12 }, (_, i) => (
                      <option key={i + 1} value={i + 1}>Grade {i + 1} — {GRADE_GROUPS[i + 1]}</option>
                    ))}
                  </select>
                </div>
                <div className="form-group">
                  <label className="form-label">Age</label>
                  <input className="form-input" type="number" min="4" max="25" placeholder="Age" value={form.age} onChange={(e) => updateForm('age', e.target.value)} />
                </div>
              </div>
              <div className="form-group">
                <label className="form-label">Gender</label>
                <select className="form-select" value={form.gender} onChange={(e) => updateForm('gender', e.target.value)}>
                  <option value="">Prefer not to say</option>
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                  <option value="Other">Other</option>
                </select>
              </div>
            </>
          )}

          {/* Step 2: Academic Details */}
          {step === 2 && (
            <>
              <div className="form-group">
                <label className="form-label">School Name</label>
                <input className="form-input" type="text" placeholder="Enter school name" value={form.school_name} onChange={(e) => updateForm('school_name', e.target.value)} />
              </div>
              <div className="form-group">
                <label className="form-label">
                  Academic Score: <span style={{ fontFamily: 'var(--font-mono)', fontWeight: 700, color: 'var(--color-accent)', fontSize: '1.1rem' }}>{form.academic_score}%</span>
                </label>
                <input type="range" min="0" max="100" step="1" value={form.academic_score} onChange={(e) => updateForm('academic_score', e.target.value)}
                  style={{ width: '100%', accentColor: 'var(--color-accent)', height: '6px' }} />
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '0.7rem', color: 'var(--color-text-muted)' }}>
                  <span>0%</span><span>50%</span><span>100%</span>
                </div>
              </div>
              <div className="form-group">
                <label className="form-label">Subjects (select all that apply)</label>
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: '0.4rem' }}>
                  {ALL_SUBJECTS.map(sub => (
                    <button key={sub} type="button" className={`chip ${form.subjects.includes(sub) ? 'active' : ''}`} onClick={() => toggleSubject(sub)}>
                      {form.subjects.includes(sub) ? '✓ ' : ''}{sub}
                    </button>
                  ))}
                </div>
              </div>
            </>
          )}

          {/* Step 3: Confirm */}
          {step === 3 && (
            <>
              <h3 style={{ fontSize: '1.1rem', marginBottom: '1rem', fontFamily: 'var(--font-display)' }}>Confirm Details</h3>
              <div style={{ display: 'grid', gap: '0.75rem' }}>
                {[
                  ['Name', form.name],
                  ['Grade', `Grade ${form.grade} — ${GRADE_GROUPS[form.grade] || ''}`],
                  ['Age', form.age || 'Not specified'],
                  ['Gender', form.gender || 'Not specified'],
                  ['School', form.school_name || 'Not specified'],
                  ['Academic Score', `${form.academic_score}%`],
                  ['Subjects', form.subjects.length > 0 ? form.subjects.join(', ') : 'None selected'],
                ].map(([label, value]) => (
                  <div key={label} style={{ display: 'flex', justifyContent: 'space-between', padding: '0.5rem 0', borderBottom: '1px solid rgba(46,53,96,0.5)' }}>
                    <span style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>{label}</span>
                    <span style={{ fontWeight: 500, fontSize: '0.9rem', textAlign: 'right', maxWidth: '60%' }}>{value}</span>
                  </div>
                ))}
              </div>

              <div style={{ marginTop: '1.5rem', padding: '1rem', background: 'rgba(67,233,123,0.08)', borderRadius: 'var(--radius-md)', border: '1px solid rgba(67,233,123,0.2)' }}>
                <div style={{ fontSize: '0.85rem', fontWeight: 600, color: 'var(--color-success)', marginBottom: '0.3rem' }}>📅 Test Schedule</div>
                <div style={{ fontSize: '0.82rem', color: 'var(--color-text-secondary)' }}>
                  Test 1 (Interest Discovery): <strong>Today</strong><br />
                  Test 2 (Follow-Up): <strong>15 days from today</strong>
                </div>
              </div>
            </>
          )}

          {/* Navigation Buttons */}
          <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '2rem', paddingTop: '1rem', borderTop: '1px solid var(--color-border)' }}>
            {step > 1 ? (
              <button className="btn btn-secondary" onClick={() => setStep(step - 1)}>
                <ArrowLeft size={16} /> Back
              </button>
            ) : <div />}

            {step < 3 ? (
              <button className="btn btn-primary" disabled={!canProceed()} onClick={() => setStep(step + 1)}>
                Next <ArrowRight size={16} />
              </button>
            ) : (
              <button className="btn btn-success btn-lg" disabled={submitting} onClick={handleSubmit}>
                {submitting ? 'Registering...' : '✨ Register Student'}
              </button>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
