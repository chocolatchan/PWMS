// ============================================================
// FILE: qc_list_screen.dart
// Industrial dark-theme list of QRN- quarantine tasks.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'qc_controller.dart';
import 'qc_mock_data.dart';
import 'qc_models.dart';
import 'qc_detail_screen.dart';

class QcListScreen extends ConsumerWidget {
  const QcListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(qcListControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PWMS — KIỂM TRA CHẤT LƯỢNG',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
            Text(
              'QC Release · Phase 2 · DEMO MODE',
              style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), letterSpacing: 0.5),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFF59E0B)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pending_actions_rounded, size: 14, color: Color(0xFFF59E0B)),
                const SizedBox(width: 4),
                Text(
                  '${items.length} chờ duyệt',
                  style: const TextStyle(
                    color: Color(0xFFF59E0B),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: items.isEmpty
          ? _buildEmptyState(context)
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) => _QcTaskCard(item: items[i]),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: const Icon(Icons.check_circle_outline_rounded, size: 52, color: Color(0xFF4ADE80)),
          ),
          const SizedBox(height: 20),
          const Text(
            'TẤT CẢ ĐÃ ĐƯỢC PHÊ DUYỆT',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
              color: Color(0xFF4ADE80),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Không có lô hàng nào đang chờ kiểm định.',
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class _QcTaskCard extends ConsumerWidget {
  final QcItem item;
  const _QcTaskCard({required this.item});

  Color get _reasonColor {
    switch (item.reason) {
      case QcReason.missingDocs:          return const Color(0xFFF59E0B);
      case QcReason.physicalDamage:       return const Color(0xFFEF4444);
      case QcReason.temperatureExcursion: return const Color(0xFF8B5CF6);
    }
  }

  IconData get _reasonIcon {
    switch (item.reason) {
      case QcReason.missingDocs:          return Icons.description_outlined;
      case QcReason.physicalDamage:       return Icons.broken_image_outlined;
      case QcReason.temperatureExcursion: return Icons.thermostat_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(qcFormControllerProvider.notifier).loadItem(item);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const QcDetailScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          children: [
            // Header stripe
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: _reasonColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Tote chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFF59E0B)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.shopping_basket_rounded, size: 13, color: Color(0xFFF59E0B)),
                            const SizedBox(width: 5),
                            Text(
                              item.toteCode,
                              style: const TextStyle(
                                color: Color(0xFFF59E0B),
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Product code chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF334155),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.productCode,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Reason chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: _reasonColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _reasonColor.withOpacity(0.5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_reasonIcon, size: 12, color: _reasonColor),
                            const SizedBox(width: 4),
                            Text(
                              item.reason.code,
                              style: TextStyle(
                                color: _reasonColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.manufacturer,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _MetaChip(icon: Icons.numbers_rounded, label: 'Lô: ${item.batchNumber}'),
                      const SizedBox(width: 8),
                      _MetaChip(icon: Icons.inventory_2_outlined, label: '${item.declaredQty} ${item.unit}'),
                      const Spacer(),
                      Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.3)),
                    ],
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

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF64748B)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
        ],
      ),
    );
  }
}
