// ============================================================
// FILE: picking_screen.dart
// Picking Wizard UI - Industrial PDA Styling.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'picking_controller.dart';
import 'picking_models.dart';

class PickingScreen extends ConsumerWidget {
  const PickingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pickingWizardControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          'PICKING WIZARD',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(pickingWizardControllerProvider.notifier).reset(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStepIndicator(state.step),
          if (state.errorMessage != null)
            _buildErrorBanner(state.errorMessage!),
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
  Widget _buildStepIndicator(PickingStep currentStep) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF334155),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: PickingStep.values.map((step) {
          final isActive = step == currentStep;
          final isDone = step.index < currentStep.index;
          return Icon(
            _getStepIcon(step),
            color: isActive
                ? const Color(0xFF38BDF8)
                : isDone
                ? const Color(0xFF4ADE80)
                : const Color(0xFF64748B),
            size: 20,
          );
        }).toList(),
      ),
    );
  }

  IconData _getStepIcon(PickingStep step) {
    switch (step) {
      case PickingStep.setup:
        return Icons.settings_input_composite;
      case PickingStep.overview:
        return Icons.list_alt;
      case PickingStep.targetLoc:
        return Icons.location_on;
      case PickingStep.pickItem:
        return Icons.qr_code_scanner;
      case PickingStep.complete:
        return Icons.check_circle;
    }
  }

  // ── Step Router ──
  Widget _buildCurrentStepUI(
    BuildContext context,
    WidgetRef ref,
    PickingWizardState state,
  ) {
    switch (state.step) {
      case PickingStep.setup:
        return _SetupStep(state: state);
      case PickingStep.overview:
        return _OverviewStep(state: state);
      case PickingStep.targetLoc:
        return _TargetLocStep(state: state);
      case PickingStep.pickItem:
        return _PickItemStep(state: state);
      case PickingStep.complete:
        return _CompleteStep();
    }
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF450A0A),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFFCA5A5),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFFCA5A5),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── STEP 1: SETUP ──
class _SetupStep extends ConsumerWidget {
  final PickingWizardState state;
  const _SetupStep({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldHeader('1. QUÉT TOTE'),
          _ManualInputField(
            hint: 'TOTE-001',
            icon: Icons.shopping_basket,
            onChanged: (v) => ref
                .read(pickingWizardControllerProvider.notifier)
                .updateTote(v),
            onQuickFill: () => ref
                .read(pickingWizardControllerProvider.notifier)
                .updateTote('TOTE-MOCK-01'),
            value: state.toteCode,
          ),
          const SizedBox(height: 24),
          _buildFieldHeader('2. VỊ TRÍ ĐI'),
          _ManualInputField(
            hint: 'GATE-01',
            icon: Icons.trip_origin,
            onChanged: (v) => ref
                .read(pickingWizardControllerProvider.notifier)
                .updateStartLoc(v),
            onQuickFill: () => ref
                .read(pickingWizardControllerProvider.notifier)
                .updateStartLoc('GATE-01'),
            value: state.startLoc,
          ),
          const Spacer(),
          _PrimaryButton(
            label: 'NHẬN SO',
            onPressed: () =>
                ref.read(pickingWizardControllerProvider.notifier).startSO(),
          ),
        ],
      ),
    );
  }
}

// ── STEP 2: OVERVIEW ──
class _OverviewStep extends ConsumerWidget {
  final PickingWizardState state;
  const _OverviewStep({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final so = state.activeSO!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SO: ${so.soId}',
            style: const TextStyle(
              color: Color(0xFF38BDF8),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: so.items.length,
              itemBuilder: (context, i) {
                final item = so.items[i];
                return _ItemMiniCard(item: item);
              },
            ),
          ),
          _PrimaryButton(
            label: 'BẮT ĐẦU ĐI NHẶT',
            onPressed: () => ref
                .read(pickingWizardControllerProvider.notifier)
                .proceedToPick(),
          ),
        ],
      ),
    );
  }
}

