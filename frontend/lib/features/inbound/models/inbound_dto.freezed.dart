// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inbound_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BatchPayload _$BatchPayloadFromJson(Map<String, dynamic> json) {
  return _BatchPayload.fromJson(json);
}

/// @nodoc
mixin _$BatchPayload {
  String get productId => throw _privateConstructorUsedError;
  String get batchNumber => throw _privateConstructorUsedError;
  int get expectedQty => throw _privateConstructorUsedError;
  int get actualQty => throw _privateConstructorUsedError;

  /// Serializes this BatchPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BatchPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BatchPayloadCopyWith<BatchPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchPayloadCopyWith<$Res> {
  factory $BatchPayloadCopyWith(
    BatchPayload value,
    $Res Function(BatchPayload) then,
  ) = _$BatchPayloadCopyWithImpl<$Res, BatchPayload>;
  @useResult
  $Res call({
    String productId,
    String batchNumber,
    int expectedQty,
    int actualQty,
  });
}

/// @nodoc
class _$BatchPayloadCopyWithImpl<$Res, $Val extends BatchPayload>
    implements $BatchPayloadCopyWith<$Res> {
  _$BatchPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BatchPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? batchNumber = null,
    Object? expectedQty = null,
    Object? actualQty = null,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            batchNumber: null == batchNumber
                ? _value.batchNumber
                : batchNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            expectedQty: null == expectedQty
                ? _value.expectedQty
                : expectedQty // ignore: cast_nullable_to_non_nullable
                      as int,
            actualQty: null == actualQty
                ? _value.actualQty
                : actualQty // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BatchPayloadImplCopyWith<$Res>
    implements $BatchPayloadCopyWith<$Res> {
  factory _$$BatchPayloadImplCopyWith(
    _$BatchPayloadImpl value,
    $Res Function(_$BatchPayloadImpl) then,
  ) = __$$BatchPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String productId,
    String batchNumber,
    int expectedQty,
    int actualQty,
  });
}

