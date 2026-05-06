// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KpiMetrics _$KpiMetricsFromJson(Map<String, dynamic> json) => _KpiMetrics(
  ordersPendingPick: (json['ordersPendingPick'] as num).toInt(),
  itemsInQuarantine: (json['itemsInQuarantine'] as num).toInt(),
  dispatchRate: json['dispatchRate'] as String,
  criticalAlerts: (json['criticalAlerts'] as num).toInt(),
);

Map<String, dynamic> _$KpiMetricsToJson(_KpiMetrics instance) =>
    <String, dynamic>{
      'ordersPendingPick': instance.ordersPendingPick,
      'itemsInQuarantine': instance.itemsInQuarantine,
      'dispatchRate': instance.dispatchRate,
      'criticalAlerts': instance.criticalAlerts,
    };

_AuditLogEvent _$AuditLogEventFromJson(Map<String, dynamic> json) =>
    _AuditLogEvent(
      id: json['id'] as String,
      timestamp: json['timestamp'] as String,
      actionName: json['actionName'] as String,
      userResponsible: json['userResponsible'] as String,
      details: json['details'] as String,
      isSuccess: json['isSuccess'] as bool,
    );

Map<String, dynamic> _$AuditLogEventToJson(_AuditLogEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp,
      'actionName': instance.actionName,
      'userResponsible': instance.userResponsible,
      'details': instance.details,
      'isSuccess': instance.isSuccess,
    };

_AdminState _$AdminStateFromJson(Map<String, dynamic> json) => _AdminState(
  metrics: KpiMetrics.fromJson(json['metrics'] as Map<String, dynamic>),
  searchResult:
      (json['searchResult'] as List<dynamic>?)
          ?.map((e) => AuditLogEvent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isSearching: json['isSearching'] as bool? ?? false,
);

Map<String, dynamic> _$AdminStateToJson(_AdminState instance) =>
    <String, dynamic>{
      'metrics': instance.metrics,
      'searchResult': instance.searchResult,
      'isSearching': instance.isSearching,
    };
