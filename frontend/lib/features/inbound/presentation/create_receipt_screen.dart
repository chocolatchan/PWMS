import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../bloc/inbound_bloc.dart';
import '../bloc/inbound_event.dart';
import '../bloc/inbound_state.dart';
import '../models/inbound_models.dart';
import '../../../shared/widgets.dart';

class CreateReceiptScreen extends StatefulWidget {
  const CreateReceiptScreen({super.key});

  @override
  State<CreateReceiptScreen> createState() => _CreateReceiptScreenState();
}

class _CreateReceiptScreenState extends State<CreateReceiptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _dateController = TextEditingController();
  int? _selectedPartnerId;

  @override
  void initState() {
    super.initState();
    context.read<InboundBloc>().add(LoadPartners());
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _numberController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Khởi Tạo Phiếu Nhập')),
      body: BlocConsumer<InboundBloc, InboundState>(
        listener: (context, state) {
          if (state is InboundFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: cs.error),
            );
          }
          if (state is InboundSuccess && state.receiptId != null) {
            context.go('/inbound/scan/${state.receiptId}');
          }
        },
        builder: (context, state) {
          final partners = state is PartnersLoaded
              ? state.partners
              : <PartnerDto>[];
          final isLoading = state is InboundLoading;

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Info card ──────────────────────────
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.local_shipping_rounded,
                            color: cs.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Phiếu Nhận Hàng Mới',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Sau khi tạo, hệ thống sẽ chuyển sang màn hình quét hàng.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SectionHeader('Thông tin chứng từ'),
                const SizedBox(height: 8),

                // ── Supplier dropdown ──────────────────
                if (partners.isEmpty && state is InboundLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  DropdownButtonFormField<int>(
                    initialValue: _selectedPartnerId,
                    decoration: const InputDecoration(
                      labelText: 'Nhà cung cấp *',
                      prefixIcon: Icon(Icons.business_rounded),
                    ),
                    items: partners
                        .map(
                          (p) => DropdownMenuItem(
                            value: p.id,
                            child: Text(
                              p.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedPartnerId = val),
                    validator: (val) =>
                        val == null ? 'Vui lòng chọn nhà cung cấp' : null,
                    isExpanded: true,
                  ),
                const SizedBox(height: 14),

                // ── Receipt number ──────────────────────
                TextFormField(
                  controller: _numberController,
                  decoration: const InputDecoration(
                    labelText: 'Số hiệu phiếu *',
                    prefixIcon: Icon(Icons.tag_rounded),
                    hintText: 'VD: HD-2026-001',
                  ),
                  textCapitalization: TextCapitalization.characters,
                  validator: (v) =>
                      v!.isEmpty ? 'Vui lòng nhập số phiếu' : null,
                ),
                const SizedBox(height: 14),

                // ── Date picker ─────────────────────────
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Ngày chứng từ',
                    prefixIcon: Icon(Icons.calendar_today_rounded),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(
                        () => _dateController.text = DateFormat(
                          'yyyy-MM-dd',
                        ).format(date),
                      );
                    }
                  },
                ),
                const SizedBox(height: 32),

                // ── Submit ──────────────────────────────
                FilledButton.icon(
                  onPressed: isLoading ? null : _submit,
                  icon: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.play_arrow_rounded),
                  label: Text(
                    isLoading ? 'Đang xử lý...' : 'BẮT ĐẦU NHẬN HÀNG',
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Quay lại'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final receipt = InboundReceiptDto(
        id: 0,
        receiptNumber: _numberController.text.trim(),
        supplierId: _selectedPartnerId!,
        supplierName: '',
        receiptDate: DateTime.parse(_dateController.text),
        status: 'DRAFT',
        createdAt: DateTime.now(),
      );
      context.read<InboundBloc>().add(CreateReceiptRequested(receipt));
    }
  }
}
