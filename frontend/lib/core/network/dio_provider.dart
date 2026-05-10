import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'env_config.dart';
import 'interceptors/logging_error_interceptor.dart';

part 'dio_provider.g.dart';

/// Provider for a globally configured [Dio] instance.
/// 
/// Set [keepAlive] to true to ensure the same instance is reused across the app
/// and not disposed of when not in use.
@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  final options = BaseOptions(
    baseUrl: EnvConfig.baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    // Ensure we send and receive JSON
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  final dioInstance = Dio(options);

  // Attach interceptors
  dioInstance.interceptors.addAll([
    // 1. Optional: Retry Interceptor (Concept for idempotent requests)
    _RetryInterceptor(dio: dioInstance),
    
    // 2. Main Logging and Error Mapping Interceptor
    LoggingErrorInterceptor(),
    
    // 3. Note: AuthInterceptor should be added here once Token storage is ready
  ]);

  return dioInstance;
}

/// A simple interceptor to retry idempotent requests (GET) once upon timeout.
class _RetryInterceptor extends Interceptor {
  final Dio dio;

  _RetryInterceptor({required this.dio});

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only retry on timeouts
    final isTimeout = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout;

    // Only retry GET requests (idempotent)
    final isIdempotent = err.requestOptions.method == 'GET';

    // Avoid infinite retry loops by checking a custom extra field
    final hasRetried = err.requestOptions.extra['retried'] == true;

    if (isTimeout && isIdempotent && !hasRetried) {
      try {
        final options = err.requestOptions;
        options.extra['retried'] = true; // Mark as retried
        
        // Use the same Dio instance to fetch the request again
        final response = await dio.fetch(options);
        return handler.resolve(response);
      } catch (e) {
        // If retry fails, pass the original error along
        return handler.next(err);
      }
    }

    return handler.next(err);
  }
}
