const BaseModel = require('./BaseModel');
const db = require('../config/db');

class Exam extends BaseModel {
  static get table() {
    return 'exams';
  }

  /**
   * Get Exam Taxonomy for a school.
   */
  static async getExamsBySchool(schoolId) {
    return db(this.table)
      .where('school_id', schoolId)
      .orderBy('exam_date', 'desc')
      .select('*');
  }

  /**
   * Get specific exam details with max_marks and weightage.
   */
  static async getById(schoolId, id) {
    return db(this.table)
      .where('id', id)
      .where('school_id', schoolId)
      .first();
  }
}

module.exports = Exam;
