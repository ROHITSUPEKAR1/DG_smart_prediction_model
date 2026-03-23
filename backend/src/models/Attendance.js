const db = require('../config/db');
const BaseModel = require('./BaseModel');

class Attendance extends BaseModel {
  static get table() {
    return 'attendance';
  }

  /**
   * Bulk Submit Attendance
   * Expects data: { student_id, status, class_id, period_id, date }
   * @param {number} schoolId 
   * @param {number} teacherId 
   * @param {Array} records 
   */
  static async bulkSubmit(schoolId, teacherId, records) {
    const formatted = records.map(r => ({
      ...r,
      school_id: schoolId,
      teacher_id: teacherId,
      created_at: new Date()
    }));

    return db(this.table).insert(formatted).onConflict(['student_id', 'date', 'period_id']).merge();
  }
}

module.exports = Attendance;
