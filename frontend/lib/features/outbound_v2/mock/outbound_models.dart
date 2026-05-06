// ============================================================
// FILE: outbound_models.dart
// Models for Segregation of Duties in Packing & Dispatch.
// ============================================================

import 'package:freezed_annotation/freezed_annotation.dart';

part 'outbound_models.freezed.dart';
part 'outbound_models.g.dart';

enum OrderStatus { picked, packed, dispatched }

@freezed
abstract class OutboundTote with _$OutboundTote {
  const factory OutboundTote({
    required String toteId,
    @Default(false) bool isArrived,
  }) = _OutboundTote;

  factory OutboundTote.fromJson(Map<String, dynamic> json) => _$OutboundToteFromJson(json);
}

@freezed
abstract class SalesOrder with _$SalesOrder {
  const factory SalesOrder({
    required String soId,
    required List<OutboundTote> requiredTotes,
    @Default(OrderStatus.picked) OrderStatus status,
    String? sealCode,
    @Default(false) bool isColdChain,
    double? dispatchTemp,
  }) = _SalesOrder;

  factory SalesOrder.fromJson(Map<String, dynamic> json) => _$SalesOrderFromJson(json);
}

@freezed
abstract class OutboundState with _$OutboundState {
  const factory OutboundState({
    @Default([]) List<SalesOrder> orders,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _OutboundState;
}
