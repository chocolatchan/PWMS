// ============================================================
// FILE: putaway_screen.dart
// Full Putaway workflow UI — dark industrial Material 3 theme.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'putaway_controller.dart';
import 'putaway_models.dart';
import 'putaway_mock_data.dart';

class PutawayScreen extends ConsumerStatefulWidget {
  const PutawayScreen({super.key});

  @override
  ConsumerState<PutawayScreen> createState() => _PutawayScreenState();
}

class _PutawayScreenState extends ConsumerState<PutawayScreen> {
  final _toteCtrl    = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _pinCtrl     = TextEditingController();

  @override
  void dispose() {
    _toteCtrl.dispose();
    _locationCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  void _syncControllers(PutawayTaskState s) {
    if (_locationCtrl.text != s.scannedLocation) {
      _locationCtrl.text = s.scannedLocation;
    }
    if (_pinCtrl.text != s.pin) {
      _pinCtrl.text = s.pin;
    }
  }

  Future<void> _submitTote(String code) async {
    await ref.read(putawayControllerProvider.notifier).scanTote(code);
    _toteCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(putawayControllerProvider);
    _syncControllers(state);

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
              'PWMS — CẤT KỆ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
            Text(
              'Putaway · Phase 3 · FEFO DEMO',
              style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
        actions: [
          if (state.step != PutawayStep.scanTote)
            TextButton.icon(
              onPressed: () {
                ref.read(putawayControllerProvider.notifier).reset();
                _locationCtrl.clear();
                _pinCtrl.clear();
              },
              icon: const Icon(Icons.refresh, size: 16, color: Color(0xFF94A3B8)),
              label: const Text('RESET', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PutawayTaskState state) {
    switch (state.step) {
      case PutawayStep.scanTote:
        return _buildScanStep(context, state);
      case PutawayStep.loading:
        return _buildLoading();
      case PutawayStep.confirm:
        return _buildConfirmStep(context, state);
      case PutawayStep.success:
        return _buildSuccess(context);
    }
  }

  // ── Step 1: Scan Tote ─────────────────────────────────────
  Widget _buildScanStep(BuildContext context, PutawayTaskState state) {
    return SingleChildScrollView(
      key: const ValueKey('scan'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Big scanner icon
          Center(
            child: Container(
              width: 110,
              height: 110,
              margin: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF334155), width: 1.5),
              ),
              child: const Icon(Icons.qr_code_scanner_rounded, size: 56, color: Color(0xFF38BDF8)),
            ),
          ),

          const Text(
            'QUÉT MÃ RỔ HÀNG',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 2, color: Color(0xFF38BDF8)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Nhập mã rổ (STD-XXX hoặc TOX-XXX)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 28),

          // Input field
          TextField(
            controller: _toteCtrl,
            textCapitalization: TextCapitalization.characters,
            autofocus: true,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'STD-001 hoặc TOX-999',
              hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 14),
              prefixIcon: const Icon(Icons.barcode_reader, color: Color(0xFF38BDF8)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send_rounded, color: Color(0xFF38BDF8)),
                onPressed: () => _submitTote(_toteCtrl.text),
              ),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 2),
              ),
            ),
            onSubmitted: _submitTote,
          ),
          const SizedBox(height: 20),

