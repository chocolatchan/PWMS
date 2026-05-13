import 'package:riverpod/riverpod.dart';
import '../data/auth_repository.dart';
import '../data/auth_storage.dart';
import '../../../core/network/dio_client.dart';

// Note: authStorageProvider is already defined in auth_storage.dart
// We just import it here, or we can export it if needed.

final authRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(authStorageProvider);
  return AuthRepository(dio, storage);
});

// Provider to hold login state (loading, error)
final loginStateProvider = StateNotifierProvider<LoginNotifier, AsyncValue<void>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LoginNotifier(repo);
});

class LoginNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repo;
  
  LoginNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      await _repo.login(username, password);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
