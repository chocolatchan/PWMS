// ============================================================
// FILE: picking_list_screen.dart
// List of pending picking tasks.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'picking_mock_data.dart';
import 'picking_screen.dart';

class PickingListScreen extends ConsumerWidget {
  const PickingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          'DANH SÁCH NHẶT HÀNG',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: PickingMockData.sampleSO.items.length,
        itemBuilder: (context, index) {
          final task = PickingMockData.sampleSO.items[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: const Color(0xFF334155)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                task.productName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Vị trí: ${task.targetLoc} | Lô: ${task.batchCode}',
                    style: const TextStyle(color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (task.isLasa)
                        _Badge(label: 'LASA', color: Colors.orange),
                      const Spacer(),
                      Text(
                        '${task.expectedQty} đơn vị',
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                // In the wizard model, we start from the setup screen.
                // This list is just for overview.
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PickingScreen()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
