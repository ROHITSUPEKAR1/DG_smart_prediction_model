const jwt = require('jsonwebtoken');

/**
 * JWT Authentication Middleware
 * Verifies the Bearer token and attaches user identity to request.
 */
const auth = (req, res, next) => {
  const authHeader = req.header('Authorization');
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Access denied. No token provided.' });
  }

  const token = authHeader.split(' ')[1];
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user_id = decoded.id;
    req.role = decoded.role;
    req.school_id = decoded.school_id;
    next();
  } catch (err) {
    res.status(401).json({ error: 'Invalid or expired token.' });
  }
};

/**
 * Role-Based Access Control Middleware
 * @param {string} role 
 */
const requireRole = (role) => {
  return (req, res, next) => {
    if (req.role !== role) {
      return res.status(403).json({ error: `Forbidden: requires ${role} access.` });
    }
    next();
  };
};

module.exports = { auth, requireRole };
