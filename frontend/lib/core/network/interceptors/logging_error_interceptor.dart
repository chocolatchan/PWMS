import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import '../../error/api_failure.dart';

/// A custom Dio interceptor that handles logging and maps raw [DioException]s 
/// to our domain-specific [ApiFailure].
class LoggingErrorInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Rule 1: No raw print(), use log()
    dev.log(
      '------------------------------------------------------------------\n'
      '🚀 REQUEST[${options.method}] => PATH: ${options.path}\n'
      'Headers: ${options.headers}\n'
      'Body: ${options.data}\n'
      '------------------------------------------------------------------',
      name: 'NETWORK.DIO',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    dev.log(
      '------------------------------------------------------------------\n'
      '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}\n'
      'Data: ${response.data}\n'
      '------------------------------------------------------------------',
      name: 'NETWORK.DIO',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapDioExceptionToApiFailure(err);

    dev.log(
      '------------------------------------------------------------------\n'
      '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}\n'
      'Type: ${err.type}\n'
      'Failure: ${failure.toMessage()}\n'
      '------------------------------------------------------------------',
      name: 'NETWORK.DIO',
      error: err,
    );

    // Rule 2: Centralize all API error mapping. The UI should NEVER see a raw DioException.
    // We reject with the failure in the error field.
    return handler.reject(
      err.copyWith(error: failure),
    );
  }

  ApiFailure _mapDioExceptionToApiFailure(DioException err) {
    // 1. Handle timeouts
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return const ApiFailure.timeout();
    }

    // 2. Handle connection issues
    if (err.type == DioExceptionType.connectionError || 
        err.type == DioExceptionType.unknown) {
      return const ApiFailure.networkError();
    }

    final response = err.response;
    if (response != null) {
      final statusCode = response.statusCode;

      // 3. Handle Unauthorized (401)
      if (statusCode == 401) {
        return const ApiFailure.unauthorized();
      }

      // 4. Handle Server Errors (500)
      if (statusCode == 500) {
        String? rustErrorMessage;
        // Extract error message from JSON payload {"error": "message"} from Rust
        if (response.data is Map<String, dynamic>) {
          rustErrorMessage = response.data['error'] as String?;
        }
        
        return ApiFailure.serverError(
          code: 500,
          message: rustErrorMessage ?? 'Máy chủ gặp sự cố xử lý.',
        );
      }

      // 5. Handle other status codes
      return ApiFailure.serverError(
        code: statusCode ?? 0,
        message: 'Lỗi không xác định từ máy chủ.',
      );
    }

    return const ApiFailure.unknown(
      'Đã xảy ra lỗi không mong muốn trong quá trình xử lý yêu cầu.',
    );
  }
}
