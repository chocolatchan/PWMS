// ============================================================
// FILE: packing_mock_data.dart
// Hardcoded SO for Packing & Dispatch Phase 5.
// ============================================================

import 'packing_models.dart';

class PackingMockData {
  static const sampleSO = PackingSO(
    soId: 'SO-2026-XYZ',
    requiredTotes: [
      PackingTote(toteId: 'STD-001'),
      PackingTote(toteId: 'CLD-999'),
    ],
    isColdChain: true,
  );
}
