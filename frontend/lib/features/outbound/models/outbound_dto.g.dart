// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbound_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderItemPayloadImpl _$$OrderItemPayloadImplFromJson(
  Map<String, dynamic> json,
) => _$OrderItemPayloadImpl(
  productId: json['product_id'] as String,
  requiredQty: (json['required_qty'] as num).toInt(),
);

Map<String, dynamic> _$$OrderItemPayloadImplToJson(
  _$OrderItemPayloadImpl instance,
) => <String, dynamic>{
  'product_id': instance.productId,
  'required_qty': instance.requiredQty,
};

_$CreateOrderReqImpl _$$CreateOrderReqImplFromJson(Map<String, dynamic> json) =>
    _$CreateOrderReqImpl(
      customerName: json['customer_name'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemPayload.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CreateOrderReqImplToJson(
  _$CreateOrderReqImpl instance,
) => <String, dynamic>{
  'customer_name': instance.customerName,
  'items': instance.items,
};

_$ScanPickReqImpl _$$ScanPickReqImplFromJson(Map<String, dynamic> json) =>
    _$ScanPickReqImpl(
      taskId: json['task_id'] as String,
      barcode: json['barcode'] as String,
      inputQty: (json['input_qty'] as num).toInt(),
    );

Map<String, dynamic> _$$ScanPickReqImplToJson(_$ScanPickReqImpl instance) =>
    <String, dynamic>{
      'task_id': instance.taskId,
      'barcode': instance.barcode,
      'input_qty': instance.inputQty,
    };

_$PackContainerReqImpl _$$PackContainerReqImplFromJson(
  Map<String, dynamic> json,
) => _$PackContainerReqImpl(
  containerId: json['container_id'] as String,
  packerId: json['packer_id'] as String,
);

Map<String, dynamic> _$$PackContainerReqImplToJson(
  _$PackContainerReqImpl instance,
) => <String, dynamic>{
  'container_id': instance.containerId,
  'packer_id': instance.packerId,
};

_$DispatchReqImpl _$$DispatchReqImplFromJson(Map<String, dynamic> json) =>
    _$DispatchReqImpl(
      containerId: json['container_id'] as String,
      vehicleSealNumber: json['vehicle_seal_number'] as String,
      dispatchTemperature: (json['dispatch_temperature'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$DispatchReqImplToJson(_$DispatchReqImpl instance) =>
    <String, dynamic>{
      'container_id': instance.containerId,
      'vehicle_seal_number': instance.vehicleSealNumber,
      'dispatch_temperature': instance.dispatchTemperature,
    };

_$PickTaskImpl _$$PickTaskImplFromJson(Map<String, dynamic> json) =>
    _$PickTaskImpl(
      id: json['id'] as String,
      containerId: json['container_id'] as String,
      productName: json['product_name'] as String,
      batchNumber: json['batch_number'] as String?,
      requiredQty: (json['required_qty'] as num).toInt(),
      pickedQty: (json['picked_qty'] as num).toInt(),
      status: json['status'] as String,
      locationCode: json['location_code'] as String,
    );

Map<String, dynamic> _$$PickTaskImplToJson(_$PickTaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'container_id': instance.containerId,
      'product_name': instance.productName,
      'batch_number': instance.batchNumber,
      'required_qty': instance.requiredQty,
      'picked_qty': instance.pickedQty,
      'status': instance.status,
      'location_code': instance.locationCode,
    };
