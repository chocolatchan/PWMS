// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picking_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PickingItem _$PickingItemFromJson(Map<String, dynamic> json) => _PickingItem(
  productId: json['productId'] as String,
  productName: json['productName'] as String,
  targetLoc: json['targetLoc'] as String,
  batchCode: json['batchCode'] as String,
  expectedQty: (json['expectedQty'] as num).toInt(),
  isLasa: json['isLasa'] as bool,
);

Map<String, dynamic> _$PickingItemToJson(_PickingItem instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'targetLoc': instance.targetLoc,
      'batchCode': instance.batchCode,
      'expectedQty': instance.expectedQty,
      'isLasa': instance.isLasa,
    };

_PickingSO _$PickingSOFromJson(Map<String, dynamic> json) => _PickingSO(
  soId: json['soId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => PickingItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PickingSOToJson(_PickingSO instance) =>
    <String, dynamic>{'soId': instance.soId, 'items': instance.items};
