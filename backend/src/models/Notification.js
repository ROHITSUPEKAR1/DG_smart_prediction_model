const BaseModel = require('./BaseModel');
const db = require('../config/db');

class Notification extends BaseModel {
  static get table() {
    return 'notifications';
  }

  /**
   * Log a sent notification to the DB for in-app history.
   */
  static async logNotification(schoolId, studentId, type, title, message, priority = 'normal') {
    return db(this.table).insert({
      school_id: schoolId,
      student_id: studentId,
      type: type,
      title: title,
      message: message,
      priority: priority,
      created_at: new Date(),
    });
  }

  /**
   * Get 30-day notification history for a child.
   */
  static async getHistory(schoolId, studentId) {
    return db(this.table)
      .where('school_id', schoolId)
      .where('student_id', studentId)
      .orderBy('created_at', 'desc')
      .limit(50);
  }
}

module.exports = Notification;
