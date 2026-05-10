import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pwms_frontend/core/storage/secure_storage_service.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    // Tự động nhận diện môi trường hoặc sử dụng IP từ --dart-define=API_IP=...
    String apiIp = const String.fromEnvironment('API_IP', defaultValue: '127.0.0.1');
    String baseUrl = 'http://$apiIp:3000/api'; 
    
    if (!kIsWeb && Platform.isAndroid && apiIp == '127.0.0.1') {
      baseUrl = 'http://10.0.2.2:3000/api'; // Dành riêng cho Android Emulator nếu IP là localhost
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }

    _dio.interceptors.add(AppInterceptor());
  }

  Dio get dio => _dio;
}

class AppInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final storage = GetIt.I<SecureStorageService>();
    final token = await storage.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      final storage = GetIt.I<SecureStorageService>();
      final router = GetIt.I<GoRouter>();

      storage.deleteToken();
      router.go('/'); // Force logout context-less
    }

    return handler.next(err);
  }
}
