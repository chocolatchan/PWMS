class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

class PermissionDeniedException extends AppException {
  PermissionDeniedException([super.message = 'You do not have permission to perform this action.']);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = 'Session expired. Please login again.']);
}

class NetworkException extends AppException {
  NetworkException([super.message = 'Network error occurred. Please check your connection.']);
}
