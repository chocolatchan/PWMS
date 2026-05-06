import 'auth_user.dart';

extension AuthUserPermissions on AuthUser {
  /// Checks if the user has a specific permission.
  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }

  /// Checks if the user has any of the permissions in the list.
  bool hasAnyPermission(List<String> requiredPermissions) {
    return requiredPermissions.any((p) => permissions.contains(p));
  }
}
