const express = require('express');
const router = express.Router();
const meetingController = require('../controllers/meetingController');
const { parentOnly, teacherOnly } = require('../middleware/roleCheck');

router.post('/request', parentOnly, meetingController.requestMeeting);
router.patch('/:meeting_id/status', teacherOnly, meetingController.updateMeetingStatus);
router.get('/my-meetings', meetingController.getMeetings);

module.exports = router;
