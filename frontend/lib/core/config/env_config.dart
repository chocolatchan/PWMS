import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentConfig {
  final String apiBaseUrl;
  final String wsBaseUrl;

  const EnvironmentConfig({
    required this.apiBaseUrl,
    required this.wsBaseUrl,
  });

  // Default values using dart-define or fallback to localhost
  static const String _defaultApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:3001/api',
  );

  static const String _defaultWsBaseUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'ws://127.0.0.1:3001/ws',
  );

  factory EnvironmentConfig.dev() {
    return const EnvironmentConfig(
      apiBaseUrl: _defaultApiBaseUrl,
      wsBaseUrl: _defaultWsBaseUrl,
    );
  }

  // You can add more environments here (prod, staging, etc.)
}

final envConfigProvider = Provider<EnvironmentConfig>((ref) {
  // Logic to switch environments can be added here
  return EnvironmentConfig.dev();
});
