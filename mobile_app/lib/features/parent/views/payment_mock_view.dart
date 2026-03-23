import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/features/parent/providers/payment_execution_provider.dart';
import 'package:mobile_app/features/parent/providers/fee_ledger_provider.dart';

class PaymentMockView extends ConsumerWidget {
  final FeeInstallment installment;

  const PaymentMockView({super.key, required this.installment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(paymentExecutionProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Secure Payment'),
        leading: status == PaymentStatus.processing ? const SizedBox() : null,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (status == PaymentStatus.idle) _buildIdleUI(context, ref, theme),
              if (status == PaymentStatus.processing) _buildProcessingUI(theme),
              if (status == PaymentStatus.success) _buildSuccessUI(context, ref, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIdleUI(BuildContext context, WidgetRef ref, ThemeData theme) {
    return Column(
      children: [
        Icon(Icons.lock_person_rounded, size: 80, color: theme.primaryColor),
        const SizedBox(height: 24),
        Text(
          'Finalize Payment',
          style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Paying for ${installment.title}',
          style: GoogleFonts.outfit(color: Colors.grey),
        ),
        const SizedBox(height: 40),
        Text(
          '₹${installment.amount.toStringAsFixed(0)}',
          style: GoogleFonts.outfit(fontSize: 40, fontWeight: FontWeight.bold, color: theme.primaryColor),
        ),
        const SizedBox(height: 50),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () => ref.read(paymentExecutionProvider.notifier).executeMockPayment(),
            child: const Text('PAY SECURELY (MOCK)'),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingUI(ThemeData theme) {
    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 24),
        Text(
          'Verifying Transaction...',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        Text(
          'Please do not close the app or go back.',
          style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSuccessUI(BuildContext context, WidgetRef ref, ThemeData theme) {
    return Column(
      children: [
        const Icon(Icons.check_circle_rounded, size: 100, color: Colors.green),
        const SizedBox(height: 24),
        Text(
          'Payment Successful!',
          style: GoogleFonts.outfit(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          'Transaction ID: #${DateTime.now().millisecondsSinceEpoch}',
          style: GoogleFonts.outfit(color: Colors.grey),
        ),
        const SizedBox(height: 40),
        _buildReceiptButton(context, theme),
        const SizedBox(height: 15),
        TextButton(
          onPressed: () {
            ref.read(feeLedgerProvider.notifier).markPaid(installment.id);
            ref.read(paymentExecutionProvider.notifier).reset();
            Navigator.pop(context);
          },
          child: const Text('Back to Ledger'),
        ),
      ],
    );
  }

  Widget _buildReceiptButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.download_rounded),
        label: const Text('DOWNLOAD RECEIPT (PDF)'),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Receipt PDF saved to downloads!')),
          );
        },
      ),
    );
  }
}
