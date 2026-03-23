import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/parent/providers/result_analytics_provider.dart';

class SubjectRadarChart extends StatelessWidget {
  final List<SubjectAnalysis> analytics;

  const SubjectRadarChart({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 350,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          radarTouchData: RadarTouchData(enabled: true),
          dataSets: [
            // Student Score Dataset
            RadarDataSet(
              fillColor: theme.primaryColor.withOpacity(0.2),
              borderColor: theme.primaryColor,
              entryRadius: 4,
              dataEntries: analytics.map((s) => RadarEntry(value: s.percentage)).toList(),
              borderWidth: 2,
            ),
            // Class Average Dataset
            RadarDataSet(
              fillColor: Colors.grey.withOpacity(0.1),
              borderColor: Colors.grey.withOpacity(0.5),
              entryRadius: 0,
              dataEntries: analytics.map((s) => RadarEntry(value: s.classAverage)).toList(),
              borderWidth: 1,
            ),
          ],
          getTitle: (index, angle) {
            return RadarChartTitle(
              text: analytics[index].subject,
              angle: angle,
            );
          },
          tickCount: 1,
          ticksTextStyle: const TextStyle(color: Colors.transparent),
          gridBorderData: const BorderSide(color: Color(0xFFE2E8F0)),
          radarBorderData: const BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
