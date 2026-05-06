// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KpiMetrics {

 int get ordersPendingPick; int get itemsInQuarantine; String get dispatchRate; int get criticalAlerts;
/// Create a copy of KpiMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KpiMetricsCopyWith<KpiMetrics> get copyWith => _$KpiMetricsCopyWithImpl<KpiMetrics>(this as KpiMetrics, _$identity);

  /// Serializes this KpiMetrics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KpiMetrics&&(identical(other.ordersPendingPick, ordersPendingPick) || other.ordersPendingPick == ordersPendingPick)&&(identical(other.itemsInQuarantine, itemsInQuarantine) || other.itemsInQuarantine == itemsInQuarantine)&&(identical(other.dispatchRate, dispatchRate) || other.dispatchRate == dispatchRate)&&(identical(other.criticalAlerts, criticalAlerts) || other.criticalAlerts == criticalAlerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ordersPendingPick,itemsInQuarantine,dispatchRate,criticalAlerts);

@override
String toString() {
  return 'KpiMetrics(ordersPendingPick: $ordersPendingPick, itemsInQuarantine: $itemsInQuarantine, dispatchRate: $dispatchRate, criticalAlerts: $criticalAlerts)';
}


}

/// @nodoc
abstract mixin class $KpiMetricsCopyWith<$Res>  {
  factory $KpiMetricsCopyWith(KpiMetrics value, $Res Function(KpiMetrics) _then) = _$KpiMetricsCopyWithImpl;
@useResult
$Res call({
 int ordersPendingPick, int itemsInQuarantine, String dispatchRate, int criticalAlerts
});




}
/// @nodoc
class _$KpiMetricsCopyWithImpl<$Res>
    implements $KpiMetricsCopyWith<$Res> {
  _$KpiMetricsCopyWithImpl(this._self, this._then);

  final KpiMetrics _self;
  final $Res Function(KpiMetrics) _then;

/// Create a copy of KpiMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ordersPendingPick = null,Object? itemsInQuarantine = null,Object? dispatchRate = null,Object? criticalAlerts = null,}) {
  return _then(_self.copyWith(
ordersPendingPick: null == ordersPendingPick ? _self.ordersPendingPick : ordersPendingPick // ignore: cast_nullable_to_non_nullable
as int,itemsInQuarantine: null == itemsInQuarantine ? _self.itemsInQuarantine : itemsInQuarantine // ignore: cast_nullable_to_non_nullable
as int,dispatchRate: null == dispatchRate ? _self.dispatchRate : dispatchRate // ignore: cast_nullable_to_non_nullable
as String,criticalAlerts: null == criticalAlerts ? _self.criticalAlerts : criticalAlerts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [KpiMetrics].
extension KpiMetricsPatterns on KpiMetrics {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KpiMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KpiMetrics() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KpiMetrics value)  $default,){
final _that = this;
switch (_that) {
case _KpiMetrics():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KpiMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _KpiMetrics() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int ordersPendingPick,  int itemsInQuarantine,  String dispatchRate,  int criticalAlerts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KpiMetrics() when $default != null:
return $default(_that.ordersPendingPick,_that.itemsInQuarantine,_that.dispatchRate,_that.criticalAlerts);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int ordersPendingPick,  int itemsInQuarantine,  String dispatchRate,  int criticalAlerts)  $default,) {final _that = this;
switch (_that) {
case _KpiMetrics():
return $default(_that.ordersPendingPick,_that.itemsInQuarantine,_that.dispatchRate,_that.criticalAlerts);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int ordersPendingPick,  int itemsInQuarantine,  String dispatchRate,  int criticalAlerts)?  $default,) {final _that = this;
switch (_that) {
case _KpiMetrics() when $default != null:
return $default(_that.ordersPendingPick,_that.itemsInQuarantine,_that.dispatchRate,_that.criticalAlerts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KpiMetrics implements KpiMetrics {
  const _KpiMetrics({required this.ordersPendingPick, required this.itemsInQuarantine, required this.dispatchRate, required this.criticalAlerts});
  factory _KpiMetrics.fromJson(Map<String, dynamic> json) => _$KpiMetricsFromJson(json);

@override final  int ordersPendingPick;
@override final  int itemsInQuarantine;
@override final  String dispatchRate;
@override final  int criticalAlerts;

/// Create a copy of KpiMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KpiMetricsCopyWith<_KpiMetrics> get copyWith => __$KpiMetricsCopyWithImpl<_KpiMetrics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KpiMetricsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KpiMetrics&&(identical(other.ordersPendingPick, ordersPendingPick) || other.ordersPendingPick == ordersPendingPick)&&(identical(other.itemsInQuarantine, itemsInQuarantine) || other.itemsInQuarantine == itemsInQuarantine)&&(identical(other.dispatchRate, dispatchRate) || other.dispatchRate == dispatchRate)&&(identical(other.criticalAlerts, criticalAlerts) || other.criticalAlerts == criticalAlerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ordersPendingPick,itemsInQuarantine,dispatchRate,criticalAlerts);

@override
String toString() {
  return 'KpiMetrics(ordersPendingPick: $ordersPendingPick, itemsInQuarantine: $itemsInQuarantine, dispatchRate: $dispatchRate, criticalAlerts: $criticalAlerts)';
}


}

/// @nodoc
abstract mixin class _$KpiMetricsCopyWith<$Res> implements $KpiMetricsCopyWith<$Res> {
  factory _$KpiMetricsCopyWith(_KpiMetrics value, $Res Function(_KpiMetrics) _then) = __$KpiMetricsCopyWithImpl;
@override @useResult
$Res call({
 int ordersPendingPick, int itemsInQuarantine, String dispatchRate, int criticalAlerts
});




}
/// @nodoc
class __$KpiMetricsCopyWithImpl<$Res>
    implements _$KpiMetricsCopyWith<$Res> {
  __$KpiMetricsCopyWithImpl(this._self, this._then);

  final _KpiMetrics _self;
  final $Res Function(_KpiMetrics) _then;

/// Create a copy of KpiMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ordersPendingPick = null,Object? itemsInQuarantine = null,Object? dispatchRate = null,Object? criticalAlerts = null,}) {
  return _then(_KpiMetrics(
ordersPendingPick: null == ordersPendingPick ? _self.ordersPendingPick : ordersPendingPick // ignore: cast_nullable_to_non_nullable
as int,itemsInQuarantine: null == itemsInQuarantine ? _self.itemsInQuarantine : itemsInQuarantine // ignore: cast_nullable_to_non_nullable
as int,dispatchRate: null == dispatchRate ? _self.dispatchRate : dispatchRate // ignore: cast_nullable_to_non_nullable
as String,criticalAlerts: null == criticalAlerts ? _self.criticalAlerts : criticalAlerts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AuditLogEvent {

 String get id; String get timestamp; String get actionName; String get userResponsible; String get details; bool get isSuccess;
/// Create a copy of AuditLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditLogEventCopyWith<AuditLogEvent> get copyWith => _$AuditLogEventCopyWithImpl<AuditLogEvent>(this as AuditLogEvent, _$identity);

  /// Serializes this AuditLogEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditLogEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.actionName, actionName) || other.actionName == actionName)&&(identical(other.userResponsible, userResponsible) || other.userResponsible == userResponsible)&&(identical(other.details, details) || other.details == details)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timestamp,actionName,userResponsible,details,isSuccess);

@override
String toString() {
  return 'AuditLogEvent(id: $id, timestamp: $timestamp, actionName: $actionName, userResponsible: $userResponsible, details: $details, isSuccess: $isSuccess)';
}


}

/// @nodoc
abstract mixin class $AuditLogEventCopyWith<$Res>  {
  factory $AuditLogEventCopyWith(AuditLogEvent value, $Res Function(AuditLogEvent) _then) = _$AuditLogEventCopyWithImpl;
@useResult
$Res call({
 String id, String timestamp, String actionName, String userResponsible, String details, bool isSuccess
});




}
/// @nodoc
class _$AuditLogEventCopyWithImpl<$Res>
    implements $AuditLogEventCopyWith<$Res> {
  _$AuditLogEventCopyWithImpl(this._self, this._then);

  final AuditLogEvent _self;
  final $Res Function(AuditLogEvent) _then;

/// Create a copy of AuditLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? timestamp = null,Object? actionName = null,Object? userResponsible = null,Object? details = null,Object? isSuccess = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,actionName: null == actionName ? _self.actionName : actionName // ignore: cast_nullable_to_non_nullable
as String,userResponsible: null == userResponsible ? _self.userResponsible : userResponsible // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditLogEvent].
extension AuditLogEventPatterns on AuditLogEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditLogEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditLogEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditLogEvent value)  $default,){
final _that = this;
switch (_that) {
case _AuditLogEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditLogEvent value)?  $default,){
final _that = this;
switch (_that) {
case _AuditLogEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String timestamp,  String actionName,  String userResponsible,  String details,  bool isSuccess)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditLogEvent() when $default != null:
return $default(_that.id,_that.timestamp,_that.actionName,_that.userResponsible,_that.details,_that.isSuccess);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String timestamp,  String actionName,  String userResponsible,  String details,  bool isSuccess)  $default,) {final _that = this;
switch (_that) {
case _AuditLogEvent():
return $default(_that.id,_that.timestamp,_that.actionName,_that.userResponsible,_that.details,_that.isSuccess);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String timestamp,  String actionName,  String userResponsible,  String details,  bool isSuccess)?  $default,) {final _that = this;
switch (_that) {
case _AuditLogEvent() when $default != null:
return $default(_that.id,_that.timestamp,_that.actionName,_that.userResponsible,_that.details,_that.isSuccess);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditLogEvent implements AuditLogEvent {
  const _AuditLogEvent({required this.id, required this.timestamp, required this.actionName, required this.userResponsible, required this.details, required this.isSuccess});
  factory _AuditLogEvent.fromJson(Map<String, dynamic> json) => _$AuditLogEventFromJson(json);

@override final  String id;
@override final  String timestamp;
@override final  String actionName;
@override final  String userResponsible;
@override final  String details;
@override final  bool isSuccess;

/// Create a copy of AuditLogEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditLogEventCopyWith<_AuditLogEvent> get copyWith => __$AuditLogEventCopyWithImpl<_AuditLogEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditLogEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditLogEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.actionName, actionName) || other.actionName == actionName)&&(identical(other.userResponsible, userResponsible) || other.userResponsible == userResponsible)&&(identical(other.details, details) || other.details == details)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timestamp,actionName,userResponsible,details,isSuccess);

@override
String toString() {
  return 'AuditLogEvent(id: $id, timestamp: $timestamp, actionName: $actionName, userResponsible: $userResponsible, details: $details, isSuccess: $isSuccess)';
}


}

/// @nodoc
abstract mixin class _$AuditLogEventCopyWith<$Res> implements $AuditLogEventCopyWith<$Res> {
  factory _$AuditLogEventCopyWith(_AuditLogEvent value, $Res Function(_AuditLogEvent) _then) = __$AuditLogEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String timestamp, String actionName, String userResponsible, String details, bool isSuccess
});




}
/// @nodoc
class __$AuditLogEventCopyWithImpl<$Res>
    implements _$AuditLogEventCopyWith<$Res> {
  __$AuditLogEventCopyWithImpl(this._self, this._then);

  final _AuditLogEvent _self;
  final $Res Function(_AuditLogEvent) _then;

/// Create a copy of AuditLogEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? timestamp = null,Object? actionName = null,Object? userResponsible = null,Object? details = null,Object? isSuccess = null,}) {
  return _then(_AuditLogEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,actionName: null == actionName ? _self.actionName : actionName // ignore: cast_nullable_to_non_nullable
as String,userResponsible: null == userResponsible ? _self.userResponsible : userResponsible // ignore: cast_nullable_to_non_nullable
as String,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AdminState {

 KpiMetrics get metrics; List<AuditLogEvent> get searchResult; bool get isSearching;
/// Create a copy of AdminState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminStateCopyWith<AdminState> get copyWith => _$AdminStateCopyWithImpl<AdminState>(this as AdminState, _$identity);

  /// Serializes this AdminState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminState&&(identical(other.metrics, metrics) || other.metrics == metrics)&&const DeepCollectionEquality().equals(other.searchResult, searchResult)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metrics,const DeepCollectionEquality().hash(searchResult),isSearching);

@override
String toString() {
  return 'AdminState(metrics: $metrics, searchResult: $searchResult, isSearching: $isSearching)';
}


}

/// @nodoc
abstract mixin class $AdminStateCopyWith<$Res>  {
  factory $AdminStateCopyWith(AdminState value, $Res Function(AdminState) _then) = _$AdminStateCopyWithImpl;
@useResult
$Res call({
 KpiMetrics metrics, List<AuditLogEvent> searchResult, bool isSearching
});


$KpiMetricsCopyWith<$Res> get metrics;

}
/// @nodoc
class _$AdminStateCopyWithImpl<$Res>
    implements $AdminStateCopyWith<$Res> {
  _$AdminStateCopyWithImpl(this._self, this._then);

  final AdminState _self;
  final $Res Function(AdminState) _then;

/// Create a copy of AdminState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? metrics = null,Object? searchResult = null,Object? isSearching = null,}) {
  return _then(_self.copyWith(
metrics: null == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as KpiMetrics,searchResult: null == searchResult ? _self.searchResult : searchResult // ignore: cast_nullable_to_non_nullable
as List<AuditLogEvent>,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AdminState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KpiMetricsCopyWith<$Res> get metrics {
  
  return $KpiMetricsCopyWith<$Res>(_self.metrics, (value) {
    return _then(_self.copyWith(metrics: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminState].
extension AdminStatePatterns on AdminState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminState value)  $default,){
final _that = this;
switch (_that) {
case _AdminState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminState value)?  $default,){
final _that = this;
switch (_that) {
case _AdminState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( KpiMetrics metrics,  List<AuditLogEvent> searchResult,  bool isSearching)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminState() when $default != null:
return $default(_that.metrics,_that.searchResult,_that.isSearching);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( KpiMetrics metrics,  List<AuditLogEvent> searchResult,  bool isSearching)  $default,) {final _that = this;
switch (_that) {
case _AdminState():
return $default(_that.metrics,_that.searchResult,_that.isSearching);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( KpiMetrics metrics,  List<AuditLogEvent> searchResult,  bool isSearching)?  $default,) {final _that = this;
switch (_that) {
case _AdminState() when $default != null:
return $default(_that.metrics,_that.searchResult,_that.isSearching);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminState implements AdminState {
  const _AdminState({required this.metrics, final  List<AuditLogEvent> searchResult = const [], this.isSearching = false}): _searchResult = searchResult;
  factory _AdminState.fromJson(Map<String, dynamic> json) => _$AdminStateFromJson(json);

@override final  KpiMetrics metrics;
 final  List<AuditLogEvent> _searchResult;
@override@JsonKey() List<AuditLogEvent> get searchResult {
  if (_searchResult is EqualUnmodifiableListView) return _searchResult;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchResult);
}

@override@JsonKey() final  bool isSearching;

/// Create a copy of AdminState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminStateCopyWith<_AdminState> get copyWith => __$AdminStateCopyWithImpl<_AdminState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminState&&(identical(other.metrics, metrics) || other.metrics == metrics)&&const DeepCollectionEquality().equals(other._searchResult, _searchResult)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metrics,const DeepCollectionEquality().hash(_searchResult),isSearching);

@override
String toString() {
  return 'AdminState(metrics: $metrics, searchResult: $searchResult, isSearching: $isSearching)';
}


}

/// @nodoc
abstract mixin class _$AdminStateCopyWith<$Res> implements $AdminStateCopyWith<$Res> {
  factory _$AdminStateCopyWith(_AdminState value, $Res Function(_AdminState) _then) = __$AdminStateCopyWithImpl;
@override @useResult
$Res call({
 KpiMetrics metrics, List<AuditLogEvent> searchResult, bool isSearching
});


@override $KpiMetricsCopyWith<$Res> get metrics;

}
/// @nodoc
class __$AdminStateCopyWithImpl<$Res>
    implements _$AdminStateCopyWith<$Res> {
  __$AdminStateCopyWithImpl(this._self, this._then);

  final _AdminState _self;
  final $Res Function(_AdminState) _then;

/// Create a copy of AdminState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? metrics = null,Object? searchResult = null,Object? isSearching = null,}) {
  return _then(_AdminState(
metrics: null == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as KpiMetrics,searchResult: null == searchResult ? _self._searchResult : searchResult // ignore: cast_nullable_to_non_nullable
as List<AuditLogEvent>,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AdminState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$KpiMetricsCopyWith<$Res> get metrics {
  
  return $KpiMetricsCopyWith<$Res>(_self.metrics, (value) {
    return _then(_self.copyWith(metrics: value));
  });
}
}

// dart format on
