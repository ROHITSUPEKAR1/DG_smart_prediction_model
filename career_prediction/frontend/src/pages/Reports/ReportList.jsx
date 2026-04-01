import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { FileText, Eye, Calendar } from 'lucide-react';
import Badge from '../../components/ui/Badge';
import LoadingSpinner from '../../components/ui/LoadingSpinner';
import { listStudents } from '../../lib/api/studentsApi';
import { getStudentReports } from '../../lib/api/reportsApi';

export default function ReportList() {
  const [reports, setReports] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchReports() {
      try {
        const studentsRes = await listStudents();
        const students = studentsRes.data.students || [];

        const allReports = [];
        for (const student of students) {
          try {
            const reportsRes = await getStudentReports(student.id);
            const studentReports = (reportsRes.data || []).map(r => ({
              ...r,
              student_name: student.name,
              student_grade: student.grade,
            }));
            allReports.push(...studentReports);
          } catch (e) {
            // Skip if no reports
          }
        }
        allReports.sort((a, b) => (b.generated_at || '').localeCompare(a.generated_at || ''));
        setReports(allReports);
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    }
    fetchReports();
  }, []);

  if (loading) return <LoadingSpinner fullPage text="Loading reports..." />;

  return (
    <div className="page-wrapper">
      <div className="page-header">
        <h1>Career Reports</h1>
        <p>{reports.length} reports generated</p>
      </div>

      {reports.length === 0 ? (
        <div className="card">
          <div className="empty-state">
            <div className="icon">📄</div>
            <h3>No reports yet</h3>
            <p>Reports are generated after students complete their tests.</p>
            <Link to="/students" className="btn btn-primary">View Students</Link>
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
                  <th>Report Type</th>
                  <th>Generated</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {reports.map((report, i) => (
                  <tr key={report.id} className="animate-fade-in" style={{ animationDelay: `${i * 30}ms` }}>
                    <td style={{ fontWeight: 500 }}>{report.student_name}</td>
                    <td>
                      <span style={{ fontFamily: 'var(--font-mono)', fontWeight: 600 }}>
                        {report.student_grade}
                      </span>
                    </td>
                    <td>
                      <Badge status={report.report_type?.includes('test1') ? 'completed' : report.report_type?.includes('test2') ? 'in_progress' : 'pending'}>
                        {report.report_type === 'test1_report' ? 'Test 1 Report' : report.report_type === 'test2_report' ? 'Test 2 Report' : report.report_type}
                      </Badge>
                    </td>
                    <td style={{ color: 'var(--color-text-muted)', fontSize: '0.85rem' }}>
                      {report.generated_at ? new Date(report.generated_at).toLocaleDateString() : '-'}
                    </td>
                    <td>
                      <Link to={`/students/${report.student_id}`} className="btn btn-ghost btn-sm">
                        <Eye size={14} /> View
                      </Link>
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
