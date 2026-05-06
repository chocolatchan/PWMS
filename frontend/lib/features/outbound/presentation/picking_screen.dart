import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../core/hardware/scanner_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets.dart';
import '../bloc/outbound_bloc.dart';
import '../bloc/outbound_event.dart';
import '../bloc/outbound_state.dart';

class PickingScreen extends StatefulWidget {
  final int taskId;
  const PickingScreen({super.key, required this.taskId});

  @override
  State<PickingScreen> createState() => _PickingScreenState();
}

class _PickingScreenState extends State<PickingScreen> {
  StreamSubscription<String>? _scannerSub;

  @override
  void initState() {
    super.initState();
    _scannerSub = GetIt.I<ScannerService>().barcodeStream.listen((barcode) {
      final state = context.read<OutboundBloc>().state;
      if (state is OutboundIdle) {
        context.read<OutboundBloc>().add(
          StartTaskRequested(taskId: widget.taskId, toteCode: barcode),
        );
      }
    });
  }

  @override
  void dispose() {
    _scannerSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nhặt Hàng'),
            Text('Task #${widget.taskId}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white70)),
          ],
        ),
      ),
      body: BlocConsumer<OutboundBloc, OutboundState>(
        listener: (context, state) {
          if (state is OutboundError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Row(children: [
                const Icon(Icons.block_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(state.message)),
              ]),
              backgroundColor: cs.error,
            ));
          }
        },
        builder: (context, state) {
          if (state is OutboundLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OutboundToteLocked) {
            return _ToteLockedView(state: state);
          }

          // Idle — waiting for tote scan
          return _ScanToteView(taskId: widget.taskId);
        },
      ),
    );
  }
}

// ── Waiting for tote ──────────────────────────────────────
class _ScanToteView extends StatefulWidget {
  final int taskId;
  const _ScanToteView({required this.taskId});

  @override
  State<_ScanToteView> createState() => _ScanToteViewState();
}

class _ScanToteViewState extends State<_ScanToteView> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Task info card
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: cs.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.inventory_2_rounded, color: cs.secondary),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Task #${widget.taskId}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'RobotoMono')),
                      Text('Đang chờ quét rổ', style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
                    ],
                  ),
                  const Spacer(),
                  StatusBadge('PENDING'),
                ],
              ),
            ),
          ),
        ),

        // Scanner prompt
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, child) => Transform.scale(
                      scale: 0.92 + 0.08 * _ctrl.value,
                      child: child,
                    ),
                    child: Container(
                      width: 120, height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.3), width: 2),
                      ),
                      child: const Icon(Icons.shopping_basket_rounded, size: 60, color: Color(0xFF7C3AED)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'QUÉT RỔ HÀNG',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 2, color: const Color(0xFF7C3AED)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chiếu tia laser vào mã vạch rổ để\nbắt đầu nhặt hàng cho Task #${widget.taskId}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom hint
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            margin: EdgeInsets.zero,
            color: cs.primaryContainer.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: cs.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    'Chọn rổ màu xanh lá cho hàng thường. Rổ đỏ chỉ dành cho Thủ kho.',
                    style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                  )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Tote locked — ready to pick ───────────────────────────
class _ToteLockedView extends StatelessWidget {
  final OutboundToteLocked state;
  const _ToteLockedView({required this.state});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Success banner
        Container(
          width: double.infinity,
          color: AppTheme.zoneGreen.withValues(alpha: 0.1),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppTheme.zoneGreen, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rổ đã khóa thành công!', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppTheme.zoneGreen)),
                    Text('Task #${state.taskId} đang hoạt động', style: const TextStyle(fontSize: 12, color: AppTheme.zoneGreen)),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Tote details
        Padding(
          padding: const EdgeInsets.all(12),
          child: Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                InfoRow(label: 'Mã rổ', value: state.toteCode, icon: Icons.shopping_basket_rounded, mono: true),
                const Divider(height: 1),
                InfoRow(label: 'Task ID', value: '#${state.taskId}', icon: Icons.tag_rounded, mono: true),
                const Divider(height: 1),
                InfoRow(label: 'Trạng thái', value: 'Đang nhặt', icon: Icons.play_circle_outline),
              ],
            ),
          ),
        ),

        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ScanPlaceholder(
            message: 'Quét mã sản phẩm tại vị trí\nchỉ định trên PDA',
            icon: Icons.inventory_2_rounded,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
