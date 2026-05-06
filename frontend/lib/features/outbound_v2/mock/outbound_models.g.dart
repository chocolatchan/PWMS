// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbound_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OutboundTote _$OutboundToteFromJson(Map<String, dynamic> json) =>
    _OutboundTote(
      toteId: json['toteId'] as String,
      isArrived: json['isArrived'] as bool? ?? false,
    );

Map<String, dynamic> _$OutboundToteToJson(_OutboundTote instance) =>
    <String, dynamic>{
      'toteId': instance.toteId,
      'isArrived': instance.isArrived,
    };

_SalesOrder _$SalesOrderFromJson(Map<String, dynamic> json) => _SalesOrder(
  soId: json['soId'] as String,
  requiredTotes: (json['requiredTotes'] as List<dynamic>)
      .map((e) => OutboundTote.fromJson(e as Map<String, dynamic>))
      .toList(),
  status:
      $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
      OrderStatus.picked,
  sealCode: json['sealCode'] as String?,
  isColdChain: json['isColdChain'] as bool? ?? false,
  dispatchTemp: (json['dispatchTemp'] as num?)?.toDouble(),
);

Map<String, dynamic> _$SalesOrderToJson(_SalesOrder instance) =>
    <String, dynamic>{
      'soId': instance.soId,
      'requiredTotes': instance.requiredTotes,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'sealCode': instance.sealCode,
      'isColdChain': instance.isColdChain,
      'dispatchTemp': instance.dispatchTemp,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.picked: 'picked',
  OrderStatus.packed: 'packed',
  OrderStatus.dispatched: 'dispatched',
};
