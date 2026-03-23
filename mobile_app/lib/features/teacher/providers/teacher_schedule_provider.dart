import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/app.dart';

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
}

// Mock Schedule Provider for v1 UI dev
final teacherScheduleProvider = FutureProvider<List<ClassSchedule>>((ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 800));
  
  return [
    ClassSchedule(id: 1, title: 'Class 10-A', subject: 'Mathematics', startTime: '08:30 AM', endTime: '09:30 AM', isCompleted: true),
    ClassSchedule(id: 2, title: 'Class 11-B', subject: 'Calculus', startTime: '09:45 AM', endTime: '10:45 AM'),
    ClassSchedule(id: 3, title: 'Class 12-A', subject: 'Physics', startTime: '11:00 AM', endTime: '12:00 PM'),
    ClassSchedule(id: 4, title: 'Class 10-C', subject: 'Algebra', startTime: '01:30 PM', endTime: '02:30 PM'),
  ];
});

// Current active period identifier
final currentPeriodProvider = Provider<int>((ref) => 2); // Mock: 2nd period is active
