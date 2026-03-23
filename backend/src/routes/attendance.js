const express = require('express');
const attendanceController = require('../controllers/attendanceController');

const router = express.Router();

/**
 * @route GET /api/attendance/classes
 * @desc Get today's classes for the teacher.
 */
router.get('/classes', attendanceController.getTeacherClasses);

/**
 * @route GET /api/attendance/students/:class_id
 * @desc List students for a specific class.
 */
router.get('/students/:class_id', attendanceController.getClassStudents);

/**
 * @route POST /api/attendance/submit
 * @desc Submit class-wide attendance.
 */
router.post('/submit', attendanceController.submitAttendance);

module.exports = router;
