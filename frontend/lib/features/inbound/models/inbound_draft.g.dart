// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbound_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InboundDraftImpl _$$InboundDraftImplFromJson(Map<String, dynamic> json) =>
    _$InboundDraftImpl(
      step: (json['step'] as num?)?.toInt() ?? 0,
      poNumber: json['po_number'] as String?,
      sealNumber: json['seal_number'] as String?,
      arrivalTemperature: (json['arrival_temperature'] as num?)?.toDouble(),
      batches:
          (json['batches'] as List<dynamic>?)
              ?.map((e) => BatchPayload.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$InboundDraftImplToJson(_$InboundDraftImpl instance) =>
    <String, dynamic>{
      'step': instance.step,
      'po_number': instance.poNumber,
      'seal_number': instance.sealNumber,
      'arrival_temperature': instance.arrivalTemperature,
      'batches': instance.batches,
    };
