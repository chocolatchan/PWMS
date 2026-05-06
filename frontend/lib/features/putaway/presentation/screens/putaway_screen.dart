import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pwms_frontend/features/putaway/presentation/providers/putaway_state.dart';
import '../providers/putaway_notifier.dart';

class PutawayScreen extends ConsumerStatefulWidget {
  const PutawayScreen({super.key});

  @override
  ConsumerState<PutawayScreen> createState() => _PutawayScreenState();
}

class _PutawayScreenState extends ConsumerState<PutawayScreen> {
  final _barcodeController = TextEditingController();
  final _scannerFocusNode = FocusNode();

  @override
  void dispose() {
    _barcodeController.dispose();
    _scannerFocusNode.dispose();
    super.dispose();
  }

  void _handleBarcodeSubmit(String value) {
    if (value.isEmpty) return;
    ref.read(putawayTaskProvider.notifier).processBarcode(value);
    _barcodeController.clear();
    _scannerFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final putawayState = ref.watch(putawayTaskProvider);

    ref.listen(putawayTaskProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      floatingActionButton:
          kDebugMode && putawayState.value?.currentTask == null
          ? FloatingActionButton.extended(
              heroTag: 'debug_putaway_tote',
              onPressed: () => _handleBarcodeSubmit('TOTE-001'),
              icon: const Icon(Icons.shopping_basket),
              label: const Text('Bắn TOTE Giả (Putaway)'),
              backgroundColor: Colors.indigo,
            )
          : (kDebugMode &&
                putawayState.value?.currentStep ==
                    PutawayStep.waitingForLocation)
          ? FloatingActionButton.extended(
              heroTag: 'debug_putaway_loc',
              onPressed: () => _handleBarcodeSubmit('Z01-A01-C01'),
              icon: const Icon(Icons.location_on),
              label: const Text('Bắn Vị Trí Giả'),
              backgroundColor: Colors.orange,
            )
          : null,
      appBar: AppBar(title: const Text('Putaway (Cất hàng)')),
      body: putawayState.when(
        data: (state) {
          if (state.currentTask == null) {
            return _buildToteScanView();
          }
          return _buildTaskActiveView(state);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => _buildToteScanView(),
      ),
    );
  }

  Widget _buildToteScanView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2, size: 100, color: Colors.indigo),
          const SizedBox(height: 24),
          const Text(
            'Quét một Container đã nhận hàng để bắt đầu Putaway',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Hệ thống sẽ hướng dẫn bạn đến vị trí kệ phù hợp.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextFormField(
            controller: _barcodeController,
            focusNode: _scannerFocusNode,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'SCAN LOADED TOTE',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.qr_code_scanner),
            ),
            onFieldSubmitted: _handleBarcodeSubmit,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskActiveView(PutawayState state) {
    final task = state.currentTask!;
    final isWaitingForLocation =
        state.currentStep == PutawayStep.waitingForLocation;

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.indigo.shade50,
          child: Row(
            children: [
              const Icon(Icons.shopping_basket, color: Colors.indigo),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Container: ${task.toteBarcode}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${task.items.length} items to shelf',
                    style: TextStyle(
                      color: Colors.indigo.shade700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (!isWaitingForLocation)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.orange.shade700,
            child: Row(
              children: [
                const Icon(Icons.lock, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Đã khóa tại vị trí: ${state.lockedLocation}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      ref.read(putawayTaskProvider.notifier).unlockLocation(),
                  child: const Text(
                    'ĐỔI VỊ TRÍ',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Hidden input for scanner
        Opacity(
          opacity: 0,
          child: SizedBox(
            height: 1,
            child: TextFormField(
              controller: _barcodeController,
              focusNode: _scannerFocusNode,
              autofocus: true,
              onFieldSubmitted: _handleBarcodeSubmit,
            ),
          ),
        ),

        if (isWaitingForLocation)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    size: 80,
                    color: Colors.orange.shade300,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '📍 Di chuyển đến kệ và quét mã VỊ TRÍ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gợi ý: ${task.items.first.suggestedLocation}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: task.items.length,
              itemBuilder: (context, index) {
                final item = task.items[index];
                final isCurrentLocation =
                    item.suggestedLocation == state.lockedLocation;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: isCurrentLocation ? Colors.orange.shade50 : null,
                  child: ListTile(
                    title: Text(
                      item.productName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'SKU: ${item.sku} • Qty: ${item.scannedQty} / ${item.expectedQty}',
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrentLocation
                            ? Colors.orange
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.suggestedLocation,
                        style: TextStyle(
                          color: isCurrentLocation
                              ? Colors.white
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        if (!isWaitingForLocation)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: (state.isLoading ||
                      task.items.fold(0, (sum, it) => sum + it.scannedQty) == 0)
                  ? null
                  : () => ref.read(putawayTaskProvider.notifier).submitDrop(),
              icon: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.archive_outlined),
              label: Text(
                state.isLoading ? 'ĐANG LƯU...' : 'XÁC NHẬN CẤT HÀNG (DROP)',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade800,
                foregroundColor: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
