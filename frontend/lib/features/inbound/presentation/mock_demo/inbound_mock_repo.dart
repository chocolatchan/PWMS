// ============================================================
// FILE: inbound_mock_repo.dart
// Fake repository — simulates network I/O with local delays.
// No HTTP, No Dio, No backend calls.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'inbound_models.dart';

class MockInboundRepository {
  /// Validates all 5 GSP rules server-side (fake), then persists.
  Future<String> submitItem(InboundItemState state) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 1200));

    final item = state.poItem;
    if (item == null) {
      throw Exception('[MOCK_API] No item selected');
    }

    // Server-side double check: Over-receiving
    if (state.isOverReceiving) {
      throw Exception(
        '[MOCK_API 422] Over-receiving: actual=${state.actualQty} > expected=${item.expectedQty}',
      );
    }

    // Server-side double check: Tote prefix
    if (!state.isTotePrefixValid) {
      throw Exception(
        '[MOCK_API 400] Pure Tote Violation: Tote "${state.toteCode}" phải bắt đầu bằng "${state.requiredTotePrefix}"',
      );
    }

    // Server-side: Quarantine audit
    final code = state.quarantineFlag.code;
    final baseQty = state.baseQty;
    final tote = state.toteCode.toUpperCase();


    return '✅ Lưu thành công! ${item.productCode} | Tote: $tote | '
        'Base Qty: ${baseQty.toStringAsFixed(0)} ${item.baseUnit} | '
        'Quarantine Code: $code';
  }
}

// ── Riverpod Provider ──────────────────────────────────────
final mockInboundRepoProvider = Provider<MockInboundRepository>((ref) {
  return MockInboundRepository();
});
