import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'inbound_models.dart';
import 'inbound_repository.dart';

part 'inbound_controller.g.dart';

@riverpod
class InboundController extends _$InboundController {
  @override
  AsyncValue<InboundItem?> build() {
    return const AsyncValue.data(null);
  }

  void mockScan() {
    state = const AsyncValue.data(InboundItem(
      barcode: 'MOCK-12345',
      productName: 'Paracetamol 500mg',
      expectedQty: 1000,
      uomRate: 10.0, // Base unit is e.g. Pill, UOM is Box of 10
      isToxic: false,
    ));
  }

  void processScan(String barcode) {
    if (barcode.isEmpty) return;
    // Replace mock data generation with actual barcode processing
    state = AsyncValue.data(InboundItem(
      barcode: barcode,
      productName: 'Sản phẩm mẫu (Nhập thủ công)',
      expectedQty: 500,
      uomRate: 1.0,
      isToxic: false,
    ));
  }

  void updateActualQty(int qty) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(actualQty: qty));
  }

  void setReasonCode(QuarantineReason reason) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(reasonCode: reason));
  }


  void toggleNoMixedBatch(bool value) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(noMixedBatch: value));
  }

  void setToteCode(String code) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(toteCode: code));
  }

  Future<void> submit() async {
    final item = state.value;
    if (item == null) return;

    if (!item.isValid) {
      state = AsyncValue.error('Please fill all required fields correctly.', StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final repository = ref.read(inboundRepositoryProvider);
      await repository.submitItem(item);
      
      // Clear after success
      state = const AsyncValue.data(null);
    } catch (e, st) {
      // Revert state to previous item on error, but keep error state temporarily
      state = AsyncValue<InboundItem?>.error(e, st).copyWithPrevious(AsyncValue.data(item));
    }
  }
}
