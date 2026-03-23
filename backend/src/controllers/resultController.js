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
  const { school_id } = req;
  const { student_id } = req.params;

  try {
    const analytics = await Result.getAnalytics(school_id, student_id);
    res.json({ analytics });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
