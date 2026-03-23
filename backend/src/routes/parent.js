const express = require('express');
const parentController = require('../controllers/parentController');

const router = express.Router();

/**
 * @route GET /api/parent/children
 * @desc Get all children metadata for the parent.
 */
router.get('/children', parentController.getChildren);

/**
 * @route GET /api/parent/student/:student_id/attendance
 * @desc Get historical attendance for a specific child.
 */
router.get('/student/:student_id/attendance', parentController.getStudentAttendance);

module.exports = router;
