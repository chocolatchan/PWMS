import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/inbound_repository.dart';
import '../models/inbound_dto.dart';
import '../models/product.dart';
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
      await _repo.submitQc(
        batchNumber: req.batchNumber,
        decision: req.decision.toUpperCase(),
        minTemp: req.minTemp,
        maxTemp: req.maxTemp,
        deviationReportId: req.deviationReportId,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Draft Provider
final inboundDraftProvider = StateNotifierProvider<InboundDraftNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(inboundRepositoryProvider);
  return InboundDraftNotifier(repo);
});

class InboundDraftNotifier extends StateNotifier<AsyncValue<void>> {
  final InboundRepository _repo;
  InboundDraftNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<Map<String, dynamic>?> bindDraft(String poNumber) async {
    state = const AsyncValue.loading();
    try {
      final res = await _repo.bindDraft(BindDraftReq(poNumber: poNumber));
      state = const AsyncValue.data(null);
      return res;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> saveDraft(String poNumber, Map<String, dynamic> payload) async {
    try {
      await _repo.saveDraft(SaveDraftReq(poNumber: poNumber, payload: payload));
    } catch (e) {
      // Background save error
      print('Failed to save draft: $e');
    }
  }

  Future<void> unbindDraft(String poNumber) async {
    state = const AsyncValue.loading();
    try {
      await _repo.unbindDraft(UnbindDraftReq(poNumber: poNumber));
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getActiveDraft() async {
    state = const AsyncValue.loading();
    try {
      final res = await _repo.getActiveDraft();
      state = const AsyncValue.data(null);
      return res;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<Product> getProductByBarcode(String barcode) async {
    return await _repo.getProductByBarcode(barcode);
  }
}
