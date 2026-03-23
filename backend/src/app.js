const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const dotenv = require('dotenv');
const schoolScope = require('./middleware/schoolScope');

dotenv.config();

const app = express();

// Standard Security & Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Multi-tenant Scoping Middleware
app.use(schoolScope);

const { auth, requireRole } = require('./middleware/auth');

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/attendance', auth, requireRole('teacher'), require('./routes/attendance'));
app.use('/api/parent', auth, requireRole('parent'), require('./routes/parent'));
app.use('/api/homework', auth, requireRole('teacher'), require('./routes/homework'));

// Health Check Endpoint
app.get('/api/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    mode: 'multi-tenant',
    school_id: req.school_id || 'unscoped'
  });
});

// Error Handler
/* eslint-disable no-unused-vars */
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    message: 'Internal Server Error',
    error: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 DG Smart Backend listening on port ${PORT}`);
});

module.exports = app;
