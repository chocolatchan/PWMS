// ============================================================
// FILE: packing_models.dart
// Packing & Dispatch models with strict workflow state machine.
// ============================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'packing_models.freezed.dart';
part 'packing_models.g.dart';

enum PackingStep { scanSO, consolidate, packAndSeal, dispatch, complete }

@freezed
abstract class PackingTote with _$PackingTote {
  const factory PackingTote({
    required String toteId,
    @Default(false) bool hasArrived,
  }) = _PackingTote;

  factory PackingTote.fromJson(Map<String, dynamic> json) => _$PackingToteFromJson(json);
}

@freezed
abstract class PackingSO with _$PackingSO {
  const factory PackingSO({
    required String soId,
    required List<PackingTote> requiredTotes,
    @Default(false) bool isColdChain,
  }) = _PackingSO;

  factory PackingSO.fromJson(Map<String, dynamic> json) => _$PackingSOFromJson(json);
}

@freezed
abstract class PackingWizardState with _$PackingWizardState {
  const factory PackingWizardState({
    @Default(PackingStep.scanSO) PackingStep step,
    PackingSO? activeSO,
    
    // Step-specific data
    @Default('') String soInput,
    @Default([]) List<String> arrivedToteIds,
    @Default('') String sealCode,
    @Default(0.0) double temperature,
    @Default(false) bool isTempValid,
    
    @Default(false) bool isSubmitting,
    String? errorMessage,
  }) = _PackingWizardState;
}
