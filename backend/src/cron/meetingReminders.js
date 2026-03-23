const cron = require('node-cron');
const Meeting = require('../models/Meeting');
const NotificationService = require('../services/notificationService');

/**
 * Run every 10 minutes to scan for upcoming meetings.
 */
cron.schedule('*/10 * * * *', async () => {
  console.log('[CRON] Scanning for upcoming meetings starting in ~60 mins...');
  try {
    const upcoming = await Meeting.findUpcoming(60);

    for (const m of upcoming) {
      const title = 'Meeting Starting Soon';
      const msg = `Reminder: Your meeting is scheduled for ${new Date(m.start_time).toLocaleTimeString()}.`;

      // Dispatch to Parent
      await NotificationService.sendPush(m.school_id, m.parent_id, {
        title,
        body: msg,
        data: { type: 'meeting', id: m.id.toString() }
      });

      // Dispatch to Teacher
      await NotificationService.sendPush(m.school_id, m.teacher_id, {
        title,
        body: msg,
        data: { type: 'meeting', id: m.id.toString() }
      });
    }
  } catch (err) {
    console.error('Cron Error:', err.message);
  }
});

module.exports = cron;
