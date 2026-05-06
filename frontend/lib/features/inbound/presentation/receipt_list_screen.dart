import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../bloc/inbound_bloc.dart';
import '../bloc/inbound_event.dart';
import '../bloc/inbound_state.dart';
import '../../../shared/widgets.dart';

class ReceiptListScreen extends StatefulWidget {
  const ReceiptListScreen({super.key});

  @override
  State<ReceiptListScreen> createState() => _ReceiptListScreenState();
}

class _ReceiptListScreenState extends State<ReceiptListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<InboundBloc>().add(FetchReceipts());
    _searchController.addListener(
      () => setState(() => _query = _searchController.text),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arrival Board'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Tải lại',
            onPressed: () => context.read<InboundBloc>().add(FetchReceipts()),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search bar ────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Tìm số phiếu hoặc nhà cung cấp...',
              leading: Icon(Icons.search_rounded, color: cs.onSurfaceVariant),
              trailing: [
                if (_query.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  ),
              ],
              elevation: const WidgetStatePropertyAll(1),
              backgroundColor: WidgetStatePropertyAll(cs.surface),
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          // ── List ─────────────────────────────────────
          Expanded(
            child: BlocBuilder<InboundBloc, InboundState>(
              builder: (context, state) {
                if (state is InboundLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is InboundFailure) {
                  return Center(
                    child: AlertBanner(
                      message: state.error,
                      icon: Icons.cloud_off_rounded,
                    ),
                  );
                }

                if (state is ReceiptsLoaded) {
                  final filtered = state.receipts
                      .where(
                        (r) =>
                            r.receiptNumber.toLowerCase().contains(
                              _query.toLowerCase(),
                            ) ||
                            r.supplierName.toLowerCase().contains(
                              _query.toLowerCase(),
                            ),
                      )
                      .toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_rounded,
                            size: 56,
                            color: cs.onSurfaceVariant.withOpacity(0.4),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _query.isEmpty
                                ? 'Chưa có phiếu nhập nào'
                                : 'Không tìm thấy kết quả',
                            style: TextStyle(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) => _ReceiptCard(
                      receipt: filtered[i],
                      onTap: () {
                        context.read<InboundBloc>().add(
                          SelectReceipt(filtered[i].id),
                        );
                        context.push('/inbound/scan/${filtered[i].id}');
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/inbound/create'),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'TẠO PHIẾU MỚI',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final dynamic receipt;
  final VoidCallback onTap;

  const _ReceiptCard({required this.receipt, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      receipt.receiptNumber as String,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: cs.primary,
                        letterSpacing: 0.5,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                  ),
                  StatusBadge(receipt.status as String),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 14,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      receipt.supplierName as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat(
                      'dd/MM/yyyy',
                    ).format(receipt.receiptDate as DateTime),
                    style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
