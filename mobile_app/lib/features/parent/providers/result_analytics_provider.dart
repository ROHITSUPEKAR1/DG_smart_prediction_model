import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/cache/cache_manager.dart';
import 'package:mobile_app/core/cache/cache_keys.dart';

class SubjectAnalysis {
  final String subject;
  final double percentage;
  final double classAverage;

  SubjectAnalysis({required this.subject, required this.percentage, required this.classAverage});

  Map<String, dynamic> toJson() => {
    'subject': subject,
    'percentage': percentage,
    'classAverage': classAverage,
  };

  factory SubjectAnalysis.fromJson(Map<String, dynamic> json) => SubjectAnalysis(
    subject: json['subject'],
    percentage: (json['percentage'] as num).toDouble(),
    classAverage: (json['classAverage'] as num).toDouble(),
  );
}

class ExamTrend {
  final String examName;
  final double percentage;

  ExamTrend({required this.examName, required this.percentage});

  Map<String, dynamic> toJson() => {
    'examName': examName,
    'percentage': percentage,
  };

  factory ExamTrend.fromJson(Map<String, dynamic> json) => ExamTrend(
    examName: json['examName'],
    percentage: (json['percentage'] as num).toDouble(),
  );
}

class AcademicStats {
  final List<SubjectAnalysis> subjects;
  final List<ExamTrend> trends;

  AcademicStats({required this.subjects, required this.trends});

  Map<String, dynamic> toJson() => {
    'subjects': subjects.map((s) => s.toJson()).toList(),
    'trends': trends.map((t) => t.toJson()).toList(),
  };

  factory AcademicStats.fromJson(Map<String, dynamic> json) => AcademicStats(
    subjects: (json['subjects'] as List)
        .map((s) => SubjectAnalysis.fromJson(Map<String, dynamic>.from(s)))
        .toList(),
    trends: (json['trends'] as List)
        .map((t) => ExamTrend.fromJson(Map<String, dynamic>.from(t)))
        .toList(),
  );
}

final resultAnalyticsProvider = FutureProvider<AcademicStats>((ref) async {
  try {
    await Future.delayed(const Duration(milliseconds: 1200));

    final stats = AcademicStats(
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

    // Cache on success
    await CacheManager.put(CacheKeys.resultAnalytics, stats.toJson());

    return stats;
  } catch (e) {
    // Fallback to cache on network failure
    final cached = CacheManager.get<Map<String, dynamic>>(CacheKeys.resultAnalytics);
    if (cached != null) {
      return AcademicStats.fromJson(cached);
    }
    rethrow;
  }
});
