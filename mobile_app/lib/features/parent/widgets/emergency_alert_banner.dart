import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AlertType { schoolCircular, criticalRisk, softWarning }

class EmergencyAlertBanner extends StatelessWidget {
  final String title;
  final String message;
  final AlertType type;
  final VoidCallback onTap;

  const EmergencyAlertBanner({
    super.key,
    required this.message,
    required this.onTap,
    this.title = 'URGENT UPDATE',
    this.type = AlertType.schoolCircular,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors;
    IconData iconData;

    switch (type) {
      case AlertType.criticalRisk:
        gradientColors = const [Color(0xFFEF4444), Color(0xFFDC2626)];
        iconData = Icons.warning_rounded;
        break;
      case AlertType.softWarning:
        gradientColors = const [Color(0xFFF59E0B), Color(0xFFD97706)];
        iconData = Icons.info_outline_rounded;
        break;
      case AlertType.schoolCircular:
      default:
        gradientColors = const [Color(0xFF3B82F6), Color(0xFF2563EB)];
        iconData = Icons.campaign_rounded;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: gradientColors[0].withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Icon(iconData, color: Colors.white, size: 28),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.8), letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),

          ],
        ),
      ),
    );
  }
}
