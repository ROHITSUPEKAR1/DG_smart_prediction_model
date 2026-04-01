import { Link, useLocation } from 'react-router-dom';
import { Rocket } from 'lucide-react';
import { useAppContext } from '../../context/AppContext';

export default function Navbar() {
  const { sidebarOpen, setSidebarOpen } = useAppContext();
  const location = useLocation();

  return (
    <nav style={{
      position: 'fixed',
      top: 0,
      left: 0,
      right: 0,
      height: 'var(--navbar-height)',
      background: 'rgba(26, 31, 60, 0.85)',
      backdropFilter: 'blur(20px)',
      borderBottom: '1px solid var(--color-border)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: '0 1.5rem',
      zIndex: 1000,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
        <button
          onClick={() => setSidebarOpen(!sidebarOpen)}
          className="btn-ghost"
          style={{ padding: '0.4rem', borderRadius: 'var(--radius-sm)', lineHeight: 1, border: 'none', cursor: 'pointer', background: 'transparent', color: 'var(--color-text-muted)' }}
        >
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M3 12h18M3 6h18M3 18h18" />
          </svg>
        </button>
        <Link to="/" style={{ display: 'flex', alignItems: 'center', gap: '0.6rem', textDecoration: 'none' }}>
          <div style={{
            width: 36, height: 36,
            borderRadius: 'var(--radius-md)',
            background: 'var(--gradient-primary)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}>
            <Rocket size={20} color="white" />
          </div>
          <div>
            <div style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: '1rem', color: 'var(--color-text-primary)' }}>
              Antigravity
            </div>
            <div style={{ fontSize: '0.65rem', color: 'var(--color-text-muted)', marginTop: -2 }}>
              Career Intelligence
            </div>
          </div>
        </Link>
      </div>

      <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
        <div style={{
          padding: '0.3rem 0.75rem',
          background: 'var(--color-success-bg)',
          border: '1px solid rgba(67, 233, 123, 0.3)',
          borderRadius: 'var(--radius-full)',
          fontSize: '0.75rem',
          color: 'var(--color-success)',
          fontWeight: 600,
        }}>
          v1.0.0
        </div>
      </div>
    </nav>
  );
}
