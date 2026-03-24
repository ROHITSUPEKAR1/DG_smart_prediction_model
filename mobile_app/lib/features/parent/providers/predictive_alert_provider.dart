import 'package:flutter_riverpod/flutter_riverpod.dart';

class PredictiveAlertNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  PredictiveAlertNotifier() : super([]) {
    _loadMockAlerts();
  }

  void _loadMockAlerts() {
    state = [
      {
        'id': 'risk_01',
        'type': 'academic',
        'severity': 'high',
        'title': 'Academic Risk Alert',
        'message': 'Your child\'s average performance has dropped below 40% across recent exams.',
      }
    ];
  }

  void acknowledgeAlert(String id) {
    state = state.where((alert) => alert['id'] != id).toList();
  }
}

final predictiveAlertProvider = StateNotifierProvider<PredictiveAlertNotifier, List<Map<String, dynamic>>>((ref) {
  return PredictiveAlertNotifier();
});
