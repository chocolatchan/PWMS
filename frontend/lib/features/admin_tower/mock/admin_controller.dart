import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'admin_models.dart';
import 'admin_mock_data.dart';

part 'admin_controller.g.dart';

@Riverpod(keepAlive: true)
class AdminTowerController extends _$AdminTowerController {
  @override
  AdminState build() {
    return const AdminState(
      metrics: AdminMockData.defaultMetrics,
    );
  }

  Future<void> searchTrace(String query) async {
    final cleanQuery = query.trim().toUpperCase();
    if (cleanQuery.isEmpty) return;

    state = state.copyWith(isSearching: true, searchResult: []);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    if (cleanQuery == 'BATCH-001') {
      state = state.copyWith(isSearching: false, searchResult: AdminMockData.happyPath);
    } else if (cleanQuery == 'BATCH-ERR') {
      state = state.copyWith(isSearching: false, searchResult: AdminMockData.rejectedPath);
    } else {
      state = state.copyWith(isSearching: false, searchResult: []);
    }
  }

  void clearSearch() {
    state = state.copyWith(searchResult: [], isSearching: false);
  }
}
