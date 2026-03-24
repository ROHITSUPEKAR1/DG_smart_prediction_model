const { requireRole } = require('./auth');

/**
 * Convenience Role-Check Middleware
 * Reusable middleware functions for route-level access control.
 */
const teacherOnly = requireRole('teacher');
const parentOnly = requireRole('parent');

module.exports = { teacherOnly, parentOnly };
