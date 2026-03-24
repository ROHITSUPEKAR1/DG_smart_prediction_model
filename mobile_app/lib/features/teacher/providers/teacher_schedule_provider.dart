import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/app.dart';
import 'package:mobile_app/core/cache/cache_manager.dart';
import 'package:mobile_app/core/cache/cache_keys.dart';

// Model for Class Schedule
class ClassSchedule {
  final int id;
  final String title;
  final String subject;
  final String startTime;
  final String endTime;
  final bool isCompleted;

  ClassSchedule({
    required this.id,
    required this.title,
    required this.subject,
    required this.startTime,
    required this.endTime,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subject': subject,
    'startTime': startTime,
    'endTime': endTime,
    'isCompleted': isCompleted,
  };

  factory ClassSchedule.fromJson(Map<String, dynamic> json) => ClassSchedule(
    id: json['id'],
    title: json['title'],
    subject: json['subject'],
    startTime: json['startTime'],
    endTime: json['endTime'],
    isCompleted: json['isCompleted'] ?? false,
  );
}

// Schedule Provider with cache-fallback for offline support
final teacherScheduleProvider = FutureProvider<List<ClassSchedule>>((ref) async {
  try {
    // Simulate API delay (replace with real Dio call)
    await Future.delayed(const Duration(milliseconds: 800));

    final schedules = [
      ClassSchedule(id: 1, title: 'Class 10-A', subject: 'Mathematics', startTime: '08:30 AM', endTime: '09:30 AM', isCompleted: true),
      ClassSchedule(id: 2, title: 'Class 11-B', subject: 'Calculus', startTime: '09:45 AM', endTime: '10:45 AM'),
      ClassSchedule(id: 3, title: 'Class 12-A', subject: 'Physics', startTime: '11:00 AM', endTime: '12:00 PM'),
      ClassSchedule(id: 4, title: 'Class 10-C', subject: 'Algebra', startTime: '01:30 PM', endTime: '02:30 PM'),
    ];

    // Cache on success
    await CacheManager.put(
      CacheKeys.teacherSchedule,
      schedules.map((s) => s.toJson()).toList(),
    );

    return schedules;
  } catch (e) {
    // Fallback to cache on network failure
    final cached = CacheManager.get<List<dynamic>>(CacheKeys.teacherSchedule);
    if (cached != null) {
      return cached
          .map((item) => ClassSchedule.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    rethrow;
  }
});

// Current active period identifier
final currentPeriodProvider = Provider<int>((ref) => 2); // Mock: 2nd period is active
