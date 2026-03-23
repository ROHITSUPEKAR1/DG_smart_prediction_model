const jwt = require('jsonwebtoken');

/**
 * Multi-tenant Scoping Middleware
 * Extracts school_id from JWT or X-School-ID header
 * and attaches it to the request object.
 */
const schoolScope = (req, res, next) => {
  try {
    // 1. Check for X-School-ID header (for pre-auth or public routes)
    const headerSchoolId = req.header('X-School-ID');
    
    // 2. Check for school_id in JWT if present
    const authHeader = req.header('Authorization');
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.split(' ')[1];
      const decoded = jwt.decode(token);
      if (decoded && decoded.school_id) {
        req.school_id = decoded.school_id;
        return next();
      }
    }

    // fallback to header or default for dev testing
    if (headerSchoolId) {
      req.school_id = parseInt(headerSchoolId, 10);
      return next();
    }

    // Deny request if no school_id found in scoped routes
    // (Actual enforcement depends on whether the route is 'auth' or 'public')
    // For now, we just attach if found.
    next();
  } catch (err) {
    next(err);
  }
};

module.exports = schoolScope;
