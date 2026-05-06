// ============================================================
// FILE: putaway_mock_repo.dart
// Simulates async fetch & submit with artificial delays.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'putaway_mock_data.dart';

class MockPutawayRepository {
  /// Simulates a network fetch for a tote. Throws if not found.
  Future<PutawayTote> fetchTask(String toteCode) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final tote = PutawayMockData.findByCode(toteCode);
    if (tote == null) {
      throw Exception('Không tìm thấy rổ "$toteCode" trong hệ thống.');
    }
    return tote;
  }

  /// Simulates the drop confirmation write to WMS.
  Future<void> confirmDrop({
    required String toteCode,
    required String locationCode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));
    // In real app: POST /api/putaway/confirm
  }
}

final mockPutawayRepoProvider = Provider<MockPutawayRepository>((ref) {
  return MockPutawayRepository();
});
