const BaseModel = require('./BaseModel');

class Class extends BaseModel {
  static get table() {
    return 'classes';
  }

  /**
   * Get Classes assigned to a specific teacher.
   * Assumes a class_teacher_mapping table exists.
   * @param {number} schoolId 
   * @param {number} teacherId 
   */
  static async findByTeacher(schoolId, teacherId) {
    const db = require('../config/db');
    return db(this.table)
      .join('class_teacher_mapping', 'classes.id', 'class_teacher_mapping.class_id')
      .where('classes.school_id', schoolId)
      .where('class_teacher_mapping.teacher_id', teacherId)
      .select('classes.*', 'class_teacher_mapping.subject_name', 'class_teacher_mapping.start_time', 'class_teacher_mapping.end_time');
  }
}

module.exports = Class;
