const express = require('express');
const feeController = require('../controllers/feeController');

const router = express.Router();

/**
 * @route GET /api/parent/student/:student_id/fees
 * @desc Get the full fee ledger for a specific child.
 */
router.get('/student/:student_id/fees', feeController.getLedger);

/**
 * @route POST /api/parent/fees/:installment_id/pay
 * @desc Finalize a payment transaction for an installment.
 */
router.post('/fees/:installment_id/pay', feeController.recordPayment);

module.exports = router;
