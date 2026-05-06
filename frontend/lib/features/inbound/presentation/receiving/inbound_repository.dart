import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'inbound_models.dart';

part 'inbound_repository.g.dart';

class InboundRepository {
  Future<void> submitItem(InboundItem item) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate Server-Side Validations
    if (item.actualQty > item.expectedQty) {
      throw Exception('Server Error: Nhập lố số lượng PO');
    }

    if (item.toteCode.toUpperCase() == 'STD-123' && item.productName != 'Mocked Product') {
       throw Exception('Server Error: Rổ đã chứa hàng khác (Not a Pure Tote)');
    }
    
    // Simulate Success
    print('Successfully submitted item ${item.barcode} with Base Qty: ${item.baseQty} to Tote ${item.toteCode}');
  }
}

@riverpod
InboundRepository inboundRepository(Ref ref) {
  return InboundRepository();
}
