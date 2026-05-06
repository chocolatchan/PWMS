// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecallAlertEvent _$RecallAlertEventFromJson(Map<String, dynamic> json) =>
    RecallAlertEvent(
      batchId: json['batchId'] as String,
      reason: json['reason'] as String,
      severity: json['severity'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$RecallAlertEventToJson(RecallAlertEvent instance) =>
    <String, dynamic>{
      'batchId': instance.batchId,
      'reason': instance.reason,
      'severity': instance.severity,
      'type': instance.$type,
    };

QcReleasedEvent _$QcReleasedEventFromJson(Map<String, dynamic> json) =>
    QcReleasedEvent(
      batchId: json['batchId'] as String,
      approvedBy: json['approvedBy'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$QcReleasedEventToJson(QcReleasedEvent instance) =>
    <String, dynamic>{
      'batchId': instance.batchId,
      'approvedBy': instance.approvedBy,
      'type': instance.$type,
    };

InventoryUpdatedEvent _$InventoryUpdatedEventFromJson(
  Map<String, dynamic> json,
) => InventoryUpdatedEvent(
  locationCode: json['locationCode'] as String,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$InventoryUpdatedEventToJson(
  InventoryUpdatedEvent instance,
) => <String, dynamic>{
  'locationCode': instance.locationCode,
  'type': instance.$type,
};

UnknownEvent _$UnknownEventFromJson(Map<String, dynamic> json) =>
    UnknownEvent($type: json['type'] as String?);

Map<String, dynamic> _$UnknownEventToJson(UnknownEvent instance) =>
    <String, dynamic>{'type': instance.$type};
