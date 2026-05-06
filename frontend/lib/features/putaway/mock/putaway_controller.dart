// ============================================================
// FILE: putaway_controller.dart
// Manages all state transitions for the Putaway workflow.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'putaway_mock_repo.dart';
import 'putaway_models.dart';

class PutawayController extends StateNotifier<PutawayTaskState> {
  final MockPutawayRepository _repo;

  PutawayController(this._repo) : super(const PutawayTaskState());

  // ── Step 1: Scan / enter tote code ───────────────────────
  Future<void> scanTote(String toteCode) async {
    if (toteCode.trim().isEmpty) return;

    state = state.copyWith(step: PutawayStep.loading, clearError: true);
    try {
      final tote = await _repo.fetchTask(toteCode.trim().toUpperCase());
      state = PutawayTaskState(
        step: PutawayStep.confirm,
        tote: tote,
      );
    } catch (e) {
      state = PutawayTaskState(
        step: PutawayStep.scanTote,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // ── Step 3: User scans/types location ────────────────────
  void setScannedLocation(String loc) {
    state = state.copyWith(scannedLocation: loc.toUpperCase(), clearError: true);
  }

  // ── Step 4: Location full — reroute to alternate ─────────
  void reportLocationFull() {
    state = state.copyWith(
      isLocationFull: true,
      scannedLocation: '', // Force re-scan at new location
    );
  }

  // ── Step 5: TOX PIN ───────────────────────────────────────
  void setPin(String pin) {
    if (pin.length <= 4 && RegExp(r'^\d*$').hasMatch(pin)) {
      state = state.copyWith(pin: pin);
    }
  }

  // ── Step 6: Confirm drop ──────────────────────────────────
  Future<void> confirmDrop() async {
    if (!state.canConfirm) return;

    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      await _repo.confirmDrop(
        toteCode: state.tote!.toteCode,
        locationCode: state.activeLocation,
      );
      state = state.copyWith(step: PutawayStep.success, isSubmitting: false);
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  // ── Reset ─────────────────────────────────────────────────
  void reset() {
    state = const PutawayTaskState();
  }
}

final putawayControllerProvider =
    StateNotifierProvider<PutawayController, PutawayTaskState>((ref) {
  return PutawayController(ref.watch(mockPutawayRepoProvider));
});
