import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/shared/providers/notifications_provider.dart';

class NotificationTile extends StatelessWidget {
  final SchoolNotification notification;
  final VoidCallback onTap;

  const NotificationTile({super.key, required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _getColor(notification.type);
    final icon = _getIcon(notification.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.transparent : color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: notification.isRead ? Colors.grey.withOpacity(0.1) : color.withOpacity(0.2)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          notification.title,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: notification.isRead ? Colors.grey : Colors.black),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            notification.message,
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey[700]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(notification.date),
              style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey),
            ),
            if (!notification.isRead) ...[
              const SizedBox(height: 4),
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            ]
          ],
        ),
      ),
    );
  }

  Color _getColor(String type) {
    switch (type) {
      case 'absence': return Colors.red;
      case 'homework': return Colors.blue;
      case 'fee': return Colors.purple;
      case 'result': return Colors.orange;
      default: return Colors.green;
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'absence': return Icons.warning_amber_rounded;
      case 'homework': return Icons.assignment_rounded;
      case 'fee': return Icons.payment_rounded;
      case 'result': return Icons.analytics_rounded;
      default: return Icons.notifications_active_rounded;
    }
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
