const BaseModel = require('./BaseModel');

class Parent extends BaseModel {
  static get table() {
    return 'parents';
  }

  /**
   * Get all linked children for a parent.
   * @param {number} schoolId 
   * @param {number} parentId 
   */
  static async getParentChildren(schoolId, parentId) {
    const db = require('../config/db');
    return db('students')
      .join('parent_student_mapping', 'students.id', 'parent_student_mapping.student_id')
      .join('classes', 'students.class_id', 'classes.id')
      .where('students.school_id', schoolId)
      .where('parent_student_mapping.parent_id', parentId)
      .select('students.*', 'classes.class_name', 'classes.section_name');
  }
}

module.exports = Parent;
