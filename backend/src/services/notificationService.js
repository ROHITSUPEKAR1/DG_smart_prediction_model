// const admin = require('firebase-admin');
// const serviceAccount = require('../../config/firebase-key.json');

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount)
// });

class NotificationService {
  /**
   * Send a targeted push notification.
   */
  static async sendPush(schoolId, token, payload) {
    console.log(`[FCM-MOCK] Dispatching to ${schoolId} - Token: ${token}`);
    console.log(`[FCM-MOCK] Payload:`, payload);

    // try {
    //   await admin.messaging().send({
    //     token: token,
    //     notification: {
    //       title: payload.title,
    //       body: payload.body,
    //     },
    //     data: payload.data || {},
    //   });
    // } catch (err) {
    //   console.error('FCM Error:', err);
    // }
  }

  /**
   * Broadcast to a specific topic (e.g., class_10a).
   */
  static async broadcastToTopic(schoolId, topic, payload) {
    console.log(`[FCM-MOCK] Broadcasting to topic: ${topic} at school ${schoolId}`);
    // await admin.messaging().sendToTopic(topic, payload);
  }
}

module.exports = NotificationService;
