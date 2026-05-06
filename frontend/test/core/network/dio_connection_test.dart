import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pwms_frontend/core/config/env_config.dart';
import 'package:pwms_frontend/core/network/api_service.dart';
import 'package:pwms_frontend/core/network/interceptors/auth_interceptor.dart';

void main() {
  group('Network Plumbing Verification', () {
    test('EnvConfig variables are correctly initialized', () {
      final container = ProviderContainer();
      final config = container.read(envConfigProvider);

      expect(config.apiBaseUrl, isNotEmpty);
      expect(config.apiBaseUrl, contains('http'));
      expect(config.wsBaseUrl, isNotEmpty);
      expect(config.wsBaseUrl, contains('ws'));
    });

    test('DioProvider creates instance with correct BaseOptions', () {
      final container = ProviderContainer();
      final dio = container.read(dioProvider);
      final config = container.read(envConfigProvider);

      expect(dio.options.baseUrl, equals(config.apiBaseUrl));
      expect(dio.options.connectTimeout, equals(const Duration(seconds: 15)));
      expect(dio.options.receiveTimeout, equals(const Duration(seconds: 15)));
      expect(dio.options.sendTimeout, equals(const Duration(seconds: 15)));
      expect(dio.options.headers['Content-Type'], equals('application/json'));
    });

    test('AuthInterceptor is seamlessly attached', () {
      final container = ProviderContainer();
      final dio = container.read(dioProvider);

      final hasAuthInterceptor = dio.interceptors.any(
        (i) => i is AuthInterceptor,
      );
      expect(
        hasAuthInterceptor,
        isTrue,
        reason: 'AuthInterceptor should be present in the interceptors list',
      );
    });
  });
}
