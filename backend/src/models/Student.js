const BaseModel = require('./BaseModel');

class Student extends BaseModel {
  static get table() {
    return 'students';
  }

  static findByClass(schoolId, classId) {
    return this.query(schoolId).where('class_id', classId).orderBy('roll_number', 'asc');
  }
}

module.exports = Student;
