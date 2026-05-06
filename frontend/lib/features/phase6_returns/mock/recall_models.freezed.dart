// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recall_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventoryItem {

 String get id; String get batchCode; String get location; int get quantity; InventoryStatus get status;
/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryItemCopyWith<InventoryItem> get copyWith => _$InventoryItemCopyWithImpl<InventoryItem>(this as InventoryItem, _$identity);

  /// Serializes this InventoryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.batchCode, batchCode) || other.batchCode == batchCode)&&(identical(other.location, location) || other.location == location)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,batchCode,location,quantity,status);

@override
String toString() {
  return 'InventoryItem(id: $id, batchCode: $batchCode, location: $location, quantity: $quantity, status: $status)';
}


}

/// @nodoc
abstract mixin class $InventoryItemCopyWith<$Res>  {
  factory $InventoryItemCopyWith(InventoryItem value, $Res Function(InventoryItem) _then) = _$InventoryItemCopyWithImpl;
@useResult
$Res call({
 String id, String batchCode, String location, int quantity, InventoryStatus status
});




}
/// @nodoc
class _$InventoryItemCopyWithImpl<$Res>
    implements $InventoryItemCopyWith<$Res> {
  _$InventoryItemCopyWithImpl(this._self, this._then);

  final InventoryItem _self;
  final $Res Function(InventoryItem) _then;

/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? batchCode = null,Object? location = null,Object? quantity = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,batchCode: null == batchCode ? _self.batchCode : batchCode // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InventoryStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryItem].
extension InventoryItemPatterns on InventoryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryItem value)  $default,){
final _that = this;
switch (_that) {
case _InventoryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String batchCode,  String location,  int quantity,  InventoryStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
return $default(_that.id,_that.batchCode,_that.location,_that.quantity,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String batchCode,  String location,  int quantity,  InventoryStatus status)  $default,) {final _that = this;
switch (_that) {
case _InventoryItem():
return $default(_that.id,_that.batchCode,_that.location,_that.quantity,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String batchCode,  String location,  int quantity,  InventoryStatus status)?  $default,) {final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
return $default(_that.id,_that.batchCode,_that.location,_that.quantity,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryItem implements InventoryItem {
  const _InventoryItem({required this.id, required this.batchCode, required this.location, required this.quantity, required this.status});
  factory _InventoryItem.fromJson(Map<String, dynamic> json) => _$InventoryItemFromJson(json);

@override final  String id;
@override final  String batchCode;
@override final  String location;
@override final  int quantity;
@override final  InventoryStatus status;

/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryItemCopyWith<_InventoryItem> get copyWith => __$InventoryItemCopyWithImpl<_InventoryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.batchCode, batchCode) || other.batchCode == batchCode)&&(identical(other.location, location) || other.location == location)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,batchCode,location,quantity,status);

@override
String toString() {
  return 'InventoryItem(id: $id, batchCode: $batchCode, location: $location, quantity: $quantity, status: $status)';
}


}

/// @nodoc
abstract mixin class _$InventoryItemCopyWith<$Res> implements $InventoryItemCopyWith<$Res> {
  factory _$InventoryItemCopyWith(_InventoryItem value, $Res Function(_InventoryItem) _then) = __$InventoryItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String batchCode, String location, int quantity, InventoryStatus status
});




}
/// @nodoc
class __$InventoryItemCopyWithImpl<$Res>
    implements _$InventoryItemCopyWith<$Res> {
  __$InventoryItemCopyWithImpl(this._self, this._then);

  final _InventoryItem _self;
  final $Res Function(_InventoryItem) _then;

/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? batchCode = null,Object? location = null,Object? quantity = null,Object? status = null,}) {
  return _then(_InventoryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,batchCode: null == batchCode ? _self.batchCode : batchCode // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InventoryStatus,
  ));
}


}


