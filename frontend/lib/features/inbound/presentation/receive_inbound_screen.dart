import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/pda_scaffold.dart';
import '../../../core/ui/pda_button.dart';
import '../../../core/ui/pda_step_progress.dart';
import '../../../core/ui/pda_scan_overlay.dart';
import '../models/inbound_dto.dart';
import '../models/inbound_draft.dart';
import '../models/product.dart';
import 'inbound_providers.dart';
import '../../auth/data/auth_storage.dart';
import '../../../core/utils/gs1_parser.dart';

class ReceiveInboundScreen extends ConsumerStatefulWidget {
  const ReceiveInboundScreen({super.key});

  @override
  ConsumerState<ReceiveInboundScreen> createState() =>
      _ReceiveInboundScreenState();
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
  final _expiryController = TextEditingController();

  DateTime? _selectedExpiry;

  String? _currentProductId;
  String? _currentProductName;
  Product? _currentProduct;
  PoDetailsResponse? _poDetails;
  bool _initializing = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkActiveDraft());
  }

  Future<void> _checkActiveDraft() async {
    try {
      final response = await ref
          .read(inboundDraftProvider.notifier)
          .getActiveDraft();
      if (response != null && response.isNotEmpty) {
        final draft = InboundDraft.fromJson(
          response['payload'] as Map<String, dynamic>,
        );
        final poDetails = PoDetailsResponse.fromJson(
          response['po_details'] as Map<String, dynamic>,
        );
        setState(() {
          _poNumber = draft.poNumber;
          _poDetails = poDetails;
          _step = draft.step;
          _sealNumber = draft.sealNumber;
          _arrivalTemp = draft.arrivalTemperature;
          _batches.clear();
          _batches.addAll(draft.batches);

          _poController.text = _poNumber ?? '';
          _sealController.text = _sealNumber ?? '';
          _tempController.text = _arrivalTemp?.toString() ?? '';
          _initializing = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Resumed your active PO session'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } else {
        setState(() => _initializing = false);
      }
    } catch (e) {
      setState(() => _initializing = false);
    }
  }

  @override
  void dispose() {
    _poController.dispose();
    _sealController.dispose();
    _tempController.dispose();
    _batchNumController.dispose();
    _expectedQtyController.dispose();
    _actualQtyController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  Future<void> _saveDraft() async {
    if (_poNumber == null) return;
    final draft = InboundDraft(
      step: _step,
      poNumber: _poNumber,
      sealNumber: _sealNumber,
      arrivalTemperature: _arrivalTemp,
      batches: _batches,
    );
    await ref
        .read(inboundDraftProvider.notifier)
        .saveDraft(_poNumber!, draft.toJson());
  }

  void _nextStep() {
    setState(() {
      if (_step < 3) _step++;
    });
    _saveDraft();
  }

  void _prevStep() {
    setState(() {
      if (_step > 0) _step--;
    });
    _saveDraft();
  }

  @override
  Widget build(BuildContext context) {
    final receiveState = ref.watch(receiveInboundStateProvider);
    final draftState = ref.watch(inboundDraftProvider);

    return PdaScaffold(
      title: 'Receive Inbound',
      actions: [],
      body: Column(
        children: [
          PdaStepProgress(
            currentStep: _step,
            steps: const ['PO Info', 'Transport', 'Batches', 'Review'],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: _buildStepContent(receiveState, draftState),
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
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Back', style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepContent(
    AsyncValue<void> receiveState,
    AsyncValue<void> draftState,
  ) {
    if (_initializing || draftState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (_step) {
      case 0: // PO Info
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Purchase Order Number',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _poController,
              enabled: _poNumber == null,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'e.g., PO-2026-001',
                suffixIcon: _poNumber != null
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.qr_code_scanner, size: 32),
                        onPressed: () async {
                          final scanned = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PdaScanOverlay(
                                onScan: (barcode) =>
                                    Navigator.pop(context, barcode),
                              ),
                            ),
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
              onPressed: () async {
                if (_poController.text.isNotEmpty) {
                  final po = _poController.text;
                  try {
                    final response = await ref
                        .read(inboundDraftProvider.notifier)
                        .bindDraft(po);
                    setState(() {
                      _poNumber = po;
                      if (response != null && response.isNotEmpty) {
                        _poDetails = PoDetailsResponse.fromJson(
                          response['po_details'] as Map<String, dynamic>,
                        );
                        final payload =
                            response['payload'] as Map<String, dynamic>?;
                        if (payload != null && payload.isNotEmpty) {
                          final draft = InboundDraft.fromJson(payload);
                          _step = draft.step;
                          _sealNumber = draft.sealNumber;
                          _arrivalTemp = draft.arrivalTemperature;
                          _batches.clear();
                          _batches.addAll(draft.batches);

                          _sealController.text = _sealNumber ?? '';
                          _tempController.text = _arrivalTemp?.toString() ?? '';
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Resumed previous draft'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        } else {
                          _step = 1;
                        }
                      }
                    });
                  } catch (e) {
                    if (mounted) {
                      String msg = e.toString();
                      if (msg.contains('409')) {
                        msg =
                            'This PO is already bound to another staff member!';
                      } else if (msg.contains('404')) {
                        msg =
                            'Purchase Order not found! Please check with Admin.';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(msg),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PO Number is required')),
                  );
                }
              },
            ),
          ],
        );
      case 1: // Transport
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vehicle Seal Number (Optional)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _sealController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Seal Number',
              ),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            const Text(
              'Arrival Temperature (Optional)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _tempController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g., 4.5 °C',
              ),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 32),
            PdaButton(
              label: 'Next',
              onPressed: () {
                _sealNumber = _sealController.text.isNotEmpty
                    ? _sealController.text
                    : null;
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
            if (_poDetails != null) ...[
              const Text(
                'Expected Items in PO',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  border: Border.all(color: Colors.blue.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: _poDetails!.items.map((item) {
                    final receivedInSession = _batches
                        .where((b) => b.productId == item.productId)
                        .fold(0, (sum, b) => sum + b.actualQty);
                    final totalReceived = item.receivedQty + receivedInSession;
                    final isFull = totalReceived >= item.expectedQty;
                    return ListTile(
                      dense: true,
                      title: Text(
                        item.productName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Progress: $totalReceived / ${item.expectedQty}',
                      ),
                      trailing: isFull
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Batches Added: ${_batches.length}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _currentProductName ??
                              _currentProductId ??
                              'No product scanned',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                (_currentProductName == null &&
                                    _currentProductId == null)
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.qr_code_scanner,
                          size: 32,
                          color: Colors.blue,
                        ),
                        onPressed: () async {
                          final scanned = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PdaScanOverlay(
                                onScan: (barcode) =>
                                    Navigator.pop(context, barcode),
                              ),
                            ),
                          );
                          if (scanned != null) {
                            final code = scanned as String;
                            // Try GS1 Parsing
                            final gs1Data = Gs1Parser.parse(code);
                            String lookupCode = code;

                            if (gs1Data.containsKey('gtin')) {
                              lookupCode = gs1Data['gtin']!;
                              // Auto fill batch and expiry if present
                              if (gs1Data.containsKey('batch')) {
                                _batchNumController.text = gs1Data['batch']!;
                              }
                              if (gs1Data.containsKey('expiry')) {
                                final date = Gs1Parser.parseGs1Date(
                                  gs1Data['expiry']!,
                                );
                                if (date != null) {
                                  setState(() {
                                    _selectedExpiry = date;
                                    _expiryController.text =
                                        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                                  });
                                }
                              }
                            }

                            try {
                              final product = await ref
                                  .read(inboundDraftProvider.notifier)
                                  .getProductByBarcode(lookupCode);
                              
                              // If we have all GS1 data (Full scan), auto-add or sum up
                              if (gs1Data.containsKey('batch') && gs1Data.containsKey('expiry')) {
                                final batchNum = gs1Data['batch']!;
                                final expiryDate = Gs1Parser.parseGs1Date(gs1Data['expiry']!);
                                
                                // Get increment quantity: From GS1 count AI, or fallback to 1
                                int increment = 1;
                                if (gs1Data.containsKey('count')) {
                                  increment = int.tryParse(gs1Data['count']!) ?? 1;
                                }

                                if (expiryDate != null) {
                                  setState(() {
                                    final existingIndex = _batches.indexWhere((b) => 
                                      b.productId == product.id && 
                                      b.batchNumber == batchNum &&
                                      b.expiryDate.year == expiryDate.year &&
                                      b.expiryDate.month == expiryDate.month &&
                                      b.expiryDate.day == expiryDate.day
                                    );

                                    if (existingIndex != -1) {
                                      // Sum up quantity
                                      final b = _batches[existingIndex];
                                      final newQty = b.actualQty + increment;
                                      _batches[existingIndex] = b.copyWith(actualQty: newQty);
                                      
                                      final boxCount = (newQty / (increment > 0 ? increment : 1)).floor();
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text('Box #$boxCount added. Total: $newQty units'),
                                        backgroundColor: Colors.green,
                                      ));
                                    } else {
                                      // Add new batch
                                      _batches.add(BatchPayload(
                                        productId: product.id,
                                        batchNumber: batchNum,
                                        expiryDate: expiryDate,
                                        expectedQty: increment, 
                                        actualQty: increment,
                                      ));
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text('First Box added ($increment units)'),
                                        backgroundColor: Colors.green,
                                      ));
                                    }
                                    
                                    // Clear current selection state after auto-add
                                    _currentProductId = null;
                                    _currentProductName = null;
                                    _currentProduct = null;
                                    _batchNumController.clear();
                                    _expiryController.clear();
                                    _selectedExpiry = null;
                                  });
                                  _saveDraft();
                                  return; // Exit early as we've handled the scan
                                }
                              }

                              // If not a full scan, just populate fields for manual entry
                              setState(() {
                                _currentProductId = product.id;
                                _currentProductName = product.name;
                                _currentProduct = product;
                                _actualQtyController.text = '1';
                              });
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Product not found: $lookupCode',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentProductName ?? 'No product scanned',
                    style: TextStyle(
                      fontSize: 18,
                      color: _currentProductName == null
                          ? Colors.grey
                          : Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _batchNumController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Batch Number',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _expectedQtyController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Expected Qty',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _actualQtyController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Actual Qty',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _expiryController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Expiry Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 3650),
                            ),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedExpiry = date;
                              _expiryController.text =
                                  "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Batch'),
                      onPressed: () {
                        if (_currentProductId != null &&
                            _batchNumController.text.isNotEmpty &&
                            _expectedQtyController.text.isNotEmpty &&
                            _actualQtyController.text.isNotEmpty &&
                            _selectedExpiry != null) {
                          setState(() {
                            _batches.add(
                              BatchPayload(
                                productId: _currentProductId!,
                                batchNumber: _batchNumController.text,
                                expiryDate: _selectedExpiry!,
                                expectedQty: int.parse(
                                  _expectedQtyController.text,
                                ),
                                actualQty: int.parse(_actualQtyController.text),
                              ),
                            );
                            _currentProductId = null;
                            _currentProductName = null;
                            _selectedExpiry = null;
                            _batchNumController.clear();
                            _expectedQtyController.clear();
                            _actualQtyController.clear();
                            _expiryController.clear();
                          });
                          _saveDraft();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please fill all fields including Expiry Date',
                              ),
                            ),
                          );
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
            const Text(
              'Review Shipment',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildReviewRow('PO Number:', _poNumber ?? ''),
            _buildReviewRow('Seal Number:', _sealNumber ?? 'N/A'),
            _buildReviewRow(
              'Arrival Temp:',
              _arrivalTemp != null ? '$_arrivalTemp °C' : 'N/A',
            ),
            const SizedBox(height: 16),
            const Text(
              'Batches:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ..._batches.map((b) {
              final productName =
                  _poDetails?.items
                      .where((item) => item.productId == b.productId)
                      .firstOrNull
                      ?.productName ??
                  b.productId;

              final expiryStr =
                  "${b.expiryDate.year}-${b.expiryDate.month.toString().padLeft(2, '0')}-${b.expiryDate.day.toString().padLeft(2, '0')}";

              return ListTile(
                title: Text(
                  'Product: $productName',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Batch: ${b.batchNumber} | Expiry: $expiryStr\nQty: ${b.actualQty}',
                ),
                isThreeLine: true,
                contentPadding: EdgeInsets.zero,
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() => _batches.remove(b));
                    _saveDraft();
                  },
                ),
              );
            }),
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
                await ref
                    .read(receiveInboundStateProvider.notifier)
                    .receive(req);
                if (mounted &&
                    !ref.read(receiveInboundStateProvider).hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Received successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                } else if (mounted &&
                    ref.read(receiveInboundStateProvider).hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error: ${ref.read(receiveInboundStateProvider).error}',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
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
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
