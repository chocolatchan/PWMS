import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_service.dart';
import '../models/putaway_models.dart';

part 'putaway_repository.g.dart';

abstract class PutawayRepository {
  Future<PutawayTask> loadPutawayTask(String toteBarcode, String userId);
  Future<void> saveActiveTote(String toteBarcode, String userId);
  Future<String?> getActiveTote(String userId);
  Future<void> clearActiveTote(String userId);
  Future<void> submitDrop(String toteBarcode, String locationBarcode, List<PutawayItem> droppedItems, String userId);
  Future<void> releaseToteLock(String toteBarcode);
}

class PutawayRepositoryImpl implements PutawayRepository {
  final ApiService _apiService;
  
  // 3-Way Lock Mock DB (Survives within session, reset on boot as per Zero-Trust)
  static final Map<String, String> _toteToUser = {};

  PutawayRepositoryImpl(this._apiService);

  @override
  Future<PutawayTask> loadPutawayTask(String toteBarcode, String userId) async {
    // 3-Way Lock Check
    if (_toteToUser.containsKey(toteBarcode) && _toteToUser[toteBarcode] != userId) {
      throw Exception('This Container is currently locked by another user for Putaway.');
    }

    try {
      // In production: GET /api/v1/putaway/task/$toteBarcode
      final response = await _apiService.get('/api/v1/putaway/task/$toteBarcode');
      return PutawayTask.fromJson(response.data);
    } catch (e) {
      // MOCK FALLBACK
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Simulate that only TOTE-001 and TOTE-002 have items
      if (toteBarcode != 'TOTE-001' && toteBarcode != 'TOTE-002') {
        throw Exception('Container $toteBarcode is empty or not staged for Putaway.');
      }

      // Lock the tote
      _toteToUser[toteBarcode] = userId;

      return PutawayTask(
        toteBarcode: toteBarcode,
        status: 'ACTIVE',
        items: [
          const PutawayItem(
            sku: 'PARA500',
            productName: 'Paracetamol 500mg',
            expectedQty: 5,
            scannedQty: 0,
            suggestedLocation: 'Z01-A01-C01',
          ),
          const PutawayItem(
            sku: 'AMOX250',
            productName: 'Amoxicillin 250mg',
            expectedQty: 10,
            scannedQty: 0,
            suggestedLocation: 'Z01-B02-D04',
          ),
        ],
      );
    }
  }

  @override
  Future<void> saveActiveTote(String toteBarcode, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_putaway_tote_$userId', toteBarcode);
  }

  @override
  Future<String?> getActiveTote(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('active_putaway_tote_$userId');
  }

  @override
  Future<void> clearActiveTote(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('active_putaway_tote_$userId');
  }

  @override
  Future<void> submitDrop(String toteBarcode, String locationBarcode, List<PutawayItem> droppedItems, String userId) async {
    // 3-Way Lock Check
    if (_toteToUser[toteBarcode] != userId) {
      throw Exception('Security Violation: You do not own the lock for this Container.');
    }

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // In production: POST /api/v1/putaway/drop
    // { "tote": toteBarcode, "location": locationBarcode, "items": [...] }
  }

  @override
  Future<void> releaseToteLock(String toteBarcode) async {
    _toteToUser.remove(toteBarcode);
  }
}

@riverpod
PutawayRepository putawayRepository(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return PutawayRepositoryImpl(apiService);
}
