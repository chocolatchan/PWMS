import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/pda_scaffold.dart';
import '../../../core/ui/pda_scan_overlay.dart';
import '../models/outbound_dto.dart';
import '../presentation/outbound_providers.dart';

class PickItemScreen extends ConsumerStatefulWidget {
  final String taskId;
  final String containerId;
  final String productName;
  final String? batchNumber;
  final String locationCode;
  final int requiredQty;
  final int pickedQty;

  const PickItemScreen({
    super.key,
    required this.taskId,
    required this.containerId,
    required this.productName,
    this.batchNumber,
    required this.locationCode,
    required this.requiredQty,
    required this.pickedQty,
  });

  @override
  ConsumerState<PickItemScreen> createState() => _PickItemScreenState();
}

class _PickItemScreenState extends ConsumerState<PickItemScreen> {
  // Step 0: Scan shelf location  |  Step 1: Scan item barcode  |  Step 2: Confirm qty
  int _step = 0;
  String? _scannedLocation;
  String? _scannedBarcode;
  int _currentPicked = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentPicked = widget.pickedQty;
  }

  int get _remaining => widget.requiredQty - _currentPicked;

  Future<void> _scanLocation() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => PdaScanOverlay(onScan: (b) => Navigator.pop(context, b)),
      ),
    );
    if (result == null) return;

    // Validate location matches expected
    if (result != widget.locationCode) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text('Wrong Location'),
            ]),
            content: Text(
              'Scanned: $result\nExpected: ${widget.locationCode}\n\nPlease go to the correct shelf.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return;
    }

    setState(() {
      _scannedLocation = result;
      _step = 1;
    });
  }

  Future<void> _scanItem() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => PdaScanOverlay(onScan: (b) => Navigator.pop(context, b)),
      ),
    );
    if (result == null) return;
    setState(() {
      _scannedBarcode = result;
      _step = 2;
    });
  }

  Future<void> _confirmPick(int qty) async {
    if (_scannedBarcode == null) return;
    setState(() => _isLoading = true);

    try {
      final req = ScanPickReq(
        taskId: widget.taskId,
        barcode: _scannedBarcode!,
        inputQty: qty,
      );
      await ref.read(outboundRepositoryProvider).scanPick(req);

      setState(() {
        _currentPicked += qty;
        _isLoading = false;
      });

      if (_currentPicked >= widget.requiredQty) {
        // All done!
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Pick task completed!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        // More to pick — go back to scan item step
        setState(() {
          _scannedBarcode = null;
          _step = 1;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Picked $qty. ${_remaining} remaining.'),
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PdaScaffold(
      title: 'Picking',
      body: Column(
        children: [
          // Header progress bar
          _buildHeader(),
          // Step indicator
          _buildStepIndicator(),
          const SizedBox(height: 24),
          Expanded(child: _buildStep()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final progress = widget.requiredQty > 0
        ? (_currentPicked / widget.requiredQty).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      color: Colors.blue.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.productName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (widget.batchNumber != null)
                _chip(Icons.tag, widget.batchNumber!),
              const SizedBox(width: 8),
              _chip(Icons.location_on, widget.locationCode),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$_currentPicked / ${widget.requiredQty}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.blue.shade700),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 13, color: Colors.blue.shade700)),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['Scan Location', 'Scan Item', 'Confirm Qty'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = i == _step;
          final isDone = i < _step;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone
                              ? Colors.green
                              : isActive
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                        ),
                        child: Center(
                          child: isDone
                              ? const Icon(Icons.check, color: Colors.white, size: 18)
                              : Text('${i + 1}',
                                  style: TextStyle(
                                    color: isActive ? Colors.white : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  )),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        steps[i],
                        style: TextStyle(
                          fontSize: 11,
                          color: isActive ? Colors.blue : Colors.grey,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (i < steps.length - 1)
                  Expanded(
                    child: Divider(
                      color: isDone ? Colors.green : Colors.grey.shade300,
                      thickness: 2,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _buildScanLocationStep();
      case 1:
        return _buildScanItemStep();
      case 2:
        return _buildConfirmQtyStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildScanLocationStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, size: 80, color: Colors.blue),
          const SizedBox(height: 16),
          const Text('Go to the shelf and scan the location barcode.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            'Expected: ${widget.locationCode}',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner, size: 28),
              label: const Text('Scan Location', style: TextStyle(fontSize: 20)),
              onPressed: _scanLocation,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanItemStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2, size: 80, color: Colors.blue),
          const SizedBox(height: 16),
          Text(
            'Scan barcode on: ${widget.productName}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          if (widget.batchNumber != null) ...[
            const SizedBox(height: 8),
            Text(
              'Batch: ${widget.batchNumber}',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            'Remaining: $_remaining units',
            style: const TextStyle(
                fontSize: 18, color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner, size: 28),
              label: const Text('Scan Item Barcode', style: TextStyle(fontSize: 20)),
              onPressed: _scanItem,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmQtyStep() {
    return _QuantityConfirmWidget(
      productName: widget.productName,
      batchNumber: widget.batchNumber,
      scannedBarcode: _scannedBarcode!,
      remaining: _remaining,
      isLoading: _isLoading,
      onConfirm: _confirmPick,
      onRescan: () => setState(() {
        _scannedBarcode = null;
        _step = 1;
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Quantity Confirm Widget
// ─────────────────────────────────────────────────────────────
class _QuantityConfirmWidget extends StatefulWidget {
  final String productName;
  final String? batchNumber;
  final String scannedBarcode;
  final int remaining;
  final bool isLoading;
  final Future<void> Function(int qty) onConfirm;
  final VoidCallback onRescan;

  const _QuantityConfirmWidget({
    required this.productName,
    this.batchNumber,
    required this.scannedBarcode,
    required this.remaining,
    required this.isLoading,
    required this.onConfirm,
    required this.onRescan,
  });

  @override
  State<_QuantityConfirmWidget> createState() => _QuantityConfirmWidgetState();
}

class _QuantityConfirmWidgetState extends State<_QuantityConfirmWidget> {
  int _qty = 1;
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _qty = widget.remaining;
    _ctrl = TextEditingController(text: _qty.toString());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _set(int v) {
    final clamped = v.clamp(1, widget.remaining);
    setState(() => _qty = clamped);
    _ctrl.text = clamped.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Scanned barcode confirm chip
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Scanned',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text(widget.scannedBarcode,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: widget.onRescan,
                  child: const Text('Rescan'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'How many to pick?',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Max: ${widget.remaining}',
              style: const TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 56,
                icon: const Icon(Icons.remove_circle_outline),
                color: Colors.blue,
                onPressed: () => _set(_qty - 1),
              ),
              Container(
                width: 100,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _ctrl,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => _set(int.tryParse(v) ?? _qty),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              IconButton(
                iconSize: 56,
                icon: const Icon(Icons.add_circle_outline),
                color: Colors.blue,
                onPressed: () => _set(_qty + 1),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton.icon(
              icon: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.check, size: 28),
              label: Text(
                widget.isLoading ? 'Submitting...' : 'Confirm Pick ($_qty)',
                style: const TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: widget.isLoading ? null : () => widget.onConfirm(_qty),
            ),
          ),
        ],
      ),
    );
  }
}
