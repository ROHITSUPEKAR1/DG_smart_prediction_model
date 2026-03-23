import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubjectAnalysis {
  final String subject;
  final double percentage;
  final double classAverage;

  SubjectAnalysis({required this.subject, required this.percentage, required this.classAverage});
}

class ExamTrend {
  final String examName;
  final double percentage;

  ExamTrend({required this.examName, required this.percentage});
}

class AcademicStats {
  final List<SubjectAnalysis> subjects;
  final List<ExamTrend> trends;

  AcademicStats({required this.subjects, required this.trends});
}

final resultAnalyticsProvider = FutureProvider<AcademicStats>((ref) async {
  await Future.delayed(const Duration(milliseconds: 1200));

  return AcademicStats(
    subjects: [
      SubjectAnalysis(subject: 'Math', percentage: 92, classAverage: 78),
      SubjectAnalysis(subject: 'Science', percentage: 85, classAverage: 72),
      SubjectAnalysis(subject: 'English', percentage: 78, classAverage: 81),
      SubjectAnalysis(subject: 'History', percentage: 88, classAverage: 75),
      SubjectAnalysis(subject: 'Computer', percentage: 95, classAverage: 80),
    ],
    trends: [
      ExamTrend(examName: 'UT 1', percentage: 82),
      ExamTrend(examName: 'Midterm', percentage: 85),
      ExamTrend(examName: 'UT 2', percentage: 88),
      ExamTrend(examName: 'Annual', percentage: 91),
    ],
  );
});
