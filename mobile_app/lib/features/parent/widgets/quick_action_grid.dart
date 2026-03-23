import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/parent/providers/parent_children_provider.dart';
import 'package:mobile_app/features/parent/views/attendance_history_view.dart';
import 'package:mobile_app/features/parent/views/fee_ledger_view.dart';

class QuickActionGrid extends ConsumerWidget {
  const QuickActionGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChild = ref.watch(selectedChildProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 15),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1.4,
            children: [
              _buildActionCard(context, 'Fees', Icons.payment_rounded, Colors.purple, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeeLedgerView(childName: selectedChild.name),
                  ),
                );
              }),
              _buildActionCard(context, 'Attendance', Icons.calendar_month_rounded, Colors.green, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceHistoryView(childName: selectedChild.name),
                  ),
                );
              }),
              _buildActionCard(context, 'Results', Icons.auto_graph_rounded, Colors.orange, () {}),
              _buildActionCard(context, 'Homework', Icons.menu_book_rounded, Colors.blue, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
