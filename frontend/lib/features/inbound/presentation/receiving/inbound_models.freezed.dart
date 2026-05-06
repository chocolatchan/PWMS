// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbound_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InboundItem {

 String get barcode; String get productName; int get expectedQty; int get actualQty; double get uomRate; QuarantineReason get reasonCode; bool get noMixedBatch; String get toteCode; bool get isToxic;
/// Create a copy of InboundItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InboundItemCopyWith<InboundItem> get copyWith => _$InboundItemCopyWithImpl<InboundItem>(this as InboundItem, _$identity);

  /// Serializes this InboundItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InboundItem&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.actualQty, actualQty) || other.actualQty == actualQty)&&(identical(other.uomRate, uomRate) || other.uomRate == uomRate)&&(identical(other.reasonCode, reasonCode) || other.reasonCode == reasonCode)&&(identical(other.noMixedBatch, noMixedBatch) || other.noMixedBatch == noMixedBatch)&&(identical(other.toteCode, toteCode) || other.toteCode == toteCode)&&(identical(other.isToxic, isToxic) || other.isToxic == isToxic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,barcode,productName,expectedQty,actualQty,uomRate,reasonCode,noMixedBatch,toteCode,isToxic);

@override
String toString() {
  return 'InboundItem(barcode: $barcode, productName: $productName, expectedQty: $expectedQty, actualQty: $actualQty, uomRate: $uomRate, reasonCode: $reasonCode, noMixedBatch: $noMixedBatch, toteCode: $toteCode, isToxic: $isToxic)';
}


}

