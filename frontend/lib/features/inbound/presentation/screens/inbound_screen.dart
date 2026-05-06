import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/inbound_models.dart';
import '../providers/inbound_notifier.dart';

class InboundScreen extends ConsumerStatefulWidget {
  const InboundScreen({super.key});

  @override
  ConsumerState<InboundScreen> createState() => _InboundScreenState();
}

class _InboundScreenState extends ConsumerState<InboundScreen> {
  final _barcodeController = TextEditingController();
  final _scannerFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-resume check on entry
    Future.microtask(() {
      ref.read(inboundTaskProvider.notifier).checkActiveTask();
    });
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _scannerFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleBarcodeSubmit(String value) async {
    if (value.isEmpty) return;
    
    final inboundState = ref.read(inboundTaskProvider);
    final hasTask = inboundState.value?.currentPo != null;

    if (!hasTask) {
      // PHASE 1: Scan Container to Assign Task
      await ref.read(inboundTaskProvider.notifier).assignTask(value);
      _barcodeController.clear();
      _scannerFocusNode.requestFocus();
    } else {
      // PHASE 2: Scan Item Barcode (SKU|LOT|EXP)
      try {
        await ref.read(inboundTaskProvider.notifier).processBarcode(value);
        _barcodeController.clear();
        _scannerFocusNode.requestFocus();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
        _barcodeController.clear();
        _scannerFocusNode.requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inboundState = ref.watch(inboundTaskProvider);

    ref.listen(inboundTaskProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString()), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      floatingActionButton: kDebugMode
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'debug_tote',
                  onPressed: () => _handleBarcodeSubmit('TOTE-001'),
                  icon: const Icon(Icons.shopping_basket),
                  label: const Text('Bắn Container Giả'),
                  backgroundColor: Colors.blue,
                ),
                const SizedBox(height: 8),
                FloatingActionButton.extended(
                  heroTag: 'debug_item',
                  onPressed: () => _handleBarcodeSubmit('PARA500|LOT-001|2028-12-31'),
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Bắn Item Giả'),
                  backgroundColor: Colors.orange,
                ),
              ],
            )
          : null,
      appBar: AppBar(
        title: const Text('Inbound (Nhập kho)'),
        actions: [
          if (inboundState.value?.currentPo != null)
            IconButton(
              icon: const Icon(Icons.cloud_upload),
              onPressed: () => ref.read(inboundTaskProvider.notifier).submitReceiving(),
              tooltip: 'Submit Receiving',
            ),
        ],
      ),
      body: inboundState.when(
        data: (state) {
          if (state.currentPo == null) {
            return _buildContainerScanView();
          }
          return _buildPoProcessingView(state.currentPo!, state.toteBarcode!);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => _buildContainerScanView(),
      ),
    );
  }

  Widget _buildContainerScanView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_basket, size: 100, color: Colors.blueGrey),
          const SizedBox(height: 24),
          const Text(
            'Quét mã Container/Tote để bắt đầu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Hệ thống sẽ tự động chỉ định PO cần xử lý.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _barcodeController,
            focusNode: _scannerFocusNode,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'SCAN CONTAINER BARCODE',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.qr_code_scanner),
            ),
            onFieldSubmitted: _handleBarcodeSubmit,
          ),
        ],
      ),
    );
  }

  Widget _buildPoProcessingView(PurchaseOrder po, String toteBarcode) {
    return Column(
      children: [
        // Header Info
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blueGrey.shade50,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tote: $toteBarcode', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    Text('PO: ${po.poNumber}', style: const TextStyle(fontSize: 12)),
                    Text('Supplier: ${po.supplierName}', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_person, size: 14, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        'Locked to You',
                        style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Barcode Input Field (Always Focused)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            controller: _barcodeController,
            focusNode: _scannerFocusNode,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'SCAN ITEM BARCODE',
              hintText: 'SKU|LOT|EXP',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.qr_code_scanner),
            ),
            onFieldSubmitted: _handleBarcodeSubmit,
          ),
        ),

        // Items List
        Expanded(
          child: ListView.builder(
            itemCount: po.items.length,
            itemBuilder: (context, index) {
              final item = po.items[index];
              final isComplete = item.scannedQty == item.expectedQty;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: isComplete ? Colors.green.shade50 : null,
                child: ListTile(
                  title: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('SKU: ${item.sku}'),
                  trailing: Text(
                    '${item.scannedQty} / ${item.expectedQty}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isComplete ? Colors.green.shade700 : Colors.blue,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Step 25: Submit Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: ref.watch(inboundTaskProvider).isLoading
                  ? null
                  : () => ref.read(inboundTaskProvider.notifier).submitReceiving(),
              icon: ref.watch(inboundTaskProvider).isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle),
              label: Text(
                ref.watch(inboundTaskProvider).isLoading
                    ? 'Đang xử lý...'
                    : 'HOÀN TẤT NHẬP KHO',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
