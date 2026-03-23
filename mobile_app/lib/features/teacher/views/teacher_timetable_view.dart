import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/teacher/providers/teacher_timetable_provider.dart';
import 'package:mobile_app/features/teacher/widgets/timetable_grid_cell.dart';

class TeacherTimetableView extends ConsumerWidget {
  const TeacherTimetableView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final timetableAsync = ref.watch(teacherTimetableProvider);
    final selectedDayIndex = ref.watch(selectedDayIndexProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Weekly Timetable'),
      ),
      body: Column(
        children: [
          // Day Scroller Header
          _buildDayHeader(ref, selectedDayIndex, theme),

          const SizedBox(height: 20),

          // Period List for selected day
          Expanded(
            child: timetableAsync.when(
              data: (slots) {
                final selectedDay = slots[selectedDayIndex];
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: selectedDay.periods.length,
                  itemBuilder: (context, index) {
                    final period = selectedDay.periods[index];
                    final isNow = selectedDayIndex == 0 && index == 1; // Mock: Mon 2nd pos

                    return TimetableGridCell(
                      schedule: period,
                      isNow: isNow,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeader(WidgetRef ref, int selectedIndex, ThemeData theme) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => ref.read(selectedDayIndexProvider.notifier).state = index,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 15),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? theme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? theme.primaryColor : const Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    days[index],
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
