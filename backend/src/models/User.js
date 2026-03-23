const bcrypt = require('bcryptjs');
const BaseModel = require('./BaseModel');

class User extends BaseModel {
  static get table() {
    return 'users';
  }

  static findByMobile(schoolId, mobile) {
    return this.query(schoolId).where('mobile', mobile).first();
  }

  static async verifyPassword(user, password) {
    return bcrypt.compare(password, user.password_hash);
  }

  static async hashPassword(password) {
    return bcrypt.hash(password, 10);
  }
}

module.exports = User;
