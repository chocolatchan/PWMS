import 'dart:convert';
import 'package:pwms_frontend/features/inbound/models/inbound_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_service.dart';
import '../models/inbound_models.dart';

part 'inbound_repository.g.dart';

abstract class InboundRepository {
  Future<PurchaseOrder> assignTask(String toteBarcode, String userId);
  Future<void> submitReceiving(
    String toteBarcode,
    PurchaseOrder po,
    String userId,
  );

  // Local Draft Methods
  Future<void> saveDraft(PurchaseOrder po, String userId);
  Future<PurchaseOrder?> loadDraft(String poNumber, String userId);
  Future<void> deleteDraft(String poNumber, String userId);

  // Active Tote Management
  Future<void> saveActiveTote(String toteBarcode, String userId);
  Future<String?> getActiveTote(String userId);
  Future<void> clearActiveTote(String userId);

  Future<List<InboundReceiptDto>> getPendingReceipts();
}

class InboundRepositoryImpl implements InboundRepository {
  final ApiService _apiService;
  static final Map<String, String> _mockDb = {};
  static final Map<String, String> _toteToUser = {};

  InboundRepositoryImpl(this._apiService);

  @override
  Future<List<InboundReceiptDto>> getPendingReceipts() async {
    try {
      final response = await _apiService.get('/api/inbound/pending');
      final data = response.data as List;
      return data.map((e) => InboundReceiptDto.fromJson(e)).toList();
    } catch (e) {
      // Mock fallback
      return [];
    }
  }

  @override
  Future<PurchaseOrder> assignTask(String toteBarcode, String userId) async {
    // FIX 3: 3-Way Lock Check
    if (_toteToUser.containsKey(toteBarcode) &&
        _toteToUser[toteBarcode] != userId) {
      throw Exception('This Container is currently locked by another user.');
    }

    try {
      // In production, this hits POST /api/v1/inbound/tasks/assign
      final response = await _apiService.post(
        '/api/v1/inbound/tasks/assign',
        data: {
          'tote_barcode': toteBarcode,
          'user_id': userId, // Injected for server-side lock
        },
      );
      return PurchaseOrder.fromJson(response.data);
    } catch (e) {
      // MOCK FALLBACK WITH USER-SCOPED LOCK
      await Future.delayed(const Duration(milliseconds: 500));

      final String poNumber;
      if (_mockDb.containsKey(toteBarcode)) {
        poNumber = _mockDb[toteBarcode]!;
      } else {
        // AMNESIA CURE: Use deterministic PO number based on Tote Barcode for mock stability
        poNumber =
            'PO-${toteBarcode.hashCode.abs().toString().padLeft(3, '0').substring(0, 3)}';
        _mockDb[toteBarcode] = poNumber;
      }

      // Lock the tote to this user
      _toteToUser[toteBarcode] = userId;

      return PurchaseOrder(
        poNumber: poNumber,
        supplierName: 'Supplier for $toteBarcode',
        status: 'PROCESSING',
        items: [],
      );
    }
  }

  @override
  Future<void> submitReceiving(
    String toteBarcode,
    PurchaseOrder po,
    String userId,
  ) async {
    // 3-Way validation check
    if (_toteToUser[toteBarcode] != userId) {
      throw Exception(
        'Security Violation: User $userId does not hold the lock for Tote $toteBarcode',
      );
    }

    try {
      await _apiService.post(
        '/api/v1/inbound/po/${po.poNumber}/receive',
        data: {
          'tote_barcode': toteBarcode,
          'items': po.items
              .where((i) => i.scannedQty > 0)
              .map((item) => item.toJson())
              .toList(),
        },
      );
    } catch (e) {
      // MOCK FALLBACK
      await Future.delayed(const Duration(seconds: 1));
    }

    // Release locks structurally
    _mockDb.remove(toteBarcode);
    _toteToUser.remove(toteBarcode);
  }

  // --- Local Persistence (Drafts) ---

  @override
  Future<void> saveDraft(PurchaseOrder po, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'draft_${userId}_${po.poNumber}',
      jsonEncode(po.toJson()),
    );
  }

  @override
  Future<PurchaseOrder?> loadDraft(String poNumber, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('draft_${userId}_$poNumber');
    if (data != null) {
      return PurchaseOrder.fromJson(jsonDecode(data));
    }
    return null;
  }

  @override
  Future<void> deleteDraft(String poNumber, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('draft_${userId}_$poNumber');
  }

  // --- Active Tote Management ---

  @override
  Future<void> saveActiveTote(String toteBarcode, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_tote_$userId', toteBarcode);
  }

  @override
  Future<String?> getActiveTote(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('active_tote_$userId');
  }

  @override
  Future<void> clearActiveTote(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('active_tote_$userId');
  }
}

@riverpod
InboundRepository inboundRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return InboundRepositoryImpl(apiService);
}
