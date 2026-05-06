import '../../../core/storage/secure_storage_service.dart';
import '../models/auth_models.dart';
import 'auth_api_client.dart';

class AuthRepository {
  final AuthApiClient _apiClient;
  final SecureStorageService _storageService;

  AuthRepository(this._apiClient, this._storageService);

  Future<LoginResponse> authenticate(String username, String password) async {
    final req = LoginRequest(username: username, password: password);
    final response = await _apiClient.login(req);
    await _storageService.saveToken(response.token);
    return response;
  }
}
