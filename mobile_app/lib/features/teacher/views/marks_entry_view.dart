import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/teacher/providers/marks_batch_provider.dart';
import 'package:mobile_app/features/teacher/widgets/student_marks_row.dart';

class MarksEntryView extends ConsumerStatefulWidget {
  const MarksEntryView({super.key});

  @override
  ConsumerState<MarksEntryView> createState() => _MarksEntryViewState();
}

class _MarksEntryViewState extends ConsumerState<MarksEntryView> {
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final students = ref.watch(marksBatchProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Marks Entry'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: TextButton(
              onPressed: isSubmitting 
                ? null 
                : () async {
                  setState(() => isSubmitting = true);
                  await ref.read(marksBatchProvider.notifier).submit();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Academic reports updated for all students!')),
                    );
                    Navigator.pop(context);
                  }
                },
              child: isSubmitting 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue))
                : const Text('SUBMIT ALL'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildInfoBar(theme),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return StudentMarksRow(
                  name: student.name,
                  currentMarks: student.marks,
                  onChanged: (val) {
                    final doubleValue = double.tryParse(val) ?? 0.0;
                    ref.read(marksBatchProvider.notifier).updateMarks(student.studentId, doubleValue);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBar(ThemeData theme) {
    return Container(
      width: double.infinity,
      color: theme.primaryColor.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mathematics - Unit Test 1',
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: theme.primaryColor),
              ),
              const SizedBox(height: 4),
              Text(
                'Class: 10-A | Max Marks: 100',
                style: GoogleFonts.outfit(fontSize: 12, color: const Color(0xFF64748B)),
              ),
            ],
          ),
          const Icon(Icons.info_outline_rounded, color: Color(0xFF64748B), size: 18),
        ],
      ),
    );
  }
}
