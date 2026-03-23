const express = require('express');
const authController = require('../controllers/authController');

const router = express.Router();

/**
 * @route POST /api/auth/request-otp
 * @desc Request a 6-digit OTP for login.
 */
router.post('/request-otp', authController.requestOtp);

/**
 * @route POST /api/auth/login
 * @desc Finalize login with OTP and Password.
 */
router.post('/login', authController.loginWithOtpPassword);

/**
 * @route POST /api/auth/refresh
 * @desc Refresh Access Token.
 */
router.post('/refresh', authController.refreshToken);

module.exports = router;
