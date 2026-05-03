import 'package:dio/dio.dart';
import '../exceptions.dart';

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
        return handler.next(UnauthorizedException());
      case 403:
        return handler.next(PermissionDeniedException());
      default:
        // Handle other errors or pass through
        return handler.next(err);
    }
  }
}
