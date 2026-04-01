export default function StatCard({ icon: Icon, value, label, colorClass = 'purple' }) {
  return (
    <div className="stat-card">
      <div className={`stat-icon ${colorClass}`}>
        <Icon size={22} />
      </div>
      <div>
        <div className="stat-value">{value}</div>
        <div className="stat-label">{label}</div>
      </div>
    </div>
  );
}
