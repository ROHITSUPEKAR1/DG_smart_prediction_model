const Fee = require('../models/Fee');
const Parent = require('../models/Parent');

exports.getLedger = async (req, res) => {
  const { school_id, user_id } = req;
  const { student_id } = req.params;

  try {
    // Note: In production, verify student_id is actually linked to parent (req.user_id)
    const ledger = await Fee.getStudentFees(school_id, student_id);
    res.json({ ledger });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.recordPayment = async (req, res) => {
  const { school_id } = req;
  const { installment_id } = req.params;
  const { amount, transaction_ref, payment_mode } = req.body;

  if (!amount || !transaction_ref) {
    return res.status(400).json({ error: 'Amount and transaction reference are required' });
  }

  try {
    await Fee.recordPayment(school_id, installment_id, {
      amount,
      transaction_ref,
      payment_mode: payment_mode || 'MOCK_GATEWAY'
    });

    res.json({ message: 'Payment recorded successfully', receipt_id: `REC-${Date.now()}` });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
