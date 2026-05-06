// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbound_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InboundItem _$InboundItemFromJson(Map<String, dynamic> json) => _InboundItem(
  barcode: json['barcode'] as String,
  productName: json['productName'] as String,
  expectedQty: (json['expectedQty'] as num).toInt(),
  actualQty: (json['actualQty'] as num?)?.toInt() ?? 0,
  uomRate: (json['uomRate'] as num).toDouble(),
  reasonCode:
      $enumDecodeNullable(_$QuarantineReasonEnumMap, json['reasonCode']) ??
      QuarantineReason.normal,
  noMixedBatch: json['noMixedBatch'] as bool? ?? false,
  toteCode: json['toteCode'] as String? ?? '',
  isToxic: json['isToxic'] as bool? ?? false,
);

Map<String, dynamic> _$InboundItemToJson(_InboundItem instance) =>
    <String, dynamic>{
      'barcode': instance.barcode,
      'productName': instance.productName,
      'expectedQty': instance.expectedQty,
      'actualQty': instance.actualQty,
      'uomRate': instance.uomRate,
      'reasonCode': _$QuarantineReasonEnumMap[instance.reasonCode]!,
      'noMixedBatch': instance.noMixedBatch,
      'toteCode': instance.toteCode,
      'isToxic': instance.isToxic,
    };

const _$QuarantineReasonEnumMap = {
  QuarantineReason.normal: 'NORMAL',
  QuarantineReason.missingDocs: 'MISSING_DOCS',
  QuarantineReason.physicalDamage: 'PHYSICAL_DAMAGE',
};
