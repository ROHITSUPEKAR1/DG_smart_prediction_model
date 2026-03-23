const BaseModel = require('./BaseModel');

class School extends BaseModel {
  static get table() {
    return 'schools';
  }

  /**
   * Schools are global; they don't have a school_id themselves.
   * Override query() to return unscoped db instance.
   */
  static query() {
    const db = require('../config/db');
    return db(this.table);
  }

  static findBySubdomain(subdomain) {
    return this.query().where('subdomain', subdomain).first();
  }
}

module.exports = School;
