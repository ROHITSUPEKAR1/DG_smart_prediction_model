import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/parent/providers/parent_children_provider.dart';
import 'package:mobile_app/features/parent/widgets/child_switcher_bar.dart';
import 'package:mobile_app/features/parent/widgets/hero_attendance_card.dart';
import 'package:mobile_app/features/parent/widgets/quick_action_grid.dart';
import 'package:mobile_app/features/parent/widgets/emergency_alert_banner.dart';
import 'package:mobile_app/features/shared/views/notifications_inbox_view.dart';
import 'package:mobile_app/features/shared/providers/notifications_provider.dart';

class ParentDashboardView extends ConsumerWidget {
  const ParentDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedChild = ref.watch(selectedChildProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section: Header & Profile
              _buildHeader(context, ref, theme, 'Sarah Sharma'),

              EmergencyAlertBanner(
                message: 'School will be CLOSED tomorrow due to torrential rain.',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsInboxView()));
                },
              ),

              // Multi-child switcher
              const ChildSwitcherBar(),

              const SizedBox(height: 10),

              // Hero: Selected Child's attendance
              HeroAttendanceCard(child: selectedChild),

              // Actions and Report buttons
              const QuickActionGrid(),

              // Latest Notice or Homework Scroller (Wave 3)
              _buildSimpleNoticeBar(theme),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, ThemeData theme, String parentName) {
    final unreadCount = ref.watch(notificationsProvider.notifier).unreadCount;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=S+Sharma&background=f093fb&color=fff'),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Namaste,',
                    style: GoogleFonts.outfit(fontSize: 14, color: const Color(0xFF64748B)),
                  ),
                  Text(
                    parentName,
                    style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B)),
                  ),
                ],
              ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, size: 28, color: Color(0xFF1E293B)),
                onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsInboxView()));
                },
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleNoticeBar(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.info_outline_rounded, color: theme.primaryColor, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latest Announcement',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  'Half-Yearly Exams starting from April 5th.',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}
