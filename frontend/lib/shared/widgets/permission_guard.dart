import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pwms_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:pwms_frontend/features/auth/presentation/providers/auth_state.dart';
import 'package:pwms_frontend/features/auth/domain/auth_extensions.dart';

class PermissionGuard extends ConsumerWidget {
  final String permission;
  final Widget child;
  final Widget? fallback;

  const PermissionGuard({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.maybeWhen(
      authenticated: (user) {
        if (user.hasPermission(permission)) {
          return child;
        }
        return fallback ?? const SizedBox.shrink();
      },
      orElse: () => fallback ?? const SizedBox.shrink(),
    );
  }
}