/// @nodoc
class __$$BatchPayloadImplCopyWithImpl<$Res>
    extends _$BatchPayloadCopyWithImpl<$Res, _$BatchPayloadImpl>
    implements _$$BatchPayloadImplCopyWith<$Res> {
  __$$BatchPayloadImplCopyWithImpl(
    _$BatchPayloadImpl _value,
    $Res Function(_$BatchPayloadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BatchPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? batchNumber = null,
    Object? expectedQty = null,
    Object? actualQty = null,
  }) {
    return _then(
      _$BatchPayloadImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        batchNumber: null == batchNumber
            ? _value.batchNumber
            : batchNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        expectedQty: null == expectedQty
            ? _value.expectedQty
            : expectedQty // ignore: cast_nullable_to_non_nullable
                  as int,
        actualQty: null == actualQty
            ? _value.actualQty
            : actualQty // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$BatchPayloadImpl implements _BatchPayload {
  const _$BatchPayloadImpl({
    required this.productId,
    required this.batchNumber,
    required this.expectedQty,
    required this.actualQty,
  });

  factory _$BatchPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$BatchPayloadImplFromJson(json);

  @override
  final String productId;
  @override
  final String batchNumber;
  @override
  final int expectedQty;
  @override
  final int actualQty;

  @override
  String toString() {
    return 'BatchPayload(productId: $productId, batchNumber: $batchNumber, expectedQty: $expectedQty, actualQty: $actualQty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchPayloadImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.batchNumber, batchNumber) ||
                other.batchNumber == batchNumber) &&
            (identical(other.expectedQty, expectedQty) ||
                other.expectedQty == expectedQty) &&
            (identical(other.actualQty, actualQty) ||
                other.actualQty == actualQty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, productId, batchNumber, expectedQty, actualQty);

  /// Create a copy of BatchPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchPayloadImplCopyWith<_$BatchPayloadImpl> get copyWith =>
      __$$BatchPayloadImplCopyWithImpl<_$BatchPayloadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchPayloadImplToJson(this);
  }
}

abstract class _BatchPayload implements BatchPayload {
  const factory _BatchPayload({
    required final String productId,
    required final String batchNumber,
    required final int expectedQty,
    required final int actualQty,
  }) = _$BatchPayloadImpl;

  factory _BatchPayload.fromJson(Map<String, dynamic> json) =
      _$BatchPayloadImpl.fromJson;

  @override
  String get productId;
  @override
  String get batchNumber;
  @override
  int get expectedQty;
  @override
  int get actualQty;

  /// Create a copy of BatchPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BatchPayloadImplCopyWith<_$BatchPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReceiveInboundReq _$ReceiveInboundReqFromJson(Map<String, dynamic> json) {
  return _ReceiveInboundReq.fromJson(json);
}

/// @nodoc
mixin _$ReceiveInboundReq {
  String get poNumber => throw _privateConstructorUsedError;
  String? get vehicleSealNumber => throw _privateConstructorUsedError;
  double? get arrivalTemperature => throw _privateConstructorUsedError;
  List<BatchPayload> get batches => throw _privateConstructorUsedError;

  /// Serializes this ReceiveInboundReq to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReceiveInboundReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceiveInboundReqCopyWith<ReceiveInboundReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceiveInboundReqCopyWith<$Res> {
  factory $ReceiveInboundReqCopyWith(
    ReceiveInboundReq value,
    $Res Function(ReceiveInboundReq) then,
  ) = _$ReceiveInboundReqCopyWithImpl<$Res, ReceiveInboundReq>;
  @useResult
  $Res call({
    String poNumber,
    String? vehicleSealNumber,
    double? arrivalTemperature,
    List<BatchPayload> batches,
  });
}

/// @nodoc
class _$ReceiveInboundReqCopyWithImpl<$Res, $Val extends ReceiveInboundReq>
    implements $ReceiveInboundReqCopyWith<$Res> {
  _$ReceiveInboundReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReceiveInboundReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poNumber = null,
    Object? vehicleSealNumber = freezed,
    Object? arrivalTemperature = freezed,
    Object? batches = null,
  }) {
    return _then(
      _value.copyWith(
            poNumber: null == poNumber
                ? _value.poNumber
                : poNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            vehicleSealNumber: freezed == vehicleSealNumber
                ? _value.vehicleSealNumber
                : vehicleSealNumber // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ReceiveInboundReqImplCopyWith<$Res>
    implements $ReceiveInboundReqCopyWith<$Res> {
  factory _$$ReceiveInboundReqImplCopyWith(
    _$ReceiveInboundReqImpl value,
    $Res Function(_$ReceiveInboundReqImpl) then,
  ) = __$$ReceiveInboundReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String poNumber,
    String? vehicleSealNumber,
    double? arrivalTemperature,
    List<BatchPayload> batches,
  });
}

/// @nodoc
class __$$ReceiveInboundReqImplCopyWithImpl<$Res>
    extends _$ReceiveInboundReqCopyWithImpl<$Res, _$ReceiveInboundReqImpl>
    implements _$$ReceiveInboundReqImplCopyWith<$Res> {
  __$$ReceiveInboundReqImplCopyWithImpl(
    _$ReceiveInboundReqImpl _value,
    $Res Function(_$ReceiveInboundReqImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReceiveInboundReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poNumber = null,
    Object? vehicleSealNumber = freezed,
    Object? arrivalTemperature = freezed,
    Object? batches = null,
  }) {
    return _then(
      _$ReceiveInboundReqImpl(
        poNumber: null == poNumber
            ? _value.poNumber
            : poNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        vehicleSealNumber: freezed == vehicleSealNumber
            ? _value.vehicleSealNumber
            : vehicleSealNumber // ignore: cast_nullable_to_non_nullable
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
class _$ReceiveInboundReqImpl implements _ReceiveInboundReq {
  const _$ReceiveInboundReqImpl({
    required this.poNumber,
    this.vehicleSealNumber,
    this.arrivalTemperature,
    required final List<BatchPayload> batches,
  }) : _batches = batches;

  factory _$ReceiveInboundReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceiveInboundReqImplFromJson(json);

  @override
  final String poNumber;
  @override
  final String? vehicleSealNumber;
  @override
  final double? arrivalTemperature;
  final List<BatchPayload> _batches;
  @override
  List<BatchPayload> get batches {
    if (_batches is EqualUnmodifiableListView) return _batches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_batches);
  }

  @override
  String toString() {
    return 'ReceiveInboundReq(poNumber: $poNumber, vehicleSealNumber: $vehicleSealNumber, arrivalTemperature: $arrivalTemperature, batches: $batches)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiveInboundReqImpl &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber) &&
            (identical(other.vehicleSealNumber, vehicleSealNumber) ||
                other.vehicleSealNumber == vehicleSealNumber) &&
            (identical(other.arrivalTemperature, arrivalTemperature) ||
                other.arrivalTemperature == arrivalTemperature) &&
            const DeepCollectionEquality().equals(other._batches, _batches));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    poNumber,
    vehicleSealNumber,
    arrivalTemperature,
    const DeepCollectionEquality().hash(_batches),
  );

  /// Create a copy of ReceiveInboundReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiveInboundReqImplCopyWith<_$ReceiveInboundReqImpl> get copyWith =>
      __$$ReceiveInboundReqImplCopyWithImpl<_$ReceiveInboundReqImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceiveInboundReqImplToJson(this);
  }
}

abstract class _ReceiveInboundReq implements ReceiveInboundReq {
  const factory _ReceiveInboundReq({
    required final String poNumber,
    final String? vehicleSealNumber,
    final double? arrivalTemperature,
    required final List<BatchPayload> batches,
  }) = _$ReceiveInboundReqImpl;

  factory _ReceiveInboundReq.fromJson(Map<String, dynamic> json) =
      _$ReceiveInboundReqImpl.fromJson;

  @override
  String get poNumber;
  @override
  String? get vehicleSealNumber;
  @override
  double? get arrivalTemperature;
  @override
  List<BatchPayload> get batches;

  /// Create a copy of ReceiveInboundReq
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceiveInboundReqImplCopyWith<_$ReceiveInboundReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubmitQcReq _$SubmitQcReqFromJson(Map<String, dynamic> json) {
  return _SubmitQcReq.fromJson(json);
}

/// @nodoc
mixin _$SubmitQcReq {
  String get inboundBatchId => throw _privateConstructorUsedError;
  String get qaStaffId => throw _privateConstructorUsedError;
  double? get minTemp => throw _privateConstructorUsedError;
  double? get maxTemp => throw _privateConstructorUsedError;
  String get decision => throw _privateConstructorUsedError;

  /// Serializes this SubmitQcReq to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubmitQcReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubmitQcReqCopyWith<SubmitQcReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitQcReqCopyWith<$Res> {
  factory $SubmitQcReqCopyWith(
    SubmitQcReq value,
    $Res Function(SubmitQcReq) then,
  ) = _$SubmitQcReqCopyWithImpl<$Res, SubmitQcReq>;
  @useResult
  $Res call({
    String inboundBatchId,
    String qaStaffId,
    double? minTemp,
    double? maxTemp,
    String decision,
  });
}

/// @nodoc
class _$SubmitQcReqCopyWithImpl<$Res, $Val extends SubmitQcReq>
    implements $SubmitQcReqCopyWith<$Res> {
  _$SubmitQcReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubmitQcReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inboundBatchId = null,
    Object? qaStaffId = null,
    Object? minTemp = freezed,
    Object? maxTemp = freezed,
    Object? decision = null,
  }) {
    return _then(
      _value.copyWith(
            inboundBatchId: null == inboundBatchId
                ? _value.inboundBatchId
                : inboundBatchId // ignore: cast_nullable_to_non_nullable
                      as String,
            qaStaffId: null == qaStaffId
                ? _value.qaStaffId
                : qaStaffId // ignore: cast_nullable_to_non_nullable
                      as String,
            minTemp: freezed == minTemp
                ? _value.minTemp
                : minTemp // ignore: cast_nullable_to_non_nullable
                      as double?,
            maxTemp: freezed == maxTemp
                ? _value.maxTemp
                : maxTemp // ignore: cast_nullable_to_non_nullable
                      as double?,
            decision: null == decision
                ? _value.decision
                : decision // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubmitQcReqImplCopyWith<$Res>
    implements $SubmitQcReqCopyWith<$Res> {
  factory _$$SubmitQcReqImplCopyWith(
    _$SubmitQcReqImpl value,
    $Res Function(_$SubmitQcReqImpl) then,
  ) = __$$SubmitQcReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String inboundBatchId,
    String qaStaffId,
    double? minTemp,
    double? maxTemp,
    String decision,
  });
}

/// @nodoc
class __$$SubmitQcReqImplCopyWithImpl<$Res>
    extends _$SubmitQcReqCopyWithImpl<$Res, _$SubmitQcReqImpl>
    implements _$$SubmitQcReqImplCopyWith<$Res> {
  __$$SubmitQcReqImplCopyWithImpl(
    _$SubmitQcReqImpl _value,
    $Res Function(_$SubmitQcReqImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubmitQcReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inboundBatchId = null,
    Object? qaStaffId = null,
    Object? minTemp = freezed,
    Object? maxTemp = freezed,
    Object? decision = null,
  }) {
    return _then(
      _$SubmitQcReqImpl(
        inboundBatchId: null == inboundBatchId
            ? _value.inboundBatchId
            : inboundBatchId // ignore: cast_nullable_to_non_nullable
                  as String,
        qaStaffId: null == qaStaffId
            ? _value.qaStaffId
            : qaStaffId // ignore: cast_nullable_to_non_nullable
                  as String,
        minTemp: freezed == minTemp
            ? _value.minTemp
            : minTemp // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxTemp: freezed == maxTemp
            ? _value.maxTemp
            : maxTemp // ignore: cast_nullable_to_non_nullable
                  as double?,
        decision: null == decision
            ? _value.decision
            : decision // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$SubmitQcReqImpl implements _SubmitQcReq {
  const _$SubmitQcReqImpl({
    required this.inboundBatchId,
    required this.qaStaffId,
    this.minTemp,
    this.maxTemp,
    required this.decision,
  });

  factory _$SubmitQcReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmitQcReqImplFromJson(json);

  @override
  final String inboundBatchId;
  @override
  final String qaStaffId;
  @override
  final double? minTemp;
  @override
  final double? maxTemp;
  @override
  final String decision;

  @override
  String toString() {
    return 'SubmitQcReq(inboundBatchId: $inboundBatchId, qaStaffId: $qaStaffId, minTemp: $minTemp, maxTemp: $maxTemp, decision: $decision)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitQcReqImpl &&
            (identical(other.inboundBatchId, inboundBatchId) ||
                other.inboundBatchId == inboundBatchId) &&
            (identical(other.qaStaffId, qaStaffId) ||
                other.qaStaffId == qaStaffId) &&
            (identical(other.minTemp, minTemp) || other.minTemp == minTemp) &&
            (identical(other.maxTemp, maxTemp) || other.maxTemp == maxTemp) &&
            (identical(other.decision, decision) ||
                other.decision == decision));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    inboundBatchId,
    qaStaffId,
    minTemp,
    maxTemp,
    decision,
  );

  /// Create a copy of SubmitQcReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitQcReqImplCopyWith<_$SubmitQcReqImpl> get copyWith =>
      __$$SubmitQcReqImplCopyWithImpl<_$SubmitQcReqImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmitQcReqImplToJson(this);
  }
}

abstract class _SubmitQcReq implements SubmitQcReq {
  const factory _SubmitQcReq({
    required final String inboundBatchId,
    required final String qaStaffId,
    final double? minTemp,
    final double? maxTemp,
    required final String decision,
  }) = _$SubmitQcReqImpl;

  factory _SubmitQcReq.fromJson(Map<String, dynamic> json) =
      _$SubmitQcReqImpl.fromJson;

  @override
  String get inboundBatchId;
  @override
  String get qaStaffId;
  @override
  double? get minTemp;
  @override
  double? get maxTemp;
  @override
  String get decision;

  /// Create a copy of SubmitQcReq
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmitQcReqImplCopyWith<_$SubmitQcReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
