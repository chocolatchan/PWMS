import 'package:flutter/material.dart';
import '../../models/inbound_models.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets.dart';

class BatchEntryForm extends StatefulWidget {
  final int receiptId;
  final InboundDetailDto product;
  final Function(InboundItemRequest) onSubmit;

  const BatchEntryForm({
    super.key,
    required this.receiptId,
    required this.product,
    required this.onSubmit,
  });

  @override
  State<BatchEntryForm> createState() => _BatchEntryFormState();
}

class _BatchEntryFormState extends State<BatchEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _batchCtrl = TextEditingController();
  final _mfgCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _toteCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _locCtrl = TextEditingController();

  final _batchFocus = FocusNode();

  bool _isCoaAvailable = true;
  bool _isReturn = false;

  String get _autoToteColor {
    if (_isReturn) return 'PURPLE';
    if (!_isCoaAvailable) return 'YELLOW';
    return 'GREEN';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _batchFocus.requestFocus());
  }

  @override
  void dispose() {
    _batchFocus.dispose();
    for (final c in [_batchCtrl, _mfgCtrl, _expCtrl, _qtyCtrl, _toteCtrl, _noteCtrl, _locCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final toteAccent = AppTheme.toteColor(_autoToteColor);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: toteAccent,
        foregroundColor: Colors.white,
        title: const Text('Khai Báo Lô Hàng'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // ── Tote Banner ─────────────────────────────
          ToteBanner(_autoToteColor),

          // ── Product chip ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Card(
              margin: EdgeInsets.zero,
              color: cs.primaryContainer.withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.medication_rounded, color: cs.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.product.productName,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Form fields ──────────────────────────────
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                children: [
                  // Batch number
                  TextFormField(
                    controller: _batchCtrl,
                    focusNode: _batchFocus,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Số lô (Batch No.) *',
                      prefixIcon: Icon(Icons.pin_rounded),
                    ),
                    validator: (v) => v!.isEmpty ? 'Bắt buộc' : null,
                  ),
                  const SizedBox(height: 12),

                  // Manufacture / Expiry dates
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _mfgCtrl,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Ngày SX',
                            hintText: 'YYYY-MM-DD',
                            prefixIcon: Icon(Icons.calendar_today_rounded),
                          ),
                          validator: (v) => v!.isNotEmpty ? _dateValidator(v) : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _expCtrl,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Hạn dùng *',
                            hintText: 'YYYY-MM-DD',
                            prefixIcon: const Icon(Icons.event_busy_rounded),
                            labelStyle: TextStyle(color: cs.error),
                          ),
                          validator: (v) => v!.isEmpty ? 'Bắt buộc (NOT NULL)' : _dateValidator(v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Qty + Tote
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _qtyCtrl,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'SL khai báo *',
                            prefixIcon: Icon(Icons.numbers_rounded),
                          ),
                          validator: (v) => v!.isEmpty ? 'Bắt buộc' : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _toteCtrl,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Mã rổ *',
                            prefixIcon: Icon(Icons.shopping_basket_rounded, color: toteAccent),
                          ),
                          validator: (v) => v!.isEmpty ? 'Quét rổ' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Location
                  TextFormField(
                    controller: _locCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Vị trí Biệt trữ (Quét Location)',
                      prefixIcon: Icon(Icons.location_on_rounded),
                    ),
                    validator: (v) => v!.isEmpty ? 'Vui lòng quét vị trí' : null,
                  ),
                  const SizedBox(height: 12),

                  // Gate note
                  TextFormField(
                    controller: _noteCtrl,
                    maxLines: 2,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Ghi chú cửa kho',
                      prefixIcon: Icon(Icons.edit_note_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── GSP Document checks (NO cảm quan) ──
                  const SectionHeader('Kiểm tra hồ sơ'),
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Đầy đủ COA / Hồ sơ chất lượng', style: TextStyle(fontSize: 14)),
                          subtitle: Text(
                            _isCoaAvailable ? 'Rổ XANH — Nhập bình thường' : '⚠ Thiếu COA → Rổ VÀNG — Biệt trữ QA',
                            style: TextStyle(
                              fontSize: 12,
                              color: _isCoaAvailable ? AppTheme.zoneGreen : AppTheme.zoneYellow,
                            ),
                          ),
                          value: _isCoaAvailable,
                          activeThumbColor: AppTheme.zoneGreen,
                          onChanged: (v) => setState(() => _isCoaAvailable = v),
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          title: const Text('Hàng trả về (Returns)', style: TextStyle(fontSize: 14)),
                          subtitle: Text(
                            _isReturn ? '→ Rổ TÍM — Không trộn với hàng mới' : 'Hàng nhập mới',
                            style: TextStyle(
                              fontSize: 12,
                              color: _isReturn ? AppTheme.zonePurple : AppTheme.statusDraft,
                            ),
                          ),
                          value: _isReturn,
                          activeThumbColor: AppTheme.zonePurple,
                          onChanged: (v) => setState(() => _isReturn = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Submit button ───────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: toteAccent),
                onPressed: _submit,
                icon: const Icon(Icons.check_rounded),
                label: Text('XÁC NHẬN → Rổ ${AppTheme.toteName(_autoToteColor).split(' ').first}'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _dateValidator(String v) {
    try { DateTime.parse(v); return null; }
    catch (_) { return 'Định dạng YYYY-MM-DD'; }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(InboundItemRequest(
        receiptId: widget.receiptId,
        productId: widget.product.productId,
        batchNumber: _batchCtrl.text,
        manufactureDate: _mfgCtrl.text,
        expiryDate: _expCtrl.text,
        declaredQty: int.tryParse(_qtyCtrl.text) ?? 1,
        toteCode: _toteCtrl.text,
        isCoaAvailable: _isCoaAvailable,
        gateNote: _noteCtrl.text,
        quarantineLocationId: int.tryParse(_locCtrl.text),
      ));
    }
  }
}
