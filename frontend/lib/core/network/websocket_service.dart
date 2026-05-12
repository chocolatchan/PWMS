import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/env_config.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Ref _ref;
  bool _isConnecting = false;

  WebSocketService(this._ref);

  Future<void> connect() async {
    if (_isConnecting) return;
    _isConnecting = true;

    // Note: Using 'jwt_token' to match our AuthStorage implementation
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) {
      _isConnecting = false;
      return;
    }

    final base = EnvConfig.baseUrl.replaceFirst('http', 'ws').replaceFirst('/api/v2', '');
    final uri = Uri.parse('$base/api/v2/ws'); // Backend uses First Message Auth, not Query Params
    
    try {
      _channel = WebSocketChannel.connect(uri);
      
      // --- CRITICAL: First Message Auth Flow ---
      // Our Rust backend expects the token as the first JSON message
      _channel!.sink.add(jsonEncode({
        'type': 'auth',
        'token': token,
      }));

      _isConnecting = false;

      _channel!.stream.listen(
        (data) {
          final event = jsonDecode(data as String);
          _handleEvent(event);
        },
        onError: (e) {
          print('WebSocket error: $e');
          _reconnect();
        },
        onDone: () {
          print('WebSocket connection closed');
          _reconnect();
        },
      );
    } catch (e) {
      _isConnecting = false;
      _reconnect();
    }
  }

  void _reconnect() {
    _channel = null;
    Future.delayed(const Duration(seconds: 3), () => connect());
  }

  void _handleEvent(Map<String, dynamic> event) {
    // Backend OutboxEventMessage uses 'event_type' and 'payload'
    final type = event['event_type'] ?? event['type'] as String;
    final payload = event['payload'] ?? event;

    switch (type) {
      case 'TEMPERATURE_ALERT':
        _ref.read(temperatureAlertsProvider.notifier).addAlert(payload);
        break;
      case 'CONTAINER_PACKED':
        _ref.read(containerPackedProvider.notifier).state = payload;
        break;
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }
}

// Riverpod providers to hold live data
final temperatureAlertsProvider = StateNotifierProvider<TemperatureAlertsNotifier, List<Map<String, dynamic>>>((ref) {
  return TemperatureAlertsNotifier();
});

class TemperatureAlertsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  TemperatureAlertsNotifier() : super([]);
  
  void addAlert(Map<String, dynamic> alert) {
    state = [alert, ...state].take(50).toList(); // keep last 50
  }
}

final containerPackedProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

// Added global provider for the service
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketService(ref);
});
