import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/parent/providers/result_analytics_provider.dart';

class ExamTrendLine extends StatelessWidget {
  final List<ExamTrend> trends;

  const ExamTrendLine({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 250,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  final idx = val.toInt();
                  if (idx < trends.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(trends[idx].examName, style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey)),
                    );
                  }
                  return const SizedBox();
                },
                reservedSize: 30,
                interval: 1,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: trends.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.percentage)).toList(),
              isCurved: true,
              color: theme.primaryColor,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: theme.primaryColor.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