// ── STEP 3: TARGET LOC ──
class _TargetLocStep extends ConsumerWidget {
  final PickingWizardState state;
  const _TargetLocStep({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = state.activeSO!.items[state.currentItemIndex];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'DI CHUYỂN ĐẾN VỊ TRÍ',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          ),
          const SizedBox(height: 12),
          Text(
            item.targetLoc,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 32),
          _ManualInputField(
            hint: 'Quét mã vị trí...',
            icon: Icons.location_on,
            onSubmitted: (v) => ref
                .read(pickingWizardControllerProvider.notifier)
                .validateTargetLoc(v),
            onQuickFill: () => ref
                .read(pickingWizardControllerProvider.notifier)
                .validateTargetLoc(item.targetLoc),
          ),
        ],
      ),
    );
  }
}

// ── STEP 4: PICK ITEM ──
class _PickItemStep extends ConsumerWidget {
  final PickingWizardState state;
  const _PickItemStep({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = state.activeSO!.items[state.currentItemIndex];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.productName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Lô yêu cầu: ${item.batchCode}',
            style: const TextStyle(
              color: Color(0xFFF59E0B),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          _ManualInputField(
            hint: 'Quét Barcode / Lô...',
            icon: Icons.qr_code_scanner,
            onSubmitted: (v) => ref
                .read(pickingWizardControllerProvider.notifier)
                .validateBarcode(v),
            onQuickFill: () => ref
                .read(pickingWizardControllerProvider.notifier)
                .validateBarcode(item.batchCode),
          ),

          const SizedBox(height: 24),
          _buildFieldHeader('SỐ LƯỢNG (Cần: ${item.expectedQty})'),
          if (item.isLasa) ...[
            const SizedBox(height: 12),
            _buildLasaProgress(state, item),
          ] else ...[
            TextField(
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFF1E293B),
                hintText: '0',
                hintStyle: TextStyle(color: Color(0xFF334155)),
              ),
              onChanged: (v) => ref
                  .read(pickingWizardControllerProvider.notifier)
                  .updateNormalQty(v),
            ),
          ],

          const Spacer(),
          _PrimaryButton(
            label: 'HOÀN THÀNH ITEM',
            onPressed: () => ref
                .read(pickingWizardControllerProvider.notifier)
                .completeItem(),
          ),
        ],
      ),
    );
  }

  Widget _buildLasaProgress(PickingWizardState state, PickingItem item) {
    final progress = state.scannedQty / item.expectedQty;
    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 12,
          backgroundColor: const Color(0xFF334155),
          color: const Color(0xFF4ADE80),
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 8),
        Text(
          '${state.scannedQty} / ${item.expectedQty}',
          style: const TextStyle(
            color: Color(0xFF4ADE80),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const Text(
          'HÀNG LASA: Vui lòng quét từng hộp',
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
        ),
      ],
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
          const Icon(Icons.check_circle, size: 100, color: Color(0xFF4ADE80)),
          const SizedBox(height: 24),
          const Text(
            'HOÀN THÀNH ĐƠN HÀNG',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 48),
          _PrimaryButton(
            label: 'VỀ MÀN HÌNH QUÉT TOTE',
            onPressed: () =>
                ref.read(pickingWizardControllerProvider.notifier).reset(),
          ),
        ],
      ),
    );
  }
}

// ── UI COMPONENTS ──────────────────────────────────────────

Widget _buildFieldHeader(String label) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      label,
      style: const TextStyle(
        color: Color(0xFF94A3B8),
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class _ManualInputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback onQuickFill;
  final String? value;

  const _ManualInputField({
    required this.hint,
    required this.icon,
    this.onChanged,
    this.onSubmitted,
    required this.onQuickFill,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value);
    if (value != null) {
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 18),
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF334155)),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed: onQuickFill,
          icon: const Icon(Icons.bolt, color: Color(0xFFF59E0B)),
          style: IconButton.styleFrom(backgroundColor: const Color(0xFF334155)),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF38BDF8),
          foregroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _ItemMiniCard extends StatelessWidget {
  final PickingItem item;
  const _ItemMiniCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              item.targetLoc,
              style: const TextStyle(
                color: Color(0xFF38BDF8),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.productName,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          Text(
            'x${item.expectedQty}',
            style: const TextStyle(
              color: Color(0xFF4ADE80),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
