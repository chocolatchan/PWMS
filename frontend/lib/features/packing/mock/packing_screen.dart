// ============================================================
// FILE: packing_screen.dart
// Packing & Dispatch Wizard UI - Phase 5.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'packing_controller.dart';
import 'packing_models.dart';

class PackingScreen extends ConsumerWidget {
  const PackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(packingWizardControllerProvider);
    
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('PACKING & DISPATCH', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(packingWizardControllerProvider.notifier).reset(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStepIndicator(state.step),
          if (state.errorMessage != null) _buildErrorBanner(state.errorMessage!),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildCurrentStepUI(context, ref, state),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step Indicator ──
  Widget _buildStepIndicator(PackingStep currentStep) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF334155),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: PackingStep.values.map((step) {
          final isActive = step == currentStep;
          final isDone = step.index < currentStep.index;
          return Icon(
            _getStepIcon(step),
            color: isActive ? const Color(0xFF38BDF8) : isDone ? const Color(0xFF4ADE80) : const Color(0xFF64748B),
            size: 20,
          );
        }).toList(),
      ),
    );
  }

  IconData _getStepIcon(PackingStep step) {
    switch (step) {
      case PackingStep.scanSO: return Icons.qr_code_scanner;
      case PackingStep.consolidate: return Icons.merge_type;
      case PackingStep.packAndSeal: return Icons.inventory_2;
      case PackingStep.dispatch: return Icons.local_shipping;
      case PackingStep.complete: return Icons.check_circle;
    }
  }

  // ── Step Router ──
  Widget _buildCurrentStepUI(BuildContext context, WidgetRef ref, PackingWizardState state) {
    switch (state.step) {
      case PackingStep.scanSO: return _ScanSOStep(state: state);
      case PackingStep.consolidate: return _ConsolidateStep(state: state);
      case PackingStep.packAndSeal: return _PackAndSealStep(state: state);
      case PackingStep.dispatch: return _DispatchStep(state: state);
      case PackingStep.complete: return _CompleteStep();
    }
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF450A0A),
      child: Row(children: [
        const Icon(Icons.error_outline, color: Color(0xFFFCA5A5), size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(message, style: const TextStyle(color: Color(0xFFFCA5A5), fontWeight: FontWeight.bold, fontSize: 13))),
      ]),
    );
  }
}

// ── STEP 1: SCAN SO ──
class _ScanSOStep extends ConsumerWidget {
  final PackingWizardState state;
  const _ScanSOStep({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long_rounded, size: 80, color: Color(0xFF64748B)),
          const SizedBox(height: 32),
          _ManualInputField(
            hint: 'Quét / Nhập mã SO...',
            icon: Icons.qr_code_scanner,
            onChanged: (v) => ref.read(packingWizardControllerProvider.notifier).updateSOInput(v),
            onQuickFill: () => ref.read(packingWizardControllerProvider.notifier).updateSOInput('SO-2026-XYZ'),
            value: state.soInput,
          ),
          const SizedBox(height: 48),
          _PrimaryButton(
            label: 'XỬ LÝ ĐƠN HÀNG',
            onPressed: () => ref.read(packingWizardControllerProvider.notifier).startSO(),
          ),
        ],
      ),
    );
  }
}

// ── STEP 2: CONSOLIDATE ──
class _ConsolidateStep extends ConsumerWidget {
  final PackingWizardState state;
  const _ConsolidateStep({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final so = state.activeSO!;
    final allArrived = state.arrivedToteIds.length == so.requiredTotes.length;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('SO ID', so.soId),
          if (so.isColdChain) _buildColdBadge(),
          const SizedBox(height: 24),
          const Text('DANH SÁCH RỔ CẦN GOM', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: so.requiredTotes.length,
              itemBuilder: (context, i) {
                final tote = so.requiredTotes[i];
                final isArrived = state.arrivedToteIds.contains(tote.toteId);
                return _ToteStatusCard(toteId: tote.toteId, isArrived: isArrived);
              },
            ),
          ),
          _ManualInputField(
            hint: 'Quét mã rổ (Tote)...',
            icon: Icons.shopping_basket,
            onSubmitted: (v) => ref.read(packingWizardControllerProvider.notifier).scanTote(v),
            onQuickFill: () {
              final pending = so.requiredTotes.firstWhere((t) => !state.arrivedToteIds.contains(t.toteId));
              ref.read(packingWizardControllerProvider.notifier).scanTote(pending.toteId);
            },
          ),
          const SizedBox(height: 20),
          _PrimaryButton(
            label: 'BẮT ĐẦU ĐÓNG GÓI',
            onPressed: allArrived ? () => ref.read(packingWizardControllerProvider.notifier).proceedToPack() : null,
          ),
        ],
      ),
    );
  }

  Widget _buildColdBadge() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFF0C4A6E), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFF0EA5E9))),
      child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.ac_unit, color: Color(0xFF0EA5E9), size: 14), SizedBox(width: 6), Text('COLD CHAIN REQUIRED', style: TextStyle(color: Color(0xFF0EA5E9), fontSize: 10, fontWeight: FontWeight.bold))]),
    );
  }
}

