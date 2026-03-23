import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/teacher/providers/homework_form_provider.dart';
import 'package:mobile_app/features/teacher/widgets/multi_class_selector.dart';
import 'package:mobile_app/features/teacher/widgets/attachment_scroller.dart';

class AddHomeworkView extends ConsumerWidget {
  const AddHomeworkView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formState = ref.watch(homeworkFormProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Add Homework'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: TextButton(
              onPressed: formState.isSubmitting 
                ? null 
                : () async {
                  final ok = await ref.read(homeworkFormProvider.notifier).submit();
                  if (ok && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Homework posted & FCM alerts sent!')),
                    );
                    Navigator.pop(context);
                  }
                },
              child: formState.isSubmitting 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue))
                : const Text('POST'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Target Class Selector
            const MultiClassSelector(),

            const SizedBox(height: 10),

            // Subject and Caption Input
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Subject'),
                  TextField(
                    onChanged: (val) => ref.read(homeworkFormProvider.notifier).setSubject(val),
                    decoration: _inputDecoration('e.g. Mathematics'),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Instructions / Caption'),
                  TextField(
                    maxLines: 5,
                    onChanged: (val) => ref.read(homeworkFormProvider.notifier).setCaption(val),
                    decoration: _inputDecoration('Write homework details here...'),
                  ),
                ],
              ),
            ),

            // Hybrid Attachments
            const AttachmentScroller(),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF64748B),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
    );
  }
}
