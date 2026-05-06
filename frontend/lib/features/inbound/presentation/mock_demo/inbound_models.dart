// ============================================================
// FILE: inbound_models.dart
// Domain models with embedded GSP business rule getters.
// No code generation needed - plain Dart classes.
// ============================================================

import 'inbound_mock_data.dart';

enum QuarantineFlag { none, missingCoa, damaged }

extension QuarantineFlagLabel on QuarantineFlag {
  String get label {
    switch (this) {
      case QuarantineFlag.none:       return 'Bình thường (Chờ QC)';
      case QuarantineFlag.missingCoa: return 'Thiếu COA (Missing COA)';
      case QuarantineFlag.damaged:    return 'Hàng móp méo (Damaged)';
    }
  }
  // Mapping to backend codes or audit trail codes
  String get code {
    switch (this) {
      case QuarantineFlag.none:       return 'NORMAL_PENDING';
      case QuarantineFlag.missingCoa: return 'MISSING_DOCS';
      case QuarantineFlag.damaged:    return 'PHYSICAL_DAMAGE';
    }
  }
}

/// Immutable state object representing what the staff member has
/// filled in for a single PO line item during receiving.
class InboundItemState {
  final MockPoItem? poItem;       // null = nothing scanned yet
  final String? manufacturer;
  final String batchNumber;
  final int actualQty;
  final String toteCode;
  final bool mixedBatchConfirmed;
  final QuarantineFlag quarantineFlag;
  final bool isSubmitting;
  final String? submissionResult; // null, 'success', or error msg

  const InboundItemState({
    this.poItem,
    this.manufacturer,
    this.batchNumber = '',
    this.actualQty = 0,
    this.toteCode = '',
    this.mixedBatchConfirmed = false,
    this.quarantineFlag = QuarantineFlag.none,
    this.isSubmitting = false,
    this.submissionResult,
  });

  // ── GSP Rule 3: Is quarantine required? ───────────────────
  // In GSP Phase 3, ALL inbound goes to quarantine first
  bool get isQuarantine => true; 

  // ── GSP Rule 4: Over-receiving ─────────────────────────────
  bool get isOverReceiving {
    if (poItem == null) return false;
    return actualQty > poItem!.expectedQty;
  }

  // ── GSP Rule 5: Required tote prefix ───────────────────────
  String get requiredTotePrefix {
    if (poItem == null) return 'QRN-';
    if (poItem!.isToxic) return 'TOX-';
    return 'QRN-';
  }

  bool get isTotePrefixValid {
    if (toteCode.isEmpty) return false;
    return toteCode.toUpperCase().startsWith(requiredTotePrefix);
  }

  // ── GSP Rule 2: UOM calculation ────────────────────────────
  double get baseQty {
    if (poItem == null) return 0;
    return actualQty * poItem!.conversionRate;
  }

  // ── Can Submit? All 5 rules must pass ─────────────────────
  bool get canSubmit {
    return poItem != null
        && manufacturer != null
        && batchNumber.isNotEmpty
        && !isSubmitting
        && !isOverReceiving
        && mixedBatchConfirmed       // Rule 1
        && isTotePrefixValid         // Rule 5
        && actualQty > 0;
  }

  InboundItemState copyWith({
    MockPoItem? poItem,
    bool clearPoItem = false,
    String? manufacturer,
    bool clearManufacturer = false,
    String? batchNumber,
    int? actualQty,
    String? toteCode,
    bool? mixedBatchConfirmed,
    QuarantineFlag? quarantineFlag,
    bool? isSubmitting,
    String? submissionResult,
    bool clearSubmissionResult = false,
  }) {
    return InboundItemState(
      poItem: clearPoItem ? null : (poItem ?? this.poItem),
      manufacturer: clearManufacturer ? null : (manufacturer ?? this.manufacturer),
      batchNumber: batchNumber ?? this.batchNumber,
      actualQty: actualQty ?? this.actualQty,
      toteCode: toteCode ?? this.toteCode,
      mixedBatchConfirmed: mixedBatchConfirmed ?? this.mixedBatchConfirmed,
      quarantineFlag: quarantineFlag ?? this.quarantineFlag,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionResult: clearSubmissionResult ? null : (submissionResult ?? this.submissionResult),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InboundItemState &&
          runtimeType == other.runtimeType &&
          poItem?.id == other.poItem?.id &&
          actualQty == other.actualQty &&
          toteCode == other.toteCode &&
          mixedBatchConfirmed == other.mixedBatchConfirmed &&
          quarantineFlag == other.quarantineFlag &&
          isSubmitting == other.isSubmitting &&
          submissionResult == other.submissionResult;

  @override
  int get hashCode => Object.hash(
        poItem?.id, actualQty, toteCode, mixedBatchConfirmed,
        quarantineFlag, isSubmitting, submissionResult,
      );
}
