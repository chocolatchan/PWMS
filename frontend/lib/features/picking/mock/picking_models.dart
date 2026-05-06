// ============================================================
// FILE: picking_models.dart
// Picking models with strict workflow state machine.
// ============================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'picking_models.freezed.dart';
part 'picking_models.g.dart';

enum PickingStep { setup, overview, targetLoc, pickItem, complete }

@freezed
abstract class PickingItem with _$PickingItem {
  const factory PickingItem({
    required String productId,
    required String productName,
    required String targetLoc,
    required String batchCode,
    required int expectedQty,
    required bool isLasa,
  }) = _PickingItem;

  factory PickingItem.fromJson(Map<String, dynamic> json) => _$PickingItemFromJson(json);
}

@freezed
abstract class PickingSO with _$PickingSO {
  const factory PickingSO({
    required String soId,
    required List<PickingItem> items,
  }) = _PickingSO;

  factory PickingSO.fromJson(Map<String, dynamic> json) => _$PickingSOFromJson(json);
}

@freezed
abstract class PickingWizardState with _$PickingWizardState {
  const factory PickingWizardState({
    @Default(PickingStep.setup) PickingStep step,
    PickingSO? activeSO,
    @Default(0) int currentItemIndex,
    
    // Setup data
    @Default('') String toteCode,
    @Default('') String startLoc,
    
    // Execution data
    @Default('') String inputBuffer, // Used for scanning/typing
    @Default(0) int scannedQty,
    @Default(false) bool isTargetLocMatched,
    @Default(false) bool isBarcodeMatched,
    
    @Default(false) bool isSubmitting,
    String? errorMessage,
  }) = _PickingWizardState;
}
