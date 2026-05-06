// ============================================================
// FILE: qc_detail_screen.dart
// QC Inspection form + 3-level approval dialog.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'qc_controller.dart';
import 'qc_models.dart';
import 'qc_mock_data.dart';

class QcDetailScreen extends ConsumerStatefulWidget {
  const QcDetailScreen({super.key});

  @override
  ConsumerState<QcDetailScreen> createState() => _QcDetailScreenState();
}

class _QcDetailScreenState extends ConsumerState<QcDetailScreen> {
  final _passCtrl = TextEditingController();
  final _failCtrl = TextEditingController();
  bool _dialogShown = false;

  @override
  void dispose() {
    _passCtrl.dispose();
    _failCtrl.dispose();
    super.dispose();
  }

  void _sync(InspectionFormState s) {
    final passStr = s.passedQty == 0 ? '' : s.passedQty.toString();
    final failStr = s.failedQty == 0 ? '' : s.failedQty.toString();
    if (_passCtrl.text != passStr) _passCtrl.text = passStr;
    if (_failCtrl.text != failStr) _failCtrl.text = failStr;
  }

  Future<void> _submit() async {
    if (_dialogShown) return;
    _dialogShown = true;

    // Show approval dialog — non-dismissible
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ApprovalDialog(),
    );

    // Drive the approval chain
    await ref.read(qcFormControllerProvider.notifier).submit();

    if (!mounted) return;

    // Wait for "done" then close dialog and pop
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      Navigator.of(context).pop(); // close dialog
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) Navigator.of(context).pop(); // back to list
    }
    _dialogShown = false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(qcFormControllerProvider);
    _sync(state);

    if (state.item == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final item = state.item!;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.toteCode,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFF59E0B),
                  fontFamily: 'monospace',
                )),
            const Text('Kiểm định lô hàng',
                style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product summary card
            _ProductSummaryCard(item: item),
            const SizedBox(height: 14),

            // Split batch card
            _DarkCard(
              title: 'PHÂN LOẠI LÔ HÀNG',
              icon: Icons.call_split_rounded,
              iconColor: const Color(0xFF38BDF8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Declared qty bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Số khai báo:', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                    Text(
                      '${item.declaredQty} ${item.unit}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Pass / Fail inputs row
                Row(
                  children: [
                    Expanded(
                      child: _QtyField(
                        controller: _passCtrl,
                        label: 'Đạt (PASS)',
                        color: const Color(0xFF4ADE80),
                        icon: Icons.check_circle_rounded,
                        onChanged: (v) => ref
                            .read(qcFormControllerProvider.notifier)
                            .setPassedQty(int.tryParse(v) ?? 0),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QtyField(
                        controller: _failCtrl,
                        label: 'Không đạt (FAIL)',
                        color: const Color(0xFFEF4444),
                        icon: Icons.cancel_rounded,
                        onChanged: (v) => ref
                            .read(qcFormControllerProvider.notifier)
                            .setFailedQty(int.tryParse(v) ?? 0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Progress bar + validation message
                _SplitProgressBar(state: state, item: item),
              ]),
            ),
            const SizedBox(height: 14),

            // E-Sign PIN card
            _DarkCard(
              title: 'CHỮ KÝ ĐIỆN TỬ (E-SIGN)',
              icon: Icons.fingerprint_rounded,
              iconColor: const Color(0xFF818CF8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text(
                  'Nhập mã PIN 4 số để xác thực danh tính.',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                ),
                const SizedBox(height: 12),
                _PinInput(
                  pin: state.pin,
                  onDigit: (d) => ref
                      .read(qcFormControllerProvider.notifier)
                      .setPin(state.pin + d),
                  onDelete: () {
                    final current = state.pin;
                    if (current.isNotEmpty) {
                      ref.read(qcFormControllerProvider.notifier).setPin(
                            current.substring(0, current.length - 1),
                          );
                    }
                  },
                ),
                if (state.errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Color(0xFFEF4444), fontSize: 12),
                  ),
                ],
              ]),
            ),
            const SizedBox(height: 24),

            // Submit button
            _SubmitButton(state: state, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}

// ── Product Summary ──────────────────────────────────────────
class _ProductSummaryCard extends StatelessWidget {
  final QcItem item;
  const _ProductSummaryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A5F), Color(0xFF1E293B)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(item.productCode,
                style: const TextStyle(
                    color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.6)),
            ),
            child: Text('Lô: ${item.batchNumber}',
                style: const TextStyle(
                    color: Color(0xFFF59E0B), fontSize: 11, fontFamily: 'monospace')),
          ),
        ]),
        const SizedBox(height: 10),
        Text(item.productName,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
        Text(item.manufacturer,
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Lý do cách ly:', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            Text(item.reason.label,
                style: const TextStyle(
                    color: Color(0xFFF59E0B), fontSize: 12, fontWeight: FontWeight.w700)),
          ]),
        ),
      ]),
    );
  }
}

