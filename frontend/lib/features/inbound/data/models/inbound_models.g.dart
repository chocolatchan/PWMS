// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbound_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BatchInfo _$BatchInfoFromJson(Map<String, dynamic> json) => _BatchInfo(
  batchId: json['batchId'] as String,
  lotNumber: json['lotNumber'] as String,
  quantity: (json['quantity'] as num).toInt(),
  expiryDate: const CustomDateTimeConverter().fromJson(
    json['expiryDate'] as String?,
  ),
  manufacturingDate: const CustomDateTimeConverter().fromJson(
    json['manufacturingDate'] as String?,
  ),
);

Map<String, dynamic> _$BatchInfoToJson(_BatchInfo instance) =>
    <String, dynamic>{
      'batchId': instance.batchId,
      'lotNumber': instance.lotNumber,
      'quantity': instance.quantity,
      'expiryDate': const CustomDateTimeConverter().toJson(instance.expiryDate),
      'manufacturingDate': const CustomDateTimeConverter().toJson(
        instance.manufacturingDate,
      ),
    };

_PoItem _$PoItemFromJson(Map<String, dynamic> json) => _PoItem(
  sku: json['sku'] as String,
  productName: json['productName'] as String,
  expectedQty: (json['expectedQty'] as num).toInt(),
  scannedQty: (json['scannedQty'] as num).toInt(),
  batches:
      (json['batches'] as List<dynamic>?)
          ?.map((e) => BatchInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PoItemToJson(_PoItem instance) => <String, dynamic>{
  'sku': instance.sku,
  'productName': instance.productName,
  'expectedQty': instance.expectedQty,
  'scannedQty': instance.scannedQty,
  'batches': instance.batches,
};

_PurchaseOrder _$PurchaseOrderFromJson(Map<String, dynamic> json) =>
    _PurchaseOrder(
      poNumber: json['poNumber'] as String,
      supplierName: json['supplierName'] as String,
      status: json['status'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => PoItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PurchaseOrderToJson(_PurchaseOrder instance) =>
    <String, dynamic>{
      'poNumber': instance.poNumber,
      'supplierName': instance.supplierName,
      'status': instance.status,
      'items': instance.items,
    };
