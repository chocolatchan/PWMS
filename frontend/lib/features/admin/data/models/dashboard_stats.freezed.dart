// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardStats _$DashboardStatsFromJson(Map<String, dynamic> json) {
  return _DashboardStats.fromJson(json);
}

/// @nodoc
mixin _$DashboardStats {
  @JsonKey(name: 'total_products')
  int get totalProducts => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_orders')
  int get activeOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_inbound')
  int get pendingInbound => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_pick_tasks')
  int get pendingPickTasks => throw _privateConstructorUsedError;
  @JsonKey(name: 'inventory_status_distribution')
  List<InventoryStatusStat> get statusDistribution =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_alerts')
  List<RecentAlert> get recentAlerts => throw _privateConstructorUsedError;

  /// Serializes this DashboardStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStatsCopyWith<DashboardStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatsCopyWith<$Res> {
  factory $DashboardStatsCopyWith(
    DashboardStats value,
    $Res Function(DashboardStats) then,
  ) = _$DashboardStatsCopyWithImpl<$Res, DashboardStats>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_products') int totalProducts,
    @JsonKey(name: 'active_orders') int activeOrders,
    @JsonKey(name: 'pending_inbound') int pendingInbound,
    @JsonKey(name: 'pending_pick_tasks') int pendingPickTasks,
    @JsonKey(name: 'inventory_status_distribution')
    List<InventoryStatusStat> statusDistribution,
    @JsonKey(name: 'recent_alerts') List<RecentAlert> recentAlerts,
  });
}

/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res, $Val extends DashboardStats>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalProducts = null,
    Object? activeOrders = null,
    Object? pendingInbound = null,
    Object? pendingPickTasks = null,
    Object? statusDistribution = null,
    Object? recentAlerts = null,
  }) {
    return _then(
      _value.copyWith(
            totalProducts: null == totalProducts
                ? _value.totalProducts
                : totalProducts // ignore: cast_nullable_to_non_nullable
                      as int,
            activeOrders: null == activeOrders
                ? _value.activeOrders
                : activeOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingInbound: null == pendingInbound
                ? _value.pendingInbound
                : pendingInbound // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingPickTasks: null == pendingPickTasks
                ? _value.pendingPickTasks
                : pendingPickTasks // ignore: cast_nullable_to_non_nullable
                      as int,
            statusDistribution: null == statusDistribution
                ? _value.statusDistribution
                : statusDistribution // ignore: cast_nullable_to_non_nullable
                      as List<InventoryStatusStat>,
            recentAlerts: null == recentAlerts
                ? _value.recentAlerts
                : recentAlerts // ignore: cast_nullable_to_non_nullable
                      as List<RecentAlert>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardStatsImplCopyWith<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  factory _$$DashboardStatsImplCopyWith(
    _$DashboardStatsImpl value,
    $Res Function(_$DashboardStatsImpl) then,
  ) = __$$DashboardStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_products') int totalProducts,
    @JsonKey(name: 'active_orders') int activeOrders,
    @JsonKey(name: 'pending_inbound') int pendingInbound,
    @JsonKey(name: 'pending_pick_tasks') int pendingPickTasks,
    @JsonKey(name: 'inventory_status_distribution')
    List<InventoryStatusStat> statusDistribution,
    @JsonKey(name: 'recent_alerts') List<RecentAlert> recentAlerts,
  });
}

