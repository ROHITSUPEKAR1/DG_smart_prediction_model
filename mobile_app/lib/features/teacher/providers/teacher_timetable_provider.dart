import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/teacher/providers/teacher_schedule_provider.dart';

// Model for a Weekly Grid Slot
class TimetableSlot {
  final String day;
  final List<ClassSchedule> periods;

  TimetableSlot({required this.day, required this.periods});
}

final teacherTimetableProvider = FutureProvider<List<TimetableSlot>>((ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 1000));

  final mockPeriods = [
    ClassSchedule(id: 1, title: '10-A', subject: 'Math', startTime: '08:00', endTime: '09:00'),
    ClassSchedule(id: 2, title: '11-B', subject: 'Calculus', startTime: '09:15', endTime: '10:15'),
    ClassSchedule(id: 3, title: 'Free', subject: '-', startTime: '10:30', endTime: '11:30'),
    ClassSchedule(id: 4, title: '12-A', subject: 'Physics', startTime: '11:45', endTime: '12:45'),
    ClassSchedule(id: 5, title: '10-C', subject: 'Algebra', startTime: '01:30', endTime: '02:30'),
  ];

  return [
    TimetableSlot(day: 'Mon', periods: mockPeriods),
    TimetableSlot(day: 'Tue', periods: mockPeriods),
    TimetableSlot(day: 'Wed', periods: mockPeriods),
    TimetableSlot(day: 'Thu', periods: mockPeriods),
    TimetableSlot(day: 'Fri', periods: mockPeriods),
  ];
});

final selectedDayIndexProvider = StateProvider<int>((ref) => 0); // Default to Monday
