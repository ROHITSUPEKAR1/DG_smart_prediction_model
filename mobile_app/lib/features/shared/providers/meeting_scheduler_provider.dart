import 'package:flutter_riverpod/flutter_riverpod.dart';

class Meeting {
  final int id;
  final String parentName;
  final String teacherName;
  final String subjectName;
  final DateTime startTime;
  final String status; // pending, confirmed, rejected
  final String? notes;
  final String? zoomLink;

  Meeting({
    required this.id,
    required this.parentName,
    required this.teacherName,
    required this.subjectName,
    required this.startTime,
    required this.status,
    this.notes,
    this.zoomLink,
  });
}

class MeetingSchedulerNotifier extends StateNotifier<List<Meeting>> {
  MeetingSchedulerNotifier() : super([]) {
    _loadMockMeetings();
  }

  void _loadMockMeetings() {
    state = [
      Meeting(
        id: 1, 
        parentName: 'Sarah Sharma', 
        teacherName: 'Vikram Singh', 
        subjectName: 'Mathematics', 
        startTime: DateTime.now().add(const Duration(days: 1, hours: 2)), 
        status: 'pending',
        notes: 'Discussion about the Mid-term results.'
      ),
      Meeting(
        id: 2, 
        parentName: 'Sarah Sharma', 
        teacherName: 'Anjali Gupta', 
        subjectName: 'History', 
        startTime: DateTime.now().add(const Duration(days: 3, hours: 4)), 
        status: 'confirmed',
        zoomLink: 'https://meet.google.com/abc-xyz'
      ),
    ];
  }

  void requestMeeting(Meeting newMeeting) {
    state = [...state, newMeeting];
  }

  void updateStatus(int id, String newStatus) {
    state = state.map((m) => m.id == id ? Meeting(
      id: m.id, 
      parentName: m.parentName, 
      teacherName: m.teacherName, 
      subjectName: m.subjectName, 
      startTime: m.startTime, 
      status: newStatus,
      notes: m.notes,
      zoomLink: m.zoomLink
    ) : m).toList();
  }

  List<Meeting> getMeetingsForDay(DateTime day) {
    return state.where((m) => 
      m.startTime.year == day.year && 
      m.startTime.month == day.month && 
      m.startTime.day == day.day
    ).toList();
  }
}

final meetingSchedulerProvider = StateNotifierProvider<MeetingSchedulerNotifier, List<Meeting>>((ref) {
  return MeetingSchedulerNotifier();
});
