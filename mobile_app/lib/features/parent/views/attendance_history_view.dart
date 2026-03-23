import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/parent/widgets/attendance_weekly_scroller.dart';
import 'package:mobile_app/features/parent/widgets/attendance_status_card.dart';

class AttendanceHistoryView extends StatelessWidget {
  final String childName;

  const AttendanceHistoryView({super.key, required this.childName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('${childName}\'s Attendance'),
      ),
      body: Column(
        children: [
          // Weekly Insight Scroller
          const AttendanceWeeklyScroller(),

          const SizedBox(height: 10),

          // Statistics Header (Wave 3)
          _buildStatsStrip(theme),

          const SizedBox(height: 20),

          // History List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 5,
              itemBuilder: (context, index) {
                return const AttendanceStatusCard(
                  date: '21st March 2026',
                  status: 'Present',
                  time: '08:42 AM',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsStrip(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('94%', 'Percentage', Colors.green),
          _buildStat('18', 'Present', theme.primaryColor),
          _buildStat('02', 'Absent', Colors.red),
        ],
      ),
    );
  }

  Widget _buildStat(String val, String label, Color color) {
    return Column(
      children: [
        Text(
          val,
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
