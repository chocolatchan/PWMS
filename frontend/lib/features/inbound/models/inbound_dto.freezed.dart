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

PoItemDto _$PoItemDtoFromJson(Map<String, dynamic> json) {
  return _PoItemDto.fromJson(json);
}

/// @nodoc
mixin _$PoItemDto {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get expectedQty => throw _privateConstructorUsedError;
  int get receivedQty => throw _privateConstructorUsedError;

  /// Serializes this PoItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PoItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoItemDtoCopyWith<PoItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoItemDtoCopyWith<$Res> {
  factory $PoItemDtoCopyWith(PoItemDto value, $Res Function(PoItemDto) then) =
      _$PoItemDtoCopyWithImpl<$Res, PoItemDto>;
  @useResult
  $Res call({
    String productId,
    String productName,
    int expectedQty,
    int receivedQty,
  });
}

/// @nodoc
class _$PoItemDtoCopyWithImpl<$Res, $Val extends PoItemDto>
    implements $PoItemDtoCopyWith<$Res> {
  _$PoItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? expectedQty = null,
    Object? receivedQty = null,
  }) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            expectedQty: null == expectedQty
                ? _value.expectedQty
                : expectedQty // ignore: cast_nullable_to_non_nullable
                      as int,
            receivedQty: null == receivedQty
                ? _value.receivedQty
                : receivedQty // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PoItemDtoImplCopyWith<$Res>
    implements $PoItemDtoCopyWith<$Res> {
  factory _$$PoItemDtoImplCopyWith(
    _$PoItemDtoImpl value,
    $Res Function(_$PoItemDtoImpl) then,
  ) = __$$PoItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String productId,
    String productName,
    int expectedQty,
    int receivedQty,
  });
}

/// @nodoc
class __$$PoItemDtoImplCopyWithImpl<$Res>
    extends _$PoItemDtoCopyWithImpl<$Res, _$PoItemDtoImpl>
    implements _$$PoItemDtoImplCopyWith<$Res> {
  __$$PoItemDtoImplCopyWithImpl(
    _$PoItemDtoImpl _value,
    $Res Function(_$PoItemDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? expectedQty = null,
    Object? receivedQty = null,
  }) {
    return _then(
      _$PoItemDtoImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        expectedQty: null == expectedQty
            ? _value.expectedQty
            : expectedQty // ignore: cast_nullable_to_non_nullable
                  as int,
        receivedQty: null == receivedQty
            ? _value.receivedQty
            : receivedQty // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$PoItemDtoImpl implements _PoItemDto {
  const _$PoItemDtoImpl({
    required this.productId,
    required this.productName,
    required this.expectedQty,
    required this.receivedQty,
  });

  factory _$PoItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoItemDtoImplFromJson(json);

  @override
  final String productId;
  @override
  final String productName;
  @override
  final int expectedQty;
  @override
  final int receivedQty;

  @override
  String toString() {
    return 'PoItemDto(productId: $productId, productName: $productName, expectedQty: $expectedQty, receivedQty: $receivedQty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoItemDtoImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.expectedQty, expectedQty) ||
                other.expectedQty == expectedQty) &&
            (identical(other.receivedQty, receivedQty) ||
                other.receivedQty == receivedQty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    productName,
    expectedQty,
    receivedQty,
  );

  /// Create a copy of PoItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoItemDtoImplCopyWith<_$PoItemDtoImpl> get copyWith =>
      __$$PoItemDtoImplCopyWithImpl<_$PoItemDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoItemDtoImplToJson(this);
  }
}

abstract class _PoItemDto implements PoItemDto {
  const factory _PoItemDto({
    required final String productId,
    required final String productName,
    required final int expectedQty,
    required final int receivedQty,
  }) = _$PoItemDtoImpl;

  factory _PoItemDto.fromJson(Map<String, dynamic> json) =
      _$PoItemDtoImpl.fromJson;

  @override
  String get productId;
  @override
  String get productName;
  @override
  int get expectedQty;
  @override
  int get receivedQty;

  /// Create a copy of PoItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoItemDtoImplCopyWith<_$PoItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PoDetailsResponse _$PoDetailsResponseFromJson(Map<String, dynamic> json) {
  return _PoDetailsResponse.fromJson(json);
}

/// @nodoc
mixin _$PoDetailsResponse {
  String get poNumber => throw _privateConstructorUsedError;
  String? get vendorName => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<PoItemDto> get items => throw _privateConstructorUsedError;

  /// Serializes this PoDetailsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PoDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoDetailsResponseCopyWith<PoDetailsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoDetailsResponseCopyWith<$Res> {
  factory $PoDetailsResponseCopyWith(
    PoDetailsResponse value,
    $Res Function(PoDetailsResponse) then,
  ) = _$PoDetailsResponseCopyWithImpl<$Res, PoDetailsResponse>;
  @useResult
  $Res call({
    String poNumber,
    String? vendorName,
    String status,
    List<PoItemDto> items,
  });
}

/// @nodoc
class _$PoDetailsResponseCopyWithImpl<$Res, $Val extends PoDetailsResponse>
    implements $PoDetailsResponseCopyWith<$Res> {
  _$PoDetailsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poNumber = null,
    Object? vendorName = freezed,
    Object? status = null,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            poNumber: null == poNumber
                ? _value.poNumber
                : poNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            vendorName: freezed == vendorName
                ? _value.vendorName
                : vendorName // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<PoItemDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PoDetailsResponseImplCopyWith<$Res>
    implements $PoDetailsResponseCopyWith<$Res> {
  factory _$$PoDetailsResponseImplCopyWith(
    _$PoDetailsResponseImpl value,
    $Res Function(_$PoDetailsResponseImpl) then,
  ) = __$$PoDetailsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String poNumber,
    String? vendorName,
    String status,
    List<PoItemDto> items,
  });
}

