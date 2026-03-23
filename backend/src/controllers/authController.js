const jwt = require('jsonwebtoken');
const otpService = require('../services/otpService');
const User = require('../models/User');

const generateTokens = (user) => {
  const access = jwt.sign(
    { id: user.id, role: user.role, school_id: user.school_id },
    process.env.JWT_SECRET,
    { expiresIn: process.env.ACCESS_TOKEN_EXPIRY || '1h' }
  );
  
  const refresh = jwt.sign(
    { id: user.id, school_id: user.school_id },
    process.env.JWT_SECRET,
    { expiresIn: process.env.REFRESH_TOKEN_EXPIRY || '30d' }
  );

  return { access, refresh };
};

exports.requestOtp = async (req, res) => {
  const { mobile, school_id } = req.body;
  
  if (!mobile || !school_id) {
    return res.status(400).json({ error: 'Mobile and School ID required' });
  }

  try {
    const user = await User.findByMobile(school_id, mobile);
    if (!user) {
      return res.status(404).json({ error: 'User does not exist in this school' });
    }

    otpService.generate(mobile);
    res.json({ message: 'OTP sent successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.loginWithOtpPassword = async (req, res) => {
  const { mobile, school_id, otp, password } = req.body;

  if (!mobile || !school_id || !otp || !password) {
    return res.status(400).json({ error: 'All fields required' });
  }

  try {
    const user = await User.findByMobile(school_id, mobile);
    if (!user) return res.status(404).json({ error: 'Invalid user' });

    // Verify OTP
    if (!otpService.verify(mobile, otp)) {
      return res.status(401).json({ error: 'Invalid or expired OTP' });
    }

    // Verify Password
    const isValidPassword = await User.verifyPassword(user, password);
    if (!isValidPassword) {
      return res.status(401).json({ error: 'Invalid password' });
    }

    const { access, refresh } = generateTokens(user);

    res.json({
      access_token: access,
      refresh_token: refresh,
      user: {
        id: user.id,
        name: user.full_name,
        role: user.role,
        school_id: user.school_id
      }
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.refreshToken = async (req, res) => {
  const { refresh_token } = req.body;
  if (!refresh_token) return res.status(403).json({ error: 'Refresh token required' });

  try {
    const decoded = jwt.verify(refresh_token, process.env.JWT_SECRET);
    const user = await User.findById(decoded.school_id, decoded.id);
    if (!user) return res.status(404).json({ error: 'Session invalid' });

    const { access } = generateTokens(user);
    res.json({ access_token: access });
  } catch (err) {
    res.status(403).json({ error: 'Invalid token' });
  }
};
