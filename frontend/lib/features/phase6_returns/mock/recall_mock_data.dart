import 'recall_models.dart';

class RecallMockData {
  static const List<InventoryItem> initialInventory = [
    InventoryItem(
      id: 'INV-1001',
      batchCode: 'BATCH-DEADLY-01',
      location: 'Kệ AVL-001',
      quantity: 500,
      status: InventoryStatus.available,
    ),
    InventoryItem(
      id: 'INV-1002',
      batchCode: 'BATCH-SAFE-99',
      location: 'Kệ AVL-002',
      quantity: 1000,
      status: InventoryStatus.available,
    ),
    InventoryItem(
      id: 'INV-1003',
      batchCode: 'BATCH-DEADLY-01',
      location: 'Rổ STD-123 (Picking)',
      quantity: 20,
      status: InventoryStatus.picking,
    ),
    InventoryItem(
      id: 'INV-1004',
      batchCode: 'BATCH-DEADLY-01',
      location: 'Cửa Dispatch (Gate 2)',
      quantity: 50,
      status: InventoryStatus.dispatch,
    ),
  ];
}