// ── Qty input field ──────────────────────────────────────────
class _QtyField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Color color;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const _QtyField({
    required this.controller,
    required this.label,
    required this.color,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w900,
          color: color,
          fontFamily: 'monospace',
        ),
        decoration: InputDecoration(
          hintText: '0',
          hintStyle: TextStyle(color: color.withOpacity(0.3), fontSize: 26),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: color.withOpacity(0.4), width: 2)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: color, width: 2)),
        ),
        onChanged: onChanged,
      ),
    ]);
  }
}

// ── Split validation bar ─────────────────────────────────────
class _SplitProgressBar extends StatelessWidget {
  final InspectionFormState state;
  final QcItem item;
  const _SplitProgressBar({required this.state, required this.item});

  @override
  Widget build(BuildContext context) {
    final total = item.declaredQty as int;
    final passed = state.passedQty;
    final failed = state.failedQty;
    final entered = state.totalEntered;
    final isOver = entered > total;

    final passRatio = total > 0 ? (passed / total).clamp(0.0, 1.0) : 0.0;
    final failRatio = total > 0 ? (failed / total).clamp(0.0, 1.0) : 0.0;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Stacked bar
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          height: 12,
          child: Stack(
            children: [
              Container(color: const Color(0xFF1E293B)),
              FractionallySizedBox(
                widthFactor: passRatio,
                child: Container(color: const Color(0xFF4ADE80)),
              ),
              FractionallySizedBox(
                widthFactor: (passRatio + failRatio).clamp(0.0, 1.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: failRatio / ((passRatio + failRatio) + 0.001),
                    child: Container(color: const Color(0xFFEF4444)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$entered / $total ${item.unit}',
              style: TextStyle(
                  color: state.isSplitValid
                      ? const Color(0xFF4ADE80)
                      : isOver
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace')),
          if (state.isSplitValid)
            const Row(children: [
              Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF4ADE80)),
              SizedBox(width: 4),
              Text('Hợp lệ', style: TextStyle(color: Color(0xFF4ADE80), fontSize: 11)),
            ]),
        ],
      ),
      if (state.splitError != null)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(state.splitError!,
              style: const TextStyle(
                  color: Color(0xFFEF4444), fontSize: 11, fontWeight: FontWeight.w600)),
        ),
    ]);
  }
}

// ── PIN numpad ───────────────────────────────────────────────
class _PinInput extends StatelessWidget {
  final String pin;
  final void Function(String digit) onDigit;
  final VoidCallback onDelete;
  const _PinInput({required this.pin, required this.onDigit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Dots
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (i) {
          final filled = i < pin.length;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? const Color(0xFF818CF8) : Colors.transparent,
              border: Border.all(
                  color: filled ? const Color(0xFF818CF8) : const Color(0xFF475569),
                  width: 2),
            ),
          );
        }),
      ),
      const SizedBox(height: 20),

      // Numpad grid
      GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.2,
        children: [
          ...['1', '2', '3', '4', '5', '6', '7', '8', '9']
              .map((d) => _PinKey(label: d, onTap: () => onDigit(d))),
          const SizedBox.shrink(), // spacer
          _PinKey(label: '0', onTap: () => onDigit('0')),
          _PinKey(
            icon: Icons.backspace_outlined,
            onTap: onDelete,
            color: const Color(0xFFEF4444),
          ),
        ],
      ),
    ]);
  }
}

class _PinKey extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final Color color;
  const _PinKey({this.label, this.icon, required this.onTap, this.color = const Color(0xFF94A3B8)});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Center(
          child: label != null
              ? Text(label!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white))
              : Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}

// ── Submit button ────────────────────────────────────────────
class _SubmitButton extends StatelessWidget {
  final InspectionFormState state;
  final VoidCallback onPressed;
  const _SubmitButton({required this.state, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final can = state.canSubmit;
    return SizedBox(
      height: 56,
      child: FilledButton.icon(
        onPressed: can ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: can ? const Color(0xFF818CF8) : const Color(0xFF1E293B),
          foregroundColor: can ? Colors.white : const Color(0xFF475569),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        icon: const Icon(Icons.verified_rounded),
        label: const Text(
          'PHÊ DUYỆT & GIẢI PHÓNG LÔ',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.8),
        ),
      ),
    );
  }
}

// ── 3-Level Approval Dialog ───────────────────────────────────
class _ApprovalDialog extends ConsumerWidget {
  const _ApprovalDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(qcFormControllerProvider.select((s) => s.approvalStep));
    final isDone = step == ApprovalStep.done;

    return Dialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? const Color(0xFF4ADE80).withOpacity(0.1)
                    : const Color(0xFF818CF8).withOpacity(0.1),
              ),
              child: isDone
                  ? const Icon(Icons.check_circle_rounded, color: Color(0xFF4ADE80), size: 48)
                  : const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Color(0xFF818CF8),
                      ),
                    ),
            ),
            const SizedBox(height: 24),
            Text(
              isDone ? 'PHÊ DUYỆT THÀNH CÔNG' : 'ĐANG XỬ LÝ DỮ LIỆU...',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: isDone ? const Color(0xFF4ADE80) : Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isDone
                  ? 'Lô hàng đã được giải phóng khỏi khu cách ly.'
                  : 'Hệ thống đang lưu trữ hồ sơ kiểm định GSP.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            ),
          ],
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
