import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/io.dart';
import 'package:pwms_frontend/core/config/env_config.dart';
import 'models/ws_event.dart';

class WebSocketService {
  final Uri _url;
  IOWebSocketChannel? _channel;
  
  // Stream Abstraction: The persistent pipe for the UI
  final _messageController = StreamController<WsEvent>.broadcast();
  
  int _retryCount = 0;
  bool _isConnected = false;
  bool _isManualDisconnect = false;
  final _random = Random();

  WebSocketService(String url) : _url = Uri.parse(url);

  // Expose the persistent broadcast stream
  Stream<WsEvent> get stream => _messageController.stream;
  bool get isConnected => _isConnected;

  void connect() {
    _isManualDisconnect = false;
    _establishConnection();
  }

  void _establishConnection() {
    debugPrint('PWMS_WS: Attempting to connect to $_url');
    
    try {
      _channel = IOWebSocketChannel.connect(_url);
      _isConnected = true;
      _retryCount = 0; // Reset on success

      _channel!.stream.listen(
        (message) {
          _handleIncomingMessage(message);
        },
        onDone: _onDone,
        onError: _onError,
        cancelOnError: true,
      );
      
      debugPrint('PWMS_WS: Connected successfully.');
    } catch (e) {
      debugPrint('PWMS_WS: Connection error: $e');
      _reconnect();
    }
  }

  void _handleIncomingMessage(dynamic message) {
    try {
      final Map<String, dynamic> data = jsonDecode(message.toString());
      final event = WsEvent.fromJson(data);
      _messageController.add(event);
    } catch (e) {
      debugPrint('PWMS_WS: Parsing error - $e. Raw message: $message');
      _messageController.add(const WsEvent.unknown());
    }
  }

  void _onDone() {
    _isConnected = false;
    debugPrint('PWMS_WS: Connection closed.');
    if (!_isManualDisconnect) {
      _reconnect();
    }
  }

  void _onError(error) {
    _isConnected = false;
    debugPrint('PWMS_WS: Stream error: $error');
    _reconnect();
  }

  void _reconnect() {
    if (_isManualDisconnect) return;

    // Exponential backoff: 2^n seconds + jitter
    final delaySeconds = pow(2, _retryCount).toInt();
    final jitter = _random.nextInt(1000); // 0-999ms jitter
    final delay = Duration(seconds: min(delaySeconds, 30)) + Duration(milliseconds: jitter);

    debugPrint('PWMS_WS: Reconnecting in ${delay.inMilliseconds}ms (Attempt ${_retryCount + 1})');
    
    _retryCount++;
    
    Future.delayed(delay, () {
      if (!_isManualDisconnect) {
        _establishConnection();
      }
    });
  }

  void sendMessage(dynamic message) {
    if (_isConnected && _channel != null) {
      _channel!.sink.add(message);
    } else {
      debugPrint('PWMS_WS: Cannot send message, not connected.');
    }
  }

  void disconnect() {
    debugPrint('PWMS_WS: Manual disconnect.');
    _isManualDisconnect = true;
    _isConnected = false;
    _retryCount = 0;
    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}

final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final config = ref.watch(envConfigProvider);
  final service = WebSocketService(config.wsBaseUrl);
  
  // Auto-connect on provider initialization
  service.connect();
  
  ref.onDispose(() => service.dispose());
  return service;
});
