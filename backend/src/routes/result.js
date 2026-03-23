const express = require('express');
const resultController = require('../controllers/resultController');

const router = express.Router();

/**
 * @route POST /api/result/marks
 * @desc Bulk post/update marks for a class.
 */
router.post('/marks', resultController.postMarks);

/**
 * @route GET /api/result/student/:student_id/analytics
 * @desc Get academic analytics for a child.
 */
router.get('/student/:student_id/analytics', resultController.getAnalytics);

module.exports = router;
