// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'picking_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PickingItem {

 String get productId; String get productName; String get targetLoc; String get batchCode; int get expectedQty; bool get isLasa;
/// Create a copy of PickingItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickingItemCopyWith<PickingItem> get copyWith => _$PickingItemCopyWithImpl<PickingItem>(this as PickingItem, _$identity);

  /// Serializes this PickingItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PickingItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.targetLoc, targetLoc) || other.targetLoc == targetLoc)&&(identical(other.batchCode, batchCode) || other.batchCode == batchCode)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.isLasa, isLasa) || other.isLasa == isLasa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,targetLoc,batchCode,expectedQty,isLasa);

@override
String toString() {
  return 'PickingItem(productId: $productId, productName: $productName, targetLoc: $targetLoc, batchCode: $batchCode, expectedQty: $expectedQty, isLasa: $isLasa)';
}


}

/// @nodoc
abstract mixin class $PickingItemCopyWith<$Res>  {
  factory $PickingItemCopyWith(PickingItem value, $Res Function(PickingItem) _then) = _$PickingItemCopyWithImpl;
@useResult
$Res call({
 String productId, String productName, String targetLoc, String batchCode, int expectedQty, bool isLasa
});




}
/// @nodoc
class _$PickingItemCopyWithImpl<$Res>
    implements $PickingItemCopyWith<$Res> {
  _$PickingItemCopyWithImpl(this._self, this._then);

  final PickingItem _self;
  final $Res Function(PickingItem) _then;

/// Create a copy of PickingItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? targetLoc = null,Object? batchCode = null,Object? expectedQty = null,Object? isLasa = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,targetLoc: null == targetLoc ? _self.targetLoc : targetLoc // ignore: cast_nullable_to_non_nullable
as String,batchCode: null == batchCode ? _self.batchCode : batchCode // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as int,isLasa: null == isLasa ? _self.isLasa : isLasa // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PickingItem].
extension PickingItemPatterns on PickingItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PickingItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PickingItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PickingItem value)  $default,){
final _that = this;
switch (_that) {
case _PickingItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PickingItem value)?  $default,){
final _that = this;
switch (_that) {
case _PickingItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String productName,  String targetLoc,  String batchCode,  int expectedQty,  bool isLasa)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PickingItem() when $default != null:
return $default(_that.productId,_that.productName,_that.targetLoc,_that.batchCode,_that.expectedQty,_that.isLasa);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String productName,  String targetLoc,  String batchCode,  int expectedQty,  bool isLasa)  $default,) {final _that = this;
switch (_that) {
case _PickingItem():
return $default(_that.productId,_that.productName,_that.targetLoc,_that.batchCode,_that.expectedQty,_that.isLasa);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String productName,  String targetLoc,  String batchCode,  int expectedQty,  bool isLasa)?  $default,) {final _that = this;
switch (_that) {
case _PickingItem() when $default != null:
return $default(_that.productId,_that.productName,_that.targetLoc,_that.batchCode,_that.expectedQty,_that.isLasa);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PickingItem implements PickingItem {
  const _PickingItem({required this.productId, required this.productName, required this.targetLoc, required this.batchCode, required this.expectedQty, required this.isLasa});
  factory _PickingItem.fromJson(Map<String, dynamic> json) => _$PickingItemFromJson(json);

@override final  String productId;
@override final  String productName;
@override final  String targetLoc;
@override final  String batchCode;
@override final  int expectedQty;
@override final  bool isLasa;

/// Create a copy of PickingItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PickingItemCopyWith<_PickingItem> get copyWith => __$PickingItemCopyWithImpl<_PickingItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PickingItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PickingItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.targetLoc, targetLoc) || other.targetLoc == targetLoc)&&(identical(other.batchCode, batchCode) || other.batchCode == batchCode)&&(identical(other.expectedQty, expectedQty) || other.expectedQty == expectedQty)&&(identical(other.isLasa, isLasa) || other.isLasa == isLasa));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,productName,targetLoc,batchCode,expectedQty,isLasa);

@override
String toString() {
  return 'PickingItem(productId: $productId, productName: $productName, targetLoc: $targetLoc, batchCode: $batchCode, expectedQty: $expectedQty, isLasa: $isLasa)';
}


}

/// @nodoc
abstract mixin class _$PickingItemCopyWith<$Res> implements $PickingItemCopyWith<$Res> {
  factory _$PickingItemCopyWith(_PickingItem value, $Res Function(_PickingItem) _then) = __$PickingItemCopyWithImpl;
@override @useResult
$Res call({
 String productId, String productName, String targetLoc, String batchCode, int expectedQty, bool isLasa
});




}
/// @nodoc
class __$PickingItemCopyWithImpl<$Res>
    implements _$PickingItemCopyWith<$Res> {
  __$PickingItemCopyWithImpl(this._self, this._then);

  final _PickingItem _self;
  final $Res Function(_PickingItem) _then;

/// Create a copy of PickingItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? targetLoc = null,Object? batchCode = null,Object? expectedQty = null,Object? isLasa = null,}) {
  return _then(_PickingItem(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,targetLoc: null == targetLoc ? _self.targetLoc : targetLoc // ignore: cast_nullable_to_non_nullable
as String,batchCode: null == batchCode ? _self.batchCode : batchCode // ignore: cast_nullable_to_non_nullable
as String,expectedQty: null == expectedQty ? _self.expectedQty : expectedQty // ignore: cast_nullable_to_non_nullable
as int,isLasa: null == isLasa ? _self.isLasa : isLasa // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PickingSO {

 String get soId; List<PickingItem> get items;
/// Create a copy of PickingSO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickingSOCopyWith<PickingSO> get copyWith => _$PickingSOCopyWithImpl<PickingSO>(this as PickingSO, _$identity);

  /// Serializes this PickingSO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PickingSO&&(identical(other.soId, soId) || other.soId == soId)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,soId,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'PickingSO(soId: $soId, items: $items)';
}


}

/// @nodoc
abstract mixin class $PickingSOCopyWith<$Res>  {
  factory $PickingSOCopyWith(PickingSO value, $Res Function(PickingSO) _then) = _$PickingSOCopyWithImpl;
@useResult
$Res call({
 String soId, List<PickingItem> items
});




}
/// @nodoc
class _$PickingSOCopyWithImpl<$Res>
    implements $PickingSOCopyWith<$Res> {
  _$PickingSOCopyWithImpl(this._self, this._then);

  final PickingSO _self;
  final $Res Function(PickingSO) _then;

/// Create a copy of PickingSO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? soId = null,Object? items = null,}) {
  return _then(_self.copyWith(
soId: null == soId ? _self.soId : soId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PickingItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [PickingSO].
extension PickingSOPatterns on PickingSO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PickingSO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PickingSO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PickingSO value)  $default,){
final _that = this;
switch (_that) {
case _PickingSO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PickingSO value)?  $default,){
final _that = this;
switch (_that) {
case _PickingSO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String soId,  List<PickingItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PickingSO() when $default != null:
return $default(_that.soId,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String soId,  List<PickingItem> items)  $default,) {final _that = this;
switch (_that) {
case _PickingSO():
return $default(_that.soId,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String soId,  List<PickingItem> items)?  $default,) {final _that = this;
switch (_that) {
case _PickingSO() when $default != null:
return $default(_that.soId,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PickingSO implements PickingSO {
  const _PickingSO({required this.soId, required final  List<PickingItem> items}): _items = items;
  factory _PickingSO.fromJson(Map<String, dynamic> json) => _$PickingSOFromJson(json);

@override final  String soId;
 final  List<PickingItem> _items;
@override List<PickingItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PickingSO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PickingSOCopyWith<_PickingSO> get copyWith => __$PickingSOCopyWithImpl<_PickingSO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PickingSOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PickingSO&&(identical(other.soId, soId) || other.soId == soId)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,soId,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PickingSO(soId: $soId, items: $items)';
}


}

/// @nodoc
abstract mixin class _$PickingSOCopyWith<$Res> implements $PickingSOCopyWith<$Res> {
  factory _$PickingSOCopyWith(_PickingSO value, $Res Function(_PickingSO) _then) = __$PickingSOCopyWithImpl;
@override @useResult
$Res call({
 String soId, List<PickingItem> items
});




}
/// @nodoc
class __$PickingSOCopyWithImpl<$Res>
    implements _$PickingSOCopyWith<$Res> {
  __$PickingSOCopyWithImpl(this._self, this._then);

  final _PickingSO _self;
  final $Res Function(_PickingSO) _then;

/// Create a copy of PickingSO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? soId = null,Object? items = null,}) {
  return _then(_PickingSO(
soId: null == soId ? _self.soId : soId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PickingItem>,
  ));
}


}

/// @nodoc
mixin _$PickingWizardState {

 PickingStep get step; PickingSO? get activeSO; int get currentItemIndex;// Setup data
 String get toteCode; String get startLoc;// Execution data
 String get inputBuffer;// Used for scanning/typing
 int get scannedQty; bool get isTargetLocMatched; bool get isBarcodeMatched; bool get isSubmitting; String? get errorMessage;
/// Create a copy of PickingWizardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickingWizardStateCopyWith<PickingWizardState> get copyWith => _$PickingWizardStateCopyWithImpl<PickingWizardState>(this as PickingWizardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PickingWizardState&&(identical(other.step, step) || other.step == step)&&(identical(other.activeSO, activeSO) || other.activeSO == activeSO)&&(identical(other.currentItemIndex, currentItemIndex) || other.currentItemIndex == currentItemIndex)&&(identical(other.toteCode, toteCode) || other.toteCode == toteCode)&&(identical(other.startLoc, startLoc) || other.startLoc == startLoc)&&(identical(other.inputBuffer, inputBuffer) || other.inputBuffer == inputBuffer)&&(identical(other.scannedQty, scannedQty) || other.scannedQty == scannedQty)&&(identical(other.isTargetLocMatched, isTargetLocMatched) || other.isTargetLocMatched == isTargetLocMatched)&&(identical(other.isBarcodeMatched, isBarcodeMatched) || other.isBarcodeMatched == isBarcodeMatched)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,step,activeSO,currentItemIndex,toteCode,startLoc,inputBuffer,scannedQty,isTargetLocMatched,isBarcodeMatched,isSubmitting,errorMessage);

@override
String toString() {
  return 'PickingWizardState(step: $step, activeSO: $activeSO, currentItemIndex: $currentItemIndex, toteCode: $toteCode, startLoc: $startLoc, inputBuffer: $inputBuffer, scannedQty: $scannedQty, isTargetLocMatched: $isTargetLocMatched, isBarcodeMatched: $isBarcodeMatched, isSubmitting: $isSubmitting, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PickingWizardStateCopyWith<$Res>  {
  factory $PickingWizardStateCopyWith(PickingWizardState value, $Res Function(PickingWizardState) _then) = _$PickingWizardStateCopyWithImpl;
@useResult
$Res call({
 PickingStep step, PickingSO? activeSO, int currentItemIndex, String toteCode, String startLoc, String inputBuffer, int scannedQty, bool isTargetLocMatched, bool isBarcodeMatched, bool isSubmitting, String? errorMessage
});


$PickingSOCopyWith<$Res>? get activeSO;

}
/// @nodoc
class _$PickingWizardStateCopyWithImpl<$Res>
    implements $PickingWizardStateCopyWith<$Res> {
  _$PickingWizardStateCopyWithImpl(this._self, this._then);

  final PickingWizardState _self;
  final $Res Function(PickingWizardState) _then;

/// Create a copy of PickingWizardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? activeSO = freezed,Object? currentItemIndex = null,Object? toteCode = null,Object? startLoc = null,Object? inputBuffer = null,Object? scannedQty = null,Object? isTargetLocMatched = null,Object? isBarcodeMatched = null,Object? isSubmitting = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as PickingStep,activeSO: freezed == activeSO ? _self.activeSO : activeSO // ignore: cast_nullable_to_non_nullable
as PickingSO?,currentItemIndex: null == currentItemIndex ? _self.currentItemIndex : currentItemIndex // ignore: cast_nullable_to_non_nullable
as int,toteCode: null == toteCode ? _self.toteCode : toteCode // ignore: cast_nullable_to_non_nullable
as String,startLoc: null == startLoc ? _self.startLoc : startLoc // ignore: cast_nullable_to_non_nullable
as String,inputBuffer: null == inputBuffer ? _self.inputBuffer : inputBuffer // ignore: cast_nullable_to_non_nullable
as String,scannedQty: null == scannedQty ? _self.scannedQty : scannedQty // ignore: cast_nullable_to_non_nullable
as int,isTargetLocMatched: null == isTargetLocMatched ? _self.isTargetLocMatched : isTargetLocMatched // ignore: cast_nullable_to_non_nullable
as bool,isBarcodeMatched: null == isBarcodeMatched ? _self.isBarcodeMatched : isBarcodeMatched // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PickingWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PickingSOCopyWith<$Res>? get activeSO {
    if (_self.activeSO == null) {
    return null;
  }

  return $PickingSOCopyWith<$Res>(_self.activeSO!, (value) {
    return _then(_self.copyWith(activeSO: value));
  });
}
}


/// Adds pattern-matching-related methods to [PickingWizardState].
extension PickingWizardStatePatterns on PickingWizardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PickingWizardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PickingWizardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PickingWizardState value)  $default,){
final _that = this;
switch (_that) {
case _PickingWizardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PickingWizardState value)?  $default,){
final _that = this;
switch (_that) {
case _PickingWizardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PickingStep step,  PickingSO? activeSO,  int currentItemIndex,  String toteCode,  String startLoc,  String inputBuffer,  int scannedQty,  bool isTargetLocMatched,  bool isBarcodeMatched,  bool isSubmitting,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PickingWizardState() when $default != null:
return $default(_that.step,_that.activeSO,_that.currentItemIndex,_that.toteCode,_that.startLoc,_that.inputBuffer,_that.scannedQty,_that.isTargetLocMatched,_that.isBarcodeMatched,_that.isSubmitting,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PickingStep step,  PickingSO? activeSO,  int currentItemIndex,  String toteCode,  String startLoc,  String inputBuffer,  int scannedQty,  bool isTargetLocMatched,  bool isBarcodeMatched,  bool isSubmitting,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PickingWizardState():
return $default(_that.step,_that.activeSO,_that.currentItemIndex,_that.toteCode,_that.startLoc,_that.inputBuffer,_that.scannedQty,_that.isTargetLocMatched,_that.isBarcodeMatched,_that.isSubmitting,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PickingStep step,  PickingSO? activeSO,  int currentItemIndex,  String toteCode,  String startLoc,  String inputBuffer,  int scannedQty,  bool isTargetLocMatched,  bool isBarcodeMatched,  bool isSubmitting,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PickingWizardState() when $default != null:
return $default(_that.step,_that.activeSO,_that.currentItemIndex,_that.toteCode,_that.startLoc,_that.inputBuffer,_that.scannedQty,_that.isTargetLocMatched,_that.isBarcodeMatched,_that.isSubmitting,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PickingWizardState implements PickingWizardState {
  const _PickingWizardState({this.step = PickingStep.setup, this.activeSO, this.currentItemIndex = 0, this.toteCode = '', this.startLoc = '', this.inputBuffer = '', this.scannedQty = 0, this.isTargetLocMatched = false, this.isBarcodeMatched = false, this.isSubmitting = false, this.errorMessage});
  

@override@JsonKey() final  PickingStep step;
@override final  PickingSO? activeSO;
@override@JsonKey() final  int currentItemIndex;
// Setup data
@override@JsonKey() final  String toteCode;
@override@JsonKey() final  String startLoc;
// Execution data
@override@JsonKey() final  String inputBuffer;
// Used for scanning/typing
@override@JsonKey() final  int scannedQty;
@override@JsonKey() final  bool isTargetLocMatched;
@override@JsonKey() final  bool isBarcodeMatched;
@override@JsonKey() final  bool isSubmitting;
@override final  String? errorMessage;

/// Create a copy of PickingWizardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PickingWizardStateCopyWith<_PickingWizardState> get copyWith => __$PickingWizardStateCopyWithImpl<_PickingWizardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PickingWizardState&&(identical(other.step, step) || other.step == step)&&(identical(other.activeSO, activeSO) || other.activeSO == activeSO)&&(identical(other.currentItemIndex, currentItemIndex) || other.currentItemIndex == currentItemIndex)&&(identical(other.toteCode, toteCode) || other.toteCode == toteCode)&&(identical(other.startLoc, startLoc) || other.startLoc == startLoc)&&(identical(other.inputBuffer, inputBuffer) || other.inputBuffer == inputBuffer)&&(identical(other.scannedQty, scannedQty) || other.scannedQty == scannedQty)&&(identical(other.isTargetLocMatched, isTargetLocMatched) || other.isTargetLocMatched == isTargetLocMatched)&&(identical(other.isBarcodeMatched, isBarcodeMatched) || other.isBarcodeMatched == isBarcodeMatched)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,step,activeSO,currentItemIndex,toteCode,startLoc,inputBuffer,scannedQty,isTargetLocMatched,isBarcodeMatched,isSubmitting,errorMessage);

@override
String toString() {
  return 'PickingWizardState(step: $step, activeSO: $activeSO, currentItemIndex: $currentItemIndex, toteCode: $toteCode, startLoc: $startLoc, inputBuffer: $inputBuffer, scannedQty: $scannedQty, isTargetLocMatched: $isTargetLocMatched, isBarcodeMatched: $isBarcodeMatched, isSubmitting: $isSubmitting, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PickingWizardStateCopyWith<$Res> implements $PickingWizardStateCopyWith<$Res> {
  factory _$PickingWizardStateCopyWith(_PickingWizardState value, $Res Function(_PickingWizardState) _then) = __$PickingWizardStateCopyWithImpl;
@override @useResult
$Res call({
 PickingStep step, PickingSO? activeSO, int currentItemIndex, String toteCode, String startLoc, String inputBuffer, int scannedQty, bool isTargetLocMatched, bool isBarcodeMatched, bool isSubmitting, String? errorMessage
});


@override $PickingSOCopyWith<$Res>? get activeSO;

}
/// @nodoc
class __$PickingWizardStateCopyWithImpl<$Res>
    implements _$PickingWizardStateCopyWith<$Res> {
  __$PickingWizardStateCopyWithImpl(this._self, this._then);

  final _PickingWizardState _self;
  final $Res Function(_PickingWizardState) _then;

/// Create a copy of PickingWizardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? activeSO = freezed,Object? currentItemIndex = null,Object? toteCode = null,Object? startLoc = null,Object? inputBuffer = null,Object? scannedQty = null,Object? isTargetLocMatched = null,Object? isBarcodeMatched = null,Object? isSubmitting = null,Object? errorMessage = freezed,}) {
  return _then(_PickingWizardState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as PickingStep,activeSO: freezed == activeSO ? _self.activeSO : activeSO // ignore: cast_nullable_to_non_nullable
as PickingSO?,currentItemIndex: null == currentItemIndex ? _self.currentItemIndex : currentItemIndex // ignore: cast_nullable_to_non_nullable
as int,toteCode: null == toteCode ? _self.toteCode : toteCode // ignore: cast_nullable_to_non_nullable
as String,startLoc: null == startLoc ? _self.startLoc : startLoc // ignore: cast_nullable_to_non_nullable
as String,inputBuffer: null == inputBuffer ? _self.inputBuffer : inputBuffer // ignore: cast_nullable_to_non_nullable
as String,scannedQty: null == scannedQty ? _self.scannedQty : scannedQty // ignore: cast_nullable_to_non_nullable
as int,isTargetLocMatched: null == isTargetLocMatched ? _self.isTargetLocMatched : isTargetLocMatched // ignore: cast_nullable_to_non_nullable
as bool,isBarcodeMatched: null == isBarcodeMatched ? _self.isBarcodeMatched : isBarcodeMatched // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PickingWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PickingSOCopyWith<$Res>? get activeSO {
    if (_self.activeSO == null) {
    return null;
  }

  return $PickingSOCopyWith<$Res>(_self.activeSO!, (value) {
    return _then(_self.copyWith(activeSO: value));
  });
}
}

// dart format on
