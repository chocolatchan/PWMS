import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pwms_frontend/core/constants/app_permissions.dart';
import 'package:pwms_frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:pwms_frontend/shared/widgets/permission_guard.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PWMS', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16.0),
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        children: [
          // 1. Inbound Card
          PermissionGuard(
            permission: AppPermissions.inboundRead,
            child: _DashboardCard(
              title: 'Inbound\n(Nhập kho)',
              icon: Icons.input,
              onTap: () => context.push('/inbound'),
            ),
          ),
          
          // 2. Outbound Card
          PermissionGuard(
            permission: AppPermissions.outboundRead,
            child: _DashboardCard(
              title: 'Outbound\n(Xuất kho)',
              icon: Icons.local_shipping,
              onTap: () {},
            ),
          ),

          // 3. QC Inspection Card
          PermissionGuard(
            permission: AppPermissions.qcInspect,
            child: _DashboardCard(
              title: 'QC Inspection',
              icon: Icons.fact_check,
              onTap: () {},
            ),
          ),

          // 4. Recall Card (Critical - Red)
          PermissionGuard(
            permission: AppPermissions.recallExecute,
            child: _DashboardCard(
              title: 'Recall\n(Thu hồi)',
              icon: Icons.warning,
              color: Colors.red.shade700,
              iconColor: Colors.white,
              textColor: Colors.white,
              onTap: () {},
            ),
          ),

          // 5. Putaway Card
          PermissionGuard(
            permission: AppPermissions.putawayExecute,
            child: _DashboardCard(
              title: 'Putaway\n(Cất hàng)',
              icon: Icons.inventory,
              color: Colors.indigo.shade600,
              iconColor: Colors.white,
              textColor: Colors.white,
              onTap: () => context.push('/putaway'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final Color? iconColor;
  final Color? textColor;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: iconColor ?? Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
