const cron = require('node-cron');
const db = require('../config/db');
const RiskAssessment = require('../models/RiskAssessment');

/**
 * Run globally at 2:00 AM every night.
 * Scans all students for risks and logs anomalies.
 */
cron.schedule('0 2 * * *', async () => {
  console.log('[CRON-NIGHTLY] Running Predictive Risk Engine...');
  try {
    // We would normally loop over all active school_ids, but for MVP let's assume one globally.
    // Fetch all active students.
    const students = await db('students').select('id', 'school_id');

    for (const student of students) {
      // 1. Attendance Risk Check
      // Simulated rule: if attendance % < 75% or consecutive absent > 3 length.
      // E.g. simplified check grabbing standard attendance rate...
      const mockAttendanceRate = Math.random() * 100; // Simulated
      let activeAttendanceRisk = false;

      if (mockAttendanceRate < 75) {
        activeAttendanceRisk = true;
        await RiskAssessment.upsertRisk(
          student.school_id,
          student.id,
          RiskAssessment.RISK_TYPES.ATTENDANCE,
          RiskAssessment.SEVERITY.HIGH,
          `Attendance dropped below threshold (${mockAttendanceRate.toFixed(1)}%).`
        );
      } else {
        await RiskAssessment.resolveRisks(student.school_id, student.id, RiskAssessment.RISK_TYPES.ATTENDANCE);
      }

      // 2. Academic Risk Check
      // Simulated rule: average score across published exams < 40
      const mockAcademicAvg = Math.random() * 100;
      let activeAcademicRisk = false;

      if (mockAcademicAvg < 40) {
        activeAcademicRisk = true;
        await RiskAssessment.upsertRisk(
          student.school_id,
          student.id,
          RiskAssessment.RISK_TYPES.ACADEMIC,
          RiskAssessment.SEVERITY.HIGH,
          `Failing academic trend detected (Avg: ${mockAcademicAvg.toFixed(1)}%).`
        );
      } else {
        await RiskAssessment.resolveRisks(student.school_id, student.id, RiskAssessment.RISK_TYPES.ACADEMIC);
      }

      // 3. Financial Risk Check
      const mockFeePaid = true; // Simulated
      if (!mockFeePaid) {
        await RiskAssessment.upsertRisk(
          student.school_id,
          student.id,
          RiskAssessment.RISK_TYPES.FEE,
          RiskAssessment.SEVERITY.HIGH,
          `Critical pending dues. Access restricted in 3 days.`
        );
      } else {
        await RiskAssessment.resolveRisks(student.school_id, student.id, RiskAssessment.RISK_TYPES.FEE);
      }
    }
    console.log('[CRON-NIGHTLY] Risk Engine Complete.');
  } catch (err) {
    console.error('Risk Engine Error:', err.message);
  }
});

module.exports = cron;
