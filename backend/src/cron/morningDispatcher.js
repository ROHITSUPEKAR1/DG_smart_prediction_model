const cron = require('node-cron');
const RiskAssessment = require('../models/RiskAssessment');
const NotificationService = require('../services/notificationService');

/**
 * Dispatch HIGH severity unnotified risks at 8:00 AM.
 * Ensures we do not spam or wake parents randomly.
 */
cron.schedule('0 8 * * *', async () => {
  console.log('[CRON-MORNING] Dispatching Unnotified Risks...');
  try {
    const unnotifiedRisks = await RiskAssessment.getUnnotifiedHighRisks();

    if (!unnotifiedRisks || unnotifiedRisks.length === 0) {
      console.log('No new HIGH severity risks pending dispatch.');
      return;
    }

    const dispatchedIds = [];

    for (const risk of unnotifiedRisks) {
      const title = `Predictive Alert: ${risk.risk_type.toUpperCase()} Risk`;
      const body = risk.description;

      // Ensure we have a parent mapping for the student
      // In production, we fetch `parent_id` via a JOIN on students/guardians.
      const mockParentId = 'PARENT_MOCK_ID'; // Placeholder for dispatch loop

      try {
        await NotificationService.sendPush(risk.school_id, mockParentId, {
          title,
          body,
          data: { type: 'predictive_alert', risk_type: risk.risk_type, severity: risk.severity }
        });

        dispatchedIds.push(risk.id);
      } catch (err) {
        console.error(`Failed to dispatch push for Risk ID: ${risk.id}`);
      }
    }

    if (dispatchedIds.length > 0) {
      await RiskAssessment.markNotified(dispatchedIds);
      console.log(`Successfully dispatched and marked ${dispatchedIds.length} risks as notified.`);
    }

  } catch (err) {
    console.error('Morning Risk Dispatcher Error:', err.message);
  }
});

module.exports = cron;
