import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pwms_frontend/core/network/api_service.dart';

final authProviderInst = ChangeNotifierProvider((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthProvider(apiService)..init();
});

class User {
  final int id;
  final String username;
  final List<String> presets;

  User({required this.id, required this.username, required this.presets});

  factory User.fromJson(Map<String, dynamic> json, String token) {
    // Decode JWT for user_id (sub)
    int userId = 0;
    try {
      final parts = token.split('.');
      if (parts.length == 3) {
        final payload = jsonDecode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
        );
        userId = payload['sub'] is int ? payload['sub'] : int.parse(payload['sub'].toString());
      }
    } catch (e) {
      debugPrint('Error decoding token: $e');
    }

    return User(
      id: userId,
      username: json['username'],
      presets: List<String>.from(json['presets'] ?? []),
    );
  }
}

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  final ApiService _apiService;
  
  User? _user;
  String? _token;
  bool _isLoading = false;

  AuthProvider(this._apiService);
  
  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  Future<void> init() async {
    _token = await _storage.read(key: 'auth_token');
    final savedUser = await _storage.read(key: 'auth_user');
    if (savedUser != null && _token != null) {
      try {
        final userData = jsonDecode(savedUser);
        _user = User(
          id: userData['id'],
          username: userData['username'],
          presets: List<String>.from(userData['presets'] ?? []),
        );
      } catch (e) {
        debugPrint('Error restoring user: $e');
      }
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.post('/auth/login', data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        _token = data['token'];
        _user = User.fromJson(data, _token!);

        await _storage.write(key: 'auth_token', value: _token);
        await _storage.write(
          key: 'auth_user',
          value: jsonEncode({
            'id': _user!.id,
            'username': _user!.username,
            'presets': _user!.presets,
          }),
        );

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    await _storage.deleteAll();
    notifyListeners();
  }
}
