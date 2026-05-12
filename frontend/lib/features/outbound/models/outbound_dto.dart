import 'package:freezed_annotation/freezed_annotation.dart';

part 'outbound_dto.freezed.dart';
part 'outbound_dto.g.dart';

@freezed
class OrderItemPayload with _$OrderItemPayload {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory OrderItemPayload({
    required String productId,
    required int requiredQty,
  }) = _OrderItemPayload;

  factory OrderItemPayload.fromJson(Map<String, dynamic> json) => _$OrderItemPayloadFromJson(json);
}

@freezed
class CreateOrderReq with _$CreateOrderReq {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CreateOrderReq({
    required String customerName,
    required List<OrderItemPayload> items,
  }) = _CreateOrderReq;

  factory CreateOrderReq.fromJson(Map<String, dynamic> json) => _$CreateOrderReqFromJson(json);
}

@freezed
class ScanPickReq with _$ScanPickReq {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ScanPickReq({
    required String taskId,
    required String barcode,
    required int inputQty,
  }) = _ScanPickReq;

  factory ScanPickReq.fromJson(Map<String, dynamic> json) => _$ScanPickReqFromJson(json);
}

@freezed
class PackContainerReq with _$PackContainerReq {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PackContainerReq({
    required String containerId,
    required String packerId,
  }) = _PackContainerReq;

  factory PackContainerReq.fromJson(Map<String, dynamic> json) => _$PackContainerReqFromJson(json);
}

@freezed
class DispatchReq with _$DispatchReq {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory DispatchReq({
    required String containerId,
    required String vehicleSealNumber,
    double? dispatchTemperature,
  }) = _DispatchReq;

  factory DispatchReq.fromJson(Map<String, dynamic> json) => _$DispatchReqFromJson(json);
}

@freezed
class PickTask with _$PickTask {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PickTask({
    required String id,
    required String productName,
    required int requiredQty,
    required int pickedQty,
    required String status,
    required String locationCode,
  }) = _PickTask;

  factory PickTask.fromJson(Map<String, dynamic> json) => _$PickTaskFromJson(json);
}
