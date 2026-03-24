import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuditSubject {
  final int subjectId;
  final String subjectName;
  final int totalStudents;
  final int gradedStudents;
  final bool isPublished;

  AuditSubject({
    required this.subjectId,
    required this.subjectName,
    required this.totalStudents,
    required this.gradedStudents,
    required this.isPublished,
  });

  AuditSubject copyWith({
    int? subjectId,
    String? subjectName,
    int? totalStudents,
    int? gradedStudents,
    bool? isPublished,
  }) {
    return AuditSubject(
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      totalStudents: totalStudents ?? this.totalStudents,
      gradedStudents: gradedStudents ?? this.gradedStudents,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}

class AcademicControlNotifier extends StateNotifier<List<AuditSubject>> {
  AcademicControlNotifier() : super([]) {
    _loadMocks();
  }

  void _loadMocks() {
    state = [
      AuditSubject(subjectId: 101, subjectName: 'Mathematics', totalStudents: 45, gradedStudents: 45, isPublished: true),
      AuditSubject(subjectId: 102, subjectName: 'Physics', totalStudents: 45, gradedStudents: 40, isPublished: false),
      AuditSubject(subjectId: 103, subjectName: 'Chemistry', totalStudents: 45, gradedStudents: 0, isPublished: false),
    ];
  }

  Future<void> publishSubject(int subjectId) async {
    // Mock API call delay
    await Future.delayed(const Duration(seconds: 1));
    state = state.map((s) => s.subjectId == subjectId ? s.copyWith(isPublished: true) : s).toList();
  }
}

final academicControlProvider = StateNotifierProvider<AcademicControlNotifier, List<AuditSubject>>((ref) {
  return AcademicControlNotifier();
});
