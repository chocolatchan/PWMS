import 'package:dio/dio.dart';
import '../models/auth_models.dart';

class AuthApiClient {
  final Dio _dio;

  AuthApiClient(this._dio);

  Future<LoginResponse> login(LoginRequest req) async {
    final response = await _dio.post(
      '/auth/login',
      data: req.toJson(),
    );
    return LoginResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
