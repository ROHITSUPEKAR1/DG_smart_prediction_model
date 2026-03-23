const knex = require('knex');
require('dotenv').config();

const db = knex({
  client: 'mysql2',
  connection: {
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 3306,
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASS || '',
    database: process.env.DB_NAME || 'dg_smart',
    charset: 'utf8mb4'
  },
  pool: {
    min: 2,
    max: 10
  }
});

/**
 * Multi-tenant Scoping Extension for Knex
 * Automatically injects school_id into queries.
 */
knex.QueryBuilder.extend('withSchoolScope', function(schoolId) {
  if (!schoolId) {
    throw new Error('school_id is required for multi-tenant scoped queries');
  }
  return this.where(`${this._single.table}.school_id`, schoolId);
});

module.exports = db;
