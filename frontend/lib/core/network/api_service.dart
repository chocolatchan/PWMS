import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pwms_frontend/core/config/env_config.dart';
import 'package:pwms_frontend/core/network/interceptors/auth_interceptor.dart';
import 'package:pwms_frontend/core/network/interceptors/error_interceptor.dart';
import 'package:pwms_frontend/features/auth/presentation/providers/auth_provider.dart';

// Import authProviderInst from main.dart or where it's defined
// Since it's in main.dart right now, I'll use a comment or a proper move later.
// For now, I'll assume we can access it or I'll move it to a feature provider.

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(envConfigProvider);
  final dio = Dio(BaseOptions(
    baseUrl: config.apiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 15),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
  
  dio.interceptors.addAll([
    AuthInterceptor(),
    ErrorInterceptor(
      onUnauthorized: () {
        ref.read(authProviderInst).logout();
      },
    ),
  ]);
  
  return dio;
});

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});

class ApiService {
  final Dio dio;
  
  ApiService(this.dio);

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) {
    return dio.put(path, data: data);
  }

  Future<Response> delete(String path) {
    return dio.delete(path);
  }
}
