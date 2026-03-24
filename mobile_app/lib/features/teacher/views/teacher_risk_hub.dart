import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/teacher/widgets/risk_insight_card.dart';

final mockRisksProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {
      'id': 1,
      'first_name': 'Karan',
      'last_name': 'Vyas',
      'risk_type': 'attendance',
      'severity': 'high',
      'description': 'Attendance dropped below threshold (68.4%).',
    },
    {
      'id': 2,
      'first_name': 'Sarah',
      'last_name': 'Malik',
      'risk_type': 'academic',
      'severity': 'high',
      'description': 'Failing academic trend detected (Avg: 38.5%).',
    },
  ];
});

class TeacherRiskHub extends ConsumerWidget {
  const TeacherRiskHub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final allRisks = ref.watch(mockRisksProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('AI Risk Insights'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Academic'),
              Tab(text: 'Attendance'),
              Tab(text: 'Financial'),
            ],
            indicatorColor: Colors.red,
            labelColor: Colors.red,
          ),
        ),
        body: TabBarView(
          children: [
            _buildRiskList(allRisks.where((r) => r['risk_type'] == 'academic').toList()),
            _buildRiskList(allRisks.where((r) => r['risk_type'] == 'attendance').toList()),
            _buildRiskList(allRisks.where((r) => r['risk_type'] == 'fee').toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskList(List<Map<String, dynamic>> risks) {
    if (risks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 60, color: Colors.green.withOpacity(0.5)),
            const SizedBox(height: 15),
            Text('No immediate risks detected in this category.', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: risks.length,
      itemBuilder: (context, index) {
        return RiskInsightCard(risk: risks[index]);
      },
    );
  }
}
