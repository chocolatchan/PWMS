// ============================================================
// FILE: packing_screen.dart
// Role: PACKER - Consolidation & Sealing.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'outbound_controller.dart';
import 'outbound_models.dart';

class PackingScreenV2 extends ConsumerStatefulWidget {
  const PackingScreenV2({super.key});
  @override
  ConsumerState<PackingScreenV2> createState() => _PackingScreenV2State();
}

class _PackingScreenV2State extends ConsumerState<PackingScreenV2> {
  String _soInput = '';
  SalesOrder? _activeSO;
  String _sealCode = '';

  void _searchSO() {
    final state = ref.read(outboundControllerProvider);
    final so = state.orders.where((o) => o.soId == _soInput.toUpperCase()).firstOrNull;
    if (so != null && so.status == OrderStatus.picked) {
      setState(() => _activeSO = so);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SO không tìm thấy hoặc đã đóng gói!'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the global state to get updates on arrived totes
    final globalOrders = ref.watch(outboundControllerProvider).orders;
    if (_activeSO != null) {
      _activeSO = globalOrders.firstWhere((o) => o.soId == _activeSO!.soId);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text('ĐÓNG GÓI (PACKER)'), backgroundColor: const Color(0xFF1E293B), foregroundColor: Colors.white),
      body: _activeSO == null ? _buildSearchUI() : _buildPackingUI(),
    );
  }

  Widget _buildSearchUI() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.receipt_long, size: 64, color: Color(0xFF64748B)),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(text: _soInput),
              onChanged: (v) => _soInput = v,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(hintText: 'Nhập mã SO (vd: SO-123)...', hintStyle: const TextStyle(color: Color(0xFF334155)), filled: true, fillColor: const Color(0xFF1E293B), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(onPressed: () => setState(() => _soInput = 'SO-123'), icon: const Icon(Icons.bolt, color: Colors.orange)),
        ]),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _searchSO, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8), foregroundColor: Colors.black), child: const Text('BẮT ĐẦU'))),
      ]),
    );
  }

  Widget _buildPackingUI() {
    final allArrived = _activeSO!.requiredTotes.every((t) => t.isArrived);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('ĐANG XỬ LÝ: ${_activeSO!.soId}', style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w900, fontSize: 18)),
        const SizedBox(height: 20),
        const Text('GOM RỔ (CONSOLIDATION)', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: _activeSO!.requiredTotes.length,
            itemBuilder: (context, i) {
              final tote = _activeSO!.requiredTotes[i];
              return _ToteCard(tote: tote, onScan: () => ref.read(outboundControllerProvider.notifier).markToteArrived(_activeSO!.soId, tote.toteId));
            },
          ),
        ),
        if (allArrived) ...[
          const Divider(color: Color(0xFF334155), height: 40),
          const Text('TẠO NIÊM PHONG (SEAL)', style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: TextField(
                controller: TextEditingController(text: _sealCode),
                onChanged: (v) => _sealCode = v,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(hintText: 'Nhập Mã Seal...', filled: true, fillColor: const Color(0xFF1E293B), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(onPressed: () => setState(() => _sealCode = 'SEAL-999'), icon: const Icon(Icons.bolt, color: Colors.orange)),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _sealCode.isEmpty ? null : () {
                ref.read(outboundControllerProvider.notifier).submitPacking(_activeSO!.soId, _sealCode);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã đóng gói thành công!'), backgroundColor: Colors.green));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4ADE80), foregroundColor: Colors.black),
              child: const Text('XÁC NHẬN ĐÓNG GÓI'),
            ),
          ),
        ] else
          const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text('Vui lòng quét đủ rổ để tiếp tục', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)))),
      ]),
    );
  }
}

class _ToteCard extends StatelessWidget {
  final OutboundTote tote;
  final VoidCallback onScan;
  const _ToteCard({required this.tote, required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12), border: Border.all(color: tote.isArrived ? const Color(0xFF4ADE80) : Colors.transparent)),
      child: Row(children: [
        Icon(Icons.shopping_basket, color: tote.isArrived ? const Color(0xFF4ADE80) : const Color(0xFF64748B)),
        const SizedBox(width: 12),
        Text(tote.toteId, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const Spacer(),
        if (tote.isArrived)
          const Icon(Icons.check_circle, color: Color(0xFF4ADE80))
        else
          TextButton(onPressed: onScan, child: const Text('MOCK SCAN')),
      ]),
    );
  }
}
