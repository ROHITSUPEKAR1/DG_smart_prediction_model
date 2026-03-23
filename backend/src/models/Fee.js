const BaseModel = require('./BaseModel');
const db = require('../config/db');

class Fee extends BaseModel {
  static get table() {
    return 'fee_installments';
  }

  /**
   * Get Student Ledger.
   * @param {number} schoolId 
   * @param {number} studentId 
   */
  static async getStudentFees(schoolId, studentId) {
    const today = new Date().toISOString().split('T')[0];
    
    return db(this.table)
      .where('school_id', schoolId)
      .where('student_id', studentId)
      .orderBy('due_date', 'asc')
      .select('*')
      .then(rows => rows.map(row => {
        // Dynamic status tagging
        let status = row.status;
        if (status === 'PENDING' && row.due_date < today) {
          status = 'OVERDUE';
        }
        return { ...row, status };
      }));
  }

  /**
   * Record a payment transaction.
   */
  static async recordPayment(schoolId, installmentId, transactionData) {
    return db.transaction(async trx => {
      // Update installment status
      await trx(this.table)
        .where('id', installmentId)
        .where('school_id', schoolId)
        .update({
          status: 'PAID',
          paid_at: new Date()
        });

      // Insert transaction log
      return trx('fee_transactions').insert({
        school_id: schoolId,
        installment_id: installmentId,
        amount: transactionData.amount,
        payment_mode: transactionData.payment_mode || 'ONLINE',
        transaction_ref: transactionData.transaction_ref,
        created_at: new Date()
      });
    });
  }
}

module.exports = Fee;
