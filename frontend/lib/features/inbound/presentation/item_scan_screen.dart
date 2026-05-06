import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/scanner_wrapper.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets.dart';
import '../bloc/inbound_bloc.dart';
import '../bloc/inbound_event.dart';
import '../bloc/inbound_state.dart';
import '../models/inbound_models.dart';
import 'package:get_it/get_it.dart';
import '../../../core/hardware/scanner_service.dart';
import 'widgets/batch_entry_form.dart';

class ItemScanScreen extends StatefulWidget {
  final int receiptId;
  const ItemScanScreen({super.key, required this.receiptId});

  @override
  State<ItemScanScreen> createState() => _ItemScanScreenState();
}

class _ItemScanScreenState extends State<ItemScanScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  InboundDetailDto? _lastScanned;
  bool _flashSuccess = false;
  int _scannedCount = 0;
  bool _manualMode = false;
  final _manualController = TextEditingController();
  final _manualFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _manualController.dispose();
    _manualFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmExit()) Navigator.of(context).pop();
      },
      child: ScannerWrapper(
        child: Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nhập Kho — Quét Hàng'),
                Text(
                  'Phiếu #${widget.receiptId}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  icon: const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18,
                  ),
                  label: const Text(
                    'Hoàn tất',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  onPressed: () => _finishReceipt(context),
                ),
              ),
            ],
          ),
          body: BlocConsumer<InboundBloc, InboundState>(
            listener: (context, state) {
              if (state is InboundFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: cs.error,
                  ),
                );
              }
              if (state is ProcessingItem) {
                _showBatchForm(context, state.item);
              }
              if (state is InboundSuccess) {
                setState(() {
                  _flashSuccess = true;
                  _scannedCount++;
                });
                Future.delayed(const Duration(milliseconds: 400), () {
                  if (mounted) setState(() => _flashSuccess = false);
                });
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Column(
                    children: [
                      // ── Progress ───────────────────────────
                      PdaProgressBar(
                        current: _scannedCount,
                        total: 0,
                        label: 'Mặt hàng đã quét trong phiên này',
                      ),

                      // ── Last scanned card ──────────────────
                      if (_lastScanned != null)
                        _LastScannedCard(item: _lastScanned!),

                      // ── Manual Input Field ────────────────
                      if (_manualMode)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Card(
                            elevation: 8,
                            shadowColor: cs.primary.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: cs.primary, width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              child: TextField(
                                controller: _manualController,
                                focusNode: _manualFocusNode,
                                decoration: InputDecoration(
                                  hintText: 'Nhập mã vạch thủ công...',
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.send_rounded),
                                    color: cs.primary,
                                    onPressed: () => _handleManualSubmit(_manualController.text),
                                  ),
                                ),
                                textInputAction: TextInputAction.send,
                                onSubmitted: _handleManualSubmit,
                              ),
                            ),
                          ),
                        ),

                      // ── Scanner prompt ─────────────────────
                      Expanded(child: _ScannerPrompt(pulseCtrl: _pulseCtrl)),

                      // ── Bottom bar ─────────────────────────
                      _BottomBar(
                        receiptId: widget.receiptId,
                        onManualToggle: () {
                          setState(() {
                            _manualMode = !_manualMode;
                            if (_manualMode) {
                              _manualFocusNode.requestFocus();
                            } else {
                              _manualController.clear();
                            }
                          });
                        },
                        isManualMode: _manualMode,
                      ),
                    ],
                  ),

                  // ── Success flash ──────────────────────────
                  if (_flashSuccess)
                    IgnorePointer(
                      child: AnimatedOpacity(
                        opacity: _flashSuccess ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          color: AppTheme.zoneGreen.withOpacity(0.25),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmExit() async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            icon: const Icon(Icons.exit_to_app_rounded, size: 32),
            title: const Text('Thoát phiên nhập kho?'),
            content: const Text(
              'Dữ liệu đã quét trên phiếu này sẽ được lưu lại. Bạn có thể tiếp tục sau.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Tiếp tục'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Thoát'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showBatchForm(BuildContext context, InboundDetailDto item) async {
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (ctx, anim, _, child) => SlideTransition(
        position: Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      ),
      pageBuilder: (ctx, _, _) => BatchEntryForm(
        receiptId: widget.receiptId,
        product: item,
        onSubmit: (req) {
          context.read<InboundBloc>().add(SubmitBatchInfo(req));
          Navigator.pop(ctx, true);
        },
      ),
    );

    if (result == true) setState(() => _lastScanned = item);
  }

  void _finishReceipt(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.task_alt_rounded, size: 32, color: Colors.green),
        title: const Text('Kết thúc nhận hàng?'),
        content: Text(
          'Bạn đã quét $_scannedCount mặt hàng. Xác nhận hoàn tất phiếu nhập này?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Chưa xong'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<InboundBloc>().add(
                FinishReceiptRequested(widget.receiptId),
              );
              context.go('/inbound');
            },
            child: const Text('Xác nhận hoàn tất'),
          ),
        ],
      ),
    );
  }

  void _handleManualSubmit(String value) {
    if (value.trim().isEmpty) return;
    
    // Giả lập sự kiện quét cho ScannerService
    GetIt.I<ScannerService>().onBarcodeScanned(value.trim());

    _manualController.clear();
    setState(() => _manualMode = false);
  }
}

class _ScannerPrompt extends StatelessWidget {
  final AnimationController pulseCtrl;
  const _ScannerPrompt({required this.pulseCtrl});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: pulseCtrl,
              builder: (_, child) => Transform.scale(
                scale: 0.92 + 0.08 * pulseCtrl.value,
                child: child,
              ),
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 68,
                  color: cs.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'SẴN SÀNG QUÉT',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Chiếu tia laser vào mã vạch sản phẩm',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _LastScannedCard extends StatelessWidget {
  final InboundDetailDto item;
  const _LastScannedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      color: cs.primaryContainer.withOpacity(0.4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.zoneGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 22),
        ),
        title: Text(
          item.productName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          'Vừa quét thành công',
          style: TextStyle(fontSize: 12, color: cs.primary),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int receiptId;
  final VoidCallback onManualToggle;
  final bool isManualMode;

  const _BottomBar({
    required this.receiptId,
    required this.onManualToggle,
    required this.isManualMode,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Phiếu #$receiptId đang hoạt động',
              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
            ),
          ),
          const Icon(Icons.circle, size: 10, color: Colors.green),
          const SizedBox(width: 4),
          Text(
            'LIVE',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.zoneGreen,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 12),
          IconButton.filledTonal(
            onPressed: onManualToggle,
            icon: Icon(
              isManualMode ? Icons.keyboard_hide_rounded : Icons.edit_note_rounded,
              size: 20,
            ),
            tooltip: 'Nhập thủ công',
            style: IconButton.styleFrom(
              backgroundColor: isManualMode ? cs.primary : cs.secondaryContainer,
              foregroundColor: isManualMode ? cs.onPrimary : cs.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