/// @nodoc
class __$$PoDetailsResponseImplCopyWithImpl<$Res>
    extends _$PoDetailsResponseCopyWithImpl<$Res, _$PoDetailsResponseImpl>
    implements _$$PoDetailsResponseImplCopyWith<$Res> {
  __$$PoDetailsResponseImplCopyWithImpl(
    _$PoDetailsResponseImpl _value,
    $Res Function(_$PoDetailsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poNumber = null,
    Object? vendorName = freezed,
    Object? status = null,
    Object? items = null,
  }) {
    return _then(
      _$PoDetailsResponseImpl(
        poNumber: null == poNumber
            ? _value.poNumber
            : poNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        vendorName: freezed == vendorName
            ? _value.vendorName
            : vendorName // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<PoItemDto>,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$PoDetailsResponseImpl implements _PoDetailsResponse {
  const _$PoDetailsResponseImpl({
    required this.poNumber,
    this.vendorName,
    required this.status,
    required final List<PoItemDto> items,
  }) : _items = items;

  factory _$PoDetailsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoDetailsResponseImplFromJson(json);

  @override
  final String poNumber;
  @override
  final String? vendorName;
  @override
  final String status;
  final List<PoItemDto> _items;
  @override
  List<PoItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PoDetailsResponse(poNumber: $poNumber, vendorName: $vendorName, status: $status, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoDetailsResponseImpl &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber) &&
            (identical(other.vendorName, vendorName) ||
                other.vendorName == vendorName) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    poNumber,
    vendorName,
    status,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of PoDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoDetailsResponseImplCopyWith<_$PoDetailsResponseImpl> get copyWith =>
      __$$PoDetailsResponseImplCopyWithImpl<_$PoDetailsResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PoDetailsResponseImplToJson(this);
  }
}

abstract class _PoDetailsResponse implements PoDetailsResponse {
  const factory _PoDetailsResponse({
    required final String poNumber,
    final String? vendorName,
    required final String status,
    required final List<PoItemDto> items,
  }) = _$PoDetailsResponseImpl;

  factory _PoDetailsResponse.fromJson(Map<String, dynamic> json) =
      _$PoDetailsResponseImpl.fromJson;

  @override
  String get poNumber;
  @override
  String? get vendorName;
  @override
  String get status;
  @override
  List<PoItemDto> get items;

  /// Create a copy of PoDetailsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoDetailsResponseImplCopyWith<_$PoDetailsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BatchPayload _$BatchPayloadFromJson(Map<String, dynamic> json) {
  return _BatchPayload.fromJson(json);
}

/// @nodoc
mixin _$BatchPayload {
  String get productId => throw _privateConstructorUsedError;
  String get batchNumber => throw _privateConstructorUsedError;
  @JsonKey(toJson: _dateToJson)
  DateTime get expiryDate => throw _privateConstructorUsedError;
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
    @JsonKey(toJson: _dateToJson) DateTime expiryDate,
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
    Object? expiryDate = null,
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
            expiryDate: null == expiryDate
                ? _value.expiryDate
                : expiryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
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
    @JsonKey(toJson: _dateToJson) DateTime expiryDate,
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
    Object? expiryDate = null,
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
        expiryDate: null == expiryDate
            ? _value.expiryDate
            : expiryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
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
    @JsonKey(toJson: _dateToJson) required this.expiryDate,
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
  @JsonKey(toJson: _dateToJson)
  final DateTime expiryDate;
  @override
  final int expectedQty;
  @override
  final int actualQty;

  @override
  String toString() {
    return 'BatchPayload(productId: $productId, batchNumber: $batchNumber, expiryDate: $expiryDate, expectedQty: $expectedQty, actualQty: $actualQty)';
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
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.expectedQty, expectedQty) ||
                other.expectedQty == expectedQty) &&
            (identical(other.actualQty, actualQty) ||
                other.actualQty == actualQty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    productId,
    batchNumber,
    expiryDate,
    expectedQty,
    actualQty,
  );

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
    @JsonKey(toJson: _dateToJson) required final DateTime expiryDate,
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
  @JsonKey(toJson: _dateToJson)
  DateTime get expiryDate;
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
  String get batchNumber => throw _privateConstructorUsedError;
  double? get minTemp => throw _privateConstructorUsedError;
  double? get maxTemp => throw _privateConstructorUsedError;
  String? get deviationReportId => throw _privateConstructorUsedError;
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
    String batchNumber,
    double? minTemp,
    double? maxTemp,
    String? deviationReportId,
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
    Object? batchNumber = null,
    Object? minTemp = freezed,
    Object? maxTemp = freezed,
    Object? deviationReportId = freezed,
    Object? decision = null,
  }) {
    return _then(
      _value.copyWith(
            batchNumber: null == batchNumber
                ? _value.batchNumber
                : batchNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            minTemp: freezed == minTemp
                ? _value.minTemp
                : minTemp // ignore: cast_nullable_to_non_nullable
                      as double?,
            maxTemp: freezed == maxTemp
                ? _value.maxTemp
                : maxTemp // ignore: cast_nullable_to_non_nullable
                      as double?,
            deviationReportId: freezed == deviationReportId
                ? _value.deviationReportId
                : deviationReportId // ignore: cast_nullable_to_non_nullable
                      as String?,
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
    String batchNumber,
    double? minTemp,
    double? maxTemp,
    String? deviationReportId,
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
    Object? batchNumber = null,
    Object? minTemp = freezed,
    Object? maxTemp = freezed,
    Object? deviationReportId = freezed,
    Object? decision = null,
  }) {
    return _then(
      _$SubmitQcReqImpl(
        batchNumber: null == batchNumber
            ? _value.batchNumber
            : batchNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        minTemp: freezed == minTemp
            ? _value.minTemp
            : minTemp // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxTemp: freezed == maxTemp
            ? _value.maxTemp
            : maxTemp // ignore: cast_nullable_to_non_nullable
                  as double?,
        deviationReportId: freezed == deviationReportId
            ? _value.deviationReportId
            : deviationReportId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
    required this.batchNumber,
    this.minTemp,
    this.maxTemp,
    this.deviationReportId,
    required this.decision,
  });

  factory _$SubmitQcReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmitQcReqImplFromJson(json);

  @override
  final String batchNumber;
  @override
  final double? minTemp;
  @override
  final double? maxTemp;
  @override
  final String? deviationReportId;
  @override
  final String decision;

  @override
  String toString() {
    return 'SubmitQcReq(batchNumber: $batchNumber, minTemp: $minTemp, maxTemp: $maxTemp, deviationReportId: $deviationReportId, decision: $decision)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitQcReqImpl &&
            (identical(other.batchNumber, batchNumber) ||
                other.batchNumber == batchNumber) &&
            (identical(other.minTemp, minTemp) || other.minTemp == minTemp) &&
            (identical(other.maxTemp, maxTemp) || other.maxTemp == maxTemp) &&
            (identical(other.deviationReportId, deviationReportId) ||
                other.deviationReportId == deviationReportId) &&
            (identical(other.decision, decision) ||
                other.decision == decision));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    batchNumber,
    minTemp,
    maxTemp,
    deviationReportId,
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
    required final String batchNumber,
    final double? minTemp,
    final double? maxTemp,
    final String? deviationReportId,
    required final String decision,
  }) = _$SubmitQcReqImpl;

  factory _SubmitQcReq.fromJson(Map<String, dynamic> json) =
      _$SubmitQcReqImpl.fromJson;

  @override
  String get batchNumber;
  @override
  double? get minTemp;
  @override
  double? get maxTemp;
  @override
  String? get deviationReportId;
  @override
  String get decision;

  /// Create a copy of SubmitQcReq
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmitQcReqImplCopyWith<_$SubmitQcReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MoveToQuarantineReq _$MoveToQuarantineReqFromJson(Map<String, dynamic> json) {
  return _MoveToQuarantineReq.fromJson(json);
}

