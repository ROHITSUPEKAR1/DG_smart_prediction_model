const db = require('../config/db');

/**
 * BaseModel class for multi-tenant data management.
 * 
 * Provides static methods that automatically respect school scoping
 * if a school_id is provided.
 */
class BaseModel {
  static get table() {
    throw new Error('Table name not defined for model');
  }

  /**
   * Scoped Query Builder
   * @param {number} schoolId 
   * @returns {import('knex').QueryBuilder}
   */
  static query(schoolId) {
    if (!schoolId) {
      throw new Error(`school_id is required for queries against ${this.table}`);
    }
    return db(this.table).withSchoolScope(schoolId);
  }

  /**
   * Find Record by ID
   * @param {number} schoolId 
   * @param {number} id 
   * @returns {Promise<Object>}
   */
  static findById(schoolId, id) {
    return this.query(schoolId).where('id', id).first();
  }

  /**
   * List All Records
   * @param {number} schoolId 
   * @returns {Array<Object>}
   */
  static all(schoolId) {
    return this.query(schoolId).select('*');
  }

  /**
   * Create New Record
   * @param {number} schoolId 
   * @param {Object} data 
   * @returns {Promise<number[]>}
   */
  static create(schoolId, data) {
    return db(this.table).insert({ ...data, school_id: schoolId });
  }

  /**
   * Update Record
   * @param {number} schoolId 
   * @param {number} id 
   * @param {Object} data 
   * @returns {Promise<number>}
   */
  static update(schoolId, id, data) {
    return this.query(schoolId).where('id', id).update(data);
  }

  /**
   * Delete Record
   * @param {number} schoolId 
   * @param {number} id 
   * @returns {Promise<number>}
   */
  static delete(schoolId, id) {
    return this.query(schoolId).where('id', id).del();
  }
}

module.exports = BaseModel;
