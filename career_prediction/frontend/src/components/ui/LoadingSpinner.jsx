export default function LoadingSpinner({ text = 'Loading...', fullPage = false }) {
  const style = fullPage
    ? { display: 'flex', alignItems: 'center', justifyContent: 'center', minHeight: '60vh', flexDirection: 'column', gap: '1rem' }
    : { display: 'flex', alignItems: 'center', gap: '0.5rem', color: 'var(--color-text-muted)', fontSize: '0.9rem' };

  return (
    <div style={style}>
      <div style={{
        width: fullPage ? 40 : 18,
        height: fullPage ? 40 : 18,
        border: `3px solid var(--color-border)`,
        borderTopColor: 'var(--color-accent)',
        borderRadius: '50%',
        animation: 'spin 0.8s linear infinite',
      }} />
      {text && <span style={{ color: 'var(--color-text-muted)', fontSize: fullPage ? '1rem' : '0.85rem' }}>{text}</span>}
      <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
    </div>
  );
}
