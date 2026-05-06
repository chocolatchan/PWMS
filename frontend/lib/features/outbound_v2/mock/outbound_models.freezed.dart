// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outbound_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OutboundTote {

 String get toteId; bool get isArrived;
/// Create a copy of OutboundTote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutboundToteCopyWith<OutboundTote> get copyWith => _$OutboundToteCopyWithImpl<OutboundTote>(this as OutboundTote, _$identity);

  /// Serializes this OutboundTote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutboundTote&&(identical(other.toteId, toteId) || other.toteId == toteId)&&(identical(other.isArrived, isArrived) || other.isArrived == isArrived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,toteId,isArrived);

@override
String toString() {
  return 'OutboundTote(toteId: $toteId, isArrived: $isArrived)';
}


}

/// @nodoc
abstract mixin class $OutboundToteCopyWith<$Res>  {
  factory $OutboundToteCopyWith(OutboundTote value, $Res Function(OutboundTote) _then) = _$OutboundToteCopyWithImpl;
@useResult
$Res call({
 String toteId, bool isArrived
});




}
/// @nodoc
class _$OutboundToteCopyWithImpl<$Res>
    implements $OutboundToteCopyWith<$Res> {
  _$OutboundToteCopyWithImpl(this._self, this._then);

  final OutboundTote _self;
  final $Res Function(OutboundTote) _then;

/// Create a copy of OutboundTote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? toteId = null,Object? isArrived = null,}) {
  return _then(_self.copyWith(
toteId: null == toteId ? _self.toteId : toteId // ignore: cast_nullable_to_non_nullable
as String,isArrived: null == isArrived ? _self.isArrived : isArrived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OutboundTote].
extension OutboundTotePatterns on OutboundTote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutboundTote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutboundTote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutboundTote value)  $default,){
final _that = this;
switch (_that) {
case _OutboundTote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutboundTote value)?  $default,){
final _that = this;
switch (_that) {
case _OutboundTote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String toteId,  bool isArrived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OutboundTote() when $default != null:
return $default(_that.toteId,_that.isArrived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String toteId,  bool isArrived)  $default,) {final _that = this;
switch (_that) {
case _OutboundTote():
return $default(_that.toteId,_that.isArrived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String toteId,  bool isArrived)?  $default,) {final _that = this;
switch (_that) {
case _OutboundTote() when $default != null:
return $default(_that.toteId,_that.isArrived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OutboundTote implements OutboundTote {
  const _OutboundTote({required this.toteId, this.isArrived = false});
  factory _OutboundTote.fromJson(Map<String, dynamic> json) => _$OutboundToteFromJson(json);

@override final  String toteId;
@override@JsonKey() final  bool isArrived;

/// Create a copy of OutboundTote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutboundToteCopyWith<_OutboundTote> get copyWith => __$OutboundToteCopyWithImpl<_OutboundTote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OutboundToteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutboundTote&&(identical(other.toteId, toteId) || other.toteId == toteId)&&(identical(other.isArrived, isArrived) || other.isArrived == isArrived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,toteId,isArrived);

@override
String toString() {
  return 'OutboundTote(toteId: $toteId, isArrived: $isArrived)';
}


}

/// @nodoc
abstract mixin class _$OutboundToteCopyWith<$Res> implements $OutboundToteCopyWith<$Res> {
  factory _$OutboundToteCopyWith(_OutboundTote value, $Res Function(_OutboundTote) _then) = __$OutboundToteCopyWithImpl;
@override @useResult
$Res call({
 String toteId, bool isArrived
});




}
/// @nodoc
class __$OutboundToteCopyWithImpl<$Res>
    implements _$OutboundToteCopyWith<$Res> {
  __$OutboundToteCopyWithImpl(this._self, this._then);

  final _OutboundTote _self;
  final $Res Function(_OutboundTote) _then;

/// Create a copy of OutboundTote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? toteId = null,Object? isArrived = null,}) {
  return _then(_OutboundTote(
toteId: null == toteId ? _self.toteId : toteId // ignore: cast_nullable_to_non_nullable
as String,isArrived: null == isArrived ? _self.isArrived : isArrived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$SalesOrder {

 String get soId; List<OutboundTote> get requiredTotes; OrderStatus get status; String? get sealCode; bool get isColdChain; double? get dispatchTemp;
/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalesOrderCopyWith<SalesOrder> get copyWith => _$SalesOrderCopyWithImpl<SalesOrder>(this as SalesOrder, _$identity);

  /// Serializes this SalesOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalesOrder&&(identical(other.soId, soId) || other.soId == soId)&&const DeepCollectionEquality().equals(other.requiredTotes, requiredTotes)&&(identical(other.status, status) || other.status == status)&&(identical(other.sealCode, sealCode) || other.sealCode == sealCode)&&(identical(other.isColdChain, isColdChain) || other.isColdChain == isColdChain)&&(identical(other.dispatchTemp, dispatchTemp) || other.dispatchTemp == dispatchTemp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,soId,const DeepCollectionEquality().hash(requiredTotes),status,sealCode,isColdChain,dispatchTemp);

@override
String toString() {
  return 'SalesOrder(soId: $soId, requiredTotes: $requiredTotes, status: $status, sealCode: $sealCode, isColdChain: $isColdChain, dispatchTemp: $dispatchTemp)';
}


}

/// @nodoc
abstract mixin class $SalesOrderCopyWith<$Res>  {
  factory $SalesOrderCopyWith(SalesOrder value, $Res Function(SalesOrder) _then) = _$SalesOrderCopyWithImpl;
@useResult
$Res call({
 String soId, List<OutboundTote> requiredTotes, OrderStatus status, String? sealCode, bool isColdChain, double? dispatchTemp
});




}
/// @nodoc
class _$SalesOrderCopyWithImpl<$Res>
    implements $SalesOrderCopyWith<$Res> {
  _$SalesOrderCopyWithImpl(this._self, this._then);

  final SalesOrder _self;
  final $Res Function(SalesOrder) _then;

/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? soId = null,Object? requiredTotes = null,Object? status = null,Object? sealCode = freezed,Object? isColdChain = null,Object? dispatchTemp = freezed,}) {
  return _then(_self.copyWith(
soId: null == soId ? _self.soId : soId // ignore: cast_nullable_to_non_nullable
as String,requiredTotes: null == requiredTotes ? _self.requiredTotes : requiredTotes // ignore: cast_nullable_to_non_nullable
as List<OutboundTote>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,sealCode: freezed == sealCode ? _self.sealCode : sealCode // ignore: cast_nullable_to_non_nullable
as String?,isColdChain: null == isColdChain ? _self.isColdChain : isColdChain // ignore: cast_nullable_to_non_nullable
as bool,dispatchTemp: freezed == dispatchTemp ? _self.dispatchTemp : dispatchTemp // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [SalesOrder].
extension SalesOrderPatterns on SalesOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalesOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalesOrder value)  $default,){
final _that = this;
switch (_that) {
case _SalesOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalesOrder value)?  $default,){
final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String soId,  List<OutboundTote> requiredTotes,  OrderStatus status,  String? sealCode,  bool isColdChain,  double? dispatchTemp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
return $default(_that.soId,_that.requiredTotes,_that.status,_that.sealCode,_that.isColdChain,_that.dispatchTemp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String soId,  List<OutboundTote> requiredTotes,  OrderStatus status,  String? sealCode,  bool isColdChain,  double? dispatchTemp)  $default,) {final _that = this;
switch (_that) {
case _SalesOrder():
return $default(_that.soId,_that.requiredTotes,_that.status,_that.sealCode,_that.isColdChain,_that.dispatchTemp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String soId,  List<OutboundTote> requiredTotes,  OrderStatus status,  String? sealCode,  bool isColdChain,  double? dispatchTemp)?  $default,) {final _that = this;
switch (_that) {
case _SalesOrder() when $default != null:
return $default(_that.soId,_that.requiredTotes,_that.status,_that.sealCode,_that.isColdChain,_that.dispatchTemp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SalesOrder implements SalesOrder {
  const _SalesOrder({required this.soId, required final  List<OutboundTote> requiredTotes, this.status = OrderStatus.picked, this.sealCode, this.isColdChain = false, this.dispatchTemp}): _requiredTotes = requiredTotes;
  factory _SalesOrder.fromJson(Map<String, dynamic> json) => _$SalesOrderFromJson(json);

@override final  String soId;
 final  List<OutboundTote> _requiredTotes;
@override List<OutboundTote> get requiredTotes {
  if (_requiredTotes is EqualUnmodifiableListView) return _requiredTotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requiredTotes);
}

@override@JsonKey() final  OrderStatus status;
@override final  String? sealCode;
@override@JsonKey() final  bool isColdChain;
@override final  double? dispatchTemp;

/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalesOrderCopyWith<_SalesOrder> get copyWith => __$SalesOrderCopyWithImpl<_SalesOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SalesOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalesOrder&&(identical(other.soId, soId) || other.soId == soId)&&const DeepCollectionEquality().equals(other._requiredTotes, _requiredTotes)&&(identical(other.status, status) || other.status == status)&&(identical(other.sealCode, sealCode) || other.sealCode == sealCode)&&(identical(other.isColdChain, isColdChain) || other.isColdChain == isColdChain)&&(identical(other.dispatchTemp, dispatchTemp) || other.dispatchTemp == dispatchTemp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,soId,const DeepCollectionEquality().hash(_requiredTotes),status,sealCode,isColdChain,dispatchTemp);

@override
String toString() {
  return 'SalesOrder(soId: $soId, requiredTotes: $requiredTotes, status: $status, sealCode: $sealCode, isColdChain: $isColdChain, dispatchTemp: $dispatchTemp)';
}


}

/// @nodoc
abstract mixin class _$SalesOrderCopyWith<$Res> implements $SalesOrderCopyWith<$Res> {
  factory _$SalesOrderCopyWith(_SalesOrder value, $Res Function(_SalesOrder) _then) = __$SalesOrderCopyWithImpl;
@override @useResult
$Res call({
 String soId, List<OutboundTote> requiredTotes, OrderStatus status, String? sealCode, bool isColdChain, double? dispatchTemp
});




}
/// @nodoc
class __$SalesOrderCopyWithImpl<$Res>
    implements _$SalesOrderCopyWith<$Res> {
  __$SalesOrderCopyWithImpl(this._self, this._then);

  final _SalesOrder _self;
  final $Res Function(_SalesOrder) _then;

/// Create a copy of SalesOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? soId = null,Object? requiredTotes = null,Object? status = null,Object? sealCode = freezed,Object? isColdChain = null,Object? dispatchTemp = freezed,}) {
  return _then(_SalesOrder(
soId: null == soId ? _self.soId : soId // ignore: cast_nullable_to_non_nullable
as String,requiredTotes: null == requiredTotes ? _self._requiredTotes : requiredTotes // ignore: cast_nullable_to_non_nullable
as List<OutboundTote>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,sealCode: freezed == sealCode ? _self.sealCode : sealCode // ignore: cast_nullable_to_non_nullable
as String?,isColdChain: null == isColdChain ? _self.isColdChain : isColdChain // ignore: cast_nullable_to_non_nullable
as bool,dispatchTemp: freezed == dispatchTemp ? _self.dispatchTemp : dispatchTemp // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$OutboundState {

 List<SalesOrder> get orders; bool get isLoading; String? get errorMessage;
/// Create a copy of OutboundState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutboundStateCopyWith<OutboundState> get copyWith => _$OutboundStateCopyWithImpl<OutboundState>(this as OutboundState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutboundState&&const DeepCollectionEquality().equals(other.orders, orders)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(orders),isLoading,errorMessage);

@override
String toString() {
  return 'OutboundState(orders: $orders, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $OutboundStateCopyWith<$Res>  {
  factory $OutboundStateCopyWith(OutboundState value, $Res Function(OutboundState) _then) = _$OutboundStateCopyWithImpl;
@useResult
$Res call({
 List<SalesOrder> orders, bool isLoading, String? errorMessage
});




}
/// @nodoc
class _$OutboundStateCopyWithImpl<$Res>
    implements $OutboundStateCopyWith<$Res> {
  _$OutboundStateCopyWithImpl(this._self, this._then);

  final OutboundState _self;
  final $Res Function(OutboundState) _then;

/// Create a copy of OutboundState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orders = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
orders: null == orders ? _self.orders : orders // ignore: cast_nullable_to_non_nullable
as List<SalesOrder>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OutboundState].
extension OutboundStatePatterns on OutboundState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutboundState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutboundState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutboundState value)  $default,){
final _that = this;
switch (_that) {
case _OutboundState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutboundState value)?  $default,){
final _that = this;
switch (_that) {
case _OutboundState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SalesOrder> orders,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OutboundState() when $default != null:
return $default(_that.orders,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SalesOrder> orders,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _OutboundState():
return $default(_that.orders,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SalesOrder> orders,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _OutboundState() when $default != null:
return $default(_that.orders,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _OutboundState implements OutboundState {
  const _OutboundState({final  List<SalesOrder> orders = const [], this.isLoading = false, this.errorMessage}): _orders = orders;
  

 final  List<SalesOrder> _orders;
@override@JsonKey() List<SalesOrder> get orders {
  if (_orders is EqualUnmodifiableListView) return _orders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orders);
}

@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;

/// Create a copy of OutboundState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutboundStateCopyWith<_OutboundState> get copyWith => __$OutboundStateCopyWithImpl<_OutboundState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutboundState&&const DeepCollectionEquality().equals(other._orders, _orders)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_orders),isLoading,errorMessage);

@override
String toString() {
  return 'OutboundState(orders: $orders, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$OutboundStateCopyWith<$Res> implements $OutboundStateCopyWith<$Res> {
  factory _$OutboundStateCopyWith(_OutboundState value, $Res Function(_OutboundState) _then) = __$OutboundStateCopyWithImpl;
@override @useResult
$Res call({
 List<SalesOrder> orders, bool isLoading, String? errorMessage
});




}
/// @nodoc
class __$OutboundStateCopyWithImpl<$Res>
    implements _$OutboundStateCopyWith<$Res> {
  __$OutboundStateCopyWithImpl(this._self, this._then);

  final _OutboundState _self;
  final $Res Function(_OutboundState) _then;

/// Create a copy of OutboundState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orders = null,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_OutboundState(
orders: null == orders ? _self._orders : orders // ignore: cast_nullable_to_non_nullable
as List<SalesOrder>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
