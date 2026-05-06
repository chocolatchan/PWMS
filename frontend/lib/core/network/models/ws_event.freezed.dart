// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ws_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
WsEvent _$WsEventFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'recallAlert':
          return RecallAlertEvent.fromJson(
            json
          );
                case 'qcReleased':
          return QcReleasedEvent.fromJson(
            json
          );
                case 'inventoryUpdated':
          return InventoryUpdatedEvent.fromJson(
            json
          );
        
          default:
            return UnknownEvent.fromJson(
  json
);
        }
      
}

/// @nodoc
mixin _$WsEvent {



  /// Serializes this WsEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WsEvent);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WsEvent()';
}


}

/// @nodoc
class $WsEventCopyWith<$Res>  {
$WsEventCopyWith(WsEvent _, $Res Function(WsEvent) __);
}


/// Adds pattern-matching-related methods to [WsEvent].
extension WsEventPatterns on WsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RecallAlertEvent value)?  recallAlert,TResult Function( QcReleasedEvent value)?  qcReleased,TResult Function( InventoryUpdatedEvent value)?  inventoryUpdated,TResult Function( UnknownEvent value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RecallAlertEvent() when recallAlert != null:
return recallAlert(_that);case QcReleasedEvent() when qcReleased != null:
return qcReleased(_that);case InventoryUpdatedEvent() when inventoryUpdated != null:
return inventoryUpdated(_that);case UnknownEvent() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RecallAlertEvent value)  recallAlert,required TResult Function( QcReleasedEvent value)  qcReleased,required TResult Function( InventoryUpdatedEvent value)  inventoryUpdated,required TResult Function( UnknownEvent value)  unknown,}){
final _that = this;
switch (_that) {
case RecallAlertEvent():
return recallAlert(_that);case QcReleasedEvent():
return qcReleased(_that);case InventoryUpdatedEvent():
return inventoryUpdated(_that);case UnknownEvent():
return unknown(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RecallAlertEvent value)?  recallAlert,TResult? Function( QcReleasedEvent value)?  qcReleased,TResult? Function( InventoryUpdatedEvent value)?  inventoryUpdated,TResult? Function( UnknownEvent value)?  unknown,}){
final _that = this;
switch (_that) {
case RecallAlertEvent() when recallAlert != null:
return recallAlert(_that);case QcReleasedEvent() when qcReleased != null:
return qcReleased(_that);case InventoryUpdatedEvent() when inventoryUpdated != null:
return inventoryUpdated(_that);case UnknownEvent() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String batchId,  String reason,  String severity)?  recallAlert,TResult Function( String batchId,  String approvedBy)?  qcReleased,TResult Function( String locationCode)?  inventoryUpdated,TResult Function()?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RecallAlertEvent() when recallAlert != null:
return recallAlert(_that.batchId,_that.reason,_that.severity);case QcReleasedEvent() when qcReleased != null:
return qcReleased(_that.batchId,_that.approvedBy);case InventoryUpdatedEvent() when inventoryUpdated != null:
return inventoryUpdated(_that.locationCode);case UnknownEvent() when unknown != null:
return unknown();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String batchId,  String reason,  String severity)  recallAlert,required TResult Function( String batchId,  String approvedBy)  qcReleased,required TResult Function( String locationCode)  inventoryUpdated,required TResult Function()  unknown,}) {final _that = this;
switch (_that) {
case RecallAlertEvent():
return recallAlert(_that.batchId,_that.reason,_that.severity);case QcReleasedEvent():
return qcReleased(_that.batchId,_that.approvedBy);case InventoryUpdatedEvent():
return inventoryUpdated(_that.locationCode);case UnknownEvent():
return unknown();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String batchId,  String reason,  String severity)?  recallAlert,TResult? Function( String batchId,  String approvedBy)?  qcReleased,TResult? Function( String locationCode)?  inventoryUpdated,TResult? Function()?  unknown,}) {final _that = this;
switch (_that) {
case RecallAlertEvent() when recallAlert != null:
return recallAlert(_that.batchId,_that.reason,_that.severity);case QcReleasedEvent() when qcReleased != null:
return qcReleased(_that.batchId,_that.approvedBy);case InventoryUpdatedEvent() when inventoryUpdated != null:
return inventoryUpdated(_that.locationCode);case UnknownEvent() when unknown != null:
return unknown();case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class RecallAlertEvent implements WsEvent {
  const RecallAlertEvent({required this.batchId, required this.reason, required this.severity, final  String? $type}): $type = $type ?? 'recallAlert';
  factory RecallAlertEvent.fromJson(Map<String, dynamic> json) => _$RecallAlertEventFromJson(json);

 final  String batchId;
 final  String reason;
 final  String severity;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of WsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecallAlertEventCopyWith<RecallAlertEvent> get copyWith => _$RecallAlertEventCopyWithImpl<RecallAlertEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecallAlertEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecallAlertEvent&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.severity, severity) || other.severity == severity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,batchId,reason,severity);

@override
String toString() {
  return 'WsEvent.recallAlert(batchId: $batchId, reason: $reason, severity: $severity)';
}


}

