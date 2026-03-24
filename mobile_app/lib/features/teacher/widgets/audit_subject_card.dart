import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/teacher/providers/academic_control_provider.dart';
import 'package:mobile_app/features/teacher/views/marks_entry_view.dart';

class AuditSubjectCard extends ConsumerWidget {
  final AuditSubject subject;

  const AuditSubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isComplete = subject.gradedStudents == subject.totalStudents;
    final progress = subject.totalStudents > 0 ? (subject.gradedStudents / subject.totalStudents) : 0.0;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () {
          if (!subject.isPublished) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MarksEntryView()));
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subject.subjectName,
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildStatusBadge(subject.isPublished),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Grading Progress',
                    style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[600]),
                  ),
                  Text(
                    '${subject.gradedStudents} / ${subject.totalStudents}',
                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(isComplete ? Colors.green : Colors.orange),
                ),
              ),
              const SizedBox(height: 20),
              if (!subject.isPublished)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isComplete ? () => _confirmPublish(context, ref) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('PUBLISH RESULTS' + (!isComplete ? ' (Incomplete)' : ''), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'PUBLISHED TO PARENTS',
                      style: GoogleFonts.outfit(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool published) {
    if (published) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Text('LIVE', style: GoogleFonts.outfit(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text('DRAFT', style: GoogleFonts.outfit(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  void _confirmPublish(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Publish ${subject.subjectName}?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: const Text('This will lock editing and instantly send push notifications to all parents allowing them to view the results. This action cannot be undone easily.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(academicControlProvider.notifier).publishSubject(subject.subjectId);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Results Published Successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('CONFIRM & PUBLISH'),
          ),
        ],
      ),
    );
  }
}
