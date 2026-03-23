import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/teacher/providers/teacher_schedule_provider.dart';
import 'package:mobile_app/features/teacher/views/attendance_marking_view.dart';

class TimelineScheduleCard extends StatelessWidget {
  final ClassSchedule schedule;
  final bool isCurrent;

  const TimelineScheduleCard({
    super.key,
    required this.schedule,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Column
          Column(
            children: [
              Text(
                schedule.startTime,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: isCurrent ? theme.primaryColor : const Color(0xFF64748B),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 2,
                height: 80,
                decoration: BoxDecoration(
                  color: isCurrent ? theme.primaryColor : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),

          const SizedBox(width: 15),

          // Schedule Card
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceMarkingView(
                      classTitle: schedule.title,
                      subject: schedule.subject,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isCurrent ? theme.primaryColor.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isCurrent ? theme.primaryColor.withOpacity(0.5) : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isCurrent ? [] : [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSubjectBadge(theme, schedule.subject),
                      if (isCurrent)
                        _buildNowBadge(theme)
                      else if (schedule.isCompleted)
                        const Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    schedule.title,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        '${schedule.startTime} - ${schedule.endTime}',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  if (isCurrent) ...[
                    const SizedBox(height: 15),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LinearProgressIndicator(
                        value: 0.65, // Mock Progress
                        backgroundColor: theme.primaryColor.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectBadge(ThemeData theme, String subject) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        subject.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: theme.primaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildNowBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'NOW',
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
