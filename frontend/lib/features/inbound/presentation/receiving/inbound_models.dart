import 'package:freezed_annotation/freezed_annotation.dart';

part 'inbound_models.freezed.dart';
part 'inbound_models.g.dart';

enum ToteCategory {
  @JsonValue('STD') std('STD-'),
  @JsonValue('TOX') tox('TOX-'),
  @JsonValue('QRN') qrn('QRN-');

  final String prefix;
  const ToteCategory(this.prefix);
}

enum QuarantineReason {
  @JsonValue('NORMAL') normal,
  @JsonValue('MISSING_DOCS') missingDocs,
  @JsonValue('PHYSICAL_DAMAGE') physicalDamage,
}

@freezed
abstract class InboundItem with _$InboundItem {
  const InboundItem._(); // Required for custom getters/methods in freezed

  const factory InboundItem({
    required String barcode,
    required String productName,
    required int expectedQty,
    @Default(0) int actualQty,
    required double uomRate,
    @Default(QuarantineReason.normal) QuarantineReason reasonCode,
    @Default(false) bool noMixedBatch,
    @Default('') String toteCode,
    @Default(false) bool isToxic,
  }) = _InboundItem;

  factory InboundItem.fromJson(Map<String, dynamic> json) =>
      _$InboundItemFromJson(json);

  // Business Logic: Calculate Base Qty
  int get baseQty => (actualQty * uomRate).round();

  // Business Logic: Determine correct Tote Category based on state
  ToteCategory get requiredToteCategory {
    if (isToxic) return ToteCategory.tox;
    return ToteCategory.qrn; // GSP: All inbound must be Quarantined initially
  }

  // Business Logic: Over-receiving check
  bool get isOverReceiving => actualQty > expectedQty;

  // Validation: Check if the current state is valid for submission
  bool get isValid {
    if (barcode.isEmpty) return false;
    if (actualQty <= 0) return false;
    if (isOverReceiving) return false;
    if (!noMixedBatch) return false;
    if (toteCode.isEmpty) return false;
    if (!toteCode.toUpperCase().startsWith(requiredToteCategory.prefix)) {
      return false;
    }
    return true;
  }
}
