// ============================================================
// FILE: inbound_controller.dart
// Riverpod StateNotifier — manages all UI state transitions.
// Uses StateNotifierProvider to avoid build_runner dependency.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'inbound_mock_data.dart';
import 'inbound_mock_repo.dart';
import 'inbound_models.dart';

class InboundController extends StateNotifier<InboundItemState> {
  final MockInboundRepository _repo;

  InboundController(this._repo) : super(const InboundItemState());

  // ── Demo scanner: instantly loads Paracetamol ─────────────
  void simulateScanParacetamol() {
    _loadItem(InboundMockData.poItems[0]);
  }

  // ── Demo scanner: loads Morphine (toxic) ──────────────────
  void simulateScanMorphine() {
    _loadItem(InboundMockData.poItems[1]);
  }

  // ── Manual input simulation ───────────────────────────────
  void simulateManualInput(String barcode) {
    if (barcode.trim().isEmpty) return;
    // Just mock it as Paracetamol for demo if any barcode is entered
    _loadItem(InboundMockData.poItems[0].copyWith(productName: 'Manual: $barcode'));
  }

  void _loadItem(MockPoItem item) {
    state = InboundItemState(poItem: item);
  }


  void setManufacturer(String? name) {
    state = state.copyWith(manufacturer: name);
  }

  void setBatchNumber(String val) {
    state = state.copyWith(batchNumber: val.toUpperCase());
  }

  // ── Rule 2: Actual qty update ─────────────────────────────
  void setActualQty(int qty) {
    state = state.copyWith(actualQty: qty, clearSubmissionResult: true);
  }

  // ── Rule 5: Tote code update ──────────────────────────────
  void setToteCode(String code) {
    state = state.copyWith(toteCode: code, clearSubmissionResult: true);
  }

  // ── Rule 1: Mixed batch confirmation ─────────────────────
  void setMixedBatchConfirmed(bool value) {
    state = state.copyWith(mixedBatchConfirmed: value);
  }

  // ── Rule 3: Quarantine flag / Condition ──────────────────
  void setQuarantineFlag(QuarantineFlag flag) {
    state = state.copyWith(
      quarantineFlag: flag,
      toteCode: '',
    );
  }


  // ── Submit ────────────────────────────────────────────────
  Future<String?> submit() async {
    if (!state.canSubmit) return null;

    state = state.copyWith(isSubmitting: true, clearSubmissionResult: true);
    try {
      final result = await _repo.submitItem(state);
      state = state.copyWith(
        isSubmitting: false,
        submissionResult: 'success:$result',
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        submissionResult: 'error:${e.toString()}',
      );
      return e.toString();
    }
  }

  // ── Reset form ────────────────────────────────────────────
  void reset() {
    state = const InboundItemState();
  }
}

// ── Provider ──────────────────────────────────────────────
final inboundControllerProvider =
    StateNotifierProvider<InboundController, InboundItemState>((ref) {
      final repo = ref.watch(mockInboundRepoProvider);
      return InboundController(repo);
    });
