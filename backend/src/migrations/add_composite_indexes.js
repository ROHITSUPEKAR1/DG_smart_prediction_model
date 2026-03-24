/**
 * Composite Index Migration for Multi-Tenant Query Optimization
 * 
 * Every API query in DG Smart filters by school_id first, then by a secondary key.
 * Without composite indexes, MySQL must scan every row matching school_id before
 * narrowing by the secondary key. These compound indexes allow the query planner
 * to jump directly to the final result set.
 */
exports.up = function(knex) {
  return Promise.all([
    // attendance: queries by (school_id, student_id, date) and (school_id, teacher_id)
    knex.schema.alterTable('attendance', (table) => {
      table.index(['school_id', 'student_id', 'date'], 'idx_attendance_school_student_date');
      table.index(['school_id', 'teacher_id'], 'idx_attendance_school_teacher');
    }),

    // results: queries by (school_id, student_id) and (school_id, class_id, exam_id)
    knex.schema.alterTable('results', (table) => {
      table.index(['school_id', 'student_id'], 'idx_results_school_student');
      table.index(['school_id', 'class_id', 'exam_id'], 'idx_results_school_class_exam');
    }),

    // homework: queries by (school_id, class_id) and (school_id, teacher_id)
    knex.schema.alterTable('homework', (table) => {
      table.index(['school_id', 'class_id'], 'idx_homework_school_class');
      table.index(['school_id', 'teacher_id'], 'idx_homework_school_teacher');
    }),

    // meetings: queries by (school_id, teacher_id) and (school_id, parent_id)
    knex.schema.alterTable('meetings', (table) => {
      table.index(['school_id', 'teacher_id'], 'idx_meetings_school_teacher');
      table.index(['school_id', 'parent_id'], 'idx_meetings_school_parent');
    }),

    // risk_assessments: queries by (school_id, student_id, status)
    knex.schema.alterTable('risk_assessments', (table) => {
      table.index(['school_id', 'student_id', 'status'], 'idx_risks_school_student_status');
    }),
  ]);
};

exports.down = function(knex) {
  return Promise.all([
    knex.schema.alterTable('attendance', (table) => {
      table.dropIndex([], 'idx_attendance_school_student_date');
      table.dropIndex([], 'idx_attendance_school_teacher');
    }),
    knex.schema.alterTable('results', (table) => {
      table.dropIndex([], 'idx_results_school_student');
      table.dropIndex([], 'idx_results_school_class_exam');
    }),
    knex.schema.alterTable('homework', (table) => {
      table.dropIndex([], 'idx_homework_school_class');
      table.dropIndex([], 'idx_homework_school_teacher');
    }),
    knex.schema.alterTable('meetings', (table) => {
      table.dropIndex([], 'idx_meetings_school_teacher');
      table.dropIndex([], 'idx_meetings_school_parent');
    }),
    knex.schema.alterTable('risk_assessments', (table) => {
      table.dropIndex([], 'idx_risks_school_student_status');
    }),
  ]);
};
