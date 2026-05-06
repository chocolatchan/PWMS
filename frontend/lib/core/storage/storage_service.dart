import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage;

  StorageService(this._storage);

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';
  static const String _permissionsKey = 'auth_permissions';

  // Token methods
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // User methods
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: _userKey, value: jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final data = await _storage.read(key: _userKey);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  // Permissions methods
  Future<void> savePermissions(List<String> permissions) async {
    await _storage.write(key: _permissionsKey, value: jsonEncode(permissions));
  }

  Future<List<String>> getPermissions() async {
    final data = await _storage.read(key: _permissionsKey);
    if (data != null) {
      return List<String>.from(jsonDecode(data));
    }
    return [];
  }

  // General methods
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(const FlutterSecureStorage());
});
