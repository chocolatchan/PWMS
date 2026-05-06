// ============================================================
// FILE: qc_mock_repo.dart
// Simulates 3-level approval with artificial delays.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'qc_models.dart';

class MockQcRepository {
  /// Simulates the 3-level approval chain with real async delays.
  /// Calls [onStep] after each level to drive the UI animation.
  Future<void> submitInspection({
    required InspectionFormState form,
    required void Function(ApprovalStep step) onStep,
  }) async {
    // Validate PIN on "server"
    if (form.pin != '1234') {
      throw Exception('PIN không hợp lệ. Truy cập bị từ chối.');
    }

    // Simple delay to simulate server processing
    await Future.delayed(const Duration(milliseconds: 1500));
    onStep(ApprovalStep.done);
  }
}

// ── Riverpod Provider ──────────────────────────────────────
final mockQcRepoProvider = Provider<MockQcRepository>((ref) {
  return MockQcRepository();
});
