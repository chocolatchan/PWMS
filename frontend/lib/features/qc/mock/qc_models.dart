// ============================================================
// FILE: qc_models.dart
// Domain models for QC inspection form state.
// Plain Dart, no code-gen required.
// ============================================================

import 'qc_mock_data.dart';

enum ApprovalStep { idle, qa, chiefPharmacist, director, done }

class InspectionFormState {
  final QcItem? item;
  final int passedQty;
  final int failedQty;
  final String pin;           // 4-digit string
  final bool isSubmitting;
  final ApprovalStep approvalStep;
  final String? errorMessage;

  const InspectionFormState({
    this.item,
    this.passedQty = 0,
    this.failedQty = 0,
    this.pin = '',
    this.isSubmitting = false,
    this.approvalStep = ApprovalStep.idle,
    this.errorMessage,
  });

  // ── GSP Rule: Pass + Fail must == Declared ──────────────
  int get totalEntered => passedQty + failedQty;

  bool get isSplitValid {
    if (item == null) return false;
    return totalEntered == item!.declaredQty;
  }

  String? get splitError {
    if (item == null) return null;
    final diff = item!.declaredQty - totalEntered;
    if (diff > 0) return '⚠ Còn thiếu $diff ${item!.unit} chưa phân loại';
    if (diff < 0) return '⚠ Vượt quá ${diff.abs()} ${item!.unit} so với số khai báo';
    return null;
  }

  // ── GSP Rule: PIN must be exactly 4 digits ─────────────
  bool get isPinComplete => pin.length == 4;

  // ── Can Submit ──────────────────────────────────────────
  bool get canSubmit =>
      item != null &&
      isSplitValid &&
      isPinComplete &&
      !isSubmitting;

  InspectionFormState copyWith({
    QcItem? item,
    int? passedQty,
    int? failedQty,
    String? pin,
    bool? isSubmitting,
    ApprovalStep? approvalStep,
    String? errorMessage,
    bool clearError = false,
  }) {
    return InspectionFormState(
      item: item ?? this.item,
      passedQty: passedQty ?? this.passedQty,
      failedQty: failedQty ?? this.failedQty,
      pin: pin ?? this.pin,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      approvalStep: approvalStep ?? this.approvalStep,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
