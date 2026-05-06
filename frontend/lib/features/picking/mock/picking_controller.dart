// ============================================================
// FILE: picking_controller.dart
// Picking Wizard Controller - State Machine Logic.
// ============================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'picking_models.dart';
import 'picking_mock_data.dart';

part 'picking_controller.g.dart';

@Riverpod(keepAlive: true)
class PickingWizardController extends _$PickingWizardController {
  @override
  PickingWizardState build() => const PickingWizardState();

  // ── STEP 1: SETUP ──
  void updateTote(String val) => state = state.copyWith(toteCode: val);
  void updateStartLoc(String val) => state = state.copyWith(startLoc: val);

  void startSO() {
    if (state.toteCode.isEmpty || state.startLoc.isEmpty) {
      state = state.copyWith(errorMessage: 'Vui lòng nhập đủ Tote và Vị trí');
      return;
    }
    state = state.copyWith(
      activeSO: PickingMockData.sampleSO,
      step: PickingStep.overview,
      errorMessage: null,
    );
  }

  // ── STEP 2: OVERVIEW ──
  void proceedToPick() {
    state = state.copyWith(step: PickingStep.targetLoc);
  }

  // ── STEP 3: TARGET LOCATION ──
  void validateTargetLoc(String input) {
    final target = state.activeSO?.items[state.currentItemIndex].targetLoc ?? '';
    if (input.toUpperCase() == target.toUpperCase()) {
      state = state.copyWith(isTargetLocMatched: true, errorMessage: null);
      state = state.copyWith(step: PickingStep.pickItem);
    } else {
      state = state.copyWith(isTargetLocMatched: false, errorMessage: 'Sai vị trí! Cần: $target');
    }
  }

  // ── STEP 4: PICK ITEM ──
  void validateBarcode(String input) {
    final item = state.activeSO?.items[state.currentItemIndex];
    if (item == null) return;

    if (input.toUpperCase() == item.batchCode.toUpperCase()) {
      if (item.isLasa) {
        // LASA: Increment qty on each scan
        final newQty = state.scannedQty + 1;
        state = state.copyWith(
          scannedQty: newQty > item.expectedQty ? item.expectedQty : newQty,
          isBarcodeMatched: true,
          errorMessage: null,
        );
      } else {
        // Normal: Just unlock qty field
        state = state.copyWith(isBarcodeMatched: true, errorMessage: null);
      }
    } else {
      state = state.copyWith(errorMessage: 'Sai Barcode/Lô! Cần: ${item.batchCode}');
    }
  }

  void updateNormalQty(String val) {
    final qty = int.tryParse(val) ?? 0;
    state = state.copyWith(scannedQty: qty);
  }

  void completeItem() {
    final item = state.activeSO?.items[state.currentItemIndex];
    if (item == null) return;

    if (state.scannedQty < item.expectedQty) {
      state = state.copyWith(errorMessage: 'Chưa đủ số lượng!');
      return;
    }

    // Move to next item or finish
    final nextIdx = state.currentItemIndex + 1;
    if (nextIdx < (state.activeSO?.items.length ?? 0)) {
      state = state.copyWith(
        currentItemIndex: nextIdx,
        step: PickingStep.targetLoc,
        isTargetLocMatched: false,
        isBarcodeMatched: false,
        scannedQty: 0,
        errorMessage: null,
      );
    } else {
      state = state.copyWith(step: PickingStep.complete);
    }
  }

  void reset() {
    state = const PickingWizardState();
  }
}
