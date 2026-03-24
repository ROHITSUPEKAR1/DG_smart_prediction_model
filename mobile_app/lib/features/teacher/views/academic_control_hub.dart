import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/teacher/providers/academic_control_provider.dart';
import 'package:mobile_app/features/teacher/widgets/audit_subject_card.dart';

import 'package:mobile_app/features/teacher/widgets/export_button.dart';

class AcademicControlHub extends ConsumerWidget {
  const AcademicControlHub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final subjects = ref.watch(academicControlProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Academic Control'),
        elevation: 0,
        actions: const [ExportButton()],
      ),

      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Term 1 - Mid Term',
                    style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Class X - Section A',
                    style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return AuditSubjectCard(subject: subjects[index]);
                },
                childCount: subjects.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
