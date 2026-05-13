import 'package:freezed_annotation/freezed_annotation.dart';

part 'inbound_dto.freezed.dart';
part 'inbound_dto.g.dart';

@freezed
class PoItemDto with _$PoItemDto {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PoItemDto({
    required String productId,
    required String productName,
    required int expectedQty,
    required int receivedQty,
  }) = _PoItemDto;

  factory PoItemDto.fromJson(Map<String, dynamic> json) => _$PoItemDtoFromJson(json);
}

@freezed
class PoDetailsResponse with _$PoDetailsResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PoDetailsResponse({
    required String poNumber,
    String? vendorName,
    required String status,
    required List<PoItemDto> items,
  }) = _PoDetailsResponse;

  factory PoDetailsResponse.fromJson(Map<String, dynamic> json) => _$PoDetailsResponseFromJson(json);
}

@freezed
class BatchPayload with _$BatchPayload {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BatchPayload({
    required String productId,
    required String batchNumber,
    @JsonKey(toJson: _dateToJson) required DateTime expiryDate,
    required int expectedQty,
    required int actualQty,
  }) = _BatchPayload;

  factory BatchPayload.fromJson(Map<String, dynamic> json) => _$BatchPayloadFromJson(json);
}

String _dateToJson(DateTime date) => date.toIso8601String().split('T')[0];

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
    required String batchNumber,
    double? minTemp,
    double? maxTemp,
    String? deviationReportId,
    required String decision, // APPROVED/REJECTED
  }) = _SubmitQcReq;

  factory SubmitQcReq.fromJson(Map<String, dynamic> json) => _$SubmitQcReqFromJson(json);
}

@freezed
class MoveToQuarantineReq with _$MoveToQuarantineReq {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory MoveToQuarantineReq({
    required String batchNumber,
    required String locationCode,
  }) = _MoveToQuarantineReq;

  factory MoveToQuarantineReq.fromJson(Map<String, dynamic> json) => _$MoveToQuarantineReqFromJson(json);
}

@freezed
class BindDraftReq with _$BindDraftReq {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BindDraftReq({
    required String poNumber,
  }) = _BindDraftReq;

  factory BindDraftReq.fromJson(Map<String, dynamic> json) => _$BindDraftReqFromJson(json);
}

@freezed
class SaveDraftReq with _$SaveDraftReq {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SaveDraftReq({
    required String poNumber,
    required Map<String, dynamic> payload,
  }) = _SaveDraftReq;

  factory SaveDraftReq.fromJson(Map<String, dynamic> json) => _$SaveDraftReqFromJson(json);
}

@freezed
class UnbindDraftReq with _$UnbindDraftReq {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UnbindDraftReq({
    required String poNumber,
  }) = _UnbindDraftReq;

  factory UnbindDraftReq.fromJson(Map<String, dynamic> json) => _$UnbindDraftReqFromJson(json);
}
