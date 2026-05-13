import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/ui/pda_scaffold.dart';
import '../../../core/ui/pda_button.dart';
import '../../../core/ui/pda_scan_overlay.dart';
import '../data/inbound_repository.dart';
import 'inbound_providers.dart';

// ─────────────────────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────────────────────
class QuarantineBatch {
  final String id;
  final String batchNumber;
  final String productId;
  final String productName;
  final String? expiryDate;
  final int quantity;

  const QuarantineBatch({
    required this.id,
    required this.batchNumber,
    required this.productId,
    required this.productName,
    this.expiryDate,
    required this.quantity,
  });

  factory QuarantineBatch.fromJson(Map<String, dynamic> json) => QuarantineBatch(
        id: json['id'] as String,
        batchNumber: json['batch_number'] as String,
        productId: json['product_id'] as String,
        productName: json['product_name'] as String,
        expiryDate: json['expiry_date'] as String?,
        quantity: (json['quantity'] as num).toInt(),
      );
}

// ─────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────
class QCSubmitScreen extends ConsumerStatefulWidget {
  const QCSubmitScreen({super.key});

  @override
  ConsumerState<QCSubmitScreen> createState() => _QCSubmitScreenState();
}

class _QCSubmitScreenState extends ConsumerState<QCSubmitScreen> {
  // Step 0: Scan  |  Step 1: Inspect & Decide
  int _step = 0;

  QuarantineBatch? _batch;
  bool _isLoading = false;
  String? _errorMessage;

  final _minTempCtrl = TextEditingController();
  final _maxTempCtrl = TextEditingController();
  final _deviationCtrl = TextEditingController();

  @override
  void dispose() {
    _minTempCtrl.dispose();
    _maxTempCtrl.dispose();
    _deviationCtrl.dispose();
    super.dispose();
  }

  void _reset() => setState(() {
        _step = 0;
        _batch = null;
        _errorMessage = null;
        _minTempCtrl.clear();
        _maxTempCtrl.clear();
        _deviationCtrl.clear();
      });

  // ── Scan & Lookup ──────────────────────────────────────────
  Future<void> _scanAndLookup([String? manualCode]) async {
    String? code = manualCode;
    if (code == null) {
      code = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => PdaScanOverlay(
            onScan: (v) => Navigator.pop(context, v),
          ),
        ),
      );
    }
    if (code == null || !mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(inboundRepositoryProvider);
      final data = await repo.getQcBatch(code);
      setState(() {
        _batch = QuarantineBatch.fromJson(data);
        _step = 1;
      });
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final dynamic responseData = e.response?.data;
      String? serverMsg;
      if (responseData is Map) {
        serverMsg = responseData['error'] as String?;
      } else if (responseData is String) {
        serverMsg = responseData;
      }

      if (status == 404) {
        // Not found at all
        _showNotQuarantineDialog(code, 'Batch not found in system.');
      } else if (status == 409) {
        // Found but not in quarantine
        _showNotQuarantineDialog(code, serverMsg ?? 'Batch is not in quarantine.');
      } else {
        setState(() => _errorMessage = serverMsg ?? e.message ?? 'Unknown error');
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showNotQuarantineDialog(String batchNum, String reason) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange),
          const SizedBox(width: 8),
          const Text('Not in Quarantine'),
        ]),
        content: Text('Batch "$batchNum"\n\n$reason\n\nPlease scan another batch.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _scanAndLookup(); // re-open scanner
            },
            child: const Text('Scan Another'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // ── Submit QC Decision ─────────────────────────────────────
  Future<void> _submitDecision(String decision) async {
    if (_batch == null) return;

    if (decision == 'REJECTED' && _deviationCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a deviation note for rejection.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(inboundRepositoryProvider);
      await repo.submitQc(
        batchNumber: _batch!.batchNumber,
        decision: decision,
        minTemp: double.tryParse(_minTempCtrl.text),
        maxTemp: double.tryParse(_maxTempCtrl.text),
        deviationReportId: _deviationCtrl.text.isNotEmpty ? _deviationCtrl.text : null,
      );

      if (mounted) {
        final color = decision == 'APPROVED' ? Colors.green : Colors.red;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Batch ${_batch!.batchNumber}: $decision ✓'),
          backgroundColor: color,
          duration: const Duration(seconds: 3),
        ));
        _reset();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return PdaScaffold(
      title: 'QC Inspection',
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _step == 0
              ? _buildScanStep()
              : _buildInspectStep(),
    );
  }

  Widget _buildScanStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.qr_code_scanner, size: 80, color: Colors.blue),
          const SizedBox(height: 24),
          const Text(
            'Scan Batch Barcode',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Scan the barcode on the quarantine batch.\nOnly batches in QUARANTINE status will proceed.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ),
          ],
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner, size: 28),
              label: const Text('Scan Batch', style: TextStyle(fontSize: 20)),
              onPressed: () => _scanAndLookup(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectStep() {
    final b = _batch!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Batch Info Card
          Card(
            color: Colors.blue.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.inventory_2, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(b.productName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                  ]),
                  const Divider(height: 20),
                  _infoRow('Batch No.', b.batchNumber),
                  _infoRow('Expiry Date', b.expiryDate ?? 'N/A'),
                  _infoRow('Quantity', '${b.quantity} units'),
                  _infoRow('Status', '🔒 IN QUARANTINE'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Temperature (optional)
          const Text('Temperature Records (Optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _minTempCtrl,
                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Min Temp (°C)'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _maxTempCtrl,
                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Max Temp (°C)'),
              ),
            ),
          ]),
          const SizedBox(height: 24),

          // Deviation note (shown for reject, but pre-filled optionally)
          const Text('Deviation / Notes (Required if Rejecting)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _deviationCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'e.g. Temperature excursion detected, damaged packaging...',
            ),
          ),
          const SizedBox(height: 32),

          // Decisions
          Row(children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle, size: 28),
                label: const Text('APPROVE', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 64),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : () => _submitDecision('APPROVED'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cancel, size: 28),
                label: const Text('REJECT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 64),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : () => _submitDecision('REJECTED'),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _reset,
              child: const Text('← Scan Different Batch', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      );
}
