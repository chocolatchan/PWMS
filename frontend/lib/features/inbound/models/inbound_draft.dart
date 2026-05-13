import 'package:freezed_annotation/freezed_annotation.dart';
import 'inbound_dto.dart';

part 'inbound_draft.freezed.dart';
part 'inbound_draft.g.dart';

@freezed
class InboundDraft with _$InboundDraft {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory InboundDraft({
    @Default(0) int step,
    String? poNumber,
    String? sealNumber,
    double? arrivalTemperature,
    @Default([]) List<BatchPayload> batches,
  }) = _InboundDraft;

  factory InboundDraft.fromJson(Map<String, dynamic> json) => _$InboundDraftFromJson(json);
}
