import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/teacher/views/academic_control_hub.dart';
import 'package:mobile_app/features/teacher/views/marks_entry_view.dart';
import 'package:mobile_app/features/teacher/views/add_homework_view.dart';
import 'package:mobile_app/features/teacher/views/teacher_meeting_view.dart';

import 'package:mobile_app/features/teacher/views/teacher_risk_hub.dart';

class TeacherQuickActions extends StatelessWidget {
  const TeacherQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallAction(context, 'Post Marks', Icons.grading_rounded, Colors.blue, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AcademicControlHub()));
              }),
              _buildSmallAction(context, 'Homework', Icons.assignment_turned_in_rounded, Colors.orange, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddHomeworkView()));
              }),
              _buildSmallAction(context, 'Insights', Icons.insights_rounded, Colors.purple, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TeacherRiskHub()));
              }),
              _buildSmallAction(context, 'Meetings', Icons.handshake_rounded, Colors.green, () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TeacherMeetingView()));
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallAction(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
