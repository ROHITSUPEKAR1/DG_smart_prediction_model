const BaseModel = require('./BaseModel');
const db = require('../config/db');

class Homework extends BaseModel {
  static get table() {
    return 'homework';
  }

  /**
   * Bulk Create Homework for multiple classes.
   * @param {number} schoolId 
   * @param {number} teacherId 
   * @param {string} subject 
   * @param {string} caption 
   * @param {Array<number>} classIds 
   * @param {string} attachmentUrl 
   */
  static async bulkCreate(schoolId, teacherId, subject, caption, classIds, attachmentUrl = null) {
    const records = classIds.map(classId => ({
      school_id: schoolId,
      teacher_id: teacherId,
      class_id: classId,
      subject,
      caption,
      attachment_url: attachmentUrl,
      created_at: new Date()
    }));

    return db(this.table).insert(records);
  }

  /**
   * Get Homework history for a teacher.
   */
  static async findByTeacher(schoolId, teacherId) {
    return this.query(schoolId)
      .where('teacher_id', teacherId)
      .orderBy('created_at', 'desc');
  }
}

module.exports = Homework;
