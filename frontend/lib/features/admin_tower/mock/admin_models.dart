import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_models.freezed.dart';
part 'admin_models.g.dart';

@freezed
abstract class KpiMetrics with _$KpiMetrics {
  const factory KpiMetrics({
    required int ordersPendingPick,
    required int itemsInQuarantine,
    required String dispatchRate,
    required int criticalAlerts,
  }) = _KpiMetrics;

  factory KpiMetrics.fromJson(Map<String, dynamic> json) => _$KpiMetricsFromJson(json);
}

@freezed
abstract class AuditLogEvent with _$AuditLogEvent {
  const factory AuditLogEvent({
    required String id,
    required String timestamp,
    required String actionName,
    required String userResponsible,
    required String details,
    required bool isSuccess,
  }) = _AuditLogEvent;

  factory AuditLogEvent.fromJson(Map<String, dynamic> json) => _$AuditLogEventFromJson(json);
}

@freezed
abstract class AdminState with _$AdminState {
  const factory AdminState({
    required KpiMetrics metrics,
    @Default([]) List<AuditLogEvent> searchResult,
    @Default(false) bool isSearching,
  }) = _AdminState;

  factory AdminState.fromJson(Map<String, dynamic> json) => _$AdminStateFromJson(json);
}
