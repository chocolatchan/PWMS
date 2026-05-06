// ============================================================
// FILE: dispatch_screen.dart
// Role: DISPATCHER - Gate Check & Cold Chain.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'outbound_controller.dart';
import 'outbound_models.dart';

class DispatchScreenV2 extends ConsumerStatefulWidget {
  const DispatchScreenV2({super.key});
  @override
  ConsumerState<DispatchScreenV2> createState() => _DispatchScreenV2State();
}

class _DispatchScreenV2State extends ConsumerState<DispatchScreenV2> {
  String _sealInput = '';
  SalesOrder? _activeSO;
  double _temp = 0.0;
  bool _isTempValid = false;

  void _checkSeal() {
    final state = ref.read(outboundControllerProvider);
    final so = state.orders.where((o) => o.sealCode == _sealInput && o.status == OrderStatus.packed).firstOrNull;
    if (so != null) {
      setState(() => _activeSO = so);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Niêm phong không hợp lệ hoặc chưa được đóng gói!'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(title: const Text('ĐIỀU PHỐI (DISPATCHER)'), backgroundColor: const Color(0xFF1E293B), foregroundColor: Colors.white),
      body: _activeSO == null ? _buildGateCheckUI() : _buildDispatchUI(),
    );
  }

  Widget _buildGateCheckUI() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.security, size: 64, color: Color(0xFF64748B)),
        const SizedBox(height: 24),
        Row(children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(text: _sealInput),
              onChanged: (v) => _sealInput = v,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(hintText: 'Quét Mã Niêm Phong (SEAL)...', hintStyle: const TextStyle(color: Color(0xFF334155)), filled: true, fillColor: const Color(0xFF1E293B), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(onPressed: () => setState(() => _sealInput = 'SEAL-999'), icon: const Icon(Icons.bolt, color: Colors.orange)),
        ]),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _checkSeal, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4ADE80), foregroundColor: Colors.black), child: const Text('KIỂM TRA CỔNG'))),
      ]),
    );
  }

  Widget _buildDispatchUI() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('SO: ${_activeSO!.soId}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('NIÊM PHONG: ${_activeSO!.sealCode}', style: const TextStyle(color: Color(0xFF94A3B8))),
        const SizedBox(height: 32),
        if (_activeSO!.isColdChain) ...[
          _buildColdChainSection(),
        ],
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: (_activeSO!.isColdChain && !_isTempValid) ? null : () {
              ref.read(outboundControllerProvider.notifier).submitDispatch(_activeSO!.soId, _temp);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('XUẤT HÀNG THÀNH CÔNG!'), backgroundColor: Colors.green));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8), foregroundColor: Colors.black),
            child: const Text('XÁC NHẬN XUẤT HÀNG'),
          ),
        ),
      ]),
    );
  }

  Widget _buildColdChainSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12), border: Border.all(color: _isTempValid ? const Color(0xFF4ADE80) : const Color(0xFFDC2626))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.thermostat, color: Color(0xFFF59E0B)), SizedBox(width: 8), Text('NHIỆT ĐỘ XE GSP (<= 8°C)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(text: _temp == 0.0 ? '' : _temp.toString()),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              onChanged: (v) {
                final t = double.tryParse(v) ?? 9.9;
                setState(() {
                  _temp = t;
                  _isTempValid = t <= 8.0;
                });
              },
              decoration: const InputDecoration(hintText: 'Nhập nhiệt độ...', hintStyle: TextStyle(color: Color(0xFF334155))),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            onPressed: () => setState(() {
              _temp = 5.5;
              _isTempValid = true;
            }),
            icon: const Icon(Icons.bolt, color: Colors.orange),
          ),
        ]),
        if (!_isTempValid && _temp != 0.0)
          const Padding(padding: EdgeInsets.only(top: 8.0), child: Text('LỖI: Nhiệt độ không đạt chuẩn GSP!', style: TextStyle(color: Color(0xFFDC2626), fontSize: 12, fontWeight: FontWeight.bold))),
      ]),
    );
  }
}
