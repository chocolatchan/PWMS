// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'packing_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PackingTote {

 String get toteId; bool get hasArrived;
/// Create a copy of PackingTote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackingToteCopyWith<PackingTote> get copyWith => _$PackingToteCopyWithImpl<PackingTote>(this as PackingTote, _$identity);

  /// Serializes this PackingTote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackingTote&&(identical(other.toteId, toteId) || other.toteId == toteId)&&(identical(other.hasArrived, hasArrived) || other.hasArrived == hasArrived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,toteId,hasArrived);

@override
String toString() {
  return 'PackingTote(toteId: $toteId, hasArrived: $hasArrived)';
}


}

/// @nodoc
abstract mixin class $PackingToteCopyWith<$Res>  {
  factory $PackingToteCopyWith(PackingTote value, $Res Function(PackingTote) _then) = _$PackingToteCopyWithImpl;
@useResult
$Res call({
 String toteId, bool hasArrived
});




}
/// @nodoc
class _$PackingToteCopyWithImpl<$Res>
    implements $PackingToteCopyWith<$Res> {
  _$PackingToteCopyWithImpl(this._self, this._then);

  final PackingTote _self;
  final $Res Function(PackingTote) _then;

/// Create a copy of PackingTote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? toteId = null,Object? hasArrived = null,}) {
  return _then(_self.copyWith(
toteId: null == toteId ? _self.toteId : toteId // ignore: cast_nullable_to_non_nullable
as String,hasArrived: null == hasArrived ? _self.hasArrived : hasArrived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PackingTote].
extension PackingTotePatterns on PackingTote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackingTote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackingTote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackingTote value)  $default,){
final _that = this;
switch (_that) {
case _PackingTote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackingTote value)?  $default,){
final _that = this;
switch (_that) {
case _PackingTote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String toteId,  bool hasArrived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackingTote() when $default != null:
return $default(_that.toteId,_that.hasArrived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String toteId,  bool hasArrived)  $default,) {final _that = this;
switch (_that) {
case _PackingTote():
return $default(_that.toteId,_that.hasArrived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String toteId,  bool hasArrived)?  $default,) {final _that = this;
switch (_that) {
case _PackingTote() when $default != null:
return $default(_that.toteId,_that.hasArrived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PackingTote implements PackingTote {
  const _PackingTote({required this.toteId, this.hasArrived = false});
  factory _PackingTote.fromJson(Map<String, dynamic> json) => _$PackingToteFromJson(json);

@override final  String toteId;
@override@JsonKey() final  bool hasArrived;

/// Create a copy of PackingTote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackingToteCopyWith<_PackingTote> get copyWith => __$PackingToteCopyWithImpl<_PackingTote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackingToteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackingTote&&(identical(other.toteId, toteId) || other.toteId == toteId)&&(identical(other.hasArrived, hasArrived) || other.hasArrived == hasArrived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,toteId,hasArrived);

@override
String toString() {
  return 'PackingTote(toteId: $toteId, hasArrived: $hasArrived)';
}


}

/// @nodoc
abstract mixin class _$PackingToteCopyWith<$Res> implements $PackingToteCopyWith<$Res> {
  factory _$PackingToteCopyWith(_PackingTote value, $Res Function(_PackingTote) _then) = __$PackingToteCopyWithImpl;
@override @useResult
$Res call({
 String toteId, bool hasArrived
});




}
/// @nodoc
class __$PackingToteCopyWithImpl<$Res>
    implements _$PackingToteCopyWith<$Res> {
  __$PackingToteCopyWithImpl(this._self, this._then);

  final _PackingTote _self;
  final $Res Function(_PackingTote) _then;

/// Create a copy of PackingTote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? toteId = null,Object? hasArrived = null,}) {
  return _then(_PackingTote(
toteId: null == toteId ? _self.toteId : toteId // ignore: cast_nullable_to_non_nullable
as String,hasArrived: null == hasArrived ? _self.hasArrived : hasArrived // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PackingSO {

 String get soId; List<PackingTote> get requiredTotes; bool get isColdChain;
/// Create a copy of PackingSO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackingSOCopyWith<PackingSO> get copyWith => _$PackingSOCopyWithImpl<PackingSO>(this as PackingSO, _$identity);

  /// Serializes this PackingSO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackingSO&&(identical(other.soId, soId) || other.soId == soId)&&const DeepCollectionEquality().equals(other.requiredTotes, requiredTotes)&&(identical(other.isColdChain, isColdChain) || other.isColdChain == isColdChain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,soId,const DeepCollectionEquality().hash(requiredTotes),isColdChain);

@override
String toString() {
  return 'PackingSO(soId: $soId, requiredTotes: $requiredTotes, isColdChain: $isColdChain)';
}


}

/// @nodoc
abstract mixin class $PackingSOCopyWith<$Res>  {
  factory $PackingSOCopyWith(PackingSO value, $Res Function(PackingSO) _then) = _$PackingSOCopyWithImpl;
@useResult
$Res call({
 String soId, List<PackingTote> requiredTotes, bool isColdChain
});




}
/// @nodoc
class _$PackingSOCopyWithImpl<$Res>
    implements $PackingSOCopyWith<$Res> {
  _$PackingSOCopyWithImpl(this._self, this._then);

  final PackingSO _self;
  final $Res Function(PackingSO) _then;

/// Create a copy of PackingSO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? soId = null,Object? requiredTotes = null,Object? isColdChain = null,}) {
  return _then(_self.copyWith(
soId: null == soId ? _self.soId : soId // ignore: cast_nullable_to_non_nullable
as String,requiredTotes: null == requiredTotes ? _self.requiredTotes : requiredTotes // ignore: cast_nullable_to_non_nullable
as List<PackingTote>,isColdChain: null == isColdChain ? _self.isColdChain : isColdChain // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PackingSO].
extension PackingSOPatterns on PackingSO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackingSO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackingSO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackingSO value)  $default,){
final _that = this;
switch (_that) {
case _PackingSO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackingSO value)?  $default,){
final _that = this;
switch (_that) {
case _PackingSO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String soId,  List<PackingTote> requiredTotes,  bool isColdChain)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackingSO() when $default != null:
return $default(_that.soId,_that.requiredTotes,_that.isColdChain);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String soId,  List<PackingTote> requiredTotes,  bool isColdChain)  $default,) {final _that = this;
switch (_that) {
case _PackingSO():
return $default(_that.soId,_that.requiredTotes,_that.isColdChain);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String soId,  List<PackingTote> requiredTotes,  bool isColdChain)?  $default,) {final _that = this;
switch (_that) {
case _PackingSO() when $default != null:
return $default(_that.soId,_that.requiredTotes,_that.isColdChain);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PackingSO implements PackingSO {
  const _PackingSO({required this.soId, required final  List<PackingTote> requiredTotes, this.isColdChain = false}): _requiredTotes = requiredTotes;
  factory _PackingSO.fromJson(Map<String, dynamic> json) => _$PackingSOFromJson(json);

@override final  String soId;
 final  List<PackingTote> _requiredTotes;
@override List<PackingTote> get requiredTotes {
  if (_requiredTotes is EqualUnmodifiableListView) return _requiredTotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requiredTotes);
}

@override@JsonKey() final  bool isColdChain;

/// Create a copy of PackingSO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackingSOCopyWith<_PackingSO> get copyWith => __$PackingSOCopyWithImpl<_PackingSO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackingSOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackingSO&&(identical(other.soId, soId) || other.soId == soId)&&const DeepCollectionEquality().equals(other._requiredTotes, _requiredTotes)&&(identical(other.isColdChain, isColdChain) || other.isColdChain == isColdChain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,soId,const DeepCollectionEquality().hash(_requiredTotes),isColdChain);

@override
String toString() {
  return 'PackingSO(soId: $soId, requiredTotes: $requiredTotes, isColdChain: $isColdChain)';
}


}

/// @nodoc
abstract mixin class _$PackingSOCopyWith<$Res> implements $PackingSOCopyWith<$Res> {
  factory _$PackingSOCopyWith(_PackingSO value, $Res Function(_PackingSO) _then) = __$PackingSOCopyWithImpl;
@override @useResult
$Res call({
 String soId, List<PackingTote> requiredTotes, bool isColdChain
});




}
/// @nodoc
class __$PackingSOCopyWithImpl<$Res>
    implements _$PackingSOCopyWith<$Res> {
  __$PackingSOCopyWithImpl(this._self, this._then);

  final _PackingSO _self;
  final $Res Function(_PackingSO) _then;

/// Create a copy of PackingSO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? soId = null,Object? requiredTotes = null,Object? isColdChain = null,}) {
  return _then(_PackingSO(
soId: null == soId ? _self.soId : soId // ignore: cast_nullable_to_non_nullable
as String,requiredTotes: null == requiredTotes ? _self._requiredTotes : requiredTotes // ignore: cast_nullable_to_non_nullable
as List<PackingTote>,isColdChain: null == isColdChain ? _self.isColdChain : isColdChain // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$PackingWizardState {

 PackingStep get step; PackingSO? get activeSO;// Step-specific data
 String get soInput; List<String> get arrivedToteIds; String get sealCode; double get temperature; bool get isTempValid; bool get isSubmitting; String? get errorMessage;
/// Create a copy of PackingWizardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackingWizardStateCopyWith<PackingWizardState> get copyWith => _$PackingWizardStateCopyWithImpl<PackingWizardState>(this as PackingWizardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PackingWizardState&&(identical(other.step, step) || other.step == step)&&(identical(other.activeSO, activeSO) || other.activeSO == activeSO)&&(identical(other.soInput, soInput) || other.soInput == soInput)&&const DeepCollectionEquality().equals(other.arrivedToteIds, arrivedToteIds)&&(identical(other.sealCode, sealCode) || other.sealCode == sealCode)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.isTempValid, isTempValid) || other.isTempValid == isTempValid)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,step,activeSO,soInput,const DeepCollectionEquality().hash(arrivedToteIds),sealCode,temperature,isTempValid,isSubmitting,errorMessage);

@override
String toString() {
  return 'PackingWizardState(step: $step, activeSO: $activeSO, soInput: $soInput, arrivedToteIds: $arrivedToteIds, sealCode: $sealCode, temperature: $temperature, isTempValid: $isTempValid, isSubmitting: $isSubmitting, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PackingWizardStateCopyWith<$Res>  {
  factory $PackingWizardStateCopyWith(PackingWizardState value, $Res Function(PackingWizardState) _then) = _$PackingWizardStateCopyWithImpl;
@useResult
$Res call({
 PackingStep step, PackingSO? activeSO, String soInput, List<String> arrivedToteIds, String sealCode, double temperature, bool isTempValid, bool isSubmitting, String? errorMessage
});


$PackingSOCopyWith<$Res>? get activeSO;

}
/// @nodoc
class _$PackingWizardStateCopyWithImpl<$Res>
    implements $PackingWizardStateCopyWith<$Res> {
  _$PackingWizardStateCopyWithImpl(this._self, this._then);

  final PackingWizardState _self;
  final $Res Function(PackingWizardState) _then;

/// Create a copy of PackingWizardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? activeSO = freezed,Object? soInput = null,Object? arrivedToteIds = null,Object? sealCode = null,Object? temperature = null,Object? isTempValid = null,Object? isSubmitting = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as PackingStep,activeSO: freezed == activeSO ? _self.activeSO : activeSO // ignore: cast_nullable_to_non_nullable
as PackingSO?,soInput: null == soInput ? _self.soInput : soInput // ignore: cast_nullable_to_non_nullable
as String,arrivedToteIds: null == arrivedToteIds ? _self.arrivedToteIds : arrivedToteIds // ignore: cast_nullable_to_non_nullable
as List<String>,sealCode: null == sealCode ? _self.sealCode : sealCode // ignore: cast_nullable_to_non_nullable
as String,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,isTempValid: null == isTempValid ? _self.isTempValid : isTempValid // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PackingWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackingSOCopyWith<$Res>? get activeSO {
    if (_self.activeSO == null) {
    return null;
  }

  return $PackingSOCopyWith<$Res>(_self.activeSO!, (value) {
    return _then(_self.copyWith(activeSO: value));
  });
}
}


/// Adds pattern-matching-related methods to [PackingWizardState].
extension PackingWizardStatePatterns on PackingWizardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PackingWizardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PackingWizardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PackingWizardState value)  $default,){
final _that = this;
switch (_that) {
case _PackingWizardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PackingWizardState value)?  $default,){
final _that = this;
switch (_that) {
case _PackingWizardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PackingStep step,  PackingSO? activeSO,  String soInput,  List<String> arrivedToteIds,  String sealCode,  double temperature,  bool isTempValid,  bool isSubmitting,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PackingWizardState() when $default != null:
return $default(_that.step,_that.activeSO,_that.soInput,_that.arrivedToteIds,_that.sealCode,_that.temperature,_that.isTempValid,_that.isSubmitting,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PackingStep step,  PackingSO? activeSO,  String soInput,  List<String> arrivedToteIds,  String sealCode,  double temperature,  bool isTempValid,  bool isSubmitting,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PackingWizardState():
return $default(_that.step,_that.activeSO,_that.soInput,_that.arrivedToteIds,_that.sealCode,_that.temperature,_that.isTempValid,_that.isSubmitting,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PackingStep step,  PackingSO? activeSO,  String soInput,  List<String> arrivedToteIds,  String sealCode,  double temperature,  bool isTempValid,  bool isSubmitting,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PackingWizardState() when $default != null:
return $default(_that.step,_that.activeSO,_that.soInput,_that.arrivedToteIds,_that.sealCode,_that.temperature,_that.isTempValid,_that.isSubmitting,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PackingWizardState implements PackingWizardState {
  const _PackingWizardState({this.step = PackingStep.scanSO, this.activeSO, this.soInput = '', final  List<String> arrivedToteIds = const [], this.sealCode = '', this.temperature = 0.0, this.isTempValid = false, this.isSubmitting = false, this.errorMessage}): _arrivedToteIds = arrivedToteIds;
  

@override@JsonKey() final  PackingStep step;
@override final  PackingSO? activeSO;
// Step-specific data
@override@JsonKey() final  String soInput;
 final  List<String> _arrivedToteIds;
@override@JsonKey() List<String> get arrivedToteIds {
  if (_arrivedToteIds is EqualUnmodifiableListView) return _arrivedToteIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_arrivedToteIds);
}

@override@JsonKey() final  String sealCode;
@override@JsonKey() final  double temperature;
@override@JsonKey() final  bool isTempValid;
@override@JsonKey() final  bool isSubmitting;
@override final  String? errorMessage;

/// Create a copy of PackingWizardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackingWizardStateCopyWith<_PackingWizardState> get copyWith => __$PackingWizardStateCopyWithImpl<_PackingWizardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PackingWizardState&&(identical(other.step, step) || other.step == step)&&(identical(other.activeSO, activeSO) || other.activeSO == activeSO)&&(identical(other.soInput, soInput) || other.soInput == soInput)&&const DeepCollectionEquality().equals(other._arrivedToteIds, _arrivedToteIds)&&(identical(other.sealCode, sealCode) || other.sealCode == sealCode)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.isTempValid, isTempValid) || other.isTempValid == isTempValid)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,step,activeSO,soInput,const DeepCollectionEquality().hash(_arrivedToteIds),sealCode,temperature,isTempValid,isSubmitting,errorMessage);

@override
String toString() {
  return 'PackingWizardState(step: $step, activeSO: $activeSO, soInput: $soInput, arrivedToteIds: $arrivedToteIds, sealCode: $sealCode, temperature: $temperature, isTempValid: $isTempValid, isSubmitting: $isSubmitting, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PackingWizardStateCopyWith<$Res> implements $PackingWizardStateCopyWith<$Res> {
  factory _$PackingWizardStateCopyWith(_PackingWizardState value, $Res Function(_PackingWizardState) _then) = __$PackingWizardStateCopyWithImpl;
@override @useResult
$Res call({
 PackingStep step, PackingSO? activeSO, String soInput, List<String> arrivedToteIds, String sealCode, double temperature, bool isTempValid, bool isSubmitting, String? errorMessage
});


@override $PackingSOCopyWith<$Res>? get activeSO;

}
/// @nodoc
class __$PackingWizardStateCopyWithImpl<$Res>
    implements _$PackingWizardStateCopyWith<$Res> {
  __$PackingWizardStateCopyWithImpl(this._self, this._then);

  final _PackingWizardState _self;
  final $Res Function(_PackingWizardState) _then;

/// Create a copy of PackingWizardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? activeSO = freezed,Object? soInput = null,Object? arrivedToteIds = null,Object? sealCode = null,Object? temperature = null,Object? isTempValid = null,Object? isSubmitting = null,Object? errorMessage = freezed,}) {
  return _then(_PackingWizardState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as PackingStep,activeSO: freezed == activeSO ? _self.activeSO : activeSO // ignore: cast_nullable_to_non_nullable
as PackingSO?,soInput: null == soInput ? _self.soInput : soInput // ignore: cast_nullable_to_non_nullable
as String,arrivedToteIds: null == arrivedToteIds ? _self._arrivedToteIds : arrivedToteIds // ignore: cast_nullable_to_non_nullable
as List<String>,sealCode: null == sealCode ? _self.sealCode : sealCode // ignore: cast_nullable_to_non_nullable
as String,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,isTempValid: null == isTempValid ? _self.isTempValid : isTempValid // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PackingWizardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PackingSOCopyWith<$Res>? get activeSO {
    if (_self.activeSO == null) {
    return null;
  }

  return $PackingSOCopyWith<$Res>(_self.activeSO!, (value) {
    return _then(_self.copyWith(activeSO: value));
  });
}
}

// dart format on
