import 'package:dio/dio.dart';
import '../models/auth_dto.dart';
import 'auth_storage.dart';

class AuthRepository {
  final Dio _dio;
  final AuthStorage _storage;

  AuthRepository(this._dio, this._storage);

  Future<LoginResponse> login(String username, String password) async {
    try {
      final response = await _dio.post('login', data: {
        'username': username,
        'password': password,
      });
      final data = response.data as Map<String, dynamic>;
      final loginResponse = LoginResponse.fromJson(data);
      
      // Save token to secure storage. Role is parsed automatically via JwtDecoder in getRole()
      await _storage.saveToken(loginResponse.token);
      return loginResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid username or password');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() => _storage.deleteToken();
  Future<String?> getToken() => _storage.getToken();
  Future<String?> getRole() => _storage.getRole();
}
