// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbound_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PoItemDtoImpl _$$PoItemDtoImplFromJson(Map<String, dynamic> json) =>
    _$PoItemDtoImpl(
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      expectedQty: (json['expected_qty'] as num).toInt(),
      receivedQty: (json['received_qty'] as num).toInt(),
    );

Map<String, dynamic> _$$PoItemDtoImplToJson(_$PoItemDtoImpl instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'product_name': instance.productName,
      'expected_qty': instance.expectedQty,
      'received_qty': instance.receivedQty,
    };

_$PoDetailsResponseImpl _$$PoDetailsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PoDetailsResponseImpl(
  poNumber: json['po_number'] as String,
  vendorName: json['vendor_name'] as String?,
  status: json['status'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => PoItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$PoDetailsResponseImplToJson(
  _$PoDetailsResponseImpl instance,
) => <String, dynamic>{
  'po_number': instance.poNumber,
  'vendor_name': instance.vendorName,
  'status': instance.status,
  'items': instance.items,
};

_$BatchPayloadImpl _$$BatchPayloadImplFromJson(Map<String, dynamic> json) =>
    _$BatchPayloadImpl(
      productId: json['product_id'] as String,
      batchNumber: json['batch_number'] as String,
      expiryDate: DateTime.parse(json['expiry_date'] as String),
      expectedQty: (json['expected_qty'] as num).toInt(),
      actualQty: (json['actual_qty'] as num).toInt(),
    );

Map<String, dynamic> _$$BatchPayloadImplToJson(_$BatchPayloadImpl instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'batch_number': instance.batchNumber,
      'expiry_date': _dateToJson(instance.expiryDate),
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
      batchNumber: json['batch_number'] as String,
      minTemp: (json['min_temp'] as num?)?.toDouble(),
      maxTemp: (json['max_temp'] as num?)?.toDouble(),
      deviationReportId: json['deviation_report_id'] as String?,
      decision: json['decision'] as String,
    );

Map<String, dynamic> _$$SubmitQcReqImplToJson(_$SubmitQcReqImpl instance) =>
    <String, dynamic>{
      'batch_number': instance.batchNumber,
      'min_temp': instance.minTemp,
      'max_temp': instance.maxTemp,
      'deviation_report_id': instance.deviationReportId,
      'decision': instance.decision,
    };

_$MoveToQuarantineReqImpl _$$MoveToQuarantineReqImplFromJson(
  Map<String, dynamic> json,
) => _$MoveToQuarantineReqImpl(
  batchNumber: json['batch_number'] as String,
  locationCode: json['location_code'] as String,
);

Map<String, dynamic> _$$MoveToQuarantineReqImplToJson(
  _$MoveToQuarantineReqImpl instance,
) => <String, dynamic>{
  'batch_number': instance.batchNumber,
  'location_code': instance.locationCode,
};

_$BindDraftReqImpl _$$BindDraftReqImplFromJson(Map<String, dynamic> json) =>
    _$BindDraftReqImpl(poNumber: json['po_number'] as String);

Map<String, dynamic> _$$BindDraftReqImplToJson(_$BindDraftReqImpl instance) =>
    <String, dynamic>{'po_number': instance.poNumber};

_$SaveDraftReqImpl _$$SaveDraftReqImplFromJson(Map<String, dynamic> json) =>
    _$SaveDraftReqImpl(
      poNumber: json['po_number'] as String,
      payload: json['payload'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$SaveDraftReqImplToJson(_$SaveDraftReqImpl instance) =>
    <String, dynamic>{
      'po_number': instance.poNumber,
      'payload': instance.payload,
    };

_$UnbindDraftReqImpl _$$UnbindDraftReqImplFromJson(Map<String, dynamic> json) =>
    _$UnbindDraftReqImpl(poNumber: json['po_number'] as String);

Map<String, dynamic> _$$UnbindDraftReqImplToJson(
  _$UnbindDraftReqImpl instance,
) => <String, dynamic>{'po_number': instance.poNumber};
