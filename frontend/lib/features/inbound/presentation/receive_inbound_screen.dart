import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/pda_scaffold.dart';
import '../../../core/ui/pda_button.dart';
import '../../../core/ui/pda_step_progress.dart';
import '../../../core/ui/pda_scan_overlay.dart';
import '../models/inbound_dto.dart';
import 'inbound_providers.dart';

class ReceiveInboundScreen extends ConsumerStatefulWidget {
  const ReceiveInboundScreen({super.key});

  @override
  ConsumerState<ReceiveInboundScreen> createState() => _ReceiveInboundScreenState();
}

class _ReceiveInboundScreenState extends ConsumerState<ReceiveInboundScreen> {
  int _step = 0;
  
  // Form State
  String? _poNumber;
  String? _sealNumber;
  double? _arrivalTemp;
  final List<BatchPayload> _batches = [];
  
  // Controllers
  final _poController = TextEditingController();
  final _sealController = TextEditingController();
  final _tempController = TextEditingController();
  final _batchNumController = TextEditingController();
  final _expectedQtyController = TextEditingController();
  final _actualQtyController = TextEditingController();
  
  String? _currentProductId;

  @override
  void dispose() {
    _poController.dispose();
    _sealController.dispose();
    _tempController.dispose();
    _batchNumController.dispose();
    _expectedQtyController.dispose();
    _actualQtyController.dispose();
    super.dispose();
  }

  void _nextStep() {
    setState(() {
      if (_step < 3) _step++;
    });
  }

  void _prevStep() {
    setState(() {
      if (_step > 0) _step--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final receiveState = ref.watch(receiveInboundStateProvider);

    return PdaScaffold(
      title: 'Receive Inbound',
      body: Column(
        children: [
          PdaStepProgress(
            currentStep: _step,
            steps: const ['PO Info', 'Transport', 'Batches', 'Review'],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: _buildStepContent(receiveState),
            ),
          ),
          if (_step > 0 && !receiveState.isLoading)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: OutlinedButton(
                  onPressed: _prevStep,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Back', style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepContent(AsyncValue<void> receiveState) {
    switch (_step) {
      case 0: // PO Info
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter Purchase Order Number', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _poController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'e.g., PO-2026-001',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner, size: 32),
                  onPressed: () async {
                    final scanned = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PdaScanOverlay(onScan: (barcode) => Navigator.pop(context, barcode))),
                    );
                    if (scanned != null) {
                      setState(() {
                        _poController.text = scanned as String;
                      });
                    }
                  },
                ),
              ),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 32),
            PdaButton(
              label: 'Next',
              onPressed: () {
                if (_poController.text.isNotEmpty) {
                  _poNumber = _poController.text;
                  _nextStep();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PO Number is required')));
                }
              },
            ),
          ],
        );
      case 1: // Transport
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Vehicle Seal Number (Optional)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _sealController,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Seal Number'),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            const Text('Arrival Temperature (Optional)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _tempController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'e.g., 4.5 °C'),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 32),
            PdaButton(
              label: 'Next',
              onPressed: () {
                _sealNumber = _sealController.text.isNotEmpty ? _sealController.text : null;
                _arrivalTemp = double.tryParse(_tempController.text);
                _nextStep();
              },
            ),
          ],
        );
      case 2: // Batches
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Batches Added: ${_batches.length}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                if (_batches.isNotEmpty)
                  ElevatedButton(
                    onPressed: _nextStep,
                    child: const Text('Review', style: TextStyle(fontSize: 18)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(_currentProductId ?? 'No product scanned', 
                          style: TextStyle(fontSize: 16, color: _currentProductId == null ? Colors.grey : Colors.black)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.qr_code_scanner, size: 32, color: Colors.blue),
                        onPressed: () async {
                          final scanned = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PdaScanOverlay(onScan: (barcode) => Navigator.pop(context, barcode))),
                          );
                          if (scanned != null) {
                            setState(() => _currentProductId = scanned as String);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _batchNumController,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Batch Number'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _expectedQtyController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Expected Qty'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _actualQtyController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Actual Qty'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Batch'),
                      onPressed: () {
                        if (_currentProductId != null && _batchNumController.text.isNotEmpty && _expectedQtyController.text.isNotEmpty && _actualQtyController.text.isNotEmpty) {
                          setState(() {
                            _batches.add(BatchPayload(
                              productId: _currentProductId!,
                              batchNumber: _batchNumController.text,
                              expectedQty: int.parse(_expectedQtyController.text),
                              actualQty: int.parse(_actualQtyController.text),
                            ));
                            _currentProductId = null;
                            _batchNumController.clear();
                            _expectedQtyController.clear();
                            _actualQtyController.clear();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case 3: // Review
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Review Shipment', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildReviewRow('PO Number:', _poNumber ?? ''),
            _buildReviewRow('Seal Number:', _sealNumber ?? 'N/A'),
            _buildReviewRow('Arrival Temp:', _arrivalTemp != null ? '$_arrivalTemp °C' : 'N/A'),
            const SizedBox(height: 16),
            const Text('Batches:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ..._batches.map((b) => ListTile(
              title: Text('Product: ${b.productId}'),
              subtitle: Text('Batch: ${b.batchNumber} | Expected: ${b.expectedQty} | Actual: ${b.actualQty}'),
              contentPadding: EdgeInsets.zero,
            )),
            const SizedBox(height: 32),
            PdaButton(
              label: 'Confirm & Receive',
              isLoading: receiveState.isLoading,
              onPressed: () async {
                final req = ReceiveInboundReq(
                  poNumber: _poNumber!,
                  vehicleSealNumber: _sealNumber,
                  arrivalTemperature: _arrivalTemp,
                  batches: _batches,
                );
                await ref.read(receiveInboundStateProvider.notifier).receive(req);
                if (mounted && !ref.read(receiveInboundStateProvider).hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Received successfully!'), backgroundColor: Colors.green));
                  Navigator.pop(context);
                } else if (mounted && ref.read(receiveInboundStateProvider).hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${ref.read(receiveInboundStateProvider).error}'), backgroundColor: Colors.red));
                }
              },
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
