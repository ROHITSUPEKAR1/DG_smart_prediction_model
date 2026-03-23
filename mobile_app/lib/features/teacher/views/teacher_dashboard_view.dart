import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/teacher/providers/teacher_schedule_provider.dart';
import 'package:mobile_app/features/teacher/widgets/stats_summary_row.dart';
import 'package:mobile_app/features/teacher/widgets/timeline_schedule_card.dart';

class TeacherDashboardView extends ConsumerWidget {
  const TeacherDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheduleAsync = ref.watch(teacherScheduleProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Section
            _buildHeader(theme, 'John Mitchell'),

            // Stats row (Wave 2)
            const StatsSummaryRow(),

            const SizedBox(height: 20),

            // Today's Schedule Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Schedule",
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Full Timetable',
                      style: GoogleFonts.outfit(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Timeline View
            Expanded(
              child: scheduleAsync.when(
                data: (schedules) => ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];
                    final isCurrent = index == 1; // Mock: 2nd icon is active
                    return TimelineScheduleCard(
                      schedule: schedule,
                      isCurrent: isCurrent,
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, String teacherName) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning,',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: const Color(0xFF64748B),
                ),
              ),
              Text(
                teacherName,
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.primaryColor, width: 2),
            ),
            child: const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.indigo),
            ),
          ),
        ],
      ),
    );
  }
}
