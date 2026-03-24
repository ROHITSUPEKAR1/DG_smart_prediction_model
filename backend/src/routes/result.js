const express = require('express');
const resultController = require('../controllers/resultController');

const router = express.Router();

/**
 * @route POST /api/result/marks
 * @desc Bulk post/update marks for a class.
 */
router.post('/marks', resultController.postMarks);

const { teacherOnly } = require('../middleware/roleCheck');

/**
 * @route GET /api/result/student/:student_id/analytics
 * @desc Get academic analytics for a child.
 */
router.get('/student/:student_id/analytics', resultController.getAnalytics);

/**
 * @route POST /api/result/publish
 * @desc Publish results for a specific exam and subject
 */
router.post('/publish', teacherOnly, resultController.publishResults);

/**
 * @route GET /api/result/teacher/audit
 * @desc Get draft + published results for teacher view
 */
router.get('/teacher/audit', teacherOnly, resultController.getTeacherAudit);

module.exports = router;
