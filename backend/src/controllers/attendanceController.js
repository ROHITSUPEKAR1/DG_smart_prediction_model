const Class = require('../models/Class');
const Student = require('../models/Student');
const Attendance = require('../models/Attendance');

exports.getTeacherClasses = async (req, res) => {
  const { school_id, user_id } = req; // provided by auth middleware in Wave 2
  if (!school_id || !user_id) {
    return res.status(401).json({ error: 'Unauthorized or missing context' });
  }

  try {
    const classes = await Class.findByTeacher(school_id, user_id);
    res.json({ classes });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getClassStudents = async (req, res) => {
  const { school_id } = req;
  const { class_id } = req.params;

  if (!class_id) return res.status(400).json({ error: 'Class ID required' });

  try {
    const students = await Student.findByClass(school_id, class_id);
    res.json({ students });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.submitAttendance = async (req, res) => {
  const { school_id, user_id } = req;
  const { class_id, period_id, date, students } = req.body;

  if (!class_id || !date || !students || !Array.isArray(students)) {
    return res.status(400).json({ error: 'Incomplete attendance data' });
  }

  try {
    const records = students.map(s => ({
      student_id: s.id,
      status: s.status, // P, A, L, LV
      class_id,
      period_id,
      date
    }));

    await Attendance.bulkSubmit(school_id, user_id, records);

    // Dispatch Absence Alerts
    const NotificationService = require('../services/notificationService');
    const Notification = require('../models/Notification');

    for (const s of students) {
      if (s.status === 'A') {
        const title = 'Student Absence Alert';
        const msg = `${s.name || 'Your child'} has been marked ABSENT for Period ${period_id || 'Current'}.`;
        
        // Log to DB
        await Notification.logNotification(school_id, s.id, 'absence', title, msg, 'high');
        
        // Mock FCM Dispatch
        await NotificationService.sendPush(school_id, 'DEVICE_TOKEN_LOOKUP_NEEDED', {
          title,
          body: msg,
          data: { type: 'absence', student_id: s.id.toString() }
        });
      }
    }

    res.status(200).json({ message: 'Attendance recorded successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
