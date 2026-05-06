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
mixin _$BatchInfo {

 String get batchId; String get lotNumber; int get quantity;@CustomDateTimeConverter() DateTime? get expiryDate;@CustomDateTimeConverter() DateTime? get manufacturingDate;
/// Create a copy of BatchInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatchInfoCopyWith<BatchInfo> get copyWith => _$BatchInfoCopyWithImpl<BatchInfo>(this as BatchInfo, _$identity);

  /// Serializes this BatchInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatchInfo&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.lotNumber, lotNumber) || other.lotNumber == lotNumber)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.manufacturingDate, manufacturingDate) || other.manufacturingDate == manufacturingDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,batchId,lotNumber,quantity,expiryDate,manufacturingDate);

@override
String toString() {
  return 'BatchInfo(batchId: $batchId, lotNumber: $lotNumber, quantity: $quantity, expiryDate: $expiryDate, manufacturingDate: $manufacturingDate)';
}


}

/// @nodoc
abstract mixin class $BatchInfoCopyWith<$Res>  {
  factory $BatchInfoCopyWith(BatchInfo value, $Res Function(BatchInfo) _then) = _$BatchInfoCopyWithImpl;
@useResult
$Res call({
 String batchId, String lotNumber, int quantity,@CustomDateTimeConverter() DateTime? expiryDate,@CustomDateTimeConverter() DateTime? manufacturingDate
});




}
/// @nodoc
class _$BatchInfoCopyWithImpl<$Res>
    implements $BatchInfoCopyWith<$Res> {
  _$BatchInfoCopyWithImpl(this._self, this._then);

  final BatchInfo _self;
  final $Res Function(BatchInfo) _then;

/// Create a copy of BatchInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? batchId = null,Object? lotNumber = null,Object? quantity = null,Object? expiryDate = freezed,Object? manufacturingDate = freezed,}) {
  return _then(_self.copyWith(
batchId: null == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String,lotNumber: null == lotNumber ? _self.lotNumber : lotNumber // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,manufacturingDate: freezed == manufacturingDate ? _self.manufacturingDate : manufacturingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BatchInfo].
extension BatchInfoPatterns on BatchInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BatchInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BatchInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BatchInfo value)  $default,){
final _that = this;
switch (_that) {
case _BatchInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BatchInfo value)?  $default,){
final _that = this;
switch (_that) {
case _BatchInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String batchId,  String lotNumber,  int quantity, @CustomDateTimeConverter()  DateTime? expiryDate, @CustomDateTimeConverter()  DateTime? manufacturingDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BatchInfo() when $default != null:
return $default(_that.batchId,_that.lotNumber,_that.quantity,_that.expiryDate,_that.manufacturingDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String batchId,  String lotNumber,  int quantity, @CustomDateTimeConverter()  DateTime? expiryDate, @CustomDateTimeConverter()  DateTime? manufacturingDate)  $default,) {final _that = this;
switch (_that) {
case _BatchInfo():
return $default(_that.batchId,_that.lotNumber,_that.quantity,_that.expiryDate,_that.manufacturingDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String batchId,  String lotNumber,  int quantity, @CustomDateTimeConverter()  DateTime? expiryDate, @CustomDateTimeConverter()  DateTime? manufacturingDate)?  $default,) {final _that = this;
switch (_that) {
case _BatchInfo() when $default != null:
return $default(_that.batchId,_that.lotNumber,_that.quantity,_that.expiryDate,_that.manufacturingDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BatchInfo implements BatchInfo {
  const _BatchInfo({required this.batchId, required this.lotNumber, required this.quantity, @CustomDateTimeConverter() this.expiryDate, @CustomDateTimeConverter() this.manufacturingDate});
  factory _BatchInfo.fromJson(Map<String, dynamic> json) => _$BatchInfoFromJson(json);

@override final  String batchId;
@override final  String lotNumber;
@override final  int quantity;
@override@CustomDateTimeConverter() final  DateTime? expiryDate;
@override@CustomDateTimeConverter() final  DateTime? manufacturingDate;

/// Create a copy of BatchInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BatchInfoCopyWith<_BatchInfo> get copyWith => __$BatchInfoCopyWithImpl<_BatchInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatchInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BatchInfo&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.lotNumber, lotNumber) || other.lotNumber == lotNumber)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.manufacturingDate, manufacturingDate) || other.manufacturingDate == manufacturingDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,batchId,lotNumber,quantity,expiryDate,manufacturingDate);

@override
String toString() {
  return 'BatchInfo(batchId: $batchId, lotNumber: $lotNumber, quantity: $quantity, expiryDate: $expiryDate, manufacturingDate: $manufacturingDate)';
}


}

/// @nodoc
abstract mixin class _$BatchInfoCopyWith<$Res> implements $BatchInfoCopyWith<$Res> {
  factory _$BatchInfoCopyWith(_BatchInfo value, $Res Function(_BatchInfo) _then) = __$BatchInfoCopyWithImpl;
@override @useResult
$Res call({
 String batchId, String lotNumber, int quantity,@CustomDateTimeConverter() DateTime? expiryDate,@CustomDateTimeConverter() DateTime? manufacturingDate
});




}
/// @nodoc
class __$BatchInfoCopyWithImpl<$Res>
    implements _$BatchInfoCopyWith<$Res> {
  __$BatchInfoCopyWithImpl(this._self, this._then);

  final _BatchInfo _self;
  final $Res Function(_BatchInfo) _then;

/// Create a copy of BatchInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? batchId = null,Object? lotNumber = null,Object? quantity = null,Object? expiryDate = freezed,Object? manufacturingDate = freezed,}) {
  return _then(_BatchInfo(
batchId: null == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String,lotNumber: null == lotNumber ? _self.lotNumber : lotNumber // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,manufacturingDate: freezed == manufacturingDate ? _self.manufacturingDate : manufacturingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$PoItem {

 String get sku; String get productName; int get expectedQty; int get scannedQty; List<BatchInfo> get batches;
/// Create a copy of PoItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PoItemCopyWith<PoItem> get copyWith => _$PoItemCopyWithImpl<PoItem>(this as PoItem, _$identity);

  /// Serializes this PoItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PoItem&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.scannedQty, scannedQty) || other.scannedQty == scannedQty)&&const DeepCollectionEquality().equals(other.batches, batches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sku,productName,expectedQty,scannedQty,const DeepCollectionEquality().hash(batches));

@override
String toString() {
  return 'PoItem(sku: $sku, productName: $productName, expectedQty: $expectedQty, scannedQty: $scannedQty, batches: $batches)';
}


}

/// @nodoc
abstract mixin class $PoItemCopyWith<$Res>  {
  factory $PoItemCopyWith(PoItem value, $Res Function(PoItem) _then) = _$PoItemCopyWithImpl;
@useResult
$Res call({
 String sku, String productName, int expectedQty, int scannedQty, List<BatchInfo> batches
});




}
/// @nodoc
class _$PoItemCopyWithImpl<$Res>
    implements $PoItemCopyWith<$Res> {
  _$PoItemCopyWithImpl(this._self, this._then);

  final PoItem _self;
  final $Res Function(PoItem) _then;

/// Create a copy of PoItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sku = null,Object? productName = null,Object? expectedQty = null,Object? scannedQty = null,Object? batches = null,}) {
  return _then(_self.copyWith(
sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as int,scannedQty: null == scannedQty ? _self.scannedQty : scannedQty // ignore: cast_nullable_to_non_nullable
as int,batches: null == batches ? _self.batches : batches // ignore: cast_nullable_to_non_nullable
as List<BatchInfo>,
  ));
}

}


/// Adds pattern-matching-related methods to [PoItem].
extension PoItemPatterns on PoItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PoItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PoItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PoItem value)  $default,){
final _that = this;
switch (_that) {
case _PoItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PoItem value)?  $default,){
final _that = this;
switch (_that) {
case _PoItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sku,  String productName,  int expectedQty,  int scannedQty,  List<BatchInfo> batches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PoItem() when $default != null:
return $default(_that.sku,_that.productName,_that.expectedQty,_that.scannedQty,_that.batches);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sku,  String productName,  int expectedQty,  int scannedQty,  List<BatchInfo> batches)  $default,) {final _that = this;
switch (_that) {
case _PoItem():
return $default(_that.sku,_that.productName,_that.expectedQty,_that.scannedQty,_that.batches);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sku,  String productName,  int expectedQty,  int scannedQty,  List<BatchInfo> batches)?  $default,) {final _that = this;
switch (_that) {
case _PoItem() when $default != null:
return $default(_that.sku,_that.productName,_that.expectedQty,_that.scannedQty,_that.batches);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PoItem implements PoItem {
  const _PoItem({required this.sku, required this.productName, required this.expectedQty, required this.scannedQty, final  List<BatchInfo> batches = const []}): _batches = batches;
  factory _PoItem.fromJson(Map<String, dynamic> json) => _$PoItemFromJson(json);

@override final  String sku;
@override final  String productName;
@override final  int expectedQty;
@override final  int scannedQty;
 final  List<BatchInfo> _batches;
@override@JsonKey() List<BatchInfo> get batches {
  if (_batches is EqualUnmodifiableListView) return _batches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batches);
}


/// Create a copy of PoItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PoItemCopyWith<_PoItem> get copyWith => __$PoItemCopyWithImpl<_PoItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PoItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PoItem&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.scannedQty, scannedQty) || other.scannedQty == scannedQty)&&const DeepCollectionEquality().equals(other._batches, _batches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sku,productName,expectedQty,scannedQty,const DeepCollectionEquality().hash(_batches));

@override
String toString() {
  return 'PoItem(sku: $sku, productName: $productName, expectedQty: $expectedQty, scannedQty: $scannedQty, batches: $batches)';
}


}

/// @nodoc
abstract mixin class _$PoItemCopyWith<$Res> implements $PoItemCopyWith<$Res> {
  factory _$PoItemCopyWith(_PoItem value, $Res Function(_PoItem) _then) = __$PoItemCopyWithImpl;
@override @useResult
$Res call({
 String sku, String productName, int expectedQty, int scannedQty, List<BatchInfo> batches
});




}
/// @nodoc
class __$PoItemCopyWithImpl<$Res>
    implements _$PoItemCopyWith<$Res> {
  __$PoItemCopyWithImpl(this._self, this._then);

  final _PoItem _self;
  final $Res Function(_PoItem) _then;

/// Create a copy of PoItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sku = null,Object? productName = null,Object? expectedQty = null,Object? scannedQty = null,Object? batches = null,}) {
  return _then(_PoItem(
sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as int,scannedQty: null == scannedQty ? _self.scannedQty : scannedQty // ignore: cast_nullable_to_non_nullable
as int,batches: null == batches ? _self._batches : batches // ignore: cast_nullable_to_non_nullable
as List<BatchInfo>,
  ));
}


}


/// @nodoc
mixin _$PurchaseOrder {

 String get poNumber; String get supplierName; String get status; List<PoItem> get items;
/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOrderCopyWith<PurchaseOrder> get copyWith => _$PurchaseOrderCopyWithImpl<PurchaseOrder>(this as PurchaseOrder, _$identity);

  /// Serializes this PurchaseOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOrder&&(identical(other.poNumber, poNumber) || other.poNumber == poNumber)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,poNumber,supplierName,status,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'PurchaseOrder(poNumber: $poNumber, supplierName: $supplierName, status: $status, items: $items)';
}


}

/// @nodoc
abstract mixin class $PurchaseOrderCopyWith<$Res>  {
  factory $PurchaseOrderCopyWith(PurchaseOrder value, $Res Function(PurchaseOrder) _then) = _$PurchaseOrderCopyWithImpl;
@useResult
$Res call({
 String poNumber, String supplierName, String status, List<PoItem> items
});




}
/// @nodoc
class _$PurchaseOrderCopyWithImpl<$Res>
    implements $PurchaseOrderCopyWith<$Res> {
  _$PurchaseOrderCopyWithImpl(this._self, this._then);

  final PurchaseOrder _self;
  final $Res Function(PurchaseOrder) _then;

/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? poNumber = null,Object? supplierName = null,Object? status = null,Object? items = null,}) {
  return _then(_self.copyWith(
poNumber: null == poNumber ? _self.poNumber : poNumber // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PoItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseOrder].
extension PurchaseOrderPatterns on PurchaseOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseOrder value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseOrder value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String poNumber,  String supplierName,  String status,  List<PoItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
return $default(_that.poNumber,_that.supplierName,_that.status,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String poNumber,  String supplierName,  String status,  List<PoItem> items)  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrder():
return $default(_that.poNumber,_that.supplierName,_that.status,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String poNumber,  String supplierName,  String status,  List<PoItem> items)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseOrder() when $default != null:
return $default(_that.poNumber,_that.supplierName,_that.status,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseOrder implements PurchaseOrder {
  const _PurchaseOrder({required this.poNumber, required this.supplierName, required this.status, required final  List<PoItem> items}): _items = items;
  factory _PurchaseOrder.fromJson(Map<String, dynamic> json) => _$PurchaseOrderFromJson(json);

@override final  String poNumber;
@override final  String supplierName;
@override final  String status;
 final  List<PoItem> _items;
@override List<PoItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseOrderCopyWith<_PurchaseOrder> get copyWith => __$PurchaseOrderCopyWithImpl<_PurchaseOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseOrder&&(identical(other.poNumber, poNumber) || other.poNumber == poNumber)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,poNumber,supplierName,status,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PurchaseOrder(poNumber: $poNumber, supplierName: $supplierName, status: $status, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PurchaseOrderCopyWith<$Res> implements $PurchaseOrderCopyWith<$Res> {
  factory _$PurchaseOrderCopyWith(_PurchaseOrder value, $Res Function(_PurchaseOrder) _then) = __$PurchaseOrderCopyWithImpl;
@override @useResult
$Res call({
 String poNumber, String supplierName, String status, List<PoItem> items
});




}
/// @nodoc
class __$PurchaseOrderCopyWithImpl<$Res>
    implements _$PurchaseOrderCopyWith<$Res> {
  __$PurchaseOrderCopyWithImpl(this._self, this._then);

  final _PurchaseOrder _self;
  final $Res Function(_PurchaseOrder) _then;

/// Create a copy of PurchaseOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? poNumber = null,Object? supplierName = null,Object? status = null,Object? items = null,}) {
  return _then(_PurchaseOrder(
poNumber: null == poNumber ? _self.poNumber : poNumber // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PoItem>,
  ));
}


}

// dart format on
