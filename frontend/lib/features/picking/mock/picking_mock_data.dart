// ============================================================
// FILE: picking_mock_data.dart
// Hardcoded SO for the Picking Wizard.
// ============================================================

import 'picking_models.dart';

class PickingMockData {
  static const sampleSO = PickingSO(
    soId: 'SO-2024-05-01',
    items: [
      PickingItem(
        productId: 'P-001',
        productName: 'Paracetamol 500mg',
        targetLoc: 'LOC-A',
        batchCode: 'BATCH-01',
        expectedQty: 10,
        isLasa: false,
      ),
      PickingItem(
        productId: 'P-002',
        productName: 'Ephedrine 30mg (Hàng LASA)',
        targetLoc: 'LOC-B',
        batchCode: 'BATCH-02',
        expectedQty: 3,
        isLasa: true,
      ),
    ],
  );
}