          // Quick-fill demo buttons
          Row(
            children: [
              Expanded(
                child: _DemoButton(
                  label: 'Demo STD-001',
                  sublabel: 'Paracetamol · Bình thường',
                  color: const Color(0xFF0284C7),
                  icon: Icons.inventory_2_rounded,
                  onTap: () => _submitTote('STD-001'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DemoButton(
                  label: 'Demo TOX-999',
                  sublabel: 'Morphine · TOXIC',
                  color: const Color(0xFFDC2626),
                  icon: Icons.warning_rounded,
                  onTap: () => _submitTote('TOX-999'),
                ),
              ),
            ],
          ),

          // Error message
          if (state.errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A0F0F),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDC2626)),
              ),
              child: Row(children: [
                const Icon(Icons.error_rounded, color: Color(0xFFDC2626), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 12),
                  ),
                ),
              ]),
            ),
          ],
        ],
      ),
    );
  }

  // ── Loading ───────────────────────────────────────────────
  Widget _buildLoading() {
    return const Center(
      key: ValueKey('loading'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Color(0xFF38BDF8)),
          SizedBox(height: 16),
          Text('Đang tải thông tin rổ hàng...', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
        ],
      ),
    );
  }

  // ── Step 2–6: Confirm screen ─────────────────────────────
  Widget _buildConfirmStep(BuildContext context, PutawayTaskState state) {
    final tote = state.tote!;
    final isMatch = state.isLocationMatch;
    final isTox = tote.isToxic;
    final locColor = state.scannedLocation.isEmpty
        ? const Color(0xFF334155)
        : isMatch
            ? const Color(0xFF4ADE80)
            : const Color(0xFFDC2626);

    return SingleChildScrollView(
      key: const ValueKey('confirm'),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tote & product card
          _ToteInfoCard(tote: tote),
          const SizedBox(height: 14),

          // ── Big location target ──
          _DarkCard(
            title: 'TIẾN ĐẾN KỆ',
            icon: Icons.shelves,
            iconColor: const Color(0xFF38BDF8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (state.isLocationFull) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFF59E0B)),
                  ),
                  child: const Row(children: [
                    Icon(Icons.swap_horiz_rounded, size: 14, color: Color(0xFFF59E0B)),
                    SizedBox(width: 6),
                    Text('ĐÃ REROUTE → Kệ thay thế', style: TextStyle(color: Color(0xFFF59E0B), fontSize: 11, fontWeight: FontWeight.w700)),
                  ]),
                ),
              ],
              Center(
                child: Text(
                  state.activeLocation,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    fontFamily: 'monospace',
                    color: state.isLocationFull ? const Color(0xFFF59E0B) : const Color(0xFF38BDF8),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  state.isLocationFull
                      ? 'Kệ gốc: ${tote.suggestedLocation}'
                      : 'Kệ thay thế: ${tote.alternateLocation}',
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 12),

          // ── Scan location field ──
          _DarkCard(
            title: 'QUÉT VỊ TRÍ KỆ',
            icon: Icons.location_on_rounded,
            iconColor: locColor,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextField(
                controller: _locationCtrl,
                textCapitalization: TextCapitalization.characters,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: locColor,
                  fontFamily: 'monospace',
                ),
                decoration: InputDecoration(
                  hintText: 'Quét mã vạch kệ...',
                  hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 14),
                  prefixIcon: Icon(Icons.barcode_reader, color: locColor),
                  suffixIcon: state.scannedLocation.isEmpty
                      ? null
                      : Icon(
                          isMatch ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          color: locColor,
                        ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: locColor, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: locColor, width: 2),
                  ),
                  filled: true,
                  fillColor: locColor.withOpacity(0.05),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
                onChanged: (v) =>
                    ref.read(putawayControllerProvider.notifier).setScannedLocation(v),
              ),
              if (state.scannedLocation.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(children: [
                  Icon(
                    isMatch ? Icons.check_circle_rounded : Icons.error_rounded,
                    size: 14,
                    color: locColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isMatch
                        ? 'Vị trí hợp lệ — khớp với kệ chỉ định'
                        : 'Sai vị trí! Kệ cần đến: ${state.activeLocation}',
                    style: TextStyle(color: locColor, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ]),
              ],
            ]),
          ),
          const SizedBox(height: 12),

          // ── Báo Kệ Đầy ──
          if (!state.isLocationFull)
            OutlinedButton.icon(
              onPressed: () =>
                  ref.read(putawayControllerProvider.notifier).reportLocationFull(),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFF59E0B),
                side: const BorderSide(color: Color(0xFFF59E0B)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.swap_horiz_rounded, size: 18),
              label: const Text('BÁO KỆ ĐẦY / REROUTE', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5)),
            ),
          const SizedBox(height: 12),

          // ── TOX PIN ──
          if (isTox) ...[
            _DarkCard(
              title: 'XÁC THỰC THỦ KHO (THUỐC ĐỘC)',
              icon: Icons.lock_rounded,
              iconColor: const Color(0xFFDC2626),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.warning_rounded, size: 14, color: Color(0xFFDC2626)),
                  const SizedBox(width: 6),
                  const Text(
                    'Yêu cầu PIN 4 số của Thủ Kho',
                    style: TextStyle(color: Color(0xFFDC2626), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ]),
                const SizedBox(height: 12),
                TextField(
                  controller: _pinCtrl,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    letterSpacing: 8,
                    fontWeight: FontWeight.w900,
                  ),
                  decoration: InputDecoration(
                    hintText: '••••',
                    hintStyle: const TextStyle(color: Color(0xFF475569), letterSpacing: 8),
                    counterText: '',
                    suffixIcon: state.pin.length == 4
                        ? Icon(
                            state.isPinValid ? Icons.lock_open_rounded : Icons.lock_rounded,
                            color: state.isPinValid ? const Color(0xFF4ADE80) : const Color(0xFFDC2626),
                          )
                        : null,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: state.pin.isEmpty
                            ? const Color(0xFFDC2626).withOpacity(0.5)
                            : state.isPinValid
                                ? const Color(0xFF4ADE80)
                                : const Color(0xFFDC2626),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF2A0F0F),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                  onChanged: (v) => ref.read(putawayControllerProvider.notifier).setPin(v),
                ),
                if (state.pin.length == 4 && !state.isPinValid) ...[
                  const SizedBox(height: 6),
                  const Text('PIN không hợp lệ. Vui lòng thử lại.',
                      style: TextStyle(color: Color(0xFFDC2626), fontSize: 11)),
                ],
              ]),
            ),
            const SizedBox(height: 12),
          ],

          // Error
          if (state.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A0F0F),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDC2626)),
              ),
              child: Text(state.errorMessage!,
                  style: const TextStyle(color: Color(0xFFFCA5A5), fontSize: 12)),
            ),
            const SizedBox(height: 12),
          ],

          // Confirm button
          _ConfirmButton(state: state),
        ],
      ),
    );
  }

  // ── Success ───────────────────────────────────────────────
  Widget _buildSuccess(BuildContext context) {
    return Center(
      key: const ValueKey('success'),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4ADE80).withOpacity(0.1),
              ),
              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF4ADE80), size: 60),
            ),
            const SizedBox(height: 24),
            const Text(
              'ĐÃ CẤT KỆ THÀNH CÔNG',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: Color(0xFF4ADE80),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Rổ hàng đã được ghi nhận vào hệ thống WMS.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                ref.read(putawayControllerProvider.notifier).reset();
                _locationCtrl.clear();
                _pinCtrl.clear();
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('QUÉT RỔ TIẾP THEO', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tote info card ────────────────────────────────────────────
class _ToteInfoCard extends StatelessWidget {
  final PutawayTote tote;
  const _ToteInfoCard({required this.tote});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: tote.isToxic
              ? [const Color(0xFF7C2D12), const Color(0xFF1E293B)]
              : [const Color(0xFF1E3A5F), const Color(0xFF1E293B)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: tote.isToxic ? const Color(0xFFDC2626) : const Color(0xFF334155),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: tote.isToxic
                  ? const Color(0xFFDC2626)
                  : const Color(0xFF0284C7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                tote.isToxic ? Icons.warning_rounded : Icons.shopping_basket_rounded,
                size: 13,
                color: Colors.white,
              ),
              const SizedBox(width: 5),
              Text(
                tote.toteCode,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                ),
              ),
            ]),
          ),
          const SizedBox(width: 8),
          if (tote.isToxic)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFDC2626)),
              ),
              child: const Text(
                '⚠ KIỂM SOÁT ĐẶC BIỆT',
                style: TextStyle(color: Color(0xFFDC2626), fontSize: 10, fontWeight: FontWeight.w800),
              ),
            ),
        ]),
        const SizedBox(height: 12),
        Text(tote.productName,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white)),
        Text(tote.productCode,
            style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
        const SizedBox(height: 12),
        Row(children: [
          _Chip(icon: Icons.numbers_rounded, label: 'Lô: ${tote.batchNumber}'),
          const SizedBox(width: 8),
          _Chip(icon: Icons.inventory_2_outlined, label: '${tote.qty} ${tote.unit}'),
        ]),
      ]),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(6)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11)),
      ]),
    );
  }
}

