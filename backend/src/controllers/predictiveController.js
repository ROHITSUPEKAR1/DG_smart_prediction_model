const RiskAssessment = require('../models/RiskAssessment');

exports.getClassRisks = async (req, res) => {
  const { school_id } = req;
  const { class_id } = req.params;

  try {
    const risks = await RiskAssessment.getActiveRisksForClass(school_id, class_id);
    res.json({ risks });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getStudentRisks = async (req, res) => {
  const { school_id } = req;
  const { student_id } = req.params;

  try {
    const risks = await RiskAssessment.getActiveRisksForStudent(school_id, student_id);
    res.json({ risks });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
