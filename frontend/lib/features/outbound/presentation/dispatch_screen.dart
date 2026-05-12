import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/pda_scaffold.dart';
import '../../../core/ui/pda_button.dart';
import '../../../core/ui/pda_step_progress.dart';
import '../../../core/ui/pda_scan_overlay.dart';
import '../models/outbound_dto.dart';
import 'outbound_providers.dart';

class DispatchScreen extends ConsumerStatefulWidget {
  const DispatchScreen({super.key});

  @override
  ConsumerState<DispatchScreen> createState() => _DispatchScreenState();
}

class _DispatchScreenState extends ConsumerState<DispatchScreen> {
  int _step = 0;
  
  String? _containerId;
  String? _sealNumber;
  double? _dispatchTemp;

  final _containerController = TextEditingController();
  final _sealController = TextEditingController();
  final _tempController = TextEditingController();

  @override
  void dispose() {
    _containerController.dispose();
    _sealController.dispose();
    _tempController.dispose();
    super.dispose();
  }

  void _nextStep() {
    setState(() {
      if (_step < 2) _step++;
    });
  }

  void _prevStep() {
    setState(() {
      if (_step > 0) _step--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dispatchState = ref.watch(dispatchStateProvider);

    return PdaScaffold(
      title: 'Dispatch',
      body: Column(
        children: [
          PdaStepProgress(
            currentStep: _step,
            steps: const ['Scan Container', 'Vehicle Seal', 'Review'],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: _buildStepContent(dispatchState),
            ),
          ),
          if (_step > 0 && !dispatchState.isLoading)
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

  Widget _buildStepContent(AsyncValue<void> dispatchState) {
    switch (_step) {
      case 0: // Scan Container
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Scan Packed Container', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _containerController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Container ID',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner, size: 32),
                  onPressed: () async {
                    final scanned = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PdaScanOverlay(onScan: (barcode) => Navigator.pop(context, barcode))),
                    );
                    if (scanned != null) {
                      setState(() {
                        _containerController.text = scanned as String;
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
                if (_containerController.text.isNotEmpty) {
                  _containerId = _containerController.text;
                  _nextStep();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Container ID is required')));
                }
              },
            ),
          ],
        );
      case 1: // Vehicle Seal & Temp
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Scan Vehicle Seal', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _sealController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Seal Number',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner, size: 32),
                  onPressed: () async {
                    final scanned = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PdaScanOverlay(onScan: (barcode) => Navigator.pop(context, barcode))),
                    );
                    if (scanned != null) {
                      setState(() {
                        _sealController.text = scanned as String;
                      });
                    }
                  },
                ),
              ),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            const Text('Dispatch Temperature (Optional)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                if (_sealController.text.isNotEmpty) {
                  _sealNumber = _sealController.text;
                  _dispatchTemp = double.tryParse(_tempController.text);
                  _nextStep();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vehicle Seal is required')));
                }
              },
            ),
          ],
        );
      case 2: // Review
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Review Dispatch', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildReviewRow('Container ID:', _containerId ?? ''),
            _buildReviewRow('Seal Number:', _sealNumber ?? ''),
            _buildReviewRow('Dispatch Temp:', _dispatchTemp != null ? '$_dispatchTemp °C' : 'N/A'),
            const SizedBox(height: 32),
            PdaButton(
              label: 'Confirm Dispatch',
              isLoading: dispatchState.isLoading,
              onPressed: () async {
                final req = DispatchReq(
                  containerId: _containerId!,
                  vehicleSealNumber: _sealNumber!,
                  dispatchTemperature: _dispatchTemp,
                );
                await ref.read(dispatchStateProvider.notifier).dispatch(req);
                if (mounted && !ref.read(dispatchStateProvider).hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dispatched successfully!'), backgroundColor: Colors.green));
                  Navigator.pop(context);
                } else if (mounted && ref.read(dispatchStateProvider).hasError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${ref.read(dispatchStateProvider).error}'), backgroundColor: Colors.red));
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
