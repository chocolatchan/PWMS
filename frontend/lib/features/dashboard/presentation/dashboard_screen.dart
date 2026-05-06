import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../auth/models/auth_models.dart';
import '../../../core/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  final LoginResponse? user;
  const DashboardScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final perms = user?.permissions ?? [];

    // Build module list based on permissions
    final modules = <_Module>[
      if (perms.contains('inbound:read') || perms.contains('inbound:write'))
        _Module(
          icon: Icons.local_shipping_rounded,
          title: 'Nhập Hàng',
          subtitle: 'Tiếp nhận & phân loại rổ',
          color: AppTheme.zoneGreen,
          route: '/inbound/demo',
          badge: 'GSP',
        ),
      if (perms.contains('qc:inspect') || perms.contains('qc:release'))
        _Module(
          icon: Icons.verified_rounded,
          title: 'Kiểm Tra CL',
          subtitle: 'QA Release / Reject',
          color: AppTheme.zoneOrange,
          route: '/qc',
          badge: 'GSP',
        ),
      if (perms.contains('putaway:execute'))
        _Module(
          icon: Icons.shelves,
          title: 'Cất Kệ',
          subtitle: 'Putaway Routing FEFO',
          color: AppTheme.zoneBlue,
          route: '/putaway',
          badge: 'GSP',
        ),
      if (perms.contains('outbound:execute'))
        _Module(
          icon: Icons.inventory_2_rounded,
          title: 'Nhặt Hàng',
          subtitle: 'Picking theo FEFO',
          color: const Color(0xFF7C3AED),
          route: '/picking',
          badge: 'GSP',
        ),
      if (perms.contains('outbound:pack'))
        _Module(
          icon: Icons.inventory_2_rounded,
          title: 'Đóng Gói',
          subtitle: 'Gom rổ & Niêm phong',
          color: const Color(0xFF38BDF8),
          route: '/packing',
          badge: 'Packer',
        ),
      if (perms.contains('outbound:dispatch'))
        _Module(
          icon: Icons.local_shipping_rounded,
          title: 'Xuất Hàng',
          subtitle: 'GSP Gate Check',
          color: const Color(0xFF4ADE80),
          route: '/dispatch',
          badge: 'Dispatch',
        ),
      if (perms.contains('qc:release') || perms.contains('disposal:approve'))
        _Module(
          icon: Icons.approval_rounded,
          title: 'Phê Duyệt',
          subtitle: '3-Level Sign-off',
          color: const Color(0xFFDB2777),
          route: '/approvals',
          badge: 'Chờ ký',
        ),
      if (perms.contains('recall:execute'))
        _Module(
          icon: Icons.assignment_return_rounded,
          title: 'Returns & Recall',
          subtitle: 'Reverse Logistics',
          color: AppTheme.zoneRed,
          route: '/phase6',
          badge: 'Phase 6',
        ),
      if (perms.contains('audit:read'))
        _Module(
          icon: Icons.admin_panel_settings_rounded,
          title: 'Control Tower',
          subtitle: 'KPIs & Traceability',
          color: const Color(0xFF64748B),
          route: '/admin-tower',
          badge: 'Admin',
        ),
    ];

    // Dev/Demo module — removed as it's now the primary Inbound entry
    final allModules = modules;

    // Fallback if no perms yet (dev mode)
    if (modules.isEmpty) {
      return _NoPermissionsView(user: user);
    }

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest.withOpacity(0.3),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PWMS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            Text(
              user != null ? 'Xin chào, ${user!.fullName}' : 'Bảng điều khiển',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Đăng xuất',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // ── Header card ──────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _RoleCard(user: user),
            ),
          ),

          // ── Section title ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Text(
                'PHÂN HỆ HOẠT ĐỘNG',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: cs.primary,
                ),
              ),
            ),
          ),

          // ── Module grid ────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.05,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: allModules.length,
              itemBuilder: (context, i) => _ModuleTile(module: allModules[i]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đăng xuất?'),
        content: const Text('Bạn có chắc muốn thoát khỏi phiên làm việc?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/');
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}

// ── Role summary card ─────────────────────────────────────
class _RoleCard extends StatelessWidget {
  final LoginResponse? user;
  const _RoleCard({this.user});

  String _roleLabel(List<String> perms) {
    if (perms.contains('audit:read')) return 'Administrator';
    if (perms.contains('recall:execute')) return 'Giám Đốc Kho';
    if (perms.contains('disposal:approve')) return 'Thủ Kho / Dược Sĩ';
    if (perms.contains('qc:inspect')) return 'Nhân Viên QA';
    if (perms.contains('putaway:execute')) return 'Nhân Viên Cất Kệ';
    if (perms.contains('outbound:execute')) return 'Nhân Viên Nhặt Hàng';
    if (perms.contains('inbound:write')) return 'Nhân Viên Nhận Hàng';
    return 'Nhân Viên Kho';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final perms = user?.permissions ?? [];
    final role = _roleLabel(perms);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: cs.primaryContainer,
              radius: 28,
              child: Text(
                (user?.fullName ?? '?').substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.fullName ?? 'Người dùng',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    role,
                    style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: perms
                        .take(3)
                        .map(
                          (p) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              p,
                              style: TextStyle(
                                fontSize: 10,
                                color: cs.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Module Tile ───────────────────────────────────────────
class _Module {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String route;
  final String? badge;

  const _Module({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.route,
    this.badge,
  });
}

class _ModuleTile extends StatelessWidget {
  final _Module module;
  const _ModuleTile({required this.module});

  @override
  Widget build(BuildContext context) {
    final c = module.color;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(module.route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: c.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(module.icon, color: c, size: 24),
                  ),
                  const Spacer(),
                  if (module.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: c,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        module.badge!,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                module.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                module.subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── No permissions fallback ───────────────────────────────
class _NoPermissionsView extends StatelessWidget {
  final LoginResponse? user;
  const _NoPermissionsView({this.user});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('PWMS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 64,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              const Text(
                'Tài khoản chưa được cấp quyền',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Liên hệ Quản trị viên để được phân quyền.',
                textAlign: TextAlign.center,
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
