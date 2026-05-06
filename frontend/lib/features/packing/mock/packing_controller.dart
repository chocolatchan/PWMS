// ============================================================
// FILE: packing_controller.dart
// Packing Wizard Controller - State Machine Logic for Phase 5.
// ============================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'packing_models.dart';
import 'packing_mock_data.dart';

part 'packing_controller.g.dart';

@Riverpod(keepAlive: true)
class PackingWizardController extends _$PackingWizardController {
  @override
  PackingWizardState build() => const PackingWizardState();

  // ── STEP 1: SCAN SO ──
  void updateSOInput(String val) => state = state.copyWith(soInput: val);

  void startSO() {
    if (state.soInput.toUpperCase() == PackingMockData.sampleSO.soId) {
      state = state.copyWith(
        activeSO: PackingMockData.sampleSO,
        step: PackingStep.consolidate,
        errorMessage: null,
      );
    } else {
      state = state.copyWith(errorMessage: 'Không tìm thấy SO: ${state.soInput}');
    }
  }

  // ── STEP 2: CONSOLIDATE ──
  void scanTote(String toteId) {
    final so = state.activeSO;
    if (so == null) return;

    final isValid = so.requiredTotes.any((t) => t.toteId == toteId);
    if (!isValid) {
      state = state.copyWith(errorMessage: 'Rổ $toteId không thuộc SO này!');
      return;
    }

    if (state.arrivedToteIds.contains(toteId)) {
      state = state.copyWith(errorMessage: 'Rổ $toteId đã quét rồi!');
      return;
    }

    final newList = [...state.arrivedToteIds, toteId];
    state = state.copyWith(
      arrivedToteIds: newList,
      errorMessage: null,
    );
  }

  void proceedToPack() {
    state = state.copyWith(step: PackingStep.packAndSeal);
  }

  // ── STEP 3: PACK & SEAL ──
  void updateSealCode(String val) => state = state.copyWith(sealCode: val);

  void confirmSeal() {
    if (state.sealCode.isEmpty) {
      state = state.copyWith(errorMessage: 'Vui lòng nhập Mã Niêm Phong');
      return;
    }
    state = state.copyWith(
      step: PackingStep.dispatch,
      errorMessage: null,
    );
  }

  // ── STEP 4: DISPATCH ──
  void updateTemp(String val) {
    final temp = double.tryParse(val) ?? 0.0;
    final isValid = temp <= 8.0;
    state = state.copyWith(
      temperature: temp,
      isTempValid: isValid,
      errorMessage: isValid ? null : 'Nhiệt độ xe không đạt chuẩn GSP! (Yêu cầu <= 8°C)',
    );
  }

  void completeDispatch() {
    if (state.activeSO!.isColdChain && !state.isTempValid) {
      state = state.copyWith(errorMessage: 'Chưa đạt điều kiện nhiệt độ GSP!');
      return;
    }
    state = state.copyWith(step: PackingStep.complete);
  }

  void reset() {
    state = const PackingWizardState();
  }
}
