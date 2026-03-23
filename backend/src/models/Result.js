const BaseModel = require('./BaseModel');
const db = require('../config/db');

class Result extends BaseModel {
  static get table() {
    return 'results';
  }

  /**
   * Bulk save marks for a class.
   */
  static async bulkUpsertResults(schoolId, examId, subjectId, batchData) {
    return db.transaction(async trx => {
      for (const entry of batchData) {
        const percentage = (entry.marks / entry.max_marks) * 100;
        const grade = this.calculateGrade(percentage);

        await trx(this.table)
          .insert({
            school_id: schoolId,
            student_id: entry.student_id,
            exam_id: examId,
            subject_id: subjectId,
            marks: entry.marks,
            max_marks: entry.max_marks,
            grade: grade,
            percentage: percentage,
            created_at: new Date()
          })
          .onConflict(['student_id', 'exam_id', 'subject_id'])
          .merge();
      }
    });
  }

  /**
   * Calculate Grade (Unified Logic).
   */
  static calculateGrade(percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 40) return 'D';
    return 'F';
  }

  /**
   * Get Student Analytics (Child Performance vs. Benchmarks).
   */
  static async getAnalytics(schoolId, studentId) {
    const studentResults = await db(this.table)
      .where('student_id', studentId)
      .where('school_id', schoolId)
      .select('*');

    const analytics = [];
    for (const res of studentResults) {
      // Calculate Benchmark (Highest mark in this exam/subject)
      const benchmark = await db(this.table)
        .where('exam_id', res.exam_id)
        .where('subject_id', res.subject_id)
        .where('school_id', schoolId)
        .max('marks as highest')
        .avg('marks as average')
        .first();

      analytics.push({
        ...res,
        class_highest: benchmark.highest,
        class_average: parseFloat(benchmark.average).toFixed(2)
      });
    }
    return analytics;
  }
}

module.exports = Result;
