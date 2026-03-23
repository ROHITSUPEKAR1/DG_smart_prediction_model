import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PaymentStatus { idle, processing, success, failed }

class PaymentExecutionNotifier extends StateNotifier<PaymentStatus> {
  PaymentExecutionNotifier() : super(PaymentStatus.idle);

  Future<void> executeMockPayment() async {
    state = PaymentStatus.processing;
    await Future.delayed(const Duration(seconds: 2));
    state = PaymentStatus.success;
  }

  void reset() => state = PaymentStatus.idle;
}

final paymentExecutionProvider = StateNotifierProvider<PaymentExecutionNotifier, PaymentStatus>((ref) {
  return PaymentExecutionNotifier();
});
