// ============================================================
// FILE: outbound_dashboard.dart
// Entry point for Segregation of Duties (SoD).
// ============================================================

import 'package:flutter/material.dart';
import 'packing_screen.dart';
import 'dispatch_screen.dart';

class OutboundDashboard extends StatelessWidget {
  const OutboundDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('OUTBOUND MANAGEMENT', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const _RoleHeader(
              title: 'Hệ Thống Phân Quyền',
              subtitle: 'Vui lòng chọn vai trò để thực hiện nhiệm vụ tương ứng',
            ),
            const SizedBox(height: 40),
            _RoleCard(
              title: 'MÀN HÌNH ĐÓNG GÓI',
              role: 'PACKER',
              icon: Icons.inventory_2_rounded,
              color: const Color(0xFF38BDF8),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PackingScreenV2())),
            ),
            const SizedBox(height: 20),
            _RoleCard(
              title: 'MÀN HÌNH ĐIỀU PHỐI',
              role: 'DISPATCHER',
              icon: Icons.local_shipping_rounded,
              color: const Color(0xFF4ADE80),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DispatchScreenV2())),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _RoleHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String role;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({required this.title, required this.role, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(role, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                  const SizedBox(height: 4),
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }
}