/// @nodoc
abstract mixin class $RecallAlertEventCopyWith<$Res> implements $WsEventCopyWith<$Res> {
  factory $RecallAlertEventCopyWith(RecallAlertEvent value, $Res Function(RecallAlertEvent) _then) = _$RecallAlertEventCopyWithImpl;
@useResult
$Res call({
 String batchId, String reason, String severity
});




}
/// @nodoc
class _$RecallAlertEventCopyWithImpl<$Res>
    implements $RecallAlertEventCopyWith<$Res> {
  _$RecallAlertEventCopyWithImpl(this._self, this._then);

  final RecallAlertEvent _self;
  final $Res Function(RecallAlertEvent) _then;

/// Create a copy of WsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? batchId = null,Object? reason = null,Object? severity = null,}) {
  return _then(RecallAlertEvent(
batchId: null == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class QcReleasedEvent implements WsEvent {
  const QcReleasedEvent({required this.batchId, required this.approvedBy, final  String? $type}): $type = $type ?? 'qcReleased';
  factory QcReleasedEvent.fromJson(Map<String, dynamic> json) => _$QcReleasedEventFromJson(json);

 final  String batchId;
 final  String approvedBy;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of WsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QcReleasedEventCopyWith<QcReleasedEvent> get copyWith => _$QcReleasedEventCopyWithImpl<QcReleasedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QcReleasedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QcReleasedEvent&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,batchId,approvedBy);

@override
String toString() {
  return 'WsEvent.qcReleased(batchId: $batchId, approvedBy: $approvedBy)';
}


}

/// @nodoc
abstract mixin class $QcReleasedEventCopyWith<$Res> implements $WsEventCopyWith<$Res> {
  factory $QcReleasedEventCopyWith(QcReleasedEvent value, $Res Function(QcReleasedEvent) _then) = _$QcReleasedEventCopyWithImpl;
@useResult
$Res call({
 String batchId, String approvedBy
});




}
/// @nodoc
class _$QcReleasedEventCopyWithImpl<$Res>
    implements $QcReleasedEventCopyWith<$Res> {
  _$QcReleasedEventCopyWithImpl(this._self, this._then);

  final QcReleasedEvent _self;
  final $Res Function(QcReleasedEvent) _then;

/// Create a copy of WsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? batchId = null,Object? approvedBy = null,}) {
  return _then(QcReleasedEvent(
batchId: null == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String,approvedBy: null == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class InventoryUpdatedEvent implements WsEvent {
  const InventoryUpdatedEvent({required this.locationCode, final  String? $type}): $type = $type ?? 'inventoryUpdated';
  factory InventoryUpdatedEvent.fromJson(Map<String, dynamic> json) => _$InventoryUpdatedEventFromJson(json);

 final  String locationCode;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of WsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryUpdatedEventCopyWith<InventoryUpdatedEvent> get copyWith => _$InventoryUpdatedEventCopyWithImpl<InventoryUpdatedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryUpdatedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryUpdatedEvent&&(identical(other.locationCode, locationCode) || other.locationCode == locationCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,locationCode);

@override
String toString() {
  return 'WsEvent.inventoryUpdated(locationCode: $locationCode)';
}


}

/// @nodoc
abstract mixin class $InventoryUpdatedEventCopyWith<$Res> implements $WsEventCopyWith<$Res> {
  factory $InventoryUpdatedEventCopyWith(InventoryUpdatedEvent value, $Res Function(InventoryUpdatedEvent) _then) = _$InventoryUpdatedEventCopyWithImpl;
@useResult
$Res call({
 String locationCode
});




}
/// @nodoc
class _$InventoryUpdatedEventCopyWithImpl<$Res>
    implements $InventoryUpdatedEventCopyWith<$Res> {
  _$InventoryUpdatedEventCopyWithImpl(this._self, this._then);

  final InventoryUpdatedEvent _self;
  final $Res Function(InventoryUpdatedEvent) _then;

/// Create a copy of WsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? locationCode = null,}) {
  return _then(InventoryUpdatedEvent(
locationCode: null == locationCode ? _self.locationCode : locationCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class UnknownEvent implements WsEvent {
  const UnknownEvent({final  String? $type}): $type = $type ?? 'unknown';
  factory UnknownEvent.fromJson(Map<String, dynamic> json) => _$UnknownEventFromJson(json);



@JsonKey(name: 'type')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$UnknownEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownEvent);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WsEvent.unknown()';
}


}




// dart format on
