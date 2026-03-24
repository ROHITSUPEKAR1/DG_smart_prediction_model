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
  // Uses idx_attendance_school_student_date for conflict resolution on (student_id, date, period_id)
  static async bulkSubmit(schoolId, teacherId, records) {
    const formatted = records.map(r => ({
      ...r,
      school_id: schoolId,
      teacher_id: teacherId,
      created_at: new Date()
    }));

    return db(this.table).insert(formatted).onConflict(['student_id', 'date', 'period_id']).merge();
  }

  /**
   * Get Recent Attendance for a specific student.
   * @param {number} schoolId 
   * @param {number} studentId 
   * @param {number} limit 
   */
  // Uses idx_attendance_school_student_date for filtering by (school_id, student_id) + date ordering
  static async getRecentlyByStudent(schoolId, studentId, limit = 7) {
    const db = require('../config/db');
    return db(this.table)
      .where('school_id', schoolId)
      .where('student_id', studentId)
      .orderBy('date', 'desc')
      .limit(limit);
  }
}

module.exports = Attendance;
