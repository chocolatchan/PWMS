// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbound_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InboundDraft _$InboundDraftFromJson(Map<String, dynamic> json) {
  return _InboundDraft.fromJson(json);
}

/// @nodoc
mixin _$InboundDraft {
  int get step => throw _privateConstructorUsedError;
  String? get poNumber => throw _privateConstructorUsedError;
  String? get sealNumber => throw _privateConstructorUsedError;
  double? get arrivalTemperature => throw _privateConstructorUsedError;
  List<BatchPayload> get batches => throw _privateConstructorUsedError;

  /// Serializes this InboundDraft to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InboundDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InboundDraftCopyWith<InboundDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InboundDraftCopyWith<$Res> {
  factory $InboundDraftCopyWith(
    InboundDraft value,
    $Res Function(InboundDraft) then,
  ) = _$InboundDraftCopyWithImpl<$Res, InboundDraft>;
  @useResult
  $Res call({
    int step,
    String? poNumber,
    String? sealNumber,
    double? arrivalTemperature,
    List<BatchPayload> batches,
  });
}

/// @nodoc
class _$InboundDraftCopyWithImpl<$Res, $Val extends InboundDraft>
    implements $InboundDraftCopyWith<$Res> {
  _$InboundDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InboundDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? poNumber = freezed,
    Object? sealNumber = freezed,
    Object? arrivalTemperature = freezed,
    Object? batches = null,
  }) {
    return _then(
      _value.copyWith(
            step: null == step
                ? _value.step
                : step // ignore: cast_nullable_to_non_nullable
                      as int,
            poNumber: freezed == poNumber
                ? _value.poNumber
                : poNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            sealNumber: freezed == sealNumber
                ? _value.sealNumber
                : sealNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            arrivalTemperature: freezed == arrivalTemperature
                ? _value.arrivalTemperature
                : arrivalTemperature // ignore: cast_nullable_to_non_nullable
                      as double?,
            batches: null == batches
                ? _value.batches
                : batches // ignore: cast_nullable_to_non_nullable
                      as List<BatchPayload>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InboundDraftImplCopyWith<$Res>
    implements $InboundDraftCopyWith<$Res> {
  factory _$$InboundDraftImplCopyWith(
    _$InboundDraftImpl value,
    $Res Function(_$InboundDraftImpl) then,
  ) = __$$InboundDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int step,
    String? poNumber,
    String? sealNumber,
    double? arrivalTemperature,
    List<BatchPayload> batches,
  });
}

/// @nodoc
class __$$InboundDraftImplCopyWithImpl<$Res>
    extends _$InboundDraftCopyWithImpl<$Res, _$InboundDraftImpl>
    implements _$$InboundDraftImplCopyWith<$Res> {
  __$$InboundDraftImplCopyWithImpl(
    _$InboundDraftImpl _value,
    $Res Function(_$InboundDraftImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InboundDraft
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? poNumber = freezed,
    Object? sealNumber = freezed,
    Object? arrivalTemperature = freezed,
    Object? batches = null,
  }) {
    return _then(
      _$InboundDraftImpl(
        step: null == step
            ? _value.step
            : step // ignore: cast_nullable_to_non_nullable
                  as int,
        poNumber: freezed == poNumber
            ? _value.poNumber
            : poNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        sealNumber: freezed == sealNumber
            ? _value.sealNumber
            : sealNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        arrivalTemperature: freezed == arrivalTemperature
            ? _value.arrivalTemperature
            : arrivalTemperature // ignore: cast_nullable_to_non_nullable
                  as double?,
        batches: null == batches
            ? _value._batches
            : batches // ignore: cast_nullable_to_non_nullable
                  as List<BatchPayload>,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$InboundDraftImpl implements _InboundDraft {
  const _$InboundDraftImpl({
    this.step = 0,
    this.poNumber,
    this.sealNumber,
    this.arrivalTemperature,
    final List<BatchPayload> batches = const [],
  }) : _batches = batches;

  factory _$InboundDraftImpl.fromJson(Map<String, dynamic> json) =>
      _$$InboundDraftImplFromJson(json);

  @override
  @JsonKey()
  final int step;
  @override
  final String? poNumber;
  @override
  final String? sealNumber;
  @override
  final double? arrivalTemperature;
  final List<BatchPayload> _batches;
  @override
  @JsonKey()
  List<BatchPayload> get batches {
    if (_batches is EqualUnmodifiableListView) return _batches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_batches);
  }

  @override
  String toString() {
    return 'InboundDraft(step: $step, poNumber: $poNumber, sealNumber: $sealNumber, arrivalTemperature: $arrivalTemperature, batches: $batches)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InboundDraftImpl &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber) &&
            (identical(other.sealNumber, sealNumber) ||
                other.sealNumber == sealNumber) &&
            (identical(other.arrivalTemperature, arrivalTemperature) ||
                other.arrivalTemperature == arrivalTemperature) &&
            const DeepCollectionEquality().equals(other._batches, _batches));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    step,
    poNumber,
    sealNumber,
    arrivalTemperature,
    const DeepCollectionEquality().hash(_batches),
  );

  /// Create a copy of InboundDraft
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InboundDraftImplCopyWith<_$InboundDraftImpl> get copyWith =>
      __$$InboundDraftImplCopyWithImpl<_$InboundDraftImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InboundDraftImplToJson(this);
  }
}

abstract class _InboundDraft implements InboundDraft {
  const factory _InboundDraft({
    final int step,
    final String? poNumber,
    final String? sealNumber,
    final double? arrivalTemperature,
    final List<BatchPayload> batches,
  }) = _$InboundDraftImpl;

  factory _InboundDraft.fromJson(Map<String, dynamic> json) =
      _$InboundDraftImpl.fromJson;

  @override
  int get step;
  @override
  String? get poNumber;
  @override
  String? get sealNumber;
  @override
  double? get arrivalTemperature;
  @override
  List<BatchPayload> get batches;

  /// Create a copy of InboundDraft
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InboundDraftImplCopyWith<_$InboundDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
