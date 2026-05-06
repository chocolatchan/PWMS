import 'package:freezed_annotation/freezed_annotation.dart';

part 'inbound_models.freezed.dart';
part 'inbound_models.g.dart';

/// Safely handles ISO-8601 string to DateTime parsing for Pharma compliance.
class CustomDateTimeConverter implements JsonConverter<DateTime?, String?> {
  const CustomDateTimeConverter();

  @override
  DateTime? fromJson(String? json) {
    if (json == null || json.isEmpty) return null;
    return DateTime.tryParse(json);
  }

  @override
  String? toJson(DateTime? date) => date?.toIso8601String();
}

@freezed
abstract class BatchInfo with _$BatchInfo {
  const factory BatchInfo({
    required String batchId,
    required String lotNumber,
    required int quantity,
    @CustomDateTimeConverter() DateTime? expiryDate,
    @CustomDateTimeConverter() DateTime? manufacturingDate,
  }) = _BatchInfo;

  factory BatchInfo.fromJson(Map<String, dynamic> json) => _$BatchInfoFromJson(json);
}

@freezed
abstract class PoItem with _$PoItem {
  const factory PoItem({
    required String sku,
    required String productName,
    required int expectedQty,
    required int scannedQty,
    @Default([]) List<BatchInfo> batches,
  }) = _PoItem;

  factory PoItem.fromJson(Map<String, dynamic> json) => _$PoItemFromJson(json);
}

@freezed
abstract class PurchaseOrder with _$PurchaseOrder {
  const factory PurchaseOrder({
    required String poNumber,
    required String supplierName,
    required String status,
    required List<PoItem> items,
  }) = _PurchaseOrder;

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) => _$PurchaseOrderFromJson(json);
}
