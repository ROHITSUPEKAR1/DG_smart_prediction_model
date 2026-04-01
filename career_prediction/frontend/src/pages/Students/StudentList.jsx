import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { Search, Eye, ClipboardList, UserPlus, Filter } from 'lucide-react';
import Badge from '../../components/ui/Badge';
import LoadingSpinner from '../../components/ui/LoadingSpinner';
import { listStudents } from '../../lib/api/studentsApi';

const gradeGroups = [
  { value: '', label: 'All Grades' },
  { value: 'primary', label: 'Primary (1-5)' },
  { value: 'middle', label: 'Middle (6-8)' },
  { value: 'high_school', label: 'High School (9-10)' },
  { value: 'junior_college', label: 'Junior College (11-12)' },
];

export default function StudentList() {
  const [students, setStudents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [gradeFilter, setGradeFilter] = useState('');

  useEffect(() => {
    async function fetchStudents() {
      try {
        const res = await listStudents();
        setStudents(res.data.students || []);
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    }
    fetchStudents();
  }, []);

  const filtered = students.filter((s) => {
    const matchSearch = search === '' || 
      s.name?.toLowerCase().includes(search.toLowerCase()) ||
      s.school_name?.toLowerCase().includes(search.toLowerCase());
    const matchGrade = gradeFilter === '' || s.grade_group === gradeFilter;
    return matchSearch && matchGrade;
  });

  if (loading) return <LoadingSpinner fullPage text="Loading students..." />;

  return (
    <div className="page-wrapper">
      <div className="page-header" style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
        <div>
          <h1>Student Directory</h1>
          <p>{students.length} students registered</p>
        </div>
        <Link to="/students/register" className="btn btn-primary">
          <UserPlus size={16} /> Register Student
        </Link>
      </div>

      {/* Search & Filter Bar */}
      <div style={{ display: 'flex', gap: '1rem', marginBottom: 'var(--spacing-lg)', flexWrap: 'wrap' }}>
        <div className="search-bar" style={{ flex: 1, minWidth: '250px' }}>
          <Search size={16} className="search-icon" />
          <input
            type="text"
            placeholder="Search by name or school..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
          <Filter size={16} style={{ color: 'var(--color-text-muted)' }} />
          <select className="form-select" value={gradeFilter} onChange={(e) => setGradeFilter(e.target.value)} style={{ minWidth: '180px' }}>
            {gradeGroups.map(g => <option key={g.value} value={g.value}>{g.label}</option>)}
          </select>
        </div>
      </div>

      {filtered.length === 0 ? (
        <div className="card">
          <div className="empty-state">
            <div className="icon">🔍</div>
            <h3>No students found</h3>
            <p>{search || gradeFilter ? 'Try adjusting your search or filter.' : 'Register your first student to get started.'}</p>
            {!search && !gradeFilter && (
              <Link to="/students/register" className="btn btn-primary">
                <UserPlus size={16} /> Register Student
              </Link>
            )}
          </div>
        </div>
      ) : (
        <div className="card" style={{ padding: 0, overflow: 'hidden' }}>
          <div className="table-wrapper" style={{ border: 'none', borderRadius: 0 }}>
            <table className="table">
              <thead>
                <tr>
                  <th>Student</th>
                  <th>Grade</th>
                  <th>School</th>
                  <th>Academic</th>
                  <th>Test 1</th>
                  <th>Test 2</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {filtered.map((student, i) => (
                  <tr key={student.id} className="animate-fade-in" style={{ animationDelay: `${i * 30}ms` }}>
                    <td>
                      <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
                        <div className="avatar avatar-sm" style={{
                          background: `hsl(${(student.name?.charCodeAt(0) || 0) * 5}, 60%, 50%)`,
                          color: 'white',
                        }}>
                          {student.name?.charAt(0) || '?'}
                        </div>
                        <span style={{ fontWeight: 500 }}>{student.name}</span>
                      </div>
                    </td>
                    <td>
                      <span style={{ fontFamily: 'var(--font-mono)', fontWeight: 600, fontSize: '0.85rem' }}>
                        {student.grade}
                      </span>
                      <span style={{ fontSize: '0.75rem', color: 'var(--color-text-muted)', marginLeft: '0.25rem' }}>
                        ({student.grade_group?.replace('_', ' ')})
                      </span>
                    </td>
                    <td style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>{student.school_name || '-'}</td>
                    <td>
                      {student.academic_score != null ? (
                        <span style={{ fontFamily: 'var(--font-mono)', fontWeight: 600, color: student.academic_score >= 70 ? 'var(--color-success)' : 'var(--color-warning)' }}>
                          {student.academic_score}%
                        </span>
                      ) : '-'}
                    </td>
                    <td><Badge status={student.test1_status || 'pending'} /></td>
                    <td><Badge status={student.test2_status || 'pending'} /></td>
                    <td>
                      <div style={{ display: 'flex', gap: '0.4rem' }}>
                        <Link to={`/students/${student.id}`} className="btn btn-ghost btn-sm" title="View Profile">
                          <Eye size={14} />
                        </Link>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}
