import { NavLink, useLocation } from 'react-router-dom';
import { LayoutDashboard, Users, ClipboardList, FileText, TrendingUp, UserPlus } from 'lucide-react';
import { useAppContext } from '../../context/AppContext';

const navItems = [
  { path: '/', icon: LayoutDashboard, label: 'Dashboard' },
  { path: '/students', icon: Users, label: 'Students' },
  { path: '/students/register', icon: UserPlus, label: 'Register Student' },
  { path: '/reports', icon: FileText, label: 'Reports' },
];

export default function Sidebar() {
  const { sidebarOpen } = useAppContext();
  const location = useLocation();

  return (
    <aside style={{
      position: 'fixed',
      top: 'var(--navbar-height)',
      left: 0,
      bottom: 0,
      width: sidebarOpen ? 'var(--sidebar-width)' : '0',
      background: 'rgba(22, 27, 53, 0.95)',
      backdropFilter: 'blur(20px)',
      borderRight: sidebarOpen ? '1px solid var(--color-border)' : 'none',
      padding: sidebarOpen ? '1rem 0.75rem' : '0',
      transition: 'all 0.25s ease',
      zIndex: 900,
      overflow: sidebarOpen ? 'auto' : 'hidden',
    }}>
      <div style={{ marginBottom: '0.5rem', padding: '0 0.5rem' }}>
        <span style={{ fontSize: '0.7rem', textTransform: 'uppercase', letterSpacing: '0.1em', color: 'var(--color-text-muted)', fontWeight: 600 }}>
          Navigation
        </span>
      </div>

      <nav style={{ display: 'flex', flexDirection: 'column', gap: '4px' }}>
        {navItems.map((item) => {
          const isActive = location.pathname === item.path || 
            (item.path !== '/' && location.pathname.startsWith(item.path));
          const Icon = item.icon;

          return (
            <NavLink
              key={item.path}
              to={item.path}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '0.75rem',
                padding: '0.6rem 0.75rem',
                borderRadius: 'var(--radius-md)',
                fontSize: '0.875rem',
                fontWeight: isActive ? 600 : 400,
                color: isActive ? 'var(--color-accent)' : 'var(--color-text-muted)',
                background: isActive ? 'rgba(108, 99, 255, 0.1)' : 'transparent',
                textDecoration: 'none',
                transition: 'all 0.15s ease',
              }}
              onMouseEnter={(e) => {
                if (!isActive) {
                  e.currentTarget.style.background = 'rgba(108,99,255,0.05)';
                  e.currentTarget.style.color = 'var(--color-text-secondary)';
                }
              }}
              onMouseLeave={(e) => {
                if (!isActive) {
                  e.currentTarget.style.background = 'transparent';
                  e.currentTarget.style.color = 'var(--color-text-muted)';
                }
              }}
            >
              <Icon size={18} />
              <span>{item.label}</span>
              {isActive && (
                <div style={{
                  width: 4, height: 4,
                  borderRadius: '50%',
                  background: 'var(--color-accent)',
                  marginLeft: 'auto',
                  boxShadow: '0 0 8px var(--color-accent)',
                }} />
              )}
            </NavLink>
          );
        })}
      </nav>

      <div style={{
        position: 'absolute',
        bottom: '1rem',
        left: '0.75rem',
        right: '0.75rem',
        padding: '1rem',
        background: 'rgba(108, 99, 255, 0.08)',
        borderRadius: 'var(--radius-lg)',
        border: '1px solid rgba(108, 99, 255, 0.15)',
      }}>
        <div style={{ fontSize: '0.8rem', fontWeight: 600, color: 'var(--color-accent)', marginBottom: '0.25rem' }}>
          🧠 AI Powered
        </div>
        <div style={{ fontSize: '0.72rem', color: 'var(--color-text-muted)', lineHeight: 1.4 }}>
          Using Groq LLaMA 3.3 70B for intelligent career predictions
        </div>
      </div>
    </aside>
  );
}
