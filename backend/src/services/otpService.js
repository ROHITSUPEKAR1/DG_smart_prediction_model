const crypto = require('crypto');

/**
 * Mock OTP Service for v1.
 * Logs to console during development.
 */
class OtpService {
  constructor() {
    this.otpStore = new Map(); // In-memory for v1 development
  }

  generate(mobile) {
    const code = crypto.randomInt(100000, 999999).toString();
    this.otpStore.set(mobile, {
      code,
      expiry: Date.now() + 5 * 60 * 1000 // 5 minutes
    });
    
    console.log(`[DEV OTP] Mobile: ${mobile} | CODE: ${code}`);
    return code;
  }

  verify(mobile, code) {
    const entry = this.otpStore.get(mobile);
    if (!entry) return false;
    
    if (Date.now() > entry.expiry) {
      this.otpStore.delete(mobile);
      return false;
    }

    const isValid = entry.code === code;
    if (isValid) {
      this.otpStore.delete(mobile); // One-time use
    }
    return isValid;
  }
}

module.exports = new OtpService();
