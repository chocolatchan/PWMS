import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/pda_scaffold.dart';
import '../../../core/ui/pda_button.dart';
import '../../../core/ui/pda_step_progress.dart';
import '../../../core/ui/pda_scan_overlay.dart';
import '../models/inbound_dto.dart';
import 'inbound_providers.dart';

class MoveToQuarantineScreen extends ConsumerStatefulWidget {
  const MoveToQuarantineScreen({super.key});

  @override
  ConsumerState<MoveToQuarantineScreen> createState() => _MoveToQuarantineScreenState();
}

class _MoveToQuarantineScreenState extends ConsumerState<MoveToQuarantineScreen> {
  int _step = 0;
  String? _scannedBatchId;
  String? _scannedLocation;
  String? _confirmBatchId;
  bool _isLoading = false;

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

  void _reset() {
    setState(() {
      _step = 0;
      _scannedBatchId = null;
      _scannedLocation = null;
      _confirmBatchId = null;
      _isLoading = false;
    });
  }

  Future<void> _submit() async {
    if (_scannedBatchId == null || _scannedLocation == null || _confirmBatchId != _scannedBatchId) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid data for quarantine')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final req = MoveToQuarantineReq(
        batchNumber: _scannedBatchId!,
        locationCode: _scannedLocation!,
      );
      
      final repo = ref.read(inboundRepositoryProvider);
      // We will need to add moveToQuarantine to the repository!
      await repo.moveToQuarantine(req);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successfully moved to quarantine!'), backgroundColor: Colors.green));
        _reset(); // Ready for the next batch
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PdaScaffold(
      title: 'Move to Quarantine',
      body: Column(
        children: [
          PdaStepProgress(
            currentStep: _step,
            steps: const ['Scan Batch', 'Scan Loc', 'Confirm', 'Done'],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: _buildStepContent(),
            ),
          ),
          if (_step > 0 && _step < 3 && !_isLoading)
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

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return _buildScanStep(
          title: 'Scan Batch Barcode',
          subtitle: 'Scan the batch you want to move.',
          scannedValue: _scannedBatchId,
          onScanned: (val) {
            setState(() {
              _scannedBatchId = val;
            });
            _nextStep();
          },
        );
      case 1:
        return _buildScanStep(
          title: 'Scan QRN Location',
          subtitle: 'E.g. QRN-A1',
          scannedValue: _scannedLocation,
          onScanned: (val) {
            setState(() {
              _scannedLocation = val;
            });
            _nextStep();
          },
        );
      case 2:
        return _buildScanStep(
          title: 'Confirm Batch',
          subtitle: 'Scan the batch again at the location.',
          scannedValue: _confirmBatchId,
          onScanned: (val) {
            if (val != _scannedBatchId) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mismatch! Please scan the same batch.'), backgroundColor: Colors.red));
              return;
            }
            setState(() {
              _confirmBatchId = val;
            });
            _nextStep();
          },
        );
      case 3:
        return Column(
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text('Ready to Submit', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ListTile(
              title: const Text('Batch ID'),
              subtitle: Text(_scannedBatchId ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            ListTile(
              title: const Text('Location'),
              subtitle: Text(_scannedLocation ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),
            PdaButton(
              label: 'Submit Move',
              isLoading: _isLoading,
              onPressed: _submit,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildScanStep({
    required String title,
    required String subtitle,
    required String? scannedValue,
    required Function(String) onScanned,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 32),
        if (scannedValue != null) ...[
          const Icon(Icons.qr_code, size: 64, color: Colors.green),
          const SizedBox(height: 16),
          Text(scannedValue, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ] else ...[
          InkWell(
            onTap: () async {
              final val = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PdaScanOverlay(onScan: (barcode) => Navigator.pop(context, barcode))),
              );
              if (val != null) {
                onScanned(val as String);
              }
            },
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 64, color: Colors.blue),
                  SizedBox(height: 16),
                  Text('Tap to Scan', style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ]
      ],
    );
  }
}
