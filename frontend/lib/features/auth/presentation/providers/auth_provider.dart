import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/auth_repository_impl.dart';
import 'auth_state.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    // Zero-Trust: Purge session on boot to prevent auto-login on shared devices
    Future.microtask(() => purgeSession());
    return const AuthState.initial();
  }

  Future<void> purgeSession() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.logout(); // Nuclear purge of Token and User from Disk
    state = const AuthState.unauthenticated();
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.login(email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.unauthenticated(e.toString());
    }
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
    state = const AuthState.unauthenticated();
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final repository = ref.read(authRepositoryProvider);
    await repository.changePassword(oldPassword, newPassword);
  }

  Future<bool> verifyPassword(String password) async {
    final repository = ref.read(authRepositoryProvider);
    return await repository.verifyPassword(password);
  }
}
