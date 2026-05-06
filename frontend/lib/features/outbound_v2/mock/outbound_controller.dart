// ============================================================
// FILE: outbound_controller.dart
// Central controller for both Packing and Dispatch roles.
// ============================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'outbound_models.dart';
import 'outbound_mock_data.dart';

part 'outbound_controller.g.dart';

@Riverpod(keepAlive: true)
class OutboundController extends _$OutboundController {
  @override
  OutboundState build() => const OutboundState(orders: OutboundMockData.initialOrders);

  // ── PACKER ACTIONS ──
  void markToteArrived(String soId, String toteId) {
    final updatedOrders = state.orders.map((so) {
      if (so.soId == soId) {
        final updatedTotes = so.requiredTotes.map((t) {
          if (t.toteId == toteId) return t.copyWith(isArrived: true);
          return t;
        }).toList();
        return so.copyWith(requiredTotes: updatedTotes);
      }
      return so;
    }).toList();
    state = state.copyWith(orders: updatedOrders);
  }

  void submitPacking(String soId, String sealCode) {
    final updatedOrders = state.orders.map((so) {
      if (so.soId == soId) {
        return so.copyWith(
          status: OrderStatus.packed,
          sealCode: sealCode,
        );
      }
      return so;
    }).toList();
    state = state.copyWith(orders: updatedOrders);
  }

  // ── DISPATCHER ACTIONS ──
  void submitDispatch(String soId, double temp) {
    final updatedOrders = state.orders.map((so) {
      if (so.soId == soId) {
        return so.copyWith(
          status: OrderStatus.dispatched,
          dispatchTemp: temp,
        );
      }
      return so;
    }).toList();
    state = state.copyWith(orders: updatedOrders);
  }

  void reset() {
    state = const OutboundState(orders: OutboundMockData.initialOrders);
  }
}
