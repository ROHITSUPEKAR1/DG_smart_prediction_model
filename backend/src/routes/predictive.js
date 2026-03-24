const express = require('express');
const predictiveController = require('../controllers/predictiveController');
const { teacherOnly, parentOnly } = require('../middleware/roleCheck');

const router = express.Router();

/**
 * @route GET /api/predictive/risks/class/:class_id
 * @desc Get all active risks for a class (Teacher Triage)
 */
router.get('/risks/class/:class_id', teacherOnly, predictiveController.getClassRisks);

/**
 * @route GET /api/predictive/risks/student/:student_id
 * @desc Get active risks for a specific student (Parent View)
 */
router.get('/risks/student/:student_id', parentOnly, predictiveController.getStudentRisks);

module.exports = router;
