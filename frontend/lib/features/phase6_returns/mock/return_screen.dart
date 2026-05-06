import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recall_controller.dart';
import 'recall_models.dart';

class ReturnsScreen extends ConsumerStatefulWidget {
  const ReturnsScreen({super.key});

  @override
  ConsumerState<ReturnsScreen> createState() => _ReturnsScreenState();
}

class _ReturnsScreenState extends ConsumerState<ReturnsScreen> {
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _toteController = TextEditingController();
  ReturnReason? _selectedReason;
  bool _isColdChain = false;
  String? _errorMessage;

  @override
  void dispose() {
    _barcodeController.dispose();
    _toteController.dispose();
    super.dispose();
  }

  void _submitReturn() {
    setState(() {
      _errorMessage = null;
    });

    if (_barcodeController.text.isEmpty) {
      setState(() => _errorMessage = 'Vui lòng nhập mã vạch/SO');
      return;
    }

    if (_selectedReason == null) {
      setState(() => _errorMessage = 'Vui lòng chọn lý do trả hàng');
      return;
    }

    final totePrefix = _toteController.text.toUpperCase();
    if (!totePrefix.startsWith('QRN-') && !totePrefix.startsWith('REJ-')) {
      setState(() => _errorMessage = 'Lỗi: Phải sử dụng rổ Quarantine (QRN-) hoặc Reject (REJ-)');
      return;
    }

    ref.read(phase6ControllerProvider.notifier).processReturn(
      barcode: _barcodeController.text,
      reason: _selectedReason!,
      isColdChain: _isColdChain,
      assignedTote: totePrefix,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã tiếp nhận hàng trả về vào rổ $totePrefix'),
        backgroundColor: Colors.green,
      ),
    );

    _barcodeController.clear();
    _toteController.clear();
    setState(() {
      _selectedReason = null;
      _isColdChain = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(phase6ControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('RETURNS (HÀNG TRẢ VỀ)', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'TIẾP NHẬN HÀNG KHÁCH TRẢ',
              style: TextStyle(color: Color(0xFF38BDF8), fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFF450A0A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFDC2626)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Color(0xFFFCA5A5)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Color(0xFFFCA5A5)))),
                  ],
                ),
              ),
            _buildInputField('Mã Vạch / SO', _barcodeController, Icons.qr_code),
            const SizedBox(height: 16),
            _buildReasonDropdown(),
            const SizedBox(height: 24),
            _buildColdChainToggle(),
            const SizedBox(height: 24),
            _buildInputField('Mã Rổ (QRN- hoặc REJ-)', _toteController, Icons.shopping_basket),
            const SizedBox(height: 48),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _submitReturn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  foregroundColor: const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('XÁC NHẬN TRẢ HÀNG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            if (state.returns.isNotEmpty) ...[
              const SizedBox(height: 48),
              const Text('LỊCH SỬ TRẢ HÀNG', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...state.returns.map((ret) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  children: [
                    Icon(ret.isColdChain ? Icons.ac_unit : Icons.inventory, color: ret.isColdChain ? Colors.blue : Colors.grey),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mã: ${ret.barcode}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('Rổ: ${ret.assignedTote} | Lý do: ${ret.reason.name}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1E293B),
            prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildReasonDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lý do trả hàng', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ReturnReason>(
              value: _selectedReason,
              isExpanded: true,
              dropdownColor: const Color(0xFF1E293B),
              hint: const Text('Chọn lý do...', style: TextStyle(color: Color(0xFF64748B))),
              style: const TextStyle(color: Colors.white),
              items: ReturnReason.values.map((reason) {
                return DropdownMenuItem(
                  value: reason,
                  child: Text(reason.name),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedReason = val),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColdChainToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isColdChain ? const Color(0xFF0C4A6E) : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _isColdChain ? const Color(0xFF0EA5E9) : const Color(0xFF334155)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.ac_unit, color: _isColdChain ? const Color(0xFF0EA5E9) : const Color(0xFF64748B)),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Là Hàng Lạnh?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Switch(
                value: _isColdChain,
                onChanged: (val) => setState(() => _isColdChain = val),
                activeColor: const Color(0xFF0EA5E9),
              ),
            ],
          ),
          if (_isColdChain) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF450A0A),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: const [
                  Icon(Icons.warning, color: Color(0xFFFCA5A5), size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Hàng lạnh trả về không có Data Logger -> Bắt buộc Tiêu hủy (Z-REJ)',
                      style: TextStyle(color: Color(0xFFFCA5A5), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}