/// @nodoc
class __$$DashboardStatsImplCopyWithImpl<$Res>
    extends _$DashboardStatsCopyWithImpl<$Res, _$DashboardStatsImpl>
    implements _$$DashboardStatsImplCopyWith<$Res> {
  __$$DashboardStatsImplCopyWithImpl(
    _$DashboardStatsImpl _value,
    $Res Function(_$DashboardStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalProducts = null,
    Object? activeOrders = null,
    Object? pendingInbound = null,
    Object? pendingPickTasks = null,
    Object? statusDistribution = null,
    Object? recentAlerts = null,
  }) {
    return _then(
      _$DashboardStatsImpl(
        totalProducts: null == totalProducts
            ? _value.totalProducts
            : totalProducts // ignore: cast_nullable_to_non_nullable
                  as int,
        activeOrders: null == activeOrders
            ? _value.activeOrders
            : activeOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingInbound: null == pendingInbound
            ? _value.pendingInbound
            : pendingInbound // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingPickTasks: null == pendingPickTasks
            ? _value.pendingPickTasks
            : pendingPickTasks // ignore: cast_nullable_to_non_nullable
                  as int,
        statusDistribution: null == statusDistribution
            ? _value._statusDistribution
            : statusDistribution // ignore: cast_nullable_to_non_nullable
                  as List<InventoryStatusStat>,
        recentAlerts: null == recentAlerts
            ? _value._recentAlerts
            : recentAlerts // ignore: cast_nullable_to_non_nullable
                  as List<RecentAlert>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardStatsImpl implements _DashboardStats {
  const _$DashboardStatsImpl({
    @JsonKey(name: 'total_products') required this.totalProducts,
    @JsonKey(name: 'active_orders') required this.activeOrders,
    @JsonKey(name: 'pending_inbound') required this.pendingInbound,
    @JsonKey(name: 'pending_pick_tasks') required this.pendingPickTasks,
    @JsonKey(name: 'inventory_status_distribution')
    required final List<InventoryStatusStat> statusDistribution,
    @JsonKey(name: 'recent_alerts')
    required final List<RecentAlert> recentAlerts,
  }) : _statusDistribution = statusDistribution,
       _recentAlerts = recentAlerts;

  factory _$DashboardStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_products')
  final int totalProducts;
  @override
  @JsonKey(name: 'active_orders')
  final int activeOrders;
  @override
  @JsonKey(name: 'pending_inbound')
  final int pendingInbound;
  @override
  @JsonKey(name: 'pending_pick_tasks')
  final int pendingPickTasks;
  final List<InventoryStatusStat> _statusDistribution;
  @override
  @JsonKey(name: 'inventory_status_distribution')
  List<InventoryStatusStat> get statusDistribution {
    if (_statusDistribution is EqualUnmodifiableListView)
      return _statusDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statusDistribution);
  }

  final List<RecentAlert> _recentAlerts;
  @override
  @JsonKey(name: 'recent_alerts')
  List<RecentAlert> get recentAlerts {
    if (_recentAlerts is EqualUnmodifiableListView) return _recentAlerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentAlerts);
  }

  @override
  String toString() {
    return 'DashboardStats(totalProducts: $totalProducts, activeOrders: $activeOrders, pendingInbound: $pendingInbound, pendingPickTasks: $pendingPickTasks, statusDistribution: $statusDistribution, recentAlerts: $recentAlerts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsImpl &&
            (identical(other.totalProducts, totalProducts) ||
                other.totalProducts == totalProducts) &&
            (identical(other.activeOrders, activeOrders) ||
                other.activeOrders == activeOrders) &&
            (identical(other.pendingInbound, pendingInbound) ||
                other.pendingInbound == pendingInbound) &&
            (identical(other.pendingPickTasks, pendingPickTasks) ||
                other.pendingPickTasks == pendingPickTasks) &&
            const DeepCollectionEquality().equals(
              other._statusDistribution,
              _statusDistribution,
            ) &&
            const DeepCollectionEquality().equals(
              other._recentAlerts,
              _recentAlerts,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalProducts,
    activeOrders,
    pendingInbound,
    pendingPickTasks,
    const DeepCollectionEquality().hash(_statusDistribution),
    const DeepCollectionEquality().hash(_recentAlerts),
  );

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      __$$DashboardStatsImplCopyWithImpl<_$DashboardStatsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardStatsImplToJson(this);
  }
}

abstract class _DashboardStats implements DashboardStats {
  const factory _DashboardStats({
    @JsonKey(name: 'total_products') required final int totalProducts,
    @JsonKey(name: 'active_orders') required final int activeOrders,
    @JsonKey(name: 'pending_inbound') required final int pendingInbound,
    @JsonKey(name: 'pending_pick_tasks') required final int pendingPickTasks,
    @JsonKey(name: 'inventory_status_distribution')
    required final List<InventoryStatusStat> statusDistribution,
    @JsonKey(name: 'recent_alerts')
    required final List<RecentAlert> recentAlerts,
  }) = _$DashboardStatsImpl;

  factory _DashboardStats.fromJson(Map<String, dynamic> json) =
      _$DashboardStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_products')
  int get totalProducts;
  @override
  @JsonKey(name: 'active_orders')
  int get activeOrders;
  @override
  @JsonKey(name: 'pending_inbound')
  int get pendingInbound;
  @override
  @JsonKey(name: 'pending_pick_tasks')
  int get pendingPickTasks;
  @override
  @JsonKey(name: 'inventory_status_distribution')
  List<InventoryStatusStat> get statusDistribution;
  @override
  @JsonKey(name: 'recent_alerts')
  List<RecentAlert> get recentAlerts;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryStatusStat _$InventoryStatusStatFromJson(Map<String, dynamic> json) {
  return _InventoryStatusStat.fromJson(json);
}

/// @nodoc
mixin _$InventoryStatusStat {
  String get status => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this InventoryStatusStat to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryStatusStat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryStatusStatCopyWith<InventoryStatusStat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryStatusStatCopyWith<$Res> {
  factory $InventoryStatusStatCopyWith(
    InventoryStatusStat value,
    $Res Function(InventoryStatusStat) then,
  ) = _$InventoryStatusStatCopyWithImpl<$Res, InventoryStatusStat>;
  @useResult
  $Res call({String status, int count});
}

/// @nodoc
class _$InventoryStatusStatCopyWithImpl<$Res, $Val extends InventoryStatusStat>
    implements $InventoryStatusStatCopyWith<$Res> {
  _$InventoryStatusStatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryStatusStat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InventoryStatusStatImplCopyWith<$Res>
    implements $InventoryStatusStatCopyWith<$Res> {
  factory _$$InventoryStatusStatImplCopyWith(
    _$InventoryStatusStatImpl value,
    $Res Function(_$InventoryStatusStatImpl) then,
  ) = __$$InventoryStatusStatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, int count});
}

/// @nodoc
class __$$InventoryStatusStatImplCopyWithImpl<$Res>
    extends _$InventoryStatusStatCopyWithImpl<$Res, _$InventoryStatusStatImpl>
    implements _$$InventoryStatusStatImplCopyWith<$Res> {
  __$$InventoryStatusStatImplCopyWithImpl(
    _$InventoryStatusStatImpl _value,
    $Res Function(_$InventoryStatusStatImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryStatusStat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null, Object? count = null}) {
    return _then(
      _$InventoryStatusStatImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryStatusStatImpl implements _InventoryStatusStat {
  const _$InventoryStatusStatImpl({required this.status, required this.count});

  factory _$InventoryStatusStatImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryStatusStatImplFromJson(json);

  @override
  final String status;
  @override
  final int count;

  @override
  String toString() {
    return 'InventoryStatusStat(status: $status, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryStatusStatImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, count);

  /// Create a copy of InventoryStatusStat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryStatusStatImplCopyWith<_$InventoryStatusStatImpl> get copyWith =>
      __$$InventoryStatusStatImplCopyWithImpl<_$InventoryStatusStatImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryStatusStatImplToJson(this);
  }
}

abstract class _InventoryStatusStat implements InventoryStatusStat {
  const factory _InventoryStatusStat({
    required final String status,
    required final int count,
  }) = _$InventoryStatusStatImpl;

  factory _InventoryStatusStat.fromJson(Map<String, dynamic> json) =
      _$InventoryStatusStatImpl.fromJson;

  @override
  String get status;
  @override
  int get count;

  /// Create a copy of InventoryStatusStat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryStatusStatImplCopyWith<_$InventoryStatusStatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecentAlert _$RecentAlertFromJson(Map<String, dynamic> json) {
  return _RecentAlert.fromJson(json);
}

/// @nodoc
mixin _$RecentAlert {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_type')
  String get eventType => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RecentAlert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecentAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentAlertCopyWith<RecentAlert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentAlertCopyWith<$Res> {
  factory $RecentAlertCopyWith(
    RecentAlert value,
    $Res Function(RecentAlert) then,
  ) = _$RecentAlertCopyWithImpl<$Res, RecentAlert>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'event_type') String eventType,
    String message,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class _$RecentAlertCopyWithImpl<$Res, $Val extends RecentAlert>
    implements $RecentAlertCopyWith<$Res> {
  _$RecentAlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventType = null,
    Object? message = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            eventType: null == eventType
                ? _value.eventType
                : eventType // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecentAlertImplCopyWith<$Res>
    implements $RecentAlertCopyWith<$Res> {
  factory _$$RecentAlertImplCopyWith(
    _$RecentAlertImpl value,
    $Res Function(_$RecentAlertImpl) then,
  ) = __$$RecentAlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'event_type') String eventType,
    String message,
    @JsonKey(name: 'created_at') DateTime createdAt,
  });
}

/// @nodoc
class __$$RecentAlertImplCopyWithImpl<$Res>
    extends _$RecentAlertCopyWithImpl<$Res, _$RecentAlertImpl>
    implements _$$RecentAlertImplCopyWith<$Res> {
  __$$RecentAlertImplCopyWithImpl(
    _$RecentAlertImpl _value,
    $Res Function(_$RecentAlertImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecentAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventType = null,
    Object? message = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$RecentAlertImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        eventType: null == eventType
            ? _value.eventType
            : eventType // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentAlertImpl implements _RecentAlert {
  const _$RecentAlertImpl({
    required this.id,
    @JsonKey(name: 'event_type') required this.eventType,
    required this.message,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$RecentAlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentAlertImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'event_type')
  final String eventType;
  @override
  final String message;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'RecentAlert(id: $id, eventType: $eventType, message: $message, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentAlertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, eventType, message, createdAt);

  /// Create a copy of RecentAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentAlertImplCopyWith<_$RecentAlertImpl> get copyWith =>
      __$$RecentAlertImplCopyWithImpl<_$RecentAlertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentAlertImplToJson(this);
  }
}

abstract class _RecentAlert implements RecentAlert {
  const factory _RecentAlert({
    required final String id,
    @JsonKey(name: 'event_type') required final String eventType,
    required final String message,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
  }) = _$RecentAlertImpl;

  factory _RecentAlert.fromJson(Map<String, dynamic> json) =
      _$RecentAlertImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'event_type')
  String get eventType;
  @override
  String get message;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of RecentAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentAlertImplCopyWith<_$RecentAlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
