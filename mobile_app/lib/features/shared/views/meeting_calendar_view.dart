import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/shared/providers/meeting_scheduler_provider.dart';

class MeetingCalendarView extends ConsumerStatefulWidget {
  const MeetingCalendarView({super.key});

  @override
  ConsumerState<MeetingCalendarView> createState() => _MeetingCalendarViewState();
}

class _MeetingCalendarViewState extends ConsumerState<MeetingCalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meetingsNotifier = ref.watch(meetingSchedulerProvider.notifier);
    final meetingsForDay = _selectedDay != null ? meetingsNotifier.getMeetingsForDay(_selectedDay!) : [];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Schedule Meeting')),
      body: Column(
        children: [
          _buildCalendar(theme),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDay != null ? 'Meetings for ${_selectedDay!.day}/${_selectedDay!.month}' : 'Select a date',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () { /* Request Logic */ },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('New Request'),
                ),
              ],
            ),
          ),
          Expanded(
            child: meetingsForDay.isEmpty ? _buildNoMeetings() : _buildMeetingsList(meetingsForDay as List<Meeting>),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      child: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime.now().subtract(const Duration(days: 30)),
        lastDay: DateTime.now().add(const Duration(days: 90)),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2)]),
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
          markerDecoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMeetingsList(List<Meeting> meetings) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: meetings.length,
      itemBuilder: (context, index) {
        final m = meetings[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey.shade100)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(15),
            title: Text('${m.teacherName} (${m.subjectName})', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            subtitle: Text('${m.startTime.hour}:${m.startTime.minute.toString().padLeft(2, '0')} - Status: ${m.status.toUpperCase()}'),
            trailing: _buildStatusIcon(m.status),
          ),
        );
      },
    );
  }

  Widget _buildNoMeetings() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available_rounded, size: 60, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 10),
          Text('No meetings scheduled', style: GoogleFonts.outfit(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    final color = status == 'confirmed' ? Colors.green : (status == 'pending' ? Colors.orange : Colors.grey);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(status.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
