const BaseModel = require('./BaseModel');
const db = require('../config/db');

class Result extends BaseModel {
  static get table() {
    return 'results';
  }

  /**
   * Bulk save marks for a class.
   */
  // Uses idx_results_school_class_exam for exam scoping and idx_results_school_student for student lookup
  static async bulkUpsertResults(schoolId, examId, subjectId, batchData) {
    return db.transaction(async trx => {
      for (const entry of batchData) {
        let marks = entry.marks || 0;
        let maxMarks = entry.max_marks || 100;

        if (entry.internal_marks !== undefined && entry.external_marks !== undefined) {
          marks = entry.internal_marks + entry.external_marks;
          maxMarks = (entry.max_internal || 20) + (entry.max_external || 80);
        }

        const percentage = (maxMarks > 0) ? (marks / maxMarks) * 100 : 0;
        const grade = this.calculateGrade(percentage);

        await trx(this.table)
          .insert({
            school_id: schoolId,
            student_id: entry.student_id,
            exam_id: examId,
            subject_id: subjectId,
            marks: marks,
            internal_marks: entry.internal_marks || null,
            external_marks: entry.external_marks || null,
            max_marks: maxMarks,
            grade: grade,
            percentage: percentage,
            status: 'draft',
            created_at: new Date()
          })
          .onConflict(['student_id', 'exam_id', 'subject_id'])
          .merge({
            marks: marks,
            internal_marks: entry.internal_marks || null,
            external_marks: entry.external_marks || null,
            max_marks: maxMarks,
            grade: grade,
            percentage: percentage,
            status: 'draft',
            updated_at: new Date()
          });
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
  static async getAnalytics(schoolId, studentId, role = 'parent') {
    let query = db(this.table)
      .where('student_id', studentId)
      .where('school_id', schoolId);

    if (role === 'parent') {
      query = query.where('status', 'published');
    }

    const studentResults = await query.select('*');

    const analytics = [];
    for (const res of studentResults) {
      // Calculate Benchmark (Highest mark in this exam/subject) - Only count published?
      // For accurate benchmarks, maybe count all published. Or all? Let's assume benchmarks only look at published.
      const benchmark = await db(this.table)
        .where('exam_id', res.exam_id)
        .where('subject_id', res.subject_id)
        .where('school_id', schoolId)
        .where('status', 'published') // Optional: only benchmark against published
        .max('marks as highest')
        .avg('marks as average')
        .first();

      analytics.push({
        ...res,
        class_highest: benchmark?.highest || res.marks,
        class_average: benchmark?.average ? parseFloat(benchmark.average).toFixed(2) : res.marks
      });
    }
    return analytics;
  }

  /**
   * Publish results for an exam and subject.
   */
  static async publishResults(schoolId, examId, subjectId) {
    return db(this.table)
      .where('school_id', schoolId)
      .where('exam_id', examId)
      .where('subject_id', subjectId)
      .update({ status: 'published', updated_at: new Date() });
  }

  /**
   * Get all results (draft + published) for auditing.
   */
  static async getAuditResults(schoolId, examId, subjectId) {
    return db(this.table)
      .where('school_id', schoolId)
      .where('exam_id', examId)
      .where('subject_id', subjectId)
      .select('*');
  }
}

module.exports = Result;
