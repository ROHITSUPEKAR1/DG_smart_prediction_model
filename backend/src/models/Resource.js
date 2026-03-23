const BaseModel = require('./BaseModel');

class Resource extends BaseModel {
  static get table() {
    return 'study_materials';
  }

  static async findBySubject(schoolId, subject) {
    return this.query(schoolId)
      .where('subject', subject)
      .orderBy('title', 'asc');
  }
}

module.exports = Resource;
