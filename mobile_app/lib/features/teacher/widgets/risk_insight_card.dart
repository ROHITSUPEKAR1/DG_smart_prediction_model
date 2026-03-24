import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RiskInsightCard extends StatelessWidget {
  final Map<String, dynamic> risk;

  const RiskInsightCard({super.key, required this.risk});

  @override
  Widget build(BuildContext context) {
    final isHighSeverity = risk['severity'] == 'high';
    final cardColor = isHighSeverity ? Colors.red : Colors.orange;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: cardColor.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: () {},
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
                    '${risk['first_name']} ${risk['last_name']}',
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildSeverityBadge(cardColor, isHighSeverity),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                risk['description'],
                style: GoogleFonts.outfit(color: Colors.grey[800], fontSize: 14),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.handshake_rounded, size: 18),
                      label: const Text('Schedule PTM'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: cardColor,
                        side: BorderSide(color: cardColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.message_rounded, color: cardColor),
                    style: IconButton.styleFrom(
                      backgroundColor: cardColor.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeverityBadge(Color color, bool isHigh) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(
        isHigh ? 'HIGH RISK' : 'LOW RISK',
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
