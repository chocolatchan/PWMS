// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outbound_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderItemPayload _$OrderItemPayloadFromJson(Map<String, dynamic> json) {
  return _OrderItemPayload.fromJson(json);
}

/// @nodoc
mixin _$OrderItemPayload {
  String get productId => throw _privateConstructorUsedError;
  int get requiredQty => throw _privateConstructorUsedError;

  /// Serializes this OrderItemPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItemPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemPayloadCopyWith<OrderItemPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemPayloadCopyWith<$Res> {
  factory $OrderItemPayloadCopyWith(
    OrderItemPayload value,
    $Res Function(OrderItemPayload) then,
  ) = _$OrderItemPayloadCopyWithImpl<$Res, OrderItemPayload>;
  @useResult
  $Res call({String productId, int requiredQty});
}

/// @nodoc
class _$OrderItemPayloadCopyWithImpl<$Res, $Val extends OrderItemPayload>
    implements $OrderItemPayloadCopyWith<$Res> {
  _$OrderItemPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItemPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? productId = null, Object? requiredQty = null}) {
    return _then(
      _value.copyWith(
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            requiredQty: null == requiredQty
                ? _value.requiredQty
                : requiredQty // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderItemPayloadImplCopyWith<$Res>
    implements $OrderItemPayloadCopyWith<$Res> {
  factory _$$OrderItemPayloadImplCopyWith(
    _$OrderItemPayloadImpl value,
    $Res Function(_$OrderItemPayloadImpl) then,
  ) = __$$OrderItemPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String productId, int requiredQty});
}

/// @nodoc
class __$$OrderItemPayloadImplCopyWithImpl<$Res>
    extends _$OrderItemPayloadCopyWithImpl<$Res, _$OrderItemPayloadImpl>
    implements _$$OrderItemPayloadImplCopyWith<$Res> {
  __$$OrderItemPayloadImplCopyWithImpl(
    _$OrderItemPayloadImpl _value,
    $Res Function(_$OrderItemPayloadImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItemPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? productId = null, Object? requiredQty = null}) {
    return _then(
      _$OrderItemPayloadImpl(
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        requiredQty: null == requiredQty
            ? _value.requiredQty
            : requiredQty // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$OrderItemPayloadImpl implements _OrderItemPayload {
  const _$OrderItemPayloadImpl({
    required this.productId,
    required this.requiredQty,
  });

  factory _$OrderItemPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemPayloadImplFromJson(json);

  @override
  final String productId;
  @override
  final int requiredQty;

  @override
  String toString() {
    return 'OrderItemPayload(productId: $productId, requiredQty: $requiredQty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemPayloadImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.requiredQty, requiredQty) ||
                other.requiredQty == requiredQty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productId, requiredQty);

  /// Create a copy of OrderItemPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemPayloadImplCopyWith<_$OrderItemPayloadImpl> get copyWith =>
      __$$OrderItemPayloadImplCopyWithImpl<_$OrderItemPayloadImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemPayloadImplToJson(this);
  }
}

abstract class _OrderItemPayload implements OrderItemPayload {
  const factory _OrderItemPayload({
    required final String productId,
    required final int requiredQty,
  }) = _$OrderItemPayloadImpl;

  factory _OrderItemPayload.fromJson(Map<String, dynamic> json) =
      _$OrderItemPayloadImpl.fromJson;

  @override
  String get productId;
  @override
  int get requiredQty;

  /// Create a copy of OrderItemPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemPayloadImplCopyWith<_$OrderItemPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateOrderReq _$CreateOrderReqFromJson(Map<String, dynamic> json) {
  return _CreateOrderReq.fromJson(json);
}

/// @nodoc
mixin _$CreateOrderReq {
  String get customerName => throw _privateConstructorUsedError;
  List<OrderItemPayload> get items => throw _privateConstructorUsedError;

  /// Serializes this CreateOrderReq to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateOrderReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateOrderReqCopyWith<CreateOrderReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateOrderReqCopyWith<$Res> {
  factory $CreateOrderReqCopyWith(
    CreateOrderReq value,
    $Res Function(CreateOrderReq) then,
  ) = _$CreateOrderReqCopyWithImpl<$Res, CreateOrderReq>;
  @useResult
  $Res call({String customerName, List<OrderItemPayload> items});
}

/// @nodoc
class _$CreateOrderReqCopyWithImpl<$Res, $Val extends CreateOrderReq>
    implements $CreateOrderReqCopyWith<$Res> {
  _$CreateOrderReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateOrderReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? customerName = null, Object? items = null}) {
    return _then(
      _value.copyWith(
            customerName: null == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderItemPayload>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateOrderReqImplCopyWith<$Res>
    implements $CreateOrderReqCopyWith<$Res> {
  factory _$$CreateOrderReqImplCopyWith(
    _$CreateOrderReqImpl value,
    $Res Function(_$CreateOrderReqImpl) then,
  ) = __$$CreateOrderReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String customerName, List<OrderItemPayload> items});
}

/// @nodoc
class __$$CreateOrderReqImplCopyWithImpl<$Res>
    extends _$CreateOrderReqCopyWithImpl<$Res, _$CreateOrderReqImpl>
    implements _$$CreateOrderReqImplCopyWith<$Res> {
  __$$CreateOrderReqImplCopyWithImpl(
    _$CreateOrderReqImpl _value,
    $Res Function(_$CreateOrderReqImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateOrderReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? customerName = null, Object? items = null}) {
    return _then(
      _$CreateOrderReqImpl(
        customerName: null == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderItemPayload>,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$CreateOrderReqImpl implements _CreateOrderReq {
  const _$CreateOrderReqImpl({
    required this.customerName,
    required final List<OrderItemPayload> items,
  }) : _items = items;

  factory _$CreateOrderReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateOrderReqImplFromJson(json);

  @override
  final String customerName;
  final List<OrderItemPayload> _items;
  @override
  List<OrderItemPayload> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'CreateOrderReq(customerName: $customerName, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateOrderReqImpl &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    customerName,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of CreateOrderReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateOrderReqImplCopyWith<_$CreateOrderReqImpl> get copyWith =>
      __$$CreateOrderReqImplCopyWithImpl<_$CreateOrderReqImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateOrderReqImplToJson(this);
  }
}

abstract class _CreateOrderReq implements CreateOrderReq {
  const factory _CreateOrderReq({
    required final String customerName,
    required final List<OrderItemPayload> items,
  }) = _$CreateOrderReqImpl;

  factory _CreateOrderReq.fromJson(Map<String, dynamic> json) =
      _$CreateOrderReqImpl.fromJson;

  @override
  String get customerName;
  @override
  List<OrderItemPayload> get items;

  /// Create a copy of CreateOrderReq
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateOrderReqImplCopyWith<_$CreateOrderReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScanPickReq _$ScanPickReqFromJson(Map<String, dynamic> json) {
  return _ScanPickReq.fromJson(json);
}

/// @nodoc
mixin _$ScanPickReq {
  String get taskId => throw _privateConstructorUsedError;
  String get barcode => throw _privateConstructorUsedError;
  int get inputQty => throw _privateConstructorUsedError;

  /// Serializes this ScanPickReq to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanPickReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanPickReqCopyWith<ScanPickReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanPickReqCopyWith<$Res> {
  factory $ScanPickReqCopyWith(
    ScanPickReq value,
    $Res Function(ScanPickReq) then,
  ) = _$ScanPickReqCopyWithImpl<$Res, ScanPickReq>;
  @useResult
  $Res call({String taskId, String barcode, int inputQty});
}

/// @nodoc
class _$ScanPickReqCopyWithImpl<$Res, $Val extends ScanPickReq>
    implements $ScanPickReqCopyWith<$Res> {
  _$ScanPickReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanPickReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? barcode = null,
    Object? inputQty = null,
  }) {
    return _then(
      _value.copyWith(
            taskId: null == taskId
                ? _value.taskId
                : taskId // ignore: cast_nullable_to_non_nullable
                      as String,
            barcode: null == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String,
            inputQty: null == inputQty
                ? _value.inputQty
                : inputQty // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScanPickReqImplCopyWith<$Res>
    implements $ScanPickReqCopyWith<$Res> {
  factory _$$ScanPickReqImplCopyWith(
    _$ScanPickReqImpl value,
    $Res Function(_$ScanPickReqImpl) then,
  ) = __$$ScanPickReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String taskId, String barcode, int inputQty});
}

/// @nodoc
class __$$ScanPickReqImplCopyWithImpl<$Res>
    extends _$ScanPickReqCopyWithImpl<$Res, _$ScanPickReqImpl>
    implements _$$ScanPickReqImplCopyWith<$Res> {
  __$$ScanPickReqImplCopyWithImpl(
    _$ScanPickReqImpl _value,
    $Res Function(_$ScanPickReqImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScanPickReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? barcode = null,
    Object? inputQty = null,
  }) {
    return _then(
      _$ScanPickReqImpl(
        taskId: null == taskId
            ? _value.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as String,
        barcode: null == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String,
        inputQty: null == inputQty
            ? _value.inputQty
            : inputQty // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ScanPickReqImpl implements _ScanPickReq {
  const _$ScanPickReqImpl({
    required this.taskId,
    required this.barcode,
    required this.inputQty,
  });

  factory _$ScanPickReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanPickReqImplFromJson(json);

  @override
  final String taskId;
  @override
  final String barcode;
  @override
  final int inputQty;

  @override
  String toString() {
    return 'ScanPickReq(taskId: $taskId, barcode: $barcode, inputQty: $inputQty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanPickReqImpl &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.inputQty, inputQty) ||
                other.inputQty == inputQty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, taskId, barcode, inputQty);

  /// Create a copy of ScanPickReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanPickReqImplCopyWith<_$ScanPickReqImpl> get copyWith =>
      __$$ScanPickReqImplCopyWithImpl<_$ScanPickReqImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanPickReqImplToJson(this);
  }
}

abstract class _ScanPickReq implements ScanPickReq {
  const factory _ScanPickReq({
    required final String taskId,
    required final String barcode,
    required final int inputQty,
  }) = _$ScanPickReqImpl;

  factory _ScanPickReq.fromJson(Map<String, dynamic> json) =
      _$ScanPickReqImpl.fromJson;

  @override
  String get taskId;
  @override
  String get barcode;
  @override
  int get inputQty;

  /// Create a copy of ScanPickReq
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanPickReqImplCopyWith<_$ScanPickReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PackContainerReq _$PackContainerReqFromJson(Map<String, dynamic> json) {
  return _PackContainerReq.fromJson(json);
}

/// @nodoc
mixin _$PackContainerReq {
  String get containerId => throw _privateConstructorUsedError;
  String get packerId => throw _privateConstructorUsedError;

  /// Serializes this PackContainerReq to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PackContainerReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PackContainerReqCopyWith<PackContainerReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackContainerReqCopyWith<$Res> {
  factory $PackContainerReqCopyWith(
    PackContainerReq value,
    $Res Function(PackContainerReq) then,
  ) = _$PackContainerReqCopyWithImpl<$Res, PackContainerReq>;
  @useResult
  $Res call({String containerId, String packerId});
}

/// @nodoc
class _$PackContainerReqCopyWithImpl<$Res, $Val extends PackContainerReq>
    implements $PackContainerReqCopyWith<$Res> {
  _$PackContainerReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PackContainerReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? containerId = null, Object? packerId = null}) {
    return _then(
      _value.copyWith(
            containerId: null == containerId
                ? _value.containerId
                : containerId // ignore: cast_nullable_to_non_nullable
                      as String,
            packerId: null == packerId
                ? _value.packerId
                : packerId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PackContainerReqImplCopyWith<$Res>
    implements $PackContainerReqCopyWith<$Res> {
  factory _$$PackContainerReqImplCopyWith(
    _$PackContainerReqImpl value,
    $Res Function(_$PackContainerReqImpl) then,
  ) = __$$PackContainerReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String containerId, String packerId});
}

/// @nodoc
class __$$PackContainerReqImplCopyWithImpl<$Res>
    extends _$PackContainerReqCopyWithImpl<$Res, _$PackContainerReqImpl>
    implements _$$PackContainerReqImplCopyWith<$Res> {
  __$$PackContainerReqImplCopyWithImpl(
    _$PackContainerReqImpl _value,
    $Res Function(_$PackContainerReqImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PackContainerReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? containerId = null, Object? packerId = null}) {
    return _then(
      _$PackContainerReqImpl(
        containerId: null == containerId
            ? _value.containerId
            : containerId // ignore: cast_nullable_to_non_nullable
                  as String,
        packerId: null == packerId
            ? _value.packerId
            : packerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$PackContainerReqImpl implements _PackContainerReq {
  const _$PackContainerReqImpl({
    required this.containerId,
    required this.packerId,
  });

  factory _$PackContainerReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackContainerReqImplFromJson(json);

  @override
  final String containerId;
  @override
  final String packerId;

  @override
  String toString() {
    return 'PackContainerReq(containerId: $containerId, packerId: $packerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackContainerReqImpl &&
            (identical(other.containerId, containerId) ||
                other.containerId == containerId) &&
            (identical(other.packerId, packerId) ||
                other.packerId == packerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, containerId, packerId);

  /// Create a copy of PackContainerReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PackContainerReqImplCopyWith<_$PackContainerReqImpl> get copyWith =>
      __$$PackContainerReqImplCopyWithImpl<_$PackContainerReqImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PackContainerReqImplToJson(this);
  }
}

abstract class _PackContainerReq implements PackContainerReq {
  const factory _PackContainerReq({
    required final String containerId,
    required final String packerId,
  }) = _$PackContainerReqImpl;

  factory _PackContainerReq.fromJson(Map<String, dynamic> json) =
      _$PackContainerReqImpl.fromJson;

  @override
  String get containerId;
  @override
  String get packerId;

  /// Create a copy of PackContainerReq
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackContainerReqImplCopyWith<_$PackContainerReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DispatchReq _$DispatchReqFromJson(Map<String, dynamic> json) {
  return _DispatchReq.fromJson(json);
}

/// @nodoc
mixin _$DispatchReq {
  String get containerId => throw _privateConstructorUsedError;
  String get vehicleSealNumber => throw _privateConstructorUsedError;
  double? get dispatchTemperature => throw _privateConstructorUsedError;

  /// Serializes this DispatchReq to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DispatchReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DispatchReqCopyWith<DispatchReq> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DispatchReqCopyWith<$Res> {
  factory $DispatchReqCopyWith(
    DispatchReq value,
    $Res Function(DispatchReq) then,
  ) = _$DispatchReqCopyWithImpl<$Res, DispatchReq>;
  @useResult
  $Res call({
    String containerId,
    String vehicleSealNumber,
    double? dispatchTemperature,
  });
}

/// @nodoc
class _$DispatchReqCopyWithImpl<$Res, $Val extends DispatchReq>
    implements $DispatchReqCopyWith<$Res> {
  _$DispatchReqCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DispatchReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? containerId = null,
    Object? vehicleSealNumber = null,
    Object? dispatchTemperature = freezed,
  }) {
    return _then(
      _value.copyWith(
            containerId: null == containerId
                ? _value.containerId
                : containerId // ignore: cast_nullable_to_non_nullable
                      as String,
            vehicleSealNumber: null == vehicleSealNumber
                ? _value.vehicleSealNumber
                : vehicleSealNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            dispatchTemperature: freezed == dispatchTemperature
                ? _value.dispatchTemperature
                : dispatchTemperature // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DispatchReqImplCopyWith<$Res>
    implements $DispatchReqCopyWith<$Res> {
  factory _$$DispatchReqImplCopyWith(
    _$DispatchReqImpl value,
    $Res Function(_$DispatchReqImpl) then,
  ) = __$$DispatchReqImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String containerId,
    String vehicleSealNumber,
    double? dispatchTemperature,
  });
}

/// @nodoc
class __$$DispatchReqImplCopyWithImpl<$Res>
    extends _$DispatchReqCopyWithImpl<$Res, _$DispatchReqImpl>
    implements _$$DispatchReqImplCopyWith<$Res> {
  __$$DispatchReqImplCopyWithImpl(
    _$DispatchReqImpl _value,
    $Res Function(_$DispatchReqImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DispatchReq
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? containerId = null,
    Object? vehicleSealNumber = null,
    Object? dispatchTemperature = freezed,
  }) {
    return _then(
      _$DispatchReqImpl(
        containerId: null == containerId
            ? _value.containerId
            : containerId // ignore: cast_nullable_to_non_nullable
                  as String,
        vehicleSealNumber: null == vehicleSealNumber
            ? _value.vehicleSealNumber
            : vehicleSealNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        dispatchTemperature: freezed == dispatchTemperature
            ? _value.dispatchTemperature
            : dispatchTemperature // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$DispatchReqImpl implements _DispatchReq {
  const _$DispatchReqImpl({
    required this.containerId,
    required this.vehicleSealNumber,
    this.dispatchTemperature,
  });

  factory _$DispatchReqImpl.fromJson(Map<String, dynamic> json) =>
      _$$DispatchReqImplFromJson(json);

  @override
  final String containerId;
  @override
  final String vehicleSealNumber;
  @override
  final double? dispatchTemperature;

  @override
  String toString() {
    return 'DispatchReq(containerId: $containerId, vehicleSealNumber: $vehicleSealNumber, dispatchTemperature: $dispatchTemperature)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DispatchReqImpl &&
            (identical(other.containerId, containerId) ||
                other.containerId == containerId) &&
            (identical(other.vehicleSealNumber, vehicleSealNumber) ||
                other.vehicleSealNumber == vehicleSealNumber) &&
            (identical(other.dispatchTemperature, dispatchTemperature) ||
                other.dispatchTemperature == dispatchTemperature));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    containerId,
    vehicleSealNumber,
    dispatchTemperature,
  );

  /// Create a copy of DispatchReq
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DispatchReqImplCopyWith<_$DispatchReqImpl> get copyWith =>
      __$$DispatchReqImplCopyWithImpl<_$DispatchReqImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DispatchReqImplToJson(this);
  }
}

abstract class _DispatchReq implements DispatchReq {
  const factory _DispatchReq({
    required final String containerId,
    required final String vehicleSealNumber,
    final double? dispatchTemperature,
  }) = _$DispatchReqImpl;

  factory _DispatchReq.fromJson(Map<String, dynamic> json) =
      _$DispatchReqImpl.fromJson;

  @override
  String get containerId;
  @override
  String get vehicleSealNumber;
  @override
  double? get dispatchTemperature;

  /// Create a copy of DispatchReq
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DispatchReqImplCopyWith<_$DispatchReqImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PickTask _$PickTaskFromJson(Map<String, dynamic> json) {
  return _PickTask.fromJson(json);
}

/// @nodoc
mixin _$PickTask {
  String get id => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get requiredQty => throw _privateConstructorUsedError;
  int get pickedQty => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get locationCode => throw _privateConstructorUsedError;

  /// Serializes this PickTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PickTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PickTaskCopyWith<PickTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PickTaskCopyWith<$Res> {
  factory $PickTaskCopyWith(PickTask value, $Res Function(PickTask) then) =
      _$PickTaskCopyWithImpl<$Res, PickTask>;
  @useResult
  $Res call({
    String id,
    String productName,
    int requiredQty,
    int pickedQty,
    String status,
    String locationCode,
  });
}

/// @nodoc
class _$PickTaskCopyWithImpl<$Res, $Val extends PickTask>
    implements $PickTaskCopyWith<$Res> {
  _$PickTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PickTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productName = null,
    Object? requiredQty = null,
    Object? pickedQty = null,
    Object? status = null,
    Object? locationCode = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            requiredQty: null == requiredQty
                ? _value.requiredQty
                : requiredQty // ignore: cast_nullable_to_non_nullable
                      as int,
            pickedQty: null == pickedQty
                ? _value.pickedQty
                : pickedQty // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PickTaskImplCopyWith<$Res>
    implements $PickTaskCopyWith<$Res> {
  factory _$$PickTaskImplCopyWith(
    _$PickTaskImpl value,
    $Res Function(_$PickTaskImpl) then,
  ) = __$$PickTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String productName,
    int requiredQty,
    int pickedQty,
    String status,
    String locationCode,
  });
}

/// @nodoc
class __$$PickTaskImplCopyWithImpl<$Res>
    extends _$PickTaskCopyWithImpl<$Res, _$PickTaskImpl>
    implements _$$PickTaskImplCopyWith<$Res> {
  __$$PickTaskImplCopyWithImpl(
    _$PickTaskImpl _value,
    $Res Function(_$PickTaskImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PickTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productName = null,
    Object? requiredQty = null,
    Object? pickedQty = null,
    Object? status = null,
    Object? locationCode = null,
  }) {
    return _then(
      _$PickTaskImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        requiredQty: null == requiredQty
            ? _value.requiredQty
            : requiredQty // ignore: cast_nullable_to_non_nullable
                  as int,
        pickedQty: null == pickedQty
            ? _value.pickedQty
            : pickedQty // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
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
class _$PickTaskImpl implements _PickTask {
  const _$PickTaskImpl({
    required this.id,
    required this.productName,
    required this.requiredQty,
    required this.pickedQty,
    required this.status,
    required this.locationCode,
  });

  factory _$PickTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$PickTaskImplFromJson(json);

  @override
  final String id;
  @override
  final String productName;
  @override
  final int requiredQty;
  @override
  final int pickedQty;
  @override
  final String status;
  @override
  final String locationCode;

  @override
  String toString() {
    return 'PickTask(id: $id, productName: $productName, requiredQty: $requiredQty, pickedQty: $pickedQty, status: $status, locationCode: $locationCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PickTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.requiredQty, requiredQty) ||
                other.requiredQty == requiredQty) &&
            (identical(other.pickedQty, pickedQty) ||
                other.pickedQty == pickedQty) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.locationCode, locationCode) ||
                other.locationCode == locationCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    productName,
    requiredQty,
    pickedQty,
    status,
    locationCode,
  );

  /// Create a copy of PickTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PickTaskImplCopyWith<_$PickTaskImpl> get copyWith =>
      __$$PickTaskImplCopyWithImpl<_$PickTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PickTaskImplToJson(this);
  }
}

abstract class _PickTask implements PickTask {
  const factory _PickTask({
    required final String id,
    required final String productName,
    required final int requiredQty,
    required final int pickedQty,
    required final String status,
    required final String locationCode,
  }) = _$PickTaskImpl;

  factory _PickTask.fromJson(Map<String, dynamic> json) =
      _$PickTaskImpl.fromJson;

  @override
  String get id;
  @override
  String get productName;
  @override
  int get requiredQty;
  @override
  int get pickedQty;
  @override
  String get status;
  @override
  String get locationCode;

  /// Create a copy of PickTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PickTaskImplCopyWith<_$PickTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