// ── Demo quick-fill button ────────────────────────────────────
class _DemoButton extends StatelessWidget {
  final String label;
  final String sublabel;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  const _DemoButton({
    required this.label,
    required this.sublabel,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12)),
          Text(sublabel, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
        ]),
      ),
    );
  }
}

// ── Confirm button ────────────────────────────────────────────
class _ConfirmButton extends ConsumerWidget {
  final PutawayTaskState state;
  const _ConfirmButton({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final can = state.canConfirm;
    return SizedBox(
      height: 56,
      child: FilledButton.icon(
        onPressed: can
            ? () => ref.read(putawayControllerProvider.notifier).confirmDrop()
            : null,
        style: FilledButton.styleFrom(
          backgroundColor: can ? const Color(0xFF4ADE80) : const Color(0xFF1E293B),
          foregroundColor: can ? const Color(0xFF0F172A) : const Color(0xFF475569),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        icon: state.isSubmitting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF0F172A)),
              )
            : const Icon(Icons.inventory_2_rounded),
        label: Text(
          state.isSubmitting ? 'ĐANG LƯU...' : 'XÁC NHẬN CẤT HÀNG',
          style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.8),
        ),
      ),
    );
  }
}

// ── Reusable dark card ────────────────────────────────────────
class _DarkCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;
  const _DarkCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

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
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Text(title,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: iconColor)),
        ]),
        const Divider(color: Color(0xFF334155), height: 20),
        child,
      ]),
    );
  }
}
