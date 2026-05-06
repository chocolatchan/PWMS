// ============================================================
// FILE: picking_mock_repo.dart
// Standalone repository for picking tasks.
// ============================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'picking_mock_data.dart';
import 'picking_models.dart';

part 'picking_mock_repo.g.dart';

class MockPickingRepository {
  Future<List<PickingSO>> getPendingTasks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [PickingMockData.sampleSO];
  }

  Future<void> submitPick(String taskId) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

@riverpod
MockPickingRepository mockPickingRepo(Ref ref) {
  return MockPickingRepository();
}
