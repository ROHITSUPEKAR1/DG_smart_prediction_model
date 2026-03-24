import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/teacher/views/class_result_export_view.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.print_rounded, color: Colors.blueAccent),
      tooltip: 'Export Class PDF',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ClassResultExportView()),
        );
      },
    );
  }
}
