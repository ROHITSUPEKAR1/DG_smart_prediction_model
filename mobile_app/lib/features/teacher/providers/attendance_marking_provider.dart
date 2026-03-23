import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AttendanceStatus { present, absent, late, leave }

class StudentStatus {
  final int id;
  final String name;
  final String rollNo;
  final String? photoUrl;
  final AttendanceStatus status;

  StudentStatus({
    required this.id,
    required this.name,
    required this.rollNo,
    this.photoUrl,
    this.status = AttendanceStatus.present,
  });

  StudentStatus copyWith({AttendanceStatus? status}) {
    return StudentStatus(
      id: id,
      name: name,
      rollNo: rollNo,
      photoUrl: photoUrl,
      status: status ?? this.status,
    );
  }
}

class AttendanceMarkingNotifier extends StateNotifier<List<StudentStatus>> {
  AttendanceMarkingNotifier() : super([]) {
    _loadInitialData();
  }

  void _loadInitialData() {
    state = [
      StudentStatus(id: 1, name: 'Abeera Sharma', rollNo: '101'),
      StudentStatus(id: 2, name: 'Aditya Verma', rollNo: '102'),
      StudentStatus(id: 3, name: 'Aryan Kapoor', rollNo: '103'),
      StudentStatus(id: 4, name: 'Divya Gupta', rollNo: '104'),
      StudentStatus(id: 5, name: 'Esha Reddy', rollNo: '105'),
    ];
  }

  void toggleStatus(int studentId) {
    state = [
      for (final student in state)
        if (student.id == studentId)
          student.copyWith(
            status: student.status == AttendanceStatus.present 
              ? AttendanceStatus.absent 
              : AttendanceStatus.present
          )
        else
          student
    ];
  }

  int get presentCount => state.where((s) => s.status == AttendanceStatus.present).length;
  int get absentCount => state.where((s) => s.status == AttendanceStatus.absent).length;
}

final attendanceMarkingProvider = StateNotifierProvider<AttendanceMarkingNotifier, List<StudentStatus>>((ref) {
  return AttendanceMarkingNotifier();
});
