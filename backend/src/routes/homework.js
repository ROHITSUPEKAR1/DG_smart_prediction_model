const express = require('express');
const homeworkController = require('../controllers/homeworkController');

const router = express.Router();

/**
 * @route POST /api/homework/post
 * @desc Assign new homework to one or more classes.
 */
router.post('/post', homeworkController.addHomework);

/**
 * @route GET /api/homework/history
 * @desc Get teacher's homework assignment history.
 */
router.get('/history', homeworkController.getTeacherHomework);

/**
 * @route GET /api/homework/resources
 * @desc Browse study materials by subject.
 */
router.get('/resources', homeworkController.getResources);

module.exports = router;
