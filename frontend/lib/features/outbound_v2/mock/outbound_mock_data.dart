// ============================================================
// FILE: outbound_mock_data.dart
// Initial hardcoded state for Outbound Phase 5 (SoD).
// ============================================================

import 'outbound_models.dart';

class OutboundMockData {
  static const List<SalesOrder> initialOrders = [
    SalesOrder(
      soId: 'SO-1001',
      status: OrderStatus.picked,
      isColdChain: false,
      requiredTotes: [
        OutboundTote(toteId: 'STD-001'),
      ],
    ),
    SalesOrder(
      soId: 'SO-123',
      status: OrderStatus.picked,
      isColdChain: true,
      requiredTotes: [
        OutboundTote(toteId: 'STD-01'),
        OutboundTote(toteId: 'CLD-02'),
      ],
    ),
    SalesOrder(
      soId: 'SO-456',
      status: OrderStatus.picked,
      isColdChain: false,
      requiredTotes: [
        OutboundTote(toteId: 'STD-05'),
      ],
    ),

  ];
}
