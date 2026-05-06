import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'recall_models.dart';
import 'recall_mock_data.dart';

part 'recall_controller.g.dart';

@Riverpod(keepAlive: true)
class Phase6Controller extends _$Phase6Controller {
  @override
  Phase6State build() {
    return const Phase6State(
      inventory: RecallMockData.initialInventory,
    );
  }

  void initiateRecall(String batchCode) {
    if (batchCode.isEmpty) return;

    int totalLocked = 0;
    int itemsUpdated = 0;
    
    final StringBuffer reportBuffer = StringBuffer();
    reportBuffer.writeln('LOCKDOWN REPORT FOR BATCH: $batchCode\n');

    final updatedInventory = state.inventory.map((item) {
      if (item.batchCode.toUpperCase() == batchCode.toUpperCase() && 
          item.status != InventoryStatus.recalled) {
        
        totalLocked += item.quantity;
        itemsUpdated++;
        reportBuffer.writeln('- Đã khóa: ${item.quantity} hộp tại ${item.location}');
        
        return item.copyWith(status: InventoryStatus.recalled);
      }
      return item;
    }).toList();

    if (itemsUpdated == 0) {
      reportBuffer.writeln('Không tìm thấy sản phẩm nào thuộc lô này trong hệ thống.');
    } else {
      reportBuffer.writeln('\nTỔNG CỘNG: Đã phong tỏa $totalLocked hộp trên $itemsUpdated vị trí.');
    }

    state = state.copyWith(
      inventory: updatedInventory,
      isRecallActive: true,
      lastRecallReport: reportBuffer.toString(),
    );
  }

  void resetRecall() {
    state = state.copyWith(
      isRecallActive: false,
      lastRecallReport: null,
    );
  }

  void processReturn({
    required String barcode,
    required ReturnReason reason,
    required bool isColdChain,
    required String assignedTote,
  }) {
    final newItem = ReturnItem(
      id: const Uuid().v4(),
      barcode: barcode,
      reason: reason,
      isColdChain: isColdChain,
      assignedTote: assignedTote,
      returnedAt: DateTime.now(),
    );

    state = state.copyWith(
      returns: [...state.returns, newItem],
    );
  }
}
