import 'dart:developer' as dev;

/// Configuration for the API environment.
///
/// This class handles reading environment variables passed during build/run
/// using `--dart-define`. It provides a centralized way to access network settings.
abstract final class EnvConfig {
  /// The IP address of the backend API.
  /// 
  /// Defaults to '10.0.2.2' which is the standard loopback address 
  /// for the Android Emulator to reach the host machine.
  static const String apiIp = String.fromEnvironment(
    'API_IP',
    defaultValue: '10.0.2.2',
  );

  /// The full base URL for the V1 API.
  /// 
  /// Derived from the [apiIp] environment variable.
  static String get baseUrl {
    const port = '3000';
    const apiPath = '/api/v1';
    final url = 'http://$apiIp:$port$apiPath';
    
    // Rule 1: No raw print statements. Using developer log.
    dev.log('Initializing API with baseUrl: $url', name: 'NETWORK.CONFIG');
    
    return url;
  }

  /// Convenience getter for the WebSocket endpoint.
  static String get wsUrl => 'ws://$apiIp:3000/ws';
}
