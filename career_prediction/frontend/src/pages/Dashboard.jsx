import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { Users, ClipboardCheck, FileText, Clock, UserPlus, ArrowRight, Eye } from 'lucide-react';
import StatCard from '../components/ui/StatCard';
import Badge from '../components/ui/Badge';
import LoadingSpinner from '../components/ui/LoadingSpinner';
import { getDashboardStats, listStudents } from '../lib/api/studentsApi';

export default function Dashboard() {
  const [stats, setStats] = useState(null);
  const [students, setStudents] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchData() {
      try {
        const [statsRes, studentsRes] = await Promise.all([
          getDashboardStats(),
          listStudents()
        ]);
        setStats(statsRes.data);
        setStudents(studentsRes.data.students?.slice(0, 10) || []);
      } catch (err) {
        console.error('Dashboard fetch error:', err);
      } finally {
        setLoading(false);
      }
    }
    fetchData();
  }, []);

  if (loading) return <LoadingSpinner fullPage text="Loading dashboard..." />;

  return (
    <div className="page-wrapper">
      <div className="page-header" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <div>
          <h1>Career Intelligence Dashboard</h1>
          <p>AI-powered career prediction and counseling platform</p>
        </div>
        <Link to="/students/register" className="btn btn-primary btn-lg">
          <UserPlus size={18} />
          Register Student
        </Link>
      </div>

      {/* Stats Grid */}
      <div className="grid-4" style={{ marginBottom: 'var(--spacing-2xl)' }}>
        <StatCard icon={Users} value={stats?.total_students || 0} label="Total Students" colorClass="purple" />
        <StatCard icon={ClipboardCheck} value={stats?.tests_completed || 0} label="Tests Completed" colorClass="green" />
        <StatCard icon={FileText} value={stats?.reports_generated || 0} label="Reports Generated" colorClass="coral" />
        <StatCard icon={Clock} value={stats?.tests_pending || 0} label="Tests Pending" colorClass="amber" />
      </div>

      {/* Recent Students */}
      <div className="card" style={{ padding: 0, overflow: 'hidden' }}>
        <div style={{ padding: '1.25rem 1.5rem', borderBottom: '1px solid var(--color-border)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <h3 style={{ fontSize: '1rem', fontFamily: 'var(--font-display)' }}>Recent Students</h3>
          <Link to="/students" className="btn btn-ghost btn-sm">
            View All <ArrowRight size={14} />
          </Link>
        </div>

        {students.length === 0 ? (
          <div className="empty-state">
            <div className="icon">👨‍🎓</div>
            <h3>No students registered yet</h3>
            <p>Start by registering your first student to begin career assessment.</p>
            <Link to="/students/register" className="btn btn-primary">
              <UserPlus size={16} /> Register First Student
            </Link>
          </div>
        ) : (
          <div className="table-wrapper" style={{ border: 'none', borderRadius: 0 }}>
            <table className="table">
              <thead>
                <tr>
                  <th>Student</th>
                  <th>Grade</th>
                  <th>School</th>
                  <th>Test 1</th>
                  <th>Test 2</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {students.map((student, i) => (
                  <tr key={student.id} className="animate-fade-in" style={{ animationDelay: `${i * 50}ms` }}>
                    <td>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
                        <div className="avatar avatar-sm" style={{
                          background: `hsl(${(student.name?.charCodeAt(0) || 0) * 5}, 60%, 50%)`,
                          color: 'white',
                        }}>
                          {student.name?.charAt(0) || '?'}
                        </div>
                        <div>
                          <div style={{ fontWeight: 600, fontSize: '0.9rem' }}>{student.name}</div>
                          <div style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)' }}>
                            {student.grade_group?.replace('_', ' ')}
                          </div>
                        </div>
                      </div>
                    </td>
                    <td>
                      <span style={{ fontFamily: 'var(--font-mono)', fontWeight: 600 }}>
                        Grade {student.grade}
                      </span>
                    </td>
                    <td style={{ color: 'var(--color-text-muted)' }}>{student.school_name || '-'}</td>
                    <td><Badge status={student.test1_status || 'pending'} /></td>
                    <td><Badge status={student.test2_status || 'pending'} /></td>
                    <td>
                      <Link to={`/students/${student.id}`} className="btn btn-ghost btn-sm">
                        <Eye size={14} /> View
                      </Link>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
