import 'package:freezed_annotation/freezed_annotation.dart';

part 'ws_event.freezed.dart';
part 'ws_event.g.dart';

@Freezed(unionKey: 'type', fallbackUnion: 'unknown')
abstract class WsEvent with _$WsEvent {
  const factory WsEvent.recallAlert({
    required String batchId,
    required String reason,
    required String severity,
  }) = RecallAlertEvent;

  const factory WsEvent.qcReleased({
    required String batchId,
    required String approvedBy,
  }) = QcReleasedEvent;

  const factory WsEvent.inventoryUpdated({
    required String locationCode,
  }) = InventoryUpdatedEvent;

  const factory WsEvent.unknown() = UnknownEvent;

  factory WsEvent.fromJson(Map<String, dynamic> json) => _$WsEventFromJson(json);
}