/// @nodoc
mixin _$MoveToQuarantineReq {
  String get batchNumber => throw _privateConstructorUsedError;
  String get locationCode => throw _privateConstructorUsedError;

  /// Serializes this MoveToQuarantineReq to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MoveToQuarantineReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoveToQuarantineReqCopyWith<MoveToQuarantineReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoveToQuarantineReqCopyWith<$Res> {
  factory $MoveToQuarantineReqCopyWith(
    MoveToQuarantineReq value,
    $Res Function(MoveToQuarantineReq) then,
  ) = _$MoveToQuarantineReqCopyWithImpl<$Res, MoveToQuarantineReq>;
  @useResult
  $Res call({String batchNumber, String locationCode});
}

/// @nodoc
class _$MoveToQuarantineReqCopyWithImpl<$Res, $Val extends MoveToQuarantineReq>
    implements $MoveToQuarantineReqCopyWith<$Res> {
  _$MoveToQuarantineReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MoveToQuarantineReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? batchNumber = null, Object? locationCode = null}) {
    return _then(
      _value.copyWith(
            batchNumber: null == batchNumber
                ? _value.batchNumber
                : batchNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            locationCode: null == locationCode
                ? _value.locationCode
                : locationCode // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MoveToQuarantineReqImplCopyWith<$Res>
    implements $MoveToQuarantineReqCopyWith<$Res> {
  factory _$$MoveToQuarantineReqImplCopyWith(
    _$MoveToQuarantineReqImpl value,
    $Res Function(_$MoveToQuarantineReqImpl) then,
  ) = __$$MoveToQuarantineReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String batchNumber, String locationCode});
}

/// @nodoc
class __$$MoveToQuarantineReqImplCopyWithImpl<$Res>
    extends _$MoveToQuarantineReqCopyWithImpl<$Res, _$MoveToQuarantineReqImpl>
    implements _$$MoveToQuarantineReqImplCopyWith<$Res> {
  __$$MoveToQuarantineReqImplCopyWithImpl(
    _$MoveToQuarantineReqImpl _value,
    $Res Function(_$MoveToQuarantineReqImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MoveToQuarantineReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? batchNumber = null, Object? locationCode = null}) {
    return _then(
      _$MoveToQuarantineReqImpl(
        batchNumber: null == batchNumber
            ? _value.batchNumber
            : batchNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        locationCode: null == locationCode
            ? _value.locationCode
            : locationCode // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$MoveToQuarantineReqImpl implements _MoveToQuarantineReq {
  const _$MoveToQuarantineReqImpl({
    required this.batchNumber,
    required this.locationCode,
  });

  factory _$MoveToQuarantineReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoveToQuarantineReqImplFromJson(json);

  @override
  final String batchNumber;
  @override
  final String locationCode;

  @override
  String toString() {
    return 'MoveToQuarantineReq(batchNumber: $batchNumber, locationCode: $locationCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoveToQuarantineReqImpl &&
            (identical(other.batchNumber, batchNumber) ||
                other.batchNumber == batchNumber) &&
            (identical(other.locationCode, locationCode) ||
                other.locationCode == locationCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, batchNumber, locationCode);

  /// Create a copy of MoveToQuarantineReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoveToQuarantineReqImplCopyWith<_$MoveToQuarantineReqImpl> get copyWith =>
      __$$MoveToQuarantineReqImplCopyWithImpl<_$MoveToQuarantineReqImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MoveToQuarantineReqImplToJson(this);
  }
}

abstract class _MoveToQuarantineReq implements MoveToQuarantineReq {
  const factory _MoveToQuarantineReq({
    required final String batchNumber,
    required final String locationCode,
  }) = _$MoveToQuarantineReqImpl;

  factory _MoveToQuarantineReq.fromJson(Map<String, dynamic> json) =
      _$MoveToQuarantineReqImpl.fromJson;

  @override
  String get batchNumber;
  @override
  String get locationCode;

  /// Create a copy of MoveToQuarantineReq
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoveToQuarantineReqImplCopyWith<_$MoveToQuarantineReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BindDraftReq _$BindDraftReqFromJson(Map<String, dynamic> json) {
  return _BindDraftReq.fromJson(json);
}

/// @nodoc
mixin _$BindDraftReq {
  String get poNumber => throw _privateConstructorUsedError;

  /// Serializes this BindDraftReq to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BindDraftReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BindDraftReqCopyWith<BindDraftReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BindDraftReqCopyWith<$Res> {
  factory $BindDraftReqCopyWith(
    BindDraftReq value,
    $Res Function(BindDraftReq) then,
  ) = _$BindDraftReqCopyWithImpl<$Res, BindDraftReq>;
  @useResult
  $Res call({String poNumber});
}

/// @nodoc
class _$BindDraftReqCopyWithImpl<$Res, $Val extends BindDraftReq>
    implements $BindDraftReqCopyWith<$Res> {
  _$BindDraftReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BindDraftReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? poNumber = null}) {
    return _then(
      _value.copyWith(
            poNumber: null == poNumber
                ? _value.poNumber
                : poNumber // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BindDraftReqImplCopyWith<$Res>
    implements $BindDraftReqCopyWith<$Res> {
  factory _$$BindDraftReqImplCopyWith(
    _$BindDraftReqImpl value,
    $Res Function(_$BindDraftReqImpl) then,
  ) = __$$BindDraftReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String poNumber});
}

/// @nodoc
class __$$BindDraftReqImplCopyWithImpl<$Res>
    extends _$BindDraftReqCopyWithImpl<$Res, _$BindDraftReqImpl>
    implements _$$BindDraftReqImplCopyWith<$Res> {
  __$$BindDraftReqImplCopyWithImpl(
    _$BindDraftReqImpl _value,
    $Res Function(_$BindDraftReqImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BindDraftReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? poNumber = null}) {
    return _then(
      _$BindDraftReqImpl(
        poNumber: null == poNumber
            ? _value.poNumber
            : poNumber // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$BindDraftReqImpl implements _BindDraftReq {
  const _$BindDraftReqImpl({required this.poNumber});

  factory _$BindDraftReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$BindDraftReqImplFromJson(json);

  @override
  final String poNumber;

  @override
  String toString() {
    return 'BindDraftReq(poNumber: $poNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BindDraftReqImpl &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, poNumber);

  /// Create a copy of BindDraftReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BindDraftReqImplCopyWith<_$BindDraftReqImpl> get copyWith =>
      __$$BindDraftReqImplCopyWithImpl<_$BindDraftReqImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BindDraftReqImplToJson(this);
  }
}

abstract class _BindDraftReq implements BindDraftReq {
  const factory _BindDraftReq({required final String poNumber}) =
      _$BindDraftReqImpl;

  factory _BindDraftReq.fromJson(Map<String, dynamic> json) =
      _$BindDraftReqImpl.fromJson;

  @override
  String get poNumber;

  /// Create a copy of BindDraftReq
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BindDraftReqImplCopyWith<_$BindDraftReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SaveDraftReq _$SaveDraftReqFromJson(Map<String, dynamic> json) {
  return _SaveDraftReq.fromJson(json);
}

/// @nodoc
mixin _$SaveDraftReq {
  String get poNumber => throw _privateConstructorUsedError;
  Map<String, dynamic> get payload => throw _privateConstructorUsedError;

  /// Serializes this SaveDraftReq to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SaveDraftReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SaveDraftReqCopyWith<SaveDraftReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SaveDraftReqCopyWith<$Res> {
  factory $SaveDraftReqCopyWith(
    SaveDraftReq value,
    $Res Function(SaveDraftReq) then,
  ) = _$SaveDraftReqCopyWithImpl<$Res, SaveDraftReq>;
  @useResult
  $Res call({String poNumber, Map<String, dynamic> payload});
}

/// @nodoc
class _$SaveDraftReqCopyWithImpl<$Res, $Val extends SaveDraftReq>
    implements $SaveDraftReqCopyWith<$Res> {
  _$SaveDraftReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SaveDraftReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? poNumber = null, Object? payload = null}) {
    return _then(
      _value.copyWith(
            poNumber: null == poNumber
                ? _value.poNumber
                : poNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            payload: null == payload
                ? _value.payload
                : payload // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SaveDraftReqImplCopyWith<$Res>
    implements $SaveDraftReqCopyWith<$Res> {
  factory _$$SaveDraftReqImplCopyWith(
    _$SaveDraftReqImpl value,
    $Res Function(_$SaveDraftReqImpl) then,
  ) = __$$SaveDraftReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String poNumber, Map<String, dynamic> payload});
}

/// @nodoc
class __$$SaveDraftReqImplCopyWithImpl<$Res>
    extends _$SaveDraftReqCopyWithImpl<$Res, _$SaveDraftReqImpl>
    implements _$$SaveDraftReqImplCopyWith<$Res> {
  __$$SaveDraftReqImplCopyWithImpl(
    _$SaveDraftReqImpl _value,
    $Res Function(_$SaveDraftReqImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SaveDraftReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? poNumber = null, Object? payload = null}) {
    return _then(
      _$SaveDraftReqImpl(
        poNumber: null == poNumber
            ? _value.poNumber
            : poNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        payload: null == payload
            ? _value._payload
            : payload // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$SaveDraftReqImpl implements _SaveDraftReq {
  const _$SaveDraftReqImpl({
    required this.poNumber,
    required final Map<String, dynamic> payload,
  }) : _payload = payload;

  factory _$SaveDraftReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$SaveDraftReqImplFromJson(json);

  @override
  final String poNumber;
  final Map<String, dynamic> _payload;
  @override
  Map<String, dynamic> get payload {
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_payload);
  }

  @override
  String toString() {
    return 'SaveDraftReq(poNumber: $poNumber, payload: $payload)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveDraftReqImpl &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber) &&
            const DeepCollectionEquality().equals(other._payload, _payload));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    poNumber,
    const DeepCollectionEquality().hash(_payload),
  );

  /// Create a copy of SaveDraftReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveDraftReqImplCopyWith<_$SaveDraftReqImpl> get copyWith =>
      __$$SaveDraftReqImplCopyWithImpl<_$SaveDraftReqImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SaveDraftReqImplToJson(this);
  }
}

abstract class _SaveDraftReq implements SaveDraftReq {
  const factory _SaveDraftReq({
    required final String poNumber,
    required final Map<String, dynamic> payload,
  }) = _$SaveDraftReqImpl;

  factory _SaveDraftReq.fromJson(Map<String, dynamic> json) =
      _$SaveDraftReqImpl.fromJson;

  @override
  String get poNumber;
  @override
  Map<String, dynamic> get payload;

  /// Create a copy of SaveDraftReq
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaveDraftReqImplCopyWith<_$SaveDraftReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UnbindDraftReq _$UnbindDraftReqFromJson(Map<String, dynamic> json) {
  return _UnbindDraftReq.fromJson(json);
}

/// @nodoc
mixin _$UnbindDraftReq {
  String get poNumber => throw _privateConstructorUsedError;

  /// Serializes this UnbindDraftReq to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UnbindDraftReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UnbindDraftReqCopyWith<UnbindDraftReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnbindDraftReqCopyWith<$Res> {
  factory $UnbindDraftReqCopyWith(
    UnbindDraftReq value,
    $Res Function(UnbindDraftReq) then,
  ) = _$UnbindDraftReqCopyWithImpl<$Res, UnbindDraftReq>;
  @useResult
  $Res call({String poNumber});
}

/// @nodoc
class _$UnbindDraftReqCopyWithImpl<$Res, $Val extends UnbindDraftReq>
    implements $UnbindDraftReqCopyWith<$Res> {
  _$UnbindDraftReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UnbindDraftReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? poNumber = null}) {
    return _then(
      _value.copyWith(
            poNumber: null == poNumber
                ? _value.poNumber
                : poNumber // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UnbindDraftReqImplCopyWith<$Res>
    implements $UnbindDraftReqCopyWith<$Res> {
  factory _$$UnbindDraftReqImplCopyWith(
    _$UnbindDraftReqImpl value,
    $Res Function(_$UnbindDraftReqImpl) then,
  ) = __$$UnbindDraftReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String poNumber});
}

/// @nodoc
class __$$UnbindDraftReqImplCopyWithImpl<$Res>
    extends _$UnbindDraftReqCopyWithImpl<$Res, _$UnbindDraftReqImpl>
    implements _$$UnbindDraftReqImplCopyWith<$Res> {
  __$$UnbindDraftReqImplCopyWithImpl(
    _$UnbindDraftReqImpl _value,
    $Res Function(_$UnbindDraftReqImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UnbindDraftReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? poNumber = null}) {
    return _then(
      _$UnbindDraftReqImpl(
        poNumber: null == poNumber
            ? _value.poNumber
            : poNumber // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$UnbindDraftReqImpl implements _UnbindDraftReq {
  const _$UnbindDraftReqImpl({required this.poNumber});

  factory _$UnbindDraftReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$UnbindDraftReqImplFromJson(json);

  @override
  final String poNumber;

  @override
  String toString() {
    return 'UnbindDraftReq(poNumber: $poNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnbindDraftReqImpl &&
            (identical(other.poNumber, poNumber) ||
                other.poNumber == poNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, poNumber);

  /// Create a copy of UnbindDraftReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnbindDraftReqImplCopyWith<_$UnbindDraftReqImpl> get copyWith =>
      __$$UnbindDraftReqImplCopyWithImpl<_$UnbindDraftReqImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UnbindDraftReqImplToJson(this);
  }
}

abstract class _UnbindDraftReq implements UnbindDraftReq {
  const factory _UnbindDraftReq({required final String poNumber}) =
      _$UnbindDraftReqImpl;

  factory _UnbindDraftReq.fromJson(Map<String, dynamic> json) =
      _$UnbindDraftReqImpl.fromJson;

  @override
  String get poNumber;

  /// Create a copy of UnbindDraftReq
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnbindDraftReqImplCopyWith<_$UnbindDraftReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
