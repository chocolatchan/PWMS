import 'package:pwms_frontend/features/auth/presentation/providers/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pwms_frontend/features/inbound/data/models/inbound_models.dart';
import 'package:pwms_frontend/features/inbound/data/repositories/inbound_repository.dart';
import 'package:pwms_frontend/features/inbound/presentation/providers/inbound_state.dart';
import 'package:pwms_frontend/features/auth/presentation/providers/auth_provider.dart';

part 'inbound_notifier.g.dart';

@riverpod
class InboundTaskNotifier extends _$InboundTaskNotifier {
  @override
  Future<InboundState> build() async {
    // Watching auth state ensures the notifier re-initializes on login/logout
    ref.watch(authProvider);
    return _resumeActiveTask();
  }

  String _getUserId() {
    final authState = ref.read(authProvider);
    return authState.maybeMap(
      authenticated: (a) => a.user.id.toString(),
      orElse: () => 'guest',
    );
  }

  Future<InboundState> _resumeActiveTask() async {
    final userId = _getUserId();
    final repository = ref.read(inboundRepositoryProvider);
    final activeTote = await repository.getActiveTote(userId);

    if (activeTote != null) {
      // 1. Fetch pristine PO from Repository (Network/Mock)
      final po = await repository.assignTask(activeTote, userId);

      // 2. Attempt to read Local Draft (Source of Truth)
      final draftPo = await repository.loadDraft(po.poNumber, userId);

      if (draftPo != null) {
        // AMNESIA CURED: Override network PO with Local Draft
        return InboundState(currentPo: draftPo, toteBarcode: activeTote);
      } else {
        // Fallback to Network PO if no draft exists
        return InboundState(
          currentPo: _ensureMockItems(po),
          toteBarcode: activeTote,
        );
      }
    }
    return const InboundState();
  }

  Future<void> checkActiveTask() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _resumeActiveTask());
  }

  Future<void> assignTask(String toteBarcode) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userId = _getUserId();
      final repository = ref.read(inboundRepositoryProvider);

      // 1. Fetch pristine PO from Repository
      final po = await repository.assignTask(toteBarcode, userId);

      // Save active tote for auto-resume
      await repository.saveActiveTote(toteBarcode, userId);

      // 2. Attempt to read Local Draft
      final draftPo = await repository.loadDraft(po.poNumber, userId);

      if (draftPo != null) {
        // Override with draft if it exists (e.g. from previous aborted session)
        return InboundState(currentPo: draftPo, toteBarcode: toteBarcode);
      } else {
        // Initialize with pristine PO
        return InboundState(
          currentPo: _ensureMockItems(po),
          toteBarcode: toteBarcode,
        );
      }
    });
  }

  Future<void> processBarcode(String barcode) async {
    final currentPo = state.value?.currentPo;
    final toteBarcode = state.value?.toteBarcode;
    if (currentPo == null || toteBarcode == null) return;

    final parts = barcode.split('|');
    if (parts.length < 3) {
      throw Exception('Mã vạch không hợp lệ. Định dạng chuẩn: SKU|LOT|EXP');
    }

    final sku = parts[0];
    final lot = parts[1];
    final expStr = parts[2];

    final itemIndex = currentPo.items.indexWhere((item) => item.sku == sku);
    if (itemIndex == -1) {
      throw Exception('Sản phẩm SKU $sku không có trong PO này.');
    }

    final item = currentPo.items[itemIndex];

    // FIX 3: Strict Quantity Validation
    if (item.scannedQty >= item.expectedQty) {
      throw Exception('Over-receiving! Expected ${item.expectedQty}');
    }

    // Create or update batch
    final existingBatchIndex = item.batches.indexWhere(
      (b) => b.lotNumber == lot,
    );
    final updatedBatches = List<BatchInfo>.from(item.batches);

    if (existingBatchIndex != -1) {
      final existingBatch = updatedBatches[existingBatchIndex];
      updatedBatches[existingBatchIndex] = existingBatch.copyWith(
        quantity: existingBatch.quantity + 1,
      );
    } else {
      updatedBatches.add(
        BatchInfo(
          batchId: '${sku}_$lot',
          lotNumber: lot,
          quantity: 1,
          expiryDate: DateTime.tryParse(expStr),
        ),
      );
    }

    final updatedItem = item.copyWith(
      scannedQty: item.scannedQty + 1,
      batches: updatedBatches,
    );

    final updatedItems = List<PoItem>.from(currentPo.items);
    updatedItems[itemIndex] = updatedItem;

    final updatedPo = currentPo.copyWith(items: updatedItems);

    state = AsyncValue.data(
      InboundState(currentPo: updatedPo, toteBarcode: toteBarcode),
    );

    // Auto-save draft (Await to ensure persistence before next laser scan)
    final userId = _getUserId();
    await ref.read(inboundRepositoryProvider).saveDraft(updatedPo, userId);
  }

  Future<void> submitReceiving() async {
    final currentPo = state.value?.currentPo;
    final toteBarcode = state.value?.toteBarcode;
    if (currentPo == null || toteBarcode == null) return;

    // FIX 1: Strict Completion Validation
    final isComplete = currentPo.items.every(
      (item) => item.scannedQty >= item.expectedQty,
    );
    if (!isComplete) {
      throw Exception(
        'Cannot submit. You have not scanned all required items.',
      );
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userId = _getUserId();
      final repository = ref.read(inboundRepositoryProvider);

      await repository.submitReceiving(toteBarcode, currentPo, userId);

      // FIX 2: Clear active tote on successful submission
      await repository.clearActiveTote(userId);
      await repository.deleteDraft(currentPo.poNumber, userId);

      return const InboundState();
    });
  }

  PurchaseOrder _ensureMockItems(PurchaseOrder po) {
    if (po.items.isNotEmpty) return po;
    return po.copyWith(
      items: [
        PoItem(
          sku: 'PARA500',
          productName: 'Paracetamol 500mg',
          expectedQty: 5,
          scannedQty: 0,
          batches: [],
        ),
      ],
    );
  }
}