// ── STEP 3: PACK & SEAL ──
class _PackAndSealStep extends ConsumerWidget {
  final PackingWizardState state;
  const _PackAndSealStep({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('XÁC NHẬN ĐÓNG GÓI', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          const Text('Vui lòng kiểm tra kỹ số lượng sản phẩm trước khi dán niêm phong.', style: TextStyle(color: Color(0xFF94A3B8))),
          const SizedBox(height: 48),
          const Text('NHẬP MÃ NIÊM PHONG (SEAL)', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _ManualInputField(
            hint: 'Quét / Nhập mã Seal...',
            icon: Icons.lock_outline,
            onChanged: (v) => ref.read(packingWizardControllerProvider.notifier).updateSealCode(v),
            onQuickFill: () => ref.read(packingWizardControllerProvider.notifier).updateSealCode('SEAL-2026-999'),
            value: state.sealCode,
          ),
          const Spacer(),
          _PrimaryButton(
            label: 'XÁC NHẬN NIÊM PHONG',
            onPressed: () => ref.read(packingWizardControllerProvider.notifier).confirmSeal(),
          ),
        ],
      ),
    );
  }
}

// ── STEP 4: DISPATCH ──
class _DispatchStep extends ConsumerWidget {
  final PackingWizardState state;
  const _DispatchStep({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('XUẤT HÀNG (DISPATCH)', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12), border: Border.all(color: state.isTempValid ? const Color(0xFF4ADE80) : const Color(0xFFDC2626))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [Icon(Icons.thermostat_rounded, color: Color(0xFF94A3B8)), SizedBox(width: 8), Text('KIỂM TRA NHIỆT ĐỘ XE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
              const SizedBox(height: 16),
              _ManualInputField(
                hint: 'Nhập nhiệt độ (°C)...',
                icon: Icons.device_thermostat,
                onChanged: (v) => ref.read(packingWizardControllerProvider.notifier).updateTemp(v),
                onQuickFill: () => ref.read(packingWizardControllerProvider.notifier).updateTemp('5.5'),
                value: state.temperature.toString(),
              ),
            ]),
          ),
          const Spacer(),
          _PrimaryButton(
            label: 'XÁC NHẬN XUẤT HÀNG',
            onPressed: state.isTempValid ? () => ref.read(packingWizardControllerProvider.notifier).completeDispatch() : null,
          ),
        ],
      ),
    );
  }
}

// ── STEP 5: COMPLETE ──
class _CompleteStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 100, color: Color(0xFF4ADE80)),
          const SizedBox(height: 24),
          const Text('XUẤT HÀNG THÀNH CÔNG', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 48),
          _PrimaryButton(
            label: 'VỀ MÀN HÌNH QUÉT SO',
            onPressed: () => ref.read(packingWizardControllerProvider.notifier).reset(),
          ),
        ],
      ),
    );
  }
}

// ── UI COMPONENTS ──────────────────────────────────────────

Widget _buildInfoRow(String label, String value) {
  return Row(children: [Text('$label: ', style: const TextStyle(color: Color(0xFF94A3B8))), Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]);
}

class _ToteStatusCard extends StatelessWidget {
  final String toteId;
  final bool isArrived;
  const _ToteStatusCard({required this.toteId, required this.isArrived});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12), border: Border.all(color: isArrived ? const Color(0xFF4ADE80) : const Color(0xFF334155))),
      child: Row(children: [Icon(Icons.shopping_basket, color: isArrived ? const Color(0xFF4ADE80) : const Color(0xFF64748B)), const SizedBox(width: 12), Text(toteId, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const Spacer(), Icon(isArrived ? Icons.check_circle : Icons.radio_button_unchecked, color: isArrived ? const Color(0xFF4ADE80) : const Color(0xFF334155))]),
    );
  }
}

class _ManualInputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback onQuickFill;
  final String? value;

  const _ManualInputField({required this.hint, required this.icon, this.onChanged, this.onSubmitted, required this.onQuickFill, this.value});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value == '0.0' ? '' : value);
    if (value != null && value != '0.0') {
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    }

    return Row(children: [
      Expanded(
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          decoration: InputDecoration(prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 18), hintText: hint, hintStyle: const TextStyle(color: Color(0xFF334155)), filled: true, fillColor: const Color(0xFF1E293B), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        ),
      ),
      const SizedBox(width: 8),
      IconButton.filledTonal(onPressed: onQuickFill, icon: const Icon(Icons.bolt, color: Color(0xFFF59E0B)), style: IconButton.styleFrom(backgroundColor: const Color(0xFF334155))),
    ]);
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const _PrimaryButton({required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF38BDF8), foregroundColor: const Color(0xFF0F172A), disabledBackgroundColor: const Color(0xFF1E293B), disabledForegroundColor: const Color(0xFF475569), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 8),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
      ),
    );
  }
}
