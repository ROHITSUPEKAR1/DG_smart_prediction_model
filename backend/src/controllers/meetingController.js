const Meeting = require('../models/Meeting');
const NotificationService = require('../services/notificationService');
const Notification = require('../models/Notification');

exports.requestMeeting = async (req, res) => {
  const { school_id, user_id } = req; // provided by parent persona auth
  const { teacher_id, start_time, notes } = req.body;

  if (!teacher_id || !start_time) return res.status(400).json({ error: 'Teacher ID and start time required' });

  try {
    await Meeting.request(school_id, user_id, teacher_id, start_time, notes);

    // Notify Teacher
    const title = 'New Meeting Request';
    const msg = `A parent has requested a meeting on ${new Date(start_time).toLocaleString()}.`;
    await NotificationService.sendPush(school_id, 'TEACHER_TOKEN', { title, body: msg });

    res.status(201).json({ message: 'Meeting requested successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.updateMeetingStatus = async (req, res) => {
  const { school_id } = req;
  const { meeting_id } = req.params;
  const { status, meeting_link } = req.body;

  if (!meeting_id || !status) return res.status(400).json({ error: 'Meeting ID and status required' });

  try {
    await Meeting.updateStatus(school_id, meeting_id, status, meeting_link);

    // Notify Parent
    const title = 'Meeting Update';
    const msg = `Your meeting request has been ${status.toUpperCase()}.`;
    await NotificationService.sendPush(school_id, 'PARENT_TOKEN', { title, body: msg });

    res.json({ message: 'Status updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getMeetings = async (req, res) => {
  const { school_id, user_id, role } = req; // Assuming role is provided by auth
  try {
    const meetings = await Meeting.findByPersona(school_id, user_id, role);
    res.json({ meetings });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
