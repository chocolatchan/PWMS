import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_failure.freezed.dart';

/// Represents all possible failures when interacting with the API.
/// 
/// This class ensures that the UI layer only deals with high-level, 
/// human-readable failures rather than raw Dio exceptions.
@freezed
sealed class ApiFailure with _$ApiFailure {
  /// Occurs when there is no internet connection or the server is unreachable.
  const factory ApiFailure.networkError() = _NetworkError;

  /// Occurs when the server returns a non-2xx status code.
  const factory ApiFailure.serverError({
    required int code,
    required String message,
  }) = _ServerError;

  /// Occurs when the user is not logged in or the token has expired (401).
  const factory ApiFailure.unauthorized() = _Unauthorized;

  /// Occurs when the request takes longer than the configured timeout.
  const factory ApiFailure.timeout() = _Timeout;

  /// A catch-all for unexpected errors.
  const factory ApiFailure.unknown([String? message]) = _Unknown;
}

/// Extension to provide easy access to localized/human-readable messages.
extension ApiFailureX on ApiFailure {
  String toMessage() {
    return when(
      networkError: () => 'Lỗi kết nối. Vui lòng kiểm tra internet.',
      serverError: (code, message) => 'Lỗi máy chủ ($code): $message',
      unauthorized: () => 'Phiên làm việc hết hạn. Vui lòng đăng nhập lại.',
      timeout: () => 'Yêu cầu quá hạn. Vui lòng thử lại sau.',
      unknown: (msg) => msg ?? 'Đã xảy ra lỗi không xác định.',
    );
  }
}
