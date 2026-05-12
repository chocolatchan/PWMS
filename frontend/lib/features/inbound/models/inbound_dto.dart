import 'package:freezed_annotation/freezed_annotation.dart';

part 'inbound_dto.freezed.dart';
part 'inbound_dto.g.dart';

@freezed
class BatchPayload with _$BatchPayload {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BatchPayload({
    required String productId,
    required String batchNumber,
    required int expectedQty,
    required int actualQty,
  }) = _BatchPayload;

  factory BatchPayload.fromJson(Map<String, dynamic> json) => _$BatchPayloadFromJson(json);
}

@freezed
class ReceiveInboundReq with _$ReceiveInboundReq {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ReceiveInboundReq({
    required String poNumber,
    String? vehicleSealNumber,
    double? arrivalTemperature,
    required List<BatchPayload> batches,
  }) = _ReceiveInboundReq;

  factory ReceiveInboundReq.fromJson(Map<String, dynamic> json) => _$ReceiveInboundReqFromJson(json);
}

@freezed
class SubmitQcReq with _$SubmitQcReq {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SubmitQcReq({
    required String inboundBatchId,
    required String qaStaffId,
    double? minTemp,
    double? maxTemp,
    required String decision, // APPROVED/REJECTED
  }) = _SubmitQcReq;

  factory SubmitQcReq.fromJson(Map<String, dynamic> json) => _$SubmitQcReqFromJson(json);
}
