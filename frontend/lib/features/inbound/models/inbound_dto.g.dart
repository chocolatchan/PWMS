// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbound_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BatchPayloadImpl _$$BatchPayloadImplFromJson(Map<String, dynamic> json) =>
    _$BatchPayloadImpl(
      productId: json['product_id'] as String,
      batchNumber: json['batch_number'] as String,
      expectedQty: (json['expected_qty'] as num).toInt(),
      actualQty: (json['actual_qty'] as num).toInt(),
    );

Map<String, dynamic> _$$BatchPayloadImplToJson(_$BatchPayloadImpl instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'batch_number': instance.batchNumber,
      'expected_qty': instance.expectedQty,
      'actual_qty': instance.actualQty,
    };

_$ReceiveInboundReqImpl _$$ReceiveInboundReqImplFromJson(
  Map<String, dynamic> json,
) => _$ReceiveInboundReqImpl(
  poNumber: json['po_number'] as String,
  vehicleSealNumber: json['vehicle_seal_number'] as String?,
  arrivalTemperature: (json['arrival_temperature'] as num?)?.toDouble(),
  batches: (json['batches'] as List<dynamic>)
      .map((e) => BatchPayload.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$ReceiveInboundReqImplToJson(
  _$ReceiveInboundReqImpl instance,
) => <String, dynamic>{
  'po_number': instance.poNumber,
  'vehicle_seal_number': instance.vehicleSealNumber,
  'arrival_temperature': instance.arrivalTemperature,
  'batches': instance.batches,
};

_$SubmitQcReqImpl _$$SubmitQcReqImplFromJson(Map<String, dynamic> json) =>
    _$SubmitQcReqImpl(
      inboundBatchId: json['inbound_batch_id'] as String,
      qaStaffId: json['qa_staff_id'] as String,
      minTemp: (json['min_temp'] as num?)?.toDouble(),
      maxTemp: (json['max_temp'] as num?)?.toDouble(),
      decision: json['decision'] as String,
    );

Map<String, dynamic> _$$SubmitQcReqImplToJson(_$SubmitQcReqImpl instance) =>
    <String, dynamic>{
      'inbound_batch_id': instance.inboundBatchId,
      'qa_staff_id': instance.qaStaffId,
      'min_temp': instance.minTemp,
      'max_temp': instance.maxTemp,
      'decision': instance.decision,
    };
