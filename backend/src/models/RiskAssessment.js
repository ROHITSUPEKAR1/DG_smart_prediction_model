const BaseModel = require('./BaseModel');
const db = require('../config/db');

class RiskAssessment extends BaseModel {
  static get table() {
    return 'risk_assessments';
  }

  static get RISK_TYPES() {
    return {
      ATTENDANCE: 'attendance',
      ACADEMIC: 'academic',
      FEE: 'fee'
    };
  }

  static get SEVERITY() {
    return {
      LOW: 'low',
      HIGH: 'high'
    };
  }

  /**
   * Log/Update a risk assessment for a student
   */
  static async upsertRisk(schoolId, studentId, type, severity, description) {
    return db.transaction(async trx => {
      // Find existing active risk of this type
      const existing = await trx(this.table)
        .where({ school_id: schoolId, student_id: studentId, risk_type: type, resolved: false })
        .first();

      if (existing) {
        // Update severity/description but keep notified state if already notified
        await trx(this.table)
          .where({ id: existing.id })
          .update({ severity, description, updated_at: new Date() });
      } else {
        // Create new risk assessment
        await trx(this.table).insert({
          school_id: schoolId,
          student_id: studentId,
          risk_type: type,
          severity: severity,
          description: description,
          notified: false,
          resolved: false,
          created_at: new Date()
        });
      }
    });
  }

  /**
   * Resolve risks no longer present
   */
  static async resolveRisks(schoolId, studentId, type) {
    return db(this.table)
      .where({ school_id: schoolId, student_id: studentId, risk_type: type, resolved: false })
      .update({ resolved: true, updated_at: new Date() });
  }

  /**
   * Fetch unnotified HIGH severity risks
   */
  static async getUnnotifiedHighRisks() {
    return db(this.table)
      .where({ severity: this.SEVERITY.HIGH, notified: false, resolved: false });
  }

  /**
   * Mark risks as notified
   */
  static async markNotified(ids) {
    return db(this.table)
      .whereIn('id', ids)
      .update({ notified: true, updated_at: new Date() });
  }

  /**
   * Get active risks for a class (Teacher View)
   */
  static async getActiveRisksForClass(schoolId, classId) {
    // Requires a JOIN with students table to filter by class
    return db(this.table)
      .join('students', `${this.table}.student_id`, 'students.id')
      .where(`${this.table}.school_id`, schoolId)
      .where('students.class_id', classId)
      .where(`${this.table}.resolved`, false)
      .select(`${this.table}.*`, 'students.first_name', 'students.last_name');
  }

  /**
   * Get active risks for a student (Parent View)
   */
  static async getActiveRisksForStudent(schoolId, studentId) {
    return db(this.table)
      .where({ school_id: schoolId, student_id: studentId, resolved: false });
  }
}

module.exports = RiskAssessment;
