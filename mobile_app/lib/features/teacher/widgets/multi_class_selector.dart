import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/teacher/providers/homework_form_provider.dart';

class MultiClassSelector extends ConsumerWidget {
  const MultiClassSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedIds = ref.watch(homeworkFormProvider).selectedClassIds;

    final mockClasses = [
      {'id': 1, 'name': '10-A'},
      {'id': 2, 'name': '10-B'},
      {'id': 3, 'name': '11-C'},
      {'id': 4, 'name': '12-A'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Text(
            'Target Classes',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: mockClasses.length,
            itemBuilder: (context, index) {
              final cls = mockClasses[index];
              final isSelected = selectedIds.contains(cls['id']);

              return GestureDetector(
                onTap: () => ref.read(homeworkFormProvider.notifier).toggleClass(cls['id'] as int),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? theme.primaryColor : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      cls['name'] as String,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
