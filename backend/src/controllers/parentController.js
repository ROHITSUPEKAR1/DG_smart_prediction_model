const Parent = require('../models/Parent');
const Attendance = require('../models/Attendance');

exports.getChildren = async (req, res) => {
  const { school_id, user_id } = req;
  
  try {
    const children = await Parent.getParentChildren(school_id, user_id);
    res.json({ children });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getStudentAttendance = async (req, res) => {
  const { school_id } = req;
  const { student_id } = req.params;
  const { limit } = req.query;

  try {
    // Note: In production, verify student_id is actually linked to req.user_id
    const attendance = await Attendance.getRecentlyByStudent(school_id, student_id, parseInt(limit, 10) || 7);
    res.json({ attendance });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
