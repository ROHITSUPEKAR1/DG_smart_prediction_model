export default function Badge({ status, children }) {
  const statusClass = `badge badge-${(status || '').replace(' ', '-')}`;
  return <span className={statusClass}>{children || status}</span>;
}
