import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'inbound_controller.dart';
import 'inbound_models.dart';
import 'inbound_mock_data.dart';

class InboundDemoScreen extends ConsumerStatefulWidget {
  const InboundDemoScreen({super.key});

  @override
  ConsumerState<InboundDemoScreen> createState() => _InboundDemoScreenState();
}

class _InboundDemoScreenState extends ConsumerState<InboundDemoScreen> {
  final _qtyCtrl   = TextEditingController();
  final _toteCtrl  = TextEditingController();
  final _batchCtrl = TextEditingController();
  String? _lastResult;

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _toteCtrl.dispose();
    _batchCtrl.dispose();
    super.dispose();
  }

  void _syncControllersFromState(InboundItemState s) {
    if (_qtyCtrl.text != (s.actualQty == 0 ? '' : s.actualQty.toString())) {
      _qtyCtrl.text = s.actualQty == 0 ? '' : s.actualQty.toString();
    }
    if (_toteCtrl.text != s.toteCode) {
      _toteCtrl.text = s.toteCode;
    }
    if (_batchCtrl.text != s.batchNumber) {
      _batchCtrl.text = s.batchNumber;
    }
  }

  Future<void> _submit(BuildContext ctx) async {
    final ctrl = ref.read(inboundControllerProvider.notifier);
    final result = await ctrl.submit();
    if (!mounted) return;
    final state = ref.read(inboundControllerProvider);
    final isSuccess = state.submissionResult?.startsWith('success:') ?? false;
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(result ?? '', style: const TextStyle(fontSize: 13)),
      backgroundColor: isSuccess ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ));

    if (isSuccess) {
      // Auto-reset after success to prepare for next scan
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        ref.read(inboundControllerProvider.notifier).reset();
        _qtyCtrl.clear();
        _toteCtrl.clear();
        _batchCtrl.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inboundControllerProvider);
    _syncControllersFromState(state);

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PWMS — NHẬP KHO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.white)),
            Text('GSP Inbound Receiving · DEMO MODE', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), letterSpacing: 0.5)),
          ],
        ),
        actions: [
          if (state.poItem != null)
            TextButton.icon(
              onPressed: () {
                ref.read(inboundControllerProvider.notifier).reset();
                _qtyCtrl.clear();
                _toteCtrl.clear();
                _batchCtrl.clear();
              },
              icon: const Icon(Icons.refresh, size: 16, color: Color(0xFF94A3B8)),
              label: const Text('RESET', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            ),
        ],
      ),
      body: state.poItem == null ? _buildEmptyState(context) : _buildForm(context, state),
      floatingActionButton: _ScanFab(
        onParacetamol: () => ref.read(inboundControllerProvider.notifier).simulateScanParacetamol(),
        onMorphine:    () => ref.read(inboundControllerProvider.notifier).simulateScanMorphine(),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext ctx) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF334155), width: 1.5),
              ),
              child: const Icon(Icons.qr_code_scanner_rounded, size: 60, color: Color(0xFF38BDF8)),
            ),
            const SizedBox(height: 24),
            const Text('SẴN SÀNG NHẬN HÀNG', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 2, color: Color(0xFF38BDF8))),
            const SizedBox(height: 8),
            const Text('Nhấn nút bên dưới hoặc nhập mã thủ công', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            const SizedBox(height: 32),
            SizedBox(
              width: 300,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nhập mã vạch thủ công (Dự phòng)',
                  labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF334155))),
                  prefixIcon: const Icon(Icons.keyboard, color: Color(0xFF94A3B8)),
                ),
                onSubmitted: (v) => ref.read(inboundControllerProvider.notifier).simulateManualInput(v),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext ctx, InboundItemState state) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    final productSection = Column(
      children: [
        _ProductCard(item: state.poItem!),
        const SizedBox(height: 12),
        _BatchCard(
          state: state,
          batchCtrl: _batchCtrl,
          onManufacturerChanged: (v) => ref.read(inboundControllerProvider.notifier).setManufacturer(v),
          onBatchChanged: (v) => ref.read(inboundControllerProvider.notifier).setBatchNumber(v),
        ),
        const SizedBox(height: 12),
        _UomCard(state: state, qtyCtrl: _qtyCtrl,
          onChanged: (v) => ref.read(inboundControllerProvider.notifier).setActualQty(int.tryParse(v) ?? 0),
        ),
      ],
    );

    final processingSection = Column(
      children: [
        _QuarantineCard(state: state,
          onFlagChanged: (f) => ref.read(inboundControllerProvider.notifier).setQuarantineFlag(f),
        ),
        const SizedBox(height: 12),
        _ToteCard(state: state, toteCtrl: _toteCtrl,
          onChanged: (v) => ref.read(inboundControllerProvider.notifier).setToteCode(v),
        ),
        const SizedBox(height: 12),
        _MixedBatchCard(
          confirmed: state.mixedBatchConfirmed,
          onChanged: (v) => ref.read(inboundControllerProvider.notifier).setMixedBatchConfirmed(v),
        ),
        const SizedBox(height: 24),
        _SubmitButton(state: state, onPressed: () => _submit(ctx)),
        if (state.submissionResult != null) ...[
          const SizedBox(height: 12),
          _ResultBanner(result: state.submissionResult!),
        ],
      ],
    );

    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: isDesktop ? 1100 : double.infinity),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: productSection),
                    const SizedBox(width: 24),
                    Expanded(flex: 2, child: processingSection),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    productSection,
                    const SizedBox(height: 12),
                    processingSection,
                  ],
                ),
        ),
      ),
    );
  }

}

