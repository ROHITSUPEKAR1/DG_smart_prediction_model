const BaseModel = require('./BaseModel');
const db = require('../config/db');

class Meeting extends BaseModel {
  static get table() {
    return 'meetings';
  }

  /**
   * Status constants.
   */
  static get STATUS() {
    return {
      PENDING: 'pending',
      APPROVED: 'approved',
      REJECTED: 'rejected',
      COMPLETED: 'completed'
    };
  }

  /**
   * Request a new meeting.
   */
  static async request(schoolId, parentId, teacherId, startTime, notes) {
    return db(this.table).insert({
      school_id: schoolId,
      parent_id: parentId,
      teacher_id: teacherId,
      start_time: startTime,
      notes: notes,
      status: this.STATUS.PENDING,
      created_at: new Date()
    });
  }

  /**
   * Get meetings by persona (Parent or Teacher).
   */
  static async findByPersona(schoolId, personaId, role) {
    const field = role === 'teacher' ? 'teacher_id' : 'parent_id';
    return db(this.table)
      .where('school_id', schoolId)
      .where(field, personaId)
      .orderBy('start_time', 'asc');
  }

  /**
   * Update status with link support.
   */
  static async updateStatus(schoolId, meetingId, status, meetingLink = null) {
    return db(this.table)
      .where('school_id', schoolId)
      .where('id', meetingId)
      .update({
        status: status,
        meeting_link: meetingLink,
        updated_at: new Date()
      });
  }

  /**
   * Find meetings starting in ~X minutes for reminders.
   */
  static async findUpcoming(minutes) {
    const target = new Date(Date.now() + minutes * 60000);
    const windowStart = new Date(target.getTime() - 30000); // 30s buffer
    const windowEnd = new Date(target.getTime() + 30000);

    return db(this.table)
      .whereBetween('start_time', [windowStart, windowEnd])
      .where('status', this.STATUS.APPROVED);
  }
}

module.exports = Meeting;
