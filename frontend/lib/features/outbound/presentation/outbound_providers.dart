import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/outbound_repository.dart';
import '../models/outbound_dto.dart';
import '../../../core/network/dio_client.dart';

final outboundRepositoryProvider = Provider<OutboundRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return OutboundRepository(dio);
});

// Create Order Provider
final createOrderStateProvider = StateNotifierProvider<CreateOrderNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(outboundRepositoryProvider);
  return CreateOrderNotifier(repo);
});

class CreateOrderNotifier extends StateNotifier<AsyncValue<void>> {
  final OutboundRepository _repo;
  CreateOrderNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> create(CreateOrderReq req) async {
    state = const AsyncValue.loading();
    try {
      await _repo.createOrder(req);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Scan Pick Provider
final scanPickStateProvider = StateNotifierProvider<ScanPickNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(outboundRepositoryProvider);
  return ScanPickNotifier(repo);
});

class ScanPickNotifier extends StateNotifier<AsyncValue<void>> {
  final OutboundRepository _repo;
  ScanPickNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> pick(ScanPickReq req) async {
    state = const AsyncValue.loading();
    try {
      await _repo.scanPick(req);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Pack Container Provider
final packContainerStateProvider = StateNotifierProvider<PackContainerNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(outboundRepositoryProvider);
  return PackContainerNotifier(repo);
});

class PackContainerNotifier extends StateNotifier<AsyncValue<void>> {
  final OutboundRepository _repo;
  PackContainerNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> pack(PackContainerReq req) async {
    state = const AsyncValue.loading();
    try {
      await _repo.packContainer(req);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Dispatch Provider
final dispatchStateProvider = StateNotifierProvider<DispatchNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(outboundRepositoryProvider);
  return DispatchNotifier(repo);
});

class DispatchNotifier extends StateNotifier<AsyncValue<void>> {
  final OutboundRepository _repo;
  DispatchNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> dispatch(DispatchReq req) async {
    state = const AsyncValue.loading();
    try {
      await _repo.dispatch(req);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
