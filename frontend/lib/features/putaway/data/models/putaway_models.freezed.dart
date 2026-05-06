// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'putaway_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PutawayItem {

 String get sku; String get productName; int get expectedQty; int get scannedQty; String get suggestedLocation;
/// Create a copy of PutawayItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PutawayItemCopyWith<PutawayItem> get copyWith => _$PutawayItemCopyWithImpl<PutawayItem>(this as PutawayItem, _$identity);

  /// Serializes this PutawayItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PutawayItem&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.scannedQty, scannedQty) || other.scannedQty == scannedQty)&&(identical(other.suggestedLocation, suggestedLocation) || other.suggestedLocation == suggestedLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sku,productName,expectedQty,scannedQty,suggestedLocation);

@override
String toString() {
  return 'PutawayItem(sku: $sku, productName: $productName, expectedQty: $expectedQty, scannedQty: $scannedQty, suggestedLocation: $suggestedLocation)';
}


}

/// @nodoc
abstract mixin class $PutawayItemCopyWith<$Res>  {
  factory $PutawayItemCopyWith(PutawayItem value, $Res Function(PutawayItem) _then) = _$PutawayItemCopyWithImpl;
@useResult
$Res call({
 String sku, String productName, int expectedQty, int scannedQty, String suggestedLocation
});




}
/// @nodoc
class _$PutawayItemCopyWithImpl<$Res>
    implements $PutawayItemCopyWith<$Res> {
  _$PutawayItemCopyWithImpl(this._self, this._then);

  final PutawayItem _self;
  final $Res Function(PutawayItem) _then;

/// Create a copy of PutawayItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sku = null,Object? productName = null,Object? expectedQty = null,Object? scannedQty = null,Object? suggestedLocation = null,}) {
  return _then(_self.copyWith(
sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as int,scannedQty: null == scannedQty ? _self.scannedQty : scannedQty // ignore: cast_nullable_to_non_nullable
as int,suggestedLocation: null == suggestedLocation ? _self.suggestedLocation : suggestedLocation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PutawayItem].
extension PutawayItemPatterns on PutawayItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PutawayItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PutawayItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PutawayItem value)  $default,){
final _that = this;
switch (_that) {
case _PutawayItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PutawayItem value)?  $default,){
final _that = this;
switch (_that) {
case _PutawayItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sku,  String productName,  int expectedQty,  int scannedQty,  String suggestedLocation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PutawayItem() when $default != null:
return $default(_that.sku,_that.productName,_that.expectedQty,_that.scannedQty,_that.suggestedLocation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sku,  String productName,  int expectedQty,  int scannedQty,  String suggestedLocation)  $default,) {final _that = this;
switch (_that) {
case _PutawayItem():
return $default(_that.sku,_that.productName,_that.expectedQty,_that.scannedQty,_that.suggestedLocation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sku,  String productName,  int expectedQty,  int scannedQty,  String suggestedLocation)?  $default,) {final _that = this;
switch (_that) {
case _PutawayItem() when $default != null:
return $default(_that.sku,_that.productName,_that.expectedQty,_that.scannedQty,_that.suggestedLocation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PutawayItem implements PutawayItem {
  const _PutawayItem({required this.sku, required this.productName, required this.expectedQty, required this.scannedQty, required this.suggestedLocation});
  factory _PutawayItem.fromJson(Map<String, dynamic> json) => _$PutawayItemFromJson(json);

@override final  String sku;
@override final  String productName;
@override final  int expectedQty;
@override final  int scannedQty;
@override final  String suggestedLocation;

/// Create a copy of PutawayItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PutawayItemCopyWith<_PutawayItem> get copyWith => __$PutawayItemCopyWithImpl<_PutawayItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PutawayItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PutawayItem&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.scannedQty, scannedQty) || other.scannedQty == scannedQty)&&(identical(other.suggestedLocation, suggestedLocation) || other.suggestedLocation == suggestedLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sku,productName,expectedQty,scannedQty,suggestedLocation);

@override
String toString() {
  return 'PutawayItem(sku: $sku, productName: $productName, expectedQty: $expectedQty, scannedQty: $scannedQty, suggestedLocation: $suggestedLocation)';
}


}

/// @nodoc
abstract mixin class _$PutawayItemCopyWith<$Res> implements $PutawayItemCopyWith<$Res> {
  factory _$PutawayItemCopyWith(_PutawayItem value, $Res Function(_PutawayItem) _then) = __$PutawayItemCopyWithImpl;
@override @useResult
$Res call({
 String sku, String productName, int expectedQty, int scannedQty, String suggestedLocation
});




}
/// @nodoc
class __$PutawayItemCopyWithImpl<$Res>
    implements _$PutawayItemCopyWith<$Res> {
  __$PutawayItemCopyWithImpl(this._self, this._then);

  final _PutawayItem _self;
  final $Res Function(_PutawayItem) _then;

/// Create a copy of PutawayItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sku = null,Object? productName = null,Object? expectedQty = null,Object? scannedQty = null,Object? suggestedLocation = null,}) {
  return _then(_PutawayItem(
sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as int,scannedQty: null == scannedQty ? _self.scannedQty : scannedQty // ignore: cast_nullable_to_non_nullable
as int,suggestedLocation: null == suggestedLocation ? _self.suggestedLocation : suggestedLocation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PutawayTask {

 String get toteBarcode; List<PutawayItem> get items; String get status;
/// Create a copy of PutawayTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PutawayTaskCopyWith<PutawayTask> get copyWith => _$PutawayTaskCopyWithImpl<PutawayTask>(this as PutawayTask, _$identity);

  /// Serializes this PutawayTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PutawayTask&&(identical(other.toteBarcode, toteBarcode) || other.toteBarcode == toteBarcode)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,toteBarcode,const DeepCollectionEquality().hash(items),status);

@override
String toString() {
  return 'PutawayTask(toteBarcode: $toteBarcode, items: $items, status: $status)';
}


}

/// @nodoc
abstract mixin class $PutawayTaskCopyWith<$Res>  {
  factory $PutawayTaskCopyWith(PutawayTask value, $Res Function(PutawayTask) _then) = _$PutawayTaskCopyWithImpl;
@useResult
$Res call({
 String toteBarcode, List<PutawayItem> items, String status
});




}
/// @nodoc
class _$PutawayTaskCopyWithImpl<$Res>
    implements $PutawayTaskCopyWith<$Res> {
  _$PutawayTaskCopyWithImpl(this._self, this._then);

  final PutawayTask _self;
  final $Res Function(PutawayTask) _then;

/// Create a copy of PutawayTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? toteBarcode = null,Object? items = null,Object? status = null,}) {
  return _then(_self.copyWith(
toteBarcode: null == toteBarcode ? _self.toteBarcode : toteBarcode // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PutawayItem>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PutawayTask].
extension PutawayTaskPatterns on PutawayTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PutawayTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PutawayTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PutawayTask value)  $default,){
final _that = this;
switch (_that) {
case _PutawayTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PutawayTask value)?  $default,){
final _that = this;
switch (_that) {
case _PutawayTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String toteBarcode,  List<PutawayItem> items,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PutawayTask() when $default != null:
return $default(_that.toteBarcode,_that.items,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String toteBarcode,  List<PutawayItem> items,  String status)  $default,) {final _that = this;
switch (_that) {
case _PutawayTask():
return $default(_that.toteBarcode,_that.items,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String toteBarcode,  List<PutawayItem> items,  String status)?  $default,) {final _that = this;
switch (_that) {
case _PutawayTask() when $default != null:
return $default(_that.toteBarcode,_that.items,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PutawayTask implements PutawayTask {
  const _PutawayTask({required this.toteBarcode, required final  List<PutawayItem> items, required this.status}): _items = items;
  factory _PutawayTask.fromJson(Map<String, dynamic> json) => _$PutawayTaskFromJson(json);

@override final  String toteBarcode;
 final  List<PutawayItem> _items;
@override List<PutawayItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String status;

/// Create a copy of PutawayTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PutawayTaskCopyWith<_PutawayTask> get copyWith => __$PutawayTaskCopyWithImpl<_PutawayTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PutawayTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PutawayTask&&(identical(other.toteBarcode, toteBarcode) || other.toteBarcode == toteBarcode)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,toteBarcode,const DeepCollectionEquality().hash(_items),status);

@override
String toString() {
  return 'PutawayTask(toteBarcode: $toteBarcode, items: $items, status: $status)';
}


}

/// @nodoc
abstract mixin class _$PutawayTaskCopyWith<$Res> implements $PutawayTaskCopyWith<$Res> {
  factory _$PutawayTaskCopyWith(_PutawayTask value, $Res Function(_PutawayTask) _then) = __$PutawayTaskCopyWithImpl;
@override @useResult
$Res call({
 String toteBarcode, List<PutawayItem> items, String status
});




}
/// @nodoc
class __$PutawayTaskCopyWithImpl<$Res>
    implements _$PutawayTaskCopyWith<$Res> {
  __$PutawayTaskCopyWithImpl(this._self, this._then);

  final _PutawayTask _self;
  final $Res Function(_PutawayTask) _then;

/// Create a copy of PutawayTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? toteBarcode = null,Object? items = null,Object? status = null,}) {
  return _then(_PutawayTask(
toteBarcode: null == toteBarcode ? _self.toteBarcode : toteBarcode // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PutawayItem>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
