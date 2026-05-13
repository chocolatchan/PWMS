// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardStatsImpl _$$DashboardStatsImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardStatsImpl(
  totalProducts: (json['total_products'] as num).toInt(),
  activeOrders: (json['active_orders'] as num).toInt(),
  pendingInbound: (json['pending_inbound'] as num).toInt(),
  pendingPickTasks: (json['pending_pick_tasks'] as num).toInt(),
  statusDistribution: (json['inventory_status_distribution'] as List<dynamic>)
      .map((e) => InventoryStatusStat.fromJson(e as Map<String, dynamic>))
      .toList(),
  recentAlerts: (json['recent_alerts'] as List<dynamic>)
      .map((e) => RecentAlert.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$DashboardStatsImplToJson(
  _$DashboardStatsImpl instance,
) => <String, dynamic>{
  'total_products': instance.totalProducts,
  'active_orders': instance.activeOrders,
  'pending_inbound': instance.pendingInbound,
  'pending_pick_tasks': instance.pendingPickTasks,
  'inventory_status_distribution': instance.statusDistribution,
  'recent_alerts': instance.recentAlerts,
};

_$InventoryStatusStatImpl _$$InventoryStatusStatImplFromJson(
  Map<String, dynamic> json,
) => _$InventoryStatusStatImpl(
  status: json['status'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$$InventoryStatusStatImplToJson(
  _$InventoryStatusStatImpl instance,
) => <String, dynamic>{'status': instance.status, 'count': instance.count};

_$RecentAlertImpl _$$RecentAlertImplFromJson(Map<String, dynamic> json) =>
    _$RecentAlertImpl(
      id: json['id'] as String,
      eventType: json['event_type'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$RecentAlertImplToJson(_$RecentAlertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'event_type': instance.eventType,
      'message': instance.message,
      'created_at': instance.createdAt.toIso8601String(),
    };
