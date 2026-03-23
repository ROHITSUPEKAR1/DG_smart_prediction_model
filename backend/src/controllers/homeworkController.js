const Homework = require('../models/Homework');
const Resource = require('../models/Resource');

exports.addHomework = async (req, res) => {
  const { school_id, user_id } = req;
  const { subject, caption, class_ids, attachment_url } = req.body;

  if (!subject || !caption || !class_ids || !Array.isArray(class_ids)) {
    return res.status(400).json({ error: 'Subject, caption, and target classes are required' });
  }

  try {
    await Homework.bulkCreate(school_id, user_id, subject, caption, class_ids, attachment_url);
    
    // Dispatch Notifications
    const NotificationService = require('../services/notificationService');
    const title = `New Homework: ${subject}`;
    const msg = caption;

    for (const classId of class_ids) {
      await NotificationService.broadcastToTopic(school_id, `class_${classId}`, {
        title,
        body: msg,
        data: { type: 'homework', subject }
      });
    }

    res.status(201).json({ message: 'Homework posted successfully to targeted classes' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getTeacherHomework = async (req, res) => {
  const { school_id, user_id } = req;

  try {
    const homeworkList = await Homework.findByTeacher(school_id, user_id);
    res.json({ homework: homeworkList });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getResources = async (req, res) => {
  const { school_id } = req;
  const { subject } = req.query;

  try {
    const resources = await Resource.findBySubject(school_id, subject);
    res.json({ resources });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
