import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/parent/providers/result_analytics_provider.dart';
import 'package:mobile_app/features/parent/widgets/subject_radar_chart.dart';
import 'package:mobile_app/features/parent/widgets/exam_trend_line.dart';
import 'package:mobile_app/core/widgets/skeleton_card.dart';

class AcademicAnalyticsView extends ConsumerWidget {
  final String childName;

  const AcademicAnalyticsView({super.key, required this.childName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(resultAnalyticsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('$childName\'s Performance'),
      ),
      body: statsAsync.when(
        data: (stats) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Subject-wise Strengths'),
              SubjectRadarChart(analytics: stats.subjects),
              
              const SizedBox(height: 30),
              
              _buildSectionTitle('Overall Progress Trend'),
              ExamTrendLine(trends: stats.trends),
              
              const SizedBox(height: 30),

              _buildSectionTitle('Report Summary'),
              _buildSimpleReport(stats.subjects, theme),
              
              const SizedBox(height: 50),
            ],
          ),
        ),
        loading: () => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: const [
              SkeletonCard(height: 250),
              SizedBox(height: 20),
              SkeletonCard(height: 200),
              SizedBox(height: 20),
              SkeletonCard(height: 150),
            ],
          ),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 4),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildSimpleReport(List<SubjectAnalysis> subjects, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: subjects.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final s = subjects[index];
          return ListTile(
            title: Text(s.subject, style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
            trailing: Text(
              '${s.percentage.toStringAsFixed(0)}%',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
