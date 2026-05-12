import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/inbound_repository.dart';
import '../models/inbound_dto.dart';
import '../../../core/network/dio_client.dart';

final inboundRepositoryProvider = Provider<InboundRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return InboundRepository(dio);
});

// Receive Inbound Provider
final receiveInboundStateProvider = StateNotifierProvider<ReceiveInboundNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(inboundRepositoryProvider);
  return ReceiveInboundNotifier(repo);
});

class ReceiveInboundNotifier extends StateNotifier<AsyncValue<void>> {
  final InboundRepository _repo;
  ReceiveInboundNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> receive(ReceiveInboundReq req) async {
    state = const AsyncValue.loading();
    try {
      await _repo.receiveInbound(req);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// QC Provider
final submitQcStateProvider = StateNotifierProvider<SubmitQcNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(inboundRepositoryProvider);
  return SubmitQcNotifier(repo);
});

class SubmitQcNotifier extends StateNotifier<AsyncValue<void>> {
  final InboundRepository _repo;
  SubmitQcNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> submit(SubmitQcReq req) async {
    state = const AsyncValue.loading();
    try {
      await _repo.submitQc(req);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
