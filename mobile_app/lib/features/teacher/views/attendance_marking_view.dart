import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/teacher/providers/attendance_marking_provider.dart';
import 'package:mobile_app/features/teacher/widgets/attendance_student_card.dart';

class AttendanceMarkingView extends ConsumerWidget {
  final String classTitle;
  final String subject;

  const AttendanceMarkingView({
    super.key,
    required this.classTitle,
    required this.subject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final students = ref.watch(attendanceMarkingProvider);
    final notifier = ref.read(attendanceMarkingProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('${classTitle} - Attendance'),
      ),
      body: Column(
        children: [
          // Header Tally Stats Row
          _buildTallyHeader(theme, notifier.presentCount, notifier.absentCount),

          // Student List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return AttendanceStudentCard(
                  student: student,
                  onTap: () => notifier.toggleStatus(student.id),
                );
              },
            ),
          ),

          // Bottom Finalize Bar
          _buildBottomAction(context, theme),
        ],
      ),
    );
  }

  Widget _buildTallyHeader(ThemeData theme, int present, int absent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard('Present', present.toString(), Colors.green),
          _buildStatCard('Absent', absent.toString(), Colors.red),
          _buildStatCard('Total', (present + absent).toString(), theme.primaryColor),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String val, Color color) {
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
            fontSize: 12,
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            // Finalize Flow
            _showConfirmation(context, theme);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check_circle_rounded),
              SizedBox(width: 10),
              Text('Finalize & Submit Attendance'),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmation(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalize Attendance?'),
        content: const Text('This will save the records and notify parents of absent students.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Wait'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Attendance submitted successfully!'),
                  backgroundColor: theme.primaryColor,
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
