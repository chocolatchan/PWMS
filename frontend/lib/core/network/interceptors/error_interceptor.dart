import 'package:dio/dio.dart';
import '../../error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  final void Function()? onUnauthorized;

  ErrorInterceptor({this.onUnauthorized});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.response?.statusCode) {
      case 401:
        // Trigger force logout
        if (onUnauthorized != null) {
          onUnauthorized!();
        }
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: UnauthorizedException(),
            response: err.response,
            type: DioExceptionType.badResponse,
          ),
        );
      case 403:
        return handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: PermissionDeniedException(),
            response: err.response,
            type: DioExceptionType.badResponse,
          ),
        );
      default:
        // Handle other errors or pass through
        return handler.next(err);
    }
  }
}
