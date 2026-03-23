import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/shared/providers/meeting_scheduler_provider.dart';

class TeacherMeetingView extends ConsumerWidget {
  const TeacherMeetingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final meetings = ref.watch(meetingSchedulerProvider);
    final pending = meetings.where((m) => m.status == 'pending').toList();
    final confirmed = meetings.where((m) => m.status == 'confirmed').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Manage Meetings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending Requests'),
              Tab(text: 'Upcoming Meetings'),
            ],
            indicatorColor: Colors.purple,
            labelColor: Colors.purple,
          ),
        ),
        body: TabBarView(
          children: [
            _buildMeetingList(ref, pending, true),
            _buildMeetingList(ref, confirmed, false),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingList(WidgetRef ref, List<Meeting> list, bool isPending) {
    if (list.isEmpty) {
      return Center(child: Text('No meetings here.', style: GoogleFonts.outfit(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final m = list[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.grey.shade100)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(m.parentName, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                    _buildDateBadge(m.startTime),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Subject: ${m.subjectName}', style: GoogleFonts.outfit(color: Colors.grey[600])),
                if (m.notes != null) ...[
                  const SizedBox(height: 10),
                  Text('Notes: ${m.notes}', style: GoogleFonts.outfit(fontSize: 13, fontStyle: FontStyle.italic)),
                ],
                const SizedBox(height: 20),
                if (isPending) ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => ref.read(meetingSchedulerProvider.notifier).updateStatus(m.id, 'rejected'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            foregroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('REJECT'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => ref.read(meetingSchedulerProvider.notifier).updateStatus(m.id, 'confirmed'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('APPROVE'),
                        ),
                      ),
                    ],
                  ),
                ] else if (m.zoomLink != null) ...[
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.videocam_rounded),
                    label: const Text('JOIN VIRTUAL MEETING'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateBadge(DateTime dt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(
        '${dt.day}/${dt.month} · ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}',
        style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.purple),
      ),
    );
  }
}
