import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ClassResultExportView extends StatelessWidget {
  const ClassResultExportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Class Results'),
        backgroundColor: Colors.blueAccent,
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format, 'Class X - Section A', 'Term 1 - Mid Term'),
        canChangeOrientation: false,
        canChangePageFormat: false,
        allowPrinting: true,
        allowSharing: true,
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String className, String examName) async {
    final pdf = pw.Document();

    // Mock Data Matrix (Row: Student, Col: Subject)
    final headers = ['Student Name', 'Math', 'Physics', 'Chem', 'Total', 'Grade'];
    final data = [
      ['Riya Singh', '85', '78', '92', '255', 'A'],
      ['Aman Gupta', '90', '88', '85', '263', 'A+'],
      ['Sarah Malik', '65', '70', '68', '203', 'B'],
      ['Karan Vyas', '45', '50', '52', '147', 'C'],
      ['Neha Sharma', '95', '98', '94', '287', 'A+'],
    ];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('DG SMART SCHOOL', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
                  pw.SizedBox(height: 5),
                  pw.Text('Academic Result Archival Report', style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Class: $className', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Exam: $examName', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Date: ${DateTime.now().toLocal().toString().split(' ')[0]}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                ],
              ),
            ),
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: data,
              border: pw.TableBorder.all(color: PdfColors.grey300),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
              rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200))),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.all(8),
              cellStyle: const pw.TextStyle(fontSize: 10),
            ),
            pw.SizedBox(height: 30),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.SizedBox(height: 40),
                    pw.Container(width: 150, height: 1, color: PdfColors.black),
                    pw.SizedBox(height: 5),
                    pw.Text('Principal / Coordinator Signature', style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 10)),
                  ]
                )
              ]
            )
          ];
        },
      ),
    );

    return pdf.save();
  }
}
