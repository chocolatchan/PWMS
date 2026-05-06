import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/api_service.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/error/exceptions.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';
import 'auth_models.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final StorageService _storage;

  AuthRepositoryImpl({
    required ApiService apiService,
    required StorageService storage,
  })  : _apiService = apiService,
        _storage = storage;

  @override
  Future<AuthUser> login(String email, String password) async {
    try {
      final data = {
        'username': email,
        'password': password,
      };
      print('DEBUG: Sending login data: $data');
      final response = await _apiService.post('/auth/login', data: data);
      var authResponse = AuthResponse.fromJson(response.data);
      
      // MOCK: Inject Putaway Permission for development accounts if missing
      final lowerEmail = email.toLowerCase();
      if (lowerEmail.contains('admin') || lowerEmail.contains('staff')) {
        final currentPermissions = List<String>.from(authResponse.user.permissions);
        if (!currentPermissions.contains('putaway:execute')) {
          currentPermissions.add('putaway:execute');
          authResponse = authResponse.copyWith(
            user: authResponse.user.copyWith(permissions: currentPermissions),
          );
        }
      }
      
      // Save to storage
      await _storage.saveToken(authResponse.token);
      await _storage.saveUserData(authResponse.user.toJson());
      await _storage.savePermissions(authResponse.user.permissions);

      return authResponse.user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException();
      } else if (e.response?.statusCode == 403) {
        throw PermissionDeniedException();
      }
      throw NetworkException();
    } catch (e) {
      throw AppException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _storage.clearAll();
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    final userData = await _storage.getUserData();
    if (userData != null) {
      return AuthUser.fromJson(userData);
    }
    return null;
  }
  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await _apiService.post('/auth/change-password', data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw AppException('Invalid old password');
      }
      throw NetworkException();
    } catch (e) {
      throw AppException('Failed to change password: $e');
    }
  }

  @override
  Future<bool> verifyPassword(String password) async {
    try {
      final response = await _apiService.post('/auth/verify-password', data: {
        'password': password,
      });
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    apiService: ref.watch(apiServiceProvider),
    storage: ref.watch(storageServiceProvider),
  );
}
