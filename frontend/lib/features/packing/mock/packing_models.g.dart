// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packing_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PackingTote _$PackingToteFromJson(Map<String, dynamic> json) => _PackingTote(
  toteId: json['toteId'] as String,
  hasArrived: json['hasArrived'] as bool? ?? false,
);

Map<String, dynamic> _$PackingToteToJson(_PackingTote instance) =>
    <String, dynamic>{
      'toteId': instance.toteId,
      'hasArrived': instance.hasArrived,
    };

_PackingSO _$PackingSOFromJson(Map<String, dynamic> json) => _PackingSO(
  soId: json['soId'] as String,
  requiredTotes: (json['requiredTotes'] as List<dynamic>)
      .map((e) => PackingTote.fromJson(e as Map<String, dynamic>))
      .toList(),
  isColdChain: json['isColdChain'] as bool? ?? false,
);

Map<String, dynamic> _$PackingSOToJson(_PackingSO instance) =>
    <String, dynamic>{
      'soId': instance.soId,
      'requiredTotes': instance.requiredTotes,
      'isColdChain': instance.isColdChain,
    };
