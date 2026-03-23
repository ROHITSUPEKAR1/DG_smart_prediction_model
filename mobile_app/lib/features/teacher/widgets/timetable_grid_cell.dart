import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/teacher/providers/teacher_schedule_provider.dart';

class TimetableGridCell extends StatelessWidget {
  final ClassSchedule schedule;
  final bool isNow;

  const TimetableGridCell({
    super.key,
    required this.schedule,
    this.isNow = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFree = schedule.title.toLowerCase() == 'free';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNow ? theme.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isNow ? theme.primaryColor : (isFree ? Colors.transparent : theme.primaryColor.withOpacity(0.1)),
          width: 1,
        ),
        boxShadow: isNow ? [
          BoxShadow(color: theme.primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
        ] : [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          // Time Slot Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                schedule.startTime,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isNow ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              Text(
                schedule.endTime,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  color: isNow ? Colors.white.withOpacity(0.7) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),

          // Main Detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isNow ? Colors.white : (isFree ? const Color(0xFF64748B) : theme.primaryColor),
                  ),
                ),
                Text(
                  schedule.subject,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: isNow ? Colors.white.withOpacity(0.8) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          // Action Icon
          if (!isFree)
            Icon(
              Icons.chevron_right_rounded,
              color: isNow ? Colors.white : theme.primaryColor,
            ),
        ],
      ),
    );
  }
}
