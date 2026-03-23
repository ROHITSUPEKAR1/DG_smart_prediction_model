import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/parent/providers/parent_children_provider.dart';

class ChildSwitcherBar extends ConsumerWidget {
  const ChildSwitcherBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final children = ref.watch(parentChildrenProvider);
    final selectedIndex = ref.watch(selectedChildIndexProvider);

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: children.length,
        itemBuilder: (context, index) {
          final child = children[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => ref.read(selectedChildIndexProvider.notifier).state = index,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? theme.primaryColor : Colors.transparent,
                  width: 2.5,
                ),
              ),
              child: Column(
                children: [
                   CircleAvatar(
                    radius: 26,
                    backgroundColor: theme.primaryColor.withOpacity(0.1),
                    child: Text(
                      child.name[0],
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    child.name.split(' ')[0],
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? theme.primaryColor : const Color(0xFF64748B),
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