// ── Product header card ───────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final MockPoItem item;
  const _ProductCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: item.isToxic
              ? [const Color(0xFF7C2D12), const Color(0xFF1E293B)]
              : [const Color(0xFF1E3A5F), const Color(0xFF1E293B)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: item.isToxic ? const Color(0xFFDC2626) : const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: item.isToxic ? const Color(0xFFDC2626) : const Color(0xFF0284C7),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(item.productCode, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, fontFamily: 'monospace')),
            ),
            if (item.isToxic) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFDC2626).withOpacity(0.2), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFDC2626))),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.warning_rounded, size: 12, color: Color(0xFFDC2626)),
                  SizedBox(width: 4),
                  Text('ĐỘC - TOXIC', style: TextStyle(color: Color(0xFFDC2626), fontSize: 10, fontWeight: FontWeight.w800)),
                ]),
              ),
            ],
            if (item.isLasa) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFD97706).withOpacity(0.2), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFD97706))),
                child: const Text('LASA', style: TextStyle(color: Color(0xFFD97706), fontSize: 10, fontWeight: FontWeight.w800)),
              ),
            ],
          ]),
          const SizedBox(height: 10),
          Text(item.productName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
          Text(item.activeIngredient, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          const SizedBox(height: 12),
          Row(children: [
            _InfoChip(icon: Icons.inventory_2_outlined, label: 'Dự kiến: ${item.expectedQty} ${item.purchaseUnit}'),
            const SizedBox(width: 8),
            _InfoChip(icon: Icons.swap_horiz_rounded, label: '1 ${item.purchaseUnit} = ${item.conversionRate.toInt()} ${item.baseUnit}'),
          ]),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFFCBD5E1))),
      ]),
    );
  }
}

// ── Batch & Manufacturer Card ─────────────────────────────────
class _BatchCard extends StatelessWidget {
  final InboundItemState state;
  final TextEditingController batchCtrl;
  final ValueChanged<String?> onManufacturerChanged;
  final ValueChanged<String> onBatchChanged;

  const _BatchCard({
    required this.state,
    required this.batchCtrl,
    required this.onManufacturerChanged,
    required this.onBatchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _DarkCard(
      title: 'THÔNG TIN LÔ & NSX',
      icon: Icons.factory_outlined,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('NHÀ SẢN XUẤT *', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: state.manufacturer,
          dropdownColor: const Color(0xFF1E293B),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: '-- Chọn nhà sản xuất --',
            hintStyle: const TextStyle(color: Color(0xFF475569)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: state.manufacturer == null ? const Color(0xFFDC2626) : const Color(0xFF334155)), borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 2), borderRadius: BorderRadius.circular(8)),
          ),
          items: InboundMockData.manufacturers.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
          onChanged: onManufacturerChanged,
        ),
        const SizedBox(height: 16),
        const Text('SỐ LÔ (BATCH NO.) *', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
        const SizedBox(height: 8),
        TextField(
          controller: batchCtrl,
          textCapitalization: TextCapitalization.characters,
          style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 16, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'VD: L001/24',
            hintStyle: const TextStyle(color: Color(0xFF475569)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: state.batchNumber.isEmpty ? const Color(0xFFDC2626) : const Color(0xFF334155)), borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 2), borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: onBatchChanged,
        ),
      ]),
    );
  }
}

