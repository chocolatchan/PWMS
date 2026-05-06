import 'auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> login(String email, String password);
  Future<void> logout();
  Future<AuthUser?> getCurrentUser();
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<bool> verifyPassword(String password);
}
