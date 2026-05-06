// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'putaway_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PutawayItem _$PutawayItemFromJson(Map<String, dynamic> json) => _PutawayItem(
  sku: json['sku'] as String,
  productName: json['productName'] as String,
  expectedQty: (json['expectedQty'] as num).toInt(),
  scannedQty: (json['scannedQty'] as num).toInt(),
  suggestedLocation: json['suggestedLocation'] as String,
);

Map<String, dynamic> _$PutawayItemToJson(_PutawayItem instance) =>
    <String, dynamic>{
      'sku': instance.sku,
      'productName': instance.productName,
      'expectedQty': instance.expectedQty,
      'scannedQty': instance.scannedQty,
      'suggestedLocation': instance.suggestedLocation,
    };

_PutawayTask _$PutawayTaskFromJson(Map<String, dynamic> json) => _PutawayTask(
  toteBarcode: json['toteBarcode'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => PutawayItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: json['status'] as String,
);

Map<String, dynamic> _$PutawayTaskToJson(_PutawayTask instance) =>
    <String, dynamic>{
      'toteBarcode': instance.toteBarcode,
      'items': instance.items,
      'status': instance.status,
    };