// ── UOM Card ─────────────────────────────────────────────────
class _UomCard extends StatelessWidget {
  final InboundItemState state;
  final TextEditingController qtyCtrl;
  final ValueChanged<String> onChanged;
  const _UomCard({required this.state, required this.qtyCtrl, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isOver = state.isOverReceiving;
    return _DarkCard(
      title: 'SỐ LƯỢNG THỰC NHẬN',
      icon: Icons.scale_rounded,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextField(
          controller: qtyCtrl,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: isOver ? const Color(0xFFDC2626) : Colors.white),
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 28),
            suffix: Text(state.poItem?.purchaseUnit ?? '', style: const TextStyle(fontSize: 16, color: Color(0xFF94A3B8))),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: isOver ? const Color(0xFFDC2626) : const Color(0xFF334155), width: 2)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: isOver ? const Color(0xFFDC2626) : const Color(0xFF38BDF8), width: 2)),
            errorText: isOver ? '⚠ NHẬP LỐ: Actual (${state.actualQty}) > Expected (${state.poItem!.expectedQty})' : null,
            errorStyle: const TextStyle(color: Color(0xFFDC2626), fontSize: 12, fontWeight: FontWeight.w600),
          ),
          onChanged: onChanged,
        ),
        if (state.actualQty > 0 && !isOver) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF0F2A1A), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFF16A34A))),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Base Qty =', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
              Text('${state.baseQty.toStringAsFixed(0)} ${state.poItem?.baseUnit}',
                  style: const TextStyle(color: Color(0xFF4ADE80), fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'monospace')),
            ]),
          ),
        ],
      ]),
    );
  }
}

// ── Quarantine Card ───────────────────────────────────────────
class _QuarantineCard extends StatelessWidget {
  final InboundItemState state;
  final ValueChanged<QuarantineFlag> onFlagChanged;
  const _QuarantineCard({required this.state, required this.onFlagChanged});

  @override
  Widget build(BuildContext context) {
    return _DarkCard(
      title: 'TRẠNG THÁI KIỂM TRA',
      icon: Icons.fact_check_outlined,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('TÌNH TRẠNG NGOẠI QUAN *', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
        const SizedBox(height: 8),
        DropdownButtonFormField<QuarantineFlag>(
          value: state.quarantineFlag,
          dropdownColor: const Color(0xFF1E293B),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF334155)), borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 2), borderRadius: BorderRadius.circular(8)),
          ),
          items: QuarantineFlag.values.map((f) => DropdownMenuItem(value: f, child: Text(f.label))).toList(),
          onChanged: (v) => onFlagChanged(v!),
        ),
      ]),
    );
  }
}

// ── Tote Card ────────────────────────────────────────────────
class _ToteCard extends StatelessWidget {
  final InboundItemState state;
  final TextEditingController toteCtrl;
  final ValueChanged<String> onChanged;
  const _ToteCard({required this.state, required this.toteCtrl, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isValid = state.toteCode.isEmpty || state.isTotePrefixValid;
    final prefixColor = state.isQuarantine ? const Color(0xFFFBBF24) : (state.poItem?.isToxic == true ? const Color(0xFFDC2626) : const Color(0xFF38BDF8));

    return _DarkCard(
      title: 'MÃ RỔ HÀNG',
      icon: Icons.shopping_basket_outlined,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(color: prefixColor.withOpacity(0.15), borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)), border: Border.all(color: prefixColor)),
            child: Text(state.requiredTotePrefix, style: TextStyle(color: prefixColor, fontWeight: FontWeight.w800, fontFamily: 'monospace', fontSize: 14)),
          ),
          Expanded(
            child: TextField(
              controller: toteCtrl,
              textCapitalization: TextCapitalization.characters,
              style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 14),
              decoration: InputDecoration(
                hintText: '001',
                hintStyle: const TextStyle(color: Color(0xFF475569)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                  borderSide: BorderSide(color: isValid ? const Color(0xFF334155) : const Color(0xFFDC2626)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                  borderSide: BorderSide(color: prefixColor, width: 2),
                ),
              ),
              onChanged: onChanged,
            ),
          ),
        ]),
        if (!isValid)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('⚠ Pure Tote: Rổ phải bắt đầu bằng "${state.requiredTotePrefix}"', style: const TextStyle(color: Color(0xFFDC2626), fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        if (state.isTotePrefixValid && state.toteCode.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(children: [
              const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF4ADE80)),
              const SizedBox(width: 4),
              Text('Rổ hợp lệ: ${state.toteCode.toUpperCase()}', style: const TextStyle(color: Color(0xFF4ADE80), fontSize: 11)),
            ]),
          ),
      ]),
    );
  }
}

