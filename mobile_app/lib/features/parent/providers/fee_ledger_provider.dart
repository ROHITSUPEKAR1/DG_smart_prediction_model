import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeeInstallment {
  final int id;
  final String title;
  final double amount;
  final String dueDate;
  final String status; // PAID, PENDING, OVERDUE

  FeeInstallment({
    required this.id,
    required this.title,
    required this.amount,
    required this.dueDate,
    required this.status,
  });
}

class FeeLedgerNotifier extends StateNotifier<AsyncValue<List<FeeInstallment>>> {
  FeeLedgerNotifier() : super(const AsyncValue.loading()) {
    _loadMockLedger();
  }

  void _loadMockLedger() async {
    await Future.delayed(const Duration(milliseconds: 800));
    state = AsyncValue.data([
      FeeInstallment(id: 1, title: 'Quarter 1 Tuition', amount: 15000.0, dueDate: '2026-04-10', status: 'PAID'),
      FeeInstallment(id: 2, title: 'Quarter 2 Tuition', amount: 15000.0, dueDate: '2026-07-10', status: 'PENDING'),
      FeeInstallment(id: 3, title: 'Annual Transport Fee', amount: 8500.0, dueDate: '2026-03-01', status: 'OVERDUE'),
      FeeInstallment(id: 4, title: 'Board Exam Fee', amount: 2500.0, dueDate: '2026-10-15', status: 'PENDING'),
    ]);
  }

  void markPaid(int id) {
    if (state.hasValue) {
      final list = state.value!.map((f) => f.id == id ? FeeInstallment(id: f.id, title: f.title, amount: f.amount, dueDate: f.dueDate, status: 'PAID') : f).toList();
      state = AsyncValue.data(list);
    }
  }
}

final feeLedgerProvider = StateNotifierProvider<FeeLedgerNotifier, AsyncValue<List<FeeInstallment>>>((ref) {
  return FeeLedgerNotifier();
});

final totalBalanceProvider = Provider<double>((ref) {
  final ledger = ref.watch(feeLedgerProvider);
  return ledger.maybeWhen(
    data: (list) => list.where((f) => f.status != 'PAID').fold(0.0, (sum, f) => sum + f.amount),
    orElse: () => 0.0,
  );
});
