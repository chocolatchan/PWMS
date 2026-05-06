class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

class LoginResponse {
  final String token;
  final String userId;
  final String fullName;
  final List<String> permissions;

  LoginResponse({
    required this.token,
    required this.userId,
    required this.fullName,
    required this.permissions,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    final perms = (user['permissions'] as List<dynamic>?)?.cast<String>() ?? [];
    return LoginResponse(
      token: json['token'] as String,
      userId: user['id'].toString(),
      fullName: user['fullName'] as String,
      permissions: perms,
    );
  }

  /// Check if user has a specific permission
  bool hasPermission(String perm) => permissions.contains(perm);

  /// Check if user has any of the given permissions
  bool hasAnyPermission(List<String> perms) => perms.any((p) => permissions.contains(p));
}
