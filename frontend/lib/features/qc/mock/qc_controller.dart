// ============================================================
// FILE: qc_controller.dart
// Two Riverpod StateNotifiers:
//   1. QcListController  — manages the pending QRN list
//   2. QcFormController  — manages detail-screen form state
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'qc_mock_data.dart';
import 'qc_mock_repo.dart';
import 'qc_models.dart';

// ── Pending list ──────────────────────────────────────────

class QcListController extends StateNotifier<List<QcItem>> {
  QcListController() : super(List.from(QcMockData.pendingItems));

  void removeItem(int itemId) {
    state = state.where((e) => e.id != itemId).toList();
  }
}

final qcListControllerProvider =
    StateNotifierProvider<QcListController, List<QcItem>>(
  (ref) => QcListController(),
);

// ── Inspection form ───────────────────────────────────────

class QcFormController extends StateNotifier<InspectionFormState> {
  final MockQcRepository _repo;
  final Ref _ref;

  QcFormController(this._repo, this._ref) : super(const InspectionFormState());

  void loadItem(QcItem item) {
    state = InspectionFormState(item: item);
  }

  void setPassedQty(int qty) {
    state = state.copyWith(passedQty: qty, clearError: true);
  }

  void setFailedQty(int qty) {
    state = state.copyWith(failedQty: qty, clearError: true);
  }

  void setPin(String pin) {
    if (pin.length <= 4 && RegExp(r'^\d*$').hasMatch(pin)) {
      state = state.copyWith(pin: pin, clearError: true);
    }
  }

  void clearPin() {
    state = state.copyWith(pin: '');
  }

  /// Drives the 3-level approval animation, then removes item from list.
  Future<void> submit() async {
    if (!state.canSubmit) return;

    state = state.copyWith(isSubmitting: true, approvalStep: ApprovalStep.idle);

    try {
      await _repo.submitInspection(
        form: state,
        onStep: (step) {
          state = state.copyWith(approvalStep: step);
        },
      );

      // Remove item from pending list
      final itemId = state.item!.id;
      _ref.read(qcListControllerProvider.notifier).removeItem(itemId);
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        approvalStep: ApprovalStep.idle,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = const InspectionFormState();
  }
}

final qcFormControllerProvider =
    StateNotifierProvider<QcFormController, InspectionFormState>(
  (ref) => QcFormController(
    ref.watch(mockQcRepoProvider),
    ref,
  ),
);
