const Result = require('../models/Result');

exports.postMarks = async (req, res) => {
  const { school_id } = req;
  const { exam_id, subject_id, batchData } = req.body;

  if (!exam_id || !subject_id || !Array.isArray(batchData)) {
    return res.status(400).json({ error: 'Missing exam_id, subject_id, or batchData' });
  }

  try {
    await Result.bulkUpsertResults(school_id, exam_id, subject_id, batchData);
    res.json({ message: 'Marks saved successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getAnalytics = async (req, res) => {
  const { school_id, role } = req; // Assuming role comes from auth middleware
  const { student_id } = req.params;

  try {
    const analytics = await Result.getAnalytics(school_id, student_id, role || 'parent');
    res.json({ analytics });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.publishResults = async (req, res) => {
  const { school_id } = req;
  const { exam_id, subject_id } = req.body;

  if (!exam_id || !subject_id) return res.status(400).json({ error: 'Missing exam_id or subject_id' });

  try {
    await Result.publishResults(school_id, exam_id, subject_id);
    
    // Notify parents (simplified hook)
    const NotificationService = require('../services/notificationService');
    const title = 'Results Published';
    const msg = 'New academic results are available for your child.';
    // In reality, this would notify specific parents, but we'll mock a broadcast.
    await NotificationService.sendPush(school_id, 'ALL_PARENTS_OF_CLASS', { title, body: msg });

    res.json({ message: 'Results published successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getTeacherAudit = async (req, res) => {
  const { school_id } = req;
  const { exam_id, subject_id } = req.query;

  if (!exam_id || !subject_id) return res.status(400).json({ error: 'Missing exam_id or subject_id' });

  try {
    const results = await Result.getAuditResults(school_id, exam_id, subject_id);
    res.json({ results });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
