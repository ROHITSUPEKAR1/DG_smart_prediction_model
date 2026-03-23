import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/teacher/providers/homework_form_provider.dart';

class AttachmentScroller extends ConsumerWidget {
  const AttachmentScroller({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final attachments = ref.watch(homeworkFormProvider).attachments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Text(
            'Attachments',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF64748B),
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: attachments.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // Add button
                return GestureDetector(
                  onTap: () => ref.read(homeworkFormProvider.notifier).addAttachment('mock_path'),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 15),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.primaryColor.withOpacity(0.2), style: BorderStyle.solid),
                    ),
                    child: Icon(Icons.add_a_photo_rounded, color: theme.primaryColor),
                  ),
                );
              }

              // Attachment preview (mock)
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/80?text=Homework'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: const Icon(Icons.close, color: Colors.white, size: 10),
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
