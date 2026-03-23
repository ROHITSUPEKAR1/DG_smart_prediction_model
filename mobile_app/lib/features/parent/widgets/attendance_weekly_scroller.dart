import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceWeeklyScroller extends StatelessWidget {
  const AttendanceWeeklyScroller({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final statuses = ['P', 'P', 'A', 'P', 'P', '?', '?'];

    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final isToday = index == 0; // Mock: first is current
          final status = statuses[index];
          final isAbsent = status == 'A';
          final isPresent = status == 'P';

          return Container(
            width: 55,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isToday ? theme.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: isToday ? [
                BoxShadow(color: theme.primaryColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
              ] : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  days[index],
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: isToday ? Colors.white.withOpacity(0.8) : const Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                _buildStatusCircle(status, isPresent, isAbsent, isToday),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCircle(String symbol, bool isPresent, bool isAbsent, bool isToday) {
    Color bg = Colors.grey.shade100;
    Color text = Colors.grey;

    if (isPresent) {
       bg = isToday ? Colors.white.withOpacity(0.2) : Colors.green.withOpacity(0.1);
       text = isToday ? Colors.white : Colors.green;
    } else if (isAbsent) {
       bg = isToday ? Colors.white.withOpacity(0.2) : Colors.red.withOpacity(0.1);
       text = isToday ? Colors.white : Colors.red;
    }

    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          symbol,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: text,
          ),
        ),
      ),
    );
  }
}
