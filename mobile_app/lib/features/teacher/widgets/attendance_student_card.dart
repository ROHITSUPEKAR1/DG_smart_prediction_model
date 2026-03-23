import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/teacher/providers/attendance_marking_provider.dart';

class AttendanceStudentCard extends StatelessWidget {
  final StudentStatus student;
  final VoidCallback onTap;

  const AttendanceStudentCard({
    super.key,
    required this.student,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPresent = student.status == AttendanceStatus.present;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isPresent ? Colors.white : Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPresent ? Colors.transparent : Colors.red.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            if (isPresent)
              const BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            // Student Photo Avatar
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded, color: Colors.indigo, size: 24),
            ),
            const SizedBox(width: 15),

            // Student Name & Roll No
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isPresent ? const Color(0xFF1E293B) : Colors.red,
                    ),
                  ),
                  Text(
                    'Roll No: ${student.rollNo}',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            // Status Badge Column
            Column(
              children: [
                _buildStatusIndicator(isPresent),
                const SizedBox(height: 4),
                Text(
                  isPresent ? 'PRESENT' : 'ABSENT',
                  style: GoogleFonts.outfit(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isPresent ? theme.primaryColor : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(bool isPresent) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isPresent ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isPresent ? Icons.check_circle_rounded : Icons.cancel_rounded,
        color: isPresent ? Colors.green : Colors.red,
        size: 24,
      ),
    );
  }
}
