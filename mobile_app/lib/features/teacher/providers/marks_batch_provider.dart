import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentMarks {
  final int studentId;
  final String name;
  double marks;

  StudentMarks({required this.studentId, required this.name, this.marks = 0.0});
}

class MarksBatchNotifier extends StateNotifier<List<StudentMarks>> {
  MarksBatchNotifier() : super([]) {
    _loadMockStudents();
  }

  void _loadMockStudents() {
    state = [
      StudentMarks(studentId: 101, name: 'Aditya Kumar'),
      StudentMarks(studentId: 102, name: 'Sneha Sharma'),
      StudentMarks(studentId: 103, name: 'Rajesh Patil'),
      StudentMarks(studentId: 104, name: 'Priya Verma'),
      StudentMarks(studentId: 105, name: 'Amit Singh'),
    ];
  }

  void updateMarks(int studentId, double val) {
    state = state.map((s) => s.studentId == studentId ? StudentMarks(studentId: s.studentId, name: s.name, marks: val) : s).toList();
  }

  Future<void> submit() async {
    await Future.delayed(const Duration(seconds: 2)); // Mock API call
  }
}

final marksBatchProvider = StateNotifierProvider<MarksBatchNotifier, List<StudentMarks>>((ref) {
  return MarksBatchNotifier();
});
