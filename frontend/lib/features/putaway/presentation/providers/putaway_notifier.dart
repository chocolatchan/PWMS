import 'package:pwms_frontend/features/putaway/data/models/putaway_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../data/repositories/putaway_repository.dart';
import 'putaway_state.dart';

part 'putaway_notifier.g.dart';

@riverpod
class PutawayTaskNotifier extends _$PutawayTaskNotifier {
  @override
  Future<PutawayState> build() async {
    // Zero-Trust: React to auth changes
    ref.watch(authProvider);
    return _resumeActiveTask();
  }

  String _getUserId() {
    final authState = ref.read(authProvider);
    return authState.maybeWhen(
      authenticated: (user) => user.id.toString(),
      orElse: () => 'guest',
    );
  }

  Future<PutawayState> _resumeActiveTask() async {
    final userId = _getUserId();
    final repository = ref.read(putawayRepositoryProvider);
    final activeTote = await repository.getActiveTote(userId);

    if (activeTote != null) {
      try {
        final task = await repository.loadPutawayTask(activeTote, userId);
        return PutawayState(
          currentTask: task,
          currentStep: PutawayStep.waitingForLocation,
        );
      } catch (e) {
        await repository.clearActiveTote(userId);
      }
    }
    return const PutawayState();
  }

  Future<void> processBarcode(String barcode) async {
    final currentState = state.value;
    if (currentState == null) return;

    switch (currentState.currentStep) {
      case PutawayStep.waitingForTote:
        await _handleToteScan(barcode);
        break;
      case PutawayStep.waitingForLocation:
        _handleLocationScan(barcode);
        break;
      case PutawayStep.waitingForItem:
        _handleItemScan(barcode);
        break;
    }
  }

  Future<void> _handleToteScan(String barcode) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userId = _getUserId();
      final repository = ref.read(putawayRepositoryProvider);
      final task = await repository.loadPutawayTask(barcode, userId);
      await repository.saveActiveTote(barcode, userId);

      return PutawayState(
        currentTask: task,
        currentStep: PutawayStep.waitingForLocation,
      );
    });
  }

  void _handleLocationScan(String barcode) {
    // Regex for Location: Z-Shelf-Bin or starts with Z/R
    final locationRegex = RegExp(r'^[ZR][0-9A-Z-]+$');
    if (locationRegex.hasMatch(barcode) || barcode.contains('-')) {
      state = AsyncValue.data(
        state.value!.copyWith(
          lockedLocation: barcode,
          currentStep: PutawayStep.waitingForItem,
        ),
      );
    } else {
      throw Exception(
        'Invalid Location Barcode. Go to shelf and scan the Location tag.',
      );
    }
  }

  void _handleItemScan(String barcode) {
    // Basic item scan logic for Step 27 (just a placeholder/increment)
    // Actual batch validation would go here
    final task = state.value?.currentTask;
    if (task == null) return;

    final items = List<PutawayItem>.from(task.items);
    final index = items.indexWhere(
      (it) => it.sku == barcode || it.sku == barcode.split('|')[0],
    );

    if (index == -1) {
      throw Exception('Item $barcode not found in this Tote.');
    }

    final item = items[index];
    items[index] = item.copyWith(scannedQty: item.scannedQty + 1);

    state = AsyncValue.data(
      state.value!.copyWith(currentTask: task.copyWith(items: items)),
    );
  }

  void unlockLocation() {
    state = AsyncValue.data(
      state.value!.copyWith(
        lockedLocation: null,
        currentStep: PutawayStep.waitingForLocation,
      ),
    );
  }

  void clearError() {
    final current = state.value;
    if (current != null) {
      state = AsyncValue.data(current.copyWith(errorMessage: null));
    }
  }

  Future<void> submitDrop() async {
    final currentState = state.value;
    if (currentState == null || currentState.currentTask == null || currentState.lockedLocation == null) return;

    final droppedItems = currentState.currentTask!.items
        .where((item) => item.scannedQty > 0)
        .toList();

    if (droppedItems.isEmpty) {
      throw Exception('No items scanned to drop.');
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userId = _getUserId();
      final repository = ref.read(putawayRepositoryProvider);
      
      await repository.submitDrop(
        currentState.currentTask!.toteBarcode,
        currentState.lockedLocation!,
        droppedItems,
        userId,
      );

      // Deduction Logic: Subtract scanned from expected, reset scanned
      final updatedItems = currentState.currentTask!.items
          .map((item) {
            if (item.scannedQty > 0) {
              return item.copyWith(
                expectedQty: item.expectedQty - item.scannedQty,
                scannedQty: 0,
              );
            }
            return item;
          })
          .where((item) => item.expectedQty > 0) // Remove if empty
          .toList();

      if (updatedItems.isEmpty) {
        // Tote Empty -> Nuclear Release
        await repository.clearActiveTote(userId);
        await repository.releaseToteLock(currentState.currentTask!.toteBarcode);
        return const PutawayState(currentStep: PutawayStep.waitingForTote);
      } else {
        // Partial Drop -> Clear location and move to next
        return currentState.copyWith(
          currentTask: currentState.currentTask!.copyWith(items: updatedItems),
          lockedLocation: null,
          currentStep: PutawayStep.waitingForLocation,
        );
      }
    });
  }
}