/// @nodoc
mixin _$ReturnItem {

 String get id; String get barcode; ReturnReason get reason; bool get isColdChain; String get assignedTote; DateTime get returnedAt;
/// Create a copy of ReturnItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnItemCopyWith<ReturnItem> get copyWith => _$ReturnItemCopyWithImpl<ReturnItem>(this as ReturnItem, _$identity);

  /// Serializes this ReturnItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnItem&&(identical(other.id, id) || other.id == id)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.isColdChain, isColdChain) || other.isColdChain == isColdChain)&&(identical(other.assignedTote, assignedTote) || other.assignedTote == assignedTote)&&(identical(other.returnedAt, returnedAt) || other.returnedAt == returnedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,barcode,reason,isColdChain,assignedTote,returnedAt);

@override
String toString() {
  return 'ReturnItem(id: $id, barcode: $barcode, reason: $reason, isColdChain: $isColdChain, assignedTote: $assignedTote, returnedAt: $returnedAt)';
}


}

/// @nodoc
abstract mixin class $ReturnItemCopyWith<$Res>  {
  factory $ReturnItemCopyWith(ReturnItem value, $Res Function(ReturnItem) _then) = _$ReturnItemCopyWithImpl;
@useResult
$Res call({
 String id, String barcode, ReturnReason reason, bool isColdChain, String assignedTote, DateTime returnedAt
});




}
/// @nodoc
class _$ReturnItemCopyWithImpl<$Res>
    implements $ReturnItemCopyWith<$Res> {
  _$ReturnItemCopyWithImpl(this._self, this._then);

  final ReturnItem _self;
  final $Res Function(ReturnItem) _then;

/// Create a copy of ReturnItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? barcode = null,Object? reason = null,Object? isColdChain = null,Object? assignedTote = null,Object? returnedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ReturnReason,isColdChain: null == isColdChain ? _self.isColdChain : isColdChain // ignore: cast_nullable_to_non_nullable
as bool,assignedTote: null == assignedTote ? _self.assignedTote : assignedTote // ignore: cast_nullable_to_non_nullable
as String,returnedAt: null == returnedAt ? _self.returnedAt : returnedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ReturnItem].
extension ReturnItemPatterns on ReturnItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReturnItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReturnItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReturnItem value)  $default,){
final _that = this;
switch (_that) {
case _ReturnItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReturnItem value)?  $default,){
final _that = this;
switch (_that) {
case _ReturnItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String barcode,  ReturnReason reason,  bool isColdChain,  String assignedTote,  DateTime returnedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReturnItem() when $default != null:
return $default(_that.id,_that.barcode,_that.reason,_that.isColdChain,_that.assignedTote,_that.returnedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String barcode,  ReturnReason reason,  bool isColdChain,  String assignedTote,  DateTime returnedAt)  $default,) {final _that = this;
switch (_that) {
case _ReturnItem():
return $default(_that.id,_that.barcode,_that.reason,_that.isColdChain,_that.assignedTote,_that.returnedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String barcode,  ReturnReason reason,  bool isColdChain,  String assignedTote,  DateTime returnedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReturnItem() when $default != null:
return $default(_that.id,_that.barcode,_that.reason,_that.isColdChain,_that.assignedTote,_that.returnedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReturnItem implements ReturnItem {
  const _ReturnItem({required this.id, required this.barcode, required this.reason, required this.isColdChain, required this.assignedTote, required this.returnedAt});
  factory _ReturnItem.fromJson(Map<String, dynamic> json) => _$ReturnItemFromJson(json);

@override final  String id;
@override final  String barcode;
@override final  ReturnReason reason;
@override final  bool isColdChain;
@override final  String assignedTote;
@override final  DateTime returnedAt;

/// Create a copy of ReturnItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReturnItemCopyWith<_ReturnItem> get copyWith => __$ReturnItemCopyWithImpl<_ReturnItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReturnItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReturnItem&&(identical(other.id, id) || other.id == id)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.isColdChain, isColdChain) || other.isColdChain == isColdChain)&&(identical(other.assignedTote, assignedTote) || other.assignedTote == assignedTote)&&(identical(other.returnedAt, returnedAt) || other.returnedAt == returnedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,barcode,reason,isColdChain,assignedTote,returnedAt);

@override
String toString() {
  return 'ReturnItem(id: $id, barcode: $barcode, reason: $reason, isColdChain: $isColdChain, assignedTote: $assignedTote, returnedAt: $returnedAt)';
}


}

/// @nodoc
abstract mixin class _$ReturnItemCopyWith<$Res> implements $ReturnItemCopyWith<$Res> {
  factory _$ReturnItemCopyWith(_ReturnItem value, $Res Function(_ReturnItem) _then) = __$ReturnItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String barcode, ReturnReason reason, bool isColdChain, String assignedTote, DateTime returnedAt
});




}
/// @nodoc
class __$ReturnItemCopyWithImpl<$Res>
    implements _$ReturnItemCopyWith<$Res> {
  __$ReturnItemCopyWithImpl(this._self, this._then);

  final _ReturnItem _self;
  final $Res Function(_ReturnItem) _then;

/// Create a copy of ReturnItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? barcode = null,Object? reason = null,Object? isColdChain = null,Object? assignedTote = null,Object? returnedAt = null,}) {
  return _then(_ReturnItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ReturnReason,isColdChain: null == isColdChain ? _self.isColdChain : isColdChain // ignore: cast_nullable_to_non_nullable
as bool,assignedTote: null == assignedTote ? _self.assignedTote : assignedTote // ignore: cast_nullable_to_non_nullable
as String,returnedAt: null == returnedAt ? _self.returnedAt : returnedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Phase6State {

 List<InventoryItem> get inventory; List<ReturnItem> get returns; bool get isRecallActive; String? get lastRecallReport;
/// Create a copy of Phase6State
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Phase6StateCopyWith<Phase6State> get copyWith => _$Phase6StateCopyWithImpl<Phase6State>(this as Phase6State, _$identity);

  /// Serializes this Phase6State to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Phase6State&&const DeepCollectionEquality().equals(other.inventory, inventory)&&const DeepCollectionEquality().equals(other.returns, returns)&&(identical(other.isRecallActive, isRecallActive) || other.isRecallActive == isRecallActive)&&(identical(other.lastRecallReport, lastRecallReport) || other.lastRecallReport == lastRecallReport));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(inventory),const DeepCollectionEquality().hash(returns),isRecallActive,lastRecallReport);

@override
String toString() {
  return 'Phase6State(inventory: $inventory, returns: $returns, isRecallActive: $isRecallActive, lastRecallReport: $lastRecallReport)';
}


}

/// @nodoc
abstract mixin class $Phase6StateCopyWith<$Res>  {
  factory $Phase6StateCopyWith(Phase6State value, $Res Function(Phase6State) _then) = _$Phase6StateCopyWithImpl;
@useResult
$Res call({
 List<InventoryItem> inventory, List<ReturnItem> returns, bool isRecallActive, String? lastRecallReport
});




}
/// @nodoc
class _$Phase6StateCopyWithImpl<$Res>
    implements $Phase6StateCopyWith<$Res> {
  _$Phase6StateCopyWithImpl(this._self, this._then);

  final Phase6State _self;
  final $Res Function(Phase6State) _then;

/// Create a copy of Phase6State
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inventory = null,Object? returns = null,Object? isRecallActive = null,Object? lastRecallReport = freezed,}) {
  return _then(_self.copyWith(
inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as List<InventoryItem>,returns: null == returns ? _self.returns : returns // ignore: cast_nullable_to_non_nullable
as List<ReturnItem>,isRecallActive: null == isRecallActive ? _self.isRecallActive : isRecallActive // ignore: cast_nullable_to_non_nullable
as bool,lastRecallReport: freezed == lastRecallReport ? _self.lastRecallReport : lastRecallReport // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Phase6State].
extension Phase6StatePatterns on Phase6State {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Phase6State value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Phase6State() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Phase6State value)  $default,){
final _that = this;
switch (_that) {
case _Phase6State():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Phase6State value)?  $default,){
final _that = this;
switch (_that) {
case _Phase6State() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<InventoryItem> inventory,  List<ReturnItem> returns,  bool isRecallActive,  String? lastRecallReport)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Phase6State() when $default != null:
return $default(_that.inventory,_that.returns,_that.isRecallActive,_that.lastRecallReport);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<InventoryItem> inventory,  List<ReturnItem> returns,  bool isRecallActive,  String? lastRecallReport)  $default,) {final _that = this;
switch (_that) {
case _Phase6State():
return $default(_that.inventory,_that.returns,_that.isRecallActive,_that.lastRecallReport);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<InventoryItem> inventory,  List<ReturnItem> returns,  bool isRecallActive,  String? lastRecallReport)?  $default,) {final _that = this;
switch (_that) {
case _Phase6State() when $default != null:
return $default(_that.inventory,_that.returns,_that.isRecallActive,_that.lastRecallReport);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Phase6State implements Phase6State {
  const _Phase6State({final  List<InventoryItem> inventory = const [], final  List<ReturnItem> returns = const [], this.isRecallActive = false, this.lastRecallReport}): _inventory = inventory,_returns = returns;
  factory _Phase6State.fromJson(Map<String, dynamic> json) => _$Phase6StateFromJson(json);

 final  List<InventoryItem> _inventory;
@override@JsonKey() List<InventoryItem> get inventory {
  if (_inventory is EqualUnmodifiableListView) return _inventory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inventory);
}

 final  List<ReturnItem> _returns;
@override@JsonKey() List<ReturnItem> get returns {
  if (_returns is EqualUnmodifiableListView) return _returns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_returns);
}

@override@JsonKey() final  bool isRecallActive;
@override final  String? lastRecallReport;

/// Create a copy of Phase6State
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Phase6StateCopyWith<_Phase6State> get copyWith => __$Phase6StateCopyWithImpl<_Phase6State>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Phase6StateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Phase6State&&const DeepCollectionEquality().equals(other._inventory, _inventory)&&const DeepCollectionEquality().equals(other._returns, _returns)&&(identical(other.isRecallActive, isRecallActive) || other.isRecallActive == isRecallActive)&&(identical(other.lastRecallReport, lastRecallReport) || other.lastRecallReport == lastRecallReport));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_inventory),const DeepCollectionEquality().hash(_returns),isRecallActive,lastRecallReport);

@override
String toString() {
  return 'Phase6State(inventory: $inventory, returns: $returns, isRecallActive: $isRecallActive, lastRecallReport: $lastRecallReport)';
}


}

/// @nodoc
abstract mixin class _$Phase6StateCopyWith<$Res> implements $Phase6StateCopyWith<$Res> {
  factory _$Phase6StateCopyWith(_Phase6State value, $Res Function(_Phase6State) _then) = __$Phase6StateCopyWithImpl;
@override @useResult
$Res call({
 List<InventoryItem> inventory, List<ReturnItem> returns, bool isRecallActive, String? lastRecallReport
});




}
/// @nodoc
class __$Phase6StateCopyWithImpl<$Res>
    implements _$Phase6StateCopyWith<$Res> {
  __$Phase6StateCopyWithImpl(this._self, this._then);

  final _Phase6State _self;
  final $Res Function(_Phase6State) _then;

/// Create a copy of Phase6State
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inventory = null,Object? returns = null,Object? isRecallActive = null,Object? lastRecallReport = freezed,}) {
  return _then(_Phase6State(
inventory: null == inventory ? _self._inventory : inventory // ignore: cast_nullable_to_non_nullable
as List<InventoryItem>,returns: null == returns ? _self._returns : returns // ignore: cast_nullable_to_non_nullable
as List<ReturnItem>,isRecallActive: null == isRecallActive ? _self.isRecallActive : isRecallActive // ignore: cast_nullable_to_non_nullable
as bool,lastRecallReport: freezed == lastRecallReport ? _self.lastRecallReport : lastRecallReport // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