/// @nodoc
abstract mixin class $InboundItemCopyWith<$Res>  {
  factory $InboundItemCopyWith(InboundItem value, $Res Function(InboundItem) _then) = _$InboundItemCopyWithImpl;
@useResult
$Res call({
 String barcode, String productName, int expectedQty, int actualQty, double uomRate, QuarantineReason reasonCode, bool noMixedBatch, String toteCode, bool isToxic
});




}
/// @nodoc
class _$InboundItemCopyWithImpl<$Res>
    implements $InboundItemCopyWith<$Res> {
  _$InboundItemCopyWithImpl(this._self, this._then);

  final InboundItem _self;
  final $Res Function(InboundItem) _then;

/// Create a copy of InboundItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? barcode = null,Object? productName = null,Object? expectedQty = null,Object? actualQty = null,Object? uomRate = null,Object? reasonCode = null,Object? noMixedBatch = null,Object? toteCode = null,Object? isToxic = null,}) {
  return _then(_self.copyWith(
barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as int,actualQty: null == actualQty ? _self.actualQty : actualQty // ignore: cast_nullable_to_non_nullable
as int,uomRate: null == uomRate ? _self.uomRate : uomRate // ignore: cast_nullable_to_non_nullable
as double,reasonCode: null == reasonCode ? _self.reasonCode : reasonCode // ignore: cast_nullable_to_non_nullable
as QuarantineReason,noMixedBatch: null == noMixedBatch ? _self.noMixedBatch : noMixedBatch // ignore: cast_nullable_to_non_nullable
as bool,toteCode: null == toteCode ? _self.toteCode : toteCode // ignore: cast_nullable_to_non_nullable
as String,isToxic: null == isToxic ? _self.isToxic : isToxic // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InboundItem].
extension InboundItemPatterns on InboundItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InboundItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InboundItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InboundItem value)  $default,){
final _that = this;
switch (_that) {
case _InboundItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InboundItem value)?  $default,){
final _that = this;
switch (_that) {
case _InboundItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String barcode,  String productName,  int expectedQty,  int actualQty,  double uomRate,  QuarantineReason reasonCode,  bool noMixedBatch,  String toteCode,  bool isToxic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InboundItem() when $default != null:
return $default(_that.barcode,_that.productName,_that.expectedQty,_that.actualQty,_that.uomRate,_that.reasonCode,_that.noMixedBatch,_that.toteCode,_that.isToxic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String barcode,  String productName,  int expectedQty,  int actualQty,  double uomRate,  QuarantineReason reasonCode,  bool noMixedBatch,  String toteCode,  bool isToxic)  $default,) {final _that = this;
switch (_that) {
case _InboundItem():
return $default(_that.barcode,_that.productName,_that.expectedQty,_that.actualQty,_that.uomRate,_that.reasonCode,_that.noMixedBatch,_that.toteCode,_that.isToxic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String barcode,  String productName,  int expectedQty,  int actualQty,  double uomRate,  QuarantineReason reasonCode,  bool noMixedBatch,  String toteCode,  bool isToxic)?  $default,) {final _that = this;
switch (_that) {
case _InboundItem() when $default != null:
return $default(_that.barcode,_that.productName,_that.expectedQty,_that.actualQty,_that.uomRate,_that.reasonCode,_that.noMixedBatch,_that.toteCode,_that.isToxic);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InboundItem extends InboundItem {
  const _InboundItem({required this.barcode, required this.productName, required this.expectedQty, this.actualQty = 0, required this.uomRate, this.reasonCode = QuarantineReason.normal, this.noMixedBatch = false, this.toteCode = '', this.isToxic = false}): super._();
  factory _InboundItem.fromJson(Map<String, dynamic> json) => _$InboundItemFromJson(json);

@override final  String barcode;
@override final  String productName;
@override final  int expectedQty;
@override@JsonKey() final  int actualQty;
@override final  double uomRate;
@override@JsonKey() final  QuarantineReason reasonCode;
@override@JsonKey() final  bool noMixedBatch;
@override@JsonKey() final  String toteCode;
@override@JsonKey() final  bool isToxic;

/// Create a copy of InboundItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InboundItemCopyWith<_InboundItem> get copyWith => __$InboundItemCopyWithImpl<_InboundItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InboundItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InboundItem&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.actualQty, actualQty) || other.actualQty == actualQty)&&(identical(other.uomRate, uomRate) || other.uomRate == uomRate)&&(identical(other.reasonCode, reasonCode) || other.reasonCode == reasonCode)&&(identical(other.noMixedBatch, noMixedBatch) || other.noMixedBatch == noMixedBatch)&&(identical(other.toteCode, toteCode) || other.toteCode == toteCode)&&(identical(other.isToxic, isToxic) || other.isToxic == isToxic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,barcode,productName,expectedQty,actualQty,uomRate,reasonCode,noMixedBatch,toteCode,isToxic);

@override
String toString() {
  return 'InboundItem(barcode: $barcode, productName: $productName, expectedQty: $expectedQty, actualQty: $actualQty, uomRate: $uomRate, reasonCode: $reasonCode, noMixedBatch: $noMixedBatch, toteCode: $toteCode, isToxic: $isToxic)';
}


}

/// @nodoc
abstract mixin class _$InboundItemCopyWith<$Res> implements $InboundItemCopyWith<$Res> {
  factory _$InboundItemCopyWith(_InboundItem value, $Res Function(_InboundItem) _then) = __$InboundItemCopyWithImpl;
@override @useResult
$Res call({
 String barcode, String productName, int expectedQty, int actualQty, double uomRate, QuarantineReason reasonCode, bool noMixedBatch, String toteCode, bool isToxic
});




}
/// @nodoc
class __$InboundItemCopyWithImpl<$Res>
    implements _$InboundItemCopyWith<$Res> {
  __$InboundItemCopyWithImpl(this._self, this._then);

  final _InboundItem _self;
  final $Res Function(_InboundItem) _then;

/// Create a copy of InboundItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? barcode = null,Object? productName = null,Object? expectedQty = null,Object? actualQty = null,Object? uomRate = null,Object? reasonCode = null,Object? noMixedBatch = null,Object? toteCode = null,Object? isToxic = null,}) {
  return _then(_InboundItem(
barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as int,actualQty: null == actualQty ? _self.actualQty : actualQty // ignore: cast_nullable_to_non_nullable
as int,uomRate: null == uomRate ? _self.uomRate : uomRate // ignore: cast_nullable_to_non_nullable
as double,reasonCode: null == reasonCode ? _self.reasonCode : reasonCode // ignore: cast_nullable_to_non_nullable
as QuarantineReason,noMixedBatch: null == noMixedBatch ? _self.noMixedBatch : noMixedBatch // ignore: cast_nullable_to_non_nullable
as bool,toteCode: null == toteCode ? _self.toteCode : toteCode // ignore: cast_nullable_to_non_nullable
as String,isToxic: null == isToxic ? _self.isToxic : isToxic // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