// ── Mixed Batch Card ──────────────────────────────────────────
class _MixedBatchCard extends StatelessWidget {
  final bool confirmed;
  final ValueChanged<bool> onChanged;
  const _MixedBatchCard({required this.confirmed, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: confirmed ? const Color(0xFF0F2A1A) : const Color(0xFF2A1A0F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: confirmed ? const Color(0xFF16A34A) : const Color(0xFFD97706), width: 1.5),
      ),
      child: CheckboxListTile(
        value: confirmed,
        onChanged: (v) => onChanged(v!),
        activeColor: const Color(0xFF4ADE80),
        checkColor: const Color(0xFF0F172A),
        title: const Text('Tôi xác nhận đã kiểm tra vật lý,\nkhông trộn lô hàng khác vào rổ này.', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
        subtitle: Text(
          confirmed ? '✅ Xác nhận bởi nhân viên nhận hàng' : '⚠ Bắt buộc xác nhận theo GSP',
          style: TextStyle(color: confirmed ? const Color(0xFF4ADE80) : const Color(0xFFD97706), fontSize: 11),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }
}

// ── Submit Button ────────────────────────────────────────────
class _SubmitButton extends StatelessWidget {
  final InboundItemState state;
  final VoidCallback onPressed;
  const _SubmitButton({required this.state, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final can = state.canSubmit;
    return SizedBox(
      height: 54,
      child: FilledButton.icon(
        onPressed: can ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: can ? const Color(0xFF0284C7) : const Color(0xFF1E293B),
          foregroundColor: can ? Colors.white : const Color(0xFF475569),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: state.isSubmitting
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.cloud_upload_rounded),
        label: Text(state.isSubmitting ? 'ĐANG LƯU...' : 'XÁC NHẬN NHẬP KHO',
            style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
      ),
    );
  }
}

// ── Result Banner ────────────────────────────────────────────
class _ResultBanner extends StatelessWidget {
  final String result;
  const _ResultBanner({required this.result});

  @override
  Widget build(BuildContext context) {
    final isSuccess = result.startsWith('success:');
    final msg = result.replaceFirst(RegExp(r'^(success|error):'), '');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSuccess ? const Color(0xFF0F2A1A) : const Color(0xFF2A0F0F),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isSuccess ? const Color(0xFF16A34A) : const Color(0xFFDC2626)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
            color: isSuccess ? const Color(0xFF4ADE80) : const Color(0xFFDC2626), size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(msg, style: TextStyle(color: isSuccess ? const Color(0xFF4ADE80) : const Color(0xFFFCA5A5), fontSize: 12))),
      ]),
    );
  }
}

// ── Scan FAB ──────────────────────────────────────────────────
class _ScanFab extends StatefulWidget {
  final VoidCallback onParacetamol;
  final VoidCallback onMorphine;
  const _ScanFab({required this.onParacetamol, required this.onMorphine});

  @override
  State<_ScanFab> createState() => _ScanFabState();
}

class _ScanFabState extends State<_ScanFab> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_expanded) ...[
          _MiniAction(label: 'P001 · Paracetamol (Bình thường)', color: const Color(0xFF0284C7), icon: Icons.medication_rounded, onTap: () { setState(() => _expanded = false); widget.onParacetamol(); }),
          const SizedBox(height: 8),
          _MiniAction(label: 'P099 · Morphine (ĐỘC)', color: const Color(0xFFDC2626), icon: Icons.warning_rounded, onTap: () { setState(() => _expanded = false); widget.onMorphine(); }),
          const SizedBox(height: 8),
        ],
        FloatingActionButton.extended(
          onPressed: () => setState(() => _expanded = !_expanded),
          backgroundColor: const Color(0xFF0284C7),
          foregroundColor: Colors.white,
          icon: Icon(_expanded ? Icons.close : Icons.qr_code_scanner_rounded),
          label: Text(_expanded ? 'ĐÓNG' : 'MÔ PHỎNG QUÉT MÃ', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
        ),
      ],
    );
  }
}

class _MiniAction extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  const _MiniAction({required this.label, required this.color, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

// ── Reusable dark card ────────────────────────────────────────
class _DarkCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _DarkCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 14, color: const Color(0xFF38BDF8)),
          const SizedBox(width: 6),
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: Color(0xFF38BDF8))),
        ]),
        const Divider(color: Color(0xFF334155), height: 20),
        child,
      ]),
    );
  }
}
