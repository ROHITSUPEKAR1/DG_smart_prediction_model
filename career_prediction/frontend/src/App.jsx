import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { AppProvider, useAppContext } from './context/AppContext';
import Navbar from './components/layouts/Navbar';
import Sidebar from './components/layouts/Sidebar';
import ToastContainer from './components/ui/ToastContainer';
import Dashboard from './pages/Dashboard';
import StudentList from './pages/Students/StudentList';
import StudentRegister from './pages/Students/StudentRegister';
import StudentProfile from './pages/Students/StudentProfile';
import TestTaker from './pages/Tests/TestTaker';
import TestResult from './pages/Tests/TestResult';
import ReportList from './pages/Reports/ReportList';
import './index.css';

function AppLayout({ children }) {
  const { sidebarOpen } = useAppContext();

  return (
    <div className="app-layout">
      <Navbar />
      <Sidebar />
      <main className={`main-content ${!sidebarOpen ? 'sidebar-collapsed' : ''}`}>
        {children}
      </main>
      <ToastContainer />
    </div>
  );
}

export default function App() {
  return (
    <AppProvider>
      <Router>
        <AppLayout>
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/students" element={<StudentList />} />
            <Route path="/students/register" element={<StudentRegister />} />
            <Route path="/students/:id" element={<StudentProfile />} />
            <Route path="/tests/:testId/take" element={<TestTaker />} />
            <Route path="/tests/:testId/result" element={<TestResult />} />
            <Route path="/reports" element={<ReportList />} />
          </Routes>
        </AppLayout>
      </Router>
    </AppProvider>
  );
}
