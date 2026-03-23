import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchoolNotification {
  final int id;
  final String type;
  final String title;
  final String message;
  final DateTime date;
  bool isRead;

  SchoolNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
  });
}

class NotificationsNotifier extends StateNotifier<List<SchoolNotification>> {
  NotificationsNotifier() : super([]) {
    _loadMockHistory();
  }

  void _loadMockHistory() {
    state = [
      SchoolNotification(id: 1, type: 'absence', title: 'Student Absence Alert', message: 'Aditya has been marked ABSENT for Maths period.', date: DateTime.now().subtract(const Duration(hours: 2))),
      SchoolNotification(id: 2, type: 'attendance', title: 'Welcome to Term 2', message: 'School starts from tomorrow. Check the updated timetable.', date: DateTime.now().subtract(const Duration(days: 1))),
      SchoolNotification(id: 3, type: 'fee', title: 'Fee Due Soon', message: 'Q2 Tuition Fee (5,500 INR) is due by 30th March.', date: DateTime.now().subtract(const Duration(days: 3))),
    ];
  }

  void markAsRead(int id) {
    state = state.map((n) => n.id == id ? SchoolNotification(id: n.id, type: n.type, title: n.title, message: n.message, date: n.date, isRead: true) : n).toList();
  }

  int get unreadCount => state.where((n) => !n.isRead).length;
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, List<SchoolNotification>>((ref) {
  return NotificationsNotifier();
});
