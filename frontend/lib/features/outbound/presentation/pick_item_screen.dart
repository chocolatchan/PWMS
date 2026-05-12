import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui/pda_scaffold.dart';
import '../../../core/ui/pda_button.dart';
import '../../../core/ui/pda_step_progress.dart';
import '../../../core/ui/pda_scan_overlay.dart';
import '../data/outbound_repository.dart';
import '../models/outbound_dto.dart';
import '../presentation/outbound_providers.dart';

class PickItemScreen extends ConsumerStatefulWidget {
  final String taskId;
  final String containerId;
  final String productName;
  final int requiredQty;

  const PickItemScreen({
    super.key,
    required this.taskId,
    required this.containerId,
    required this.productName,
    required this.requiredQty,
  });

  @override
  ConsumerState<PickItemScreen> createState() => _PickItemScreenState();
}

class _PickItemScreenState extends ConsumerState<PickItemScreen> {
  int _step = 0; // 0: scan location, 1: scan item barcode, 2: confirm quantity
  String? _scannedLocation;
  String? _scannedBarcode;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    // Watch the scanPick state to show loading indicator
    final pickState = ref.watch(scanPickStateProvider);

    return PdaScaffold(
      title: 'Pick: ${widget.productName}',
      body: Column(
        children: [
          PdaStepProgress(
            currentStep: _step,
            steps: const ['Scan location', 'Scan item', 'Confirm qty'],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: _buildStepContent(pickState),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(AsyncValue<void> pickState) {
    switch (_step) {
      case 0:
        return Column(
          children: [
            const Text('Scan the shelf barcode where the item is stored.',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
            const SizedBox(height: 40),
            PdaButton(
              label: 'Scan Location',
              onPressed: () async {
                final location = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PdaScanOverlay(onScan: (barcode) => Navigator.pop(context, barcode))),
                );
                if (location != null) {
                  setState(() {
                    _scannedLocation = location as String;
                    _step = 1;
                  });
                }
              },
            ),
            if (_scannedLocation != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text('Scanned location: $_scannedLocation', style: const TextStyle(fontSize: 18)),
              ),
          ],
        );
      case 1:
        return Column(
          children: [
            const Text('Scan the item barcode.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
            const SizedBox(height: 40),
            PdaButton(
              label: 'Scan Item',
              onPressed: () async {
                final barcode = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PdaScanOverlay(onScan: (barcode) => Navigator.pop(context, barcode))),
                );
                if (barcode != null) {
                  setState(() {
                    _scannedBarcode = barcode as String;
                    _step = 2;
                  });
                }
              },
            ),
            if (_scannedBarcode != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text('Scanned: $_scannedBarcode', style: const TextStyle(fontSize: 18)),
              ),
          ],
        );
      case 2:
        return Column(
          children: [
            Text('How many ${widget.productName} to pick?', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 60,
                  onPressed: () => setState(() => _quantity = (_quantity > 1) ? _quantity - 1 : 1),
                  icon: const Icon(Icons.remove_circle_outline, size: 60),
                ),
                Container(
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 36),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: _quantity.toString()),
                    onChanged: (v) => setState(() => _quantity = int.tryParse(v) ?? 1),
                  ),
                ),
                IconButton(
                  iconSize: 60,
                  onPressed: () => setState(() => _quantity = (_quantity < widget.requiredQty) ? _quantity + 1 : widget.requiredQty),
                  icon: const Icon(Icons.add_circle_outline, size: 60),
                ),
              ],
            ),
            const SizedBox(height: 40),
            PdaButton(
              label: 'Confirm Pick',
              isLoading: pickState.isLoading,
              onPressed: () async {
                final req = ScanPickReq(
                  taskId: widget.taskId,
                  barcode: _scannedBarcode!,
                  inputQty: _quantity,
                );
                await ref.read(scanPickStateProvider.notifier).pick(req);
                if (mounted && !ref.read(scanPickStateProvider).hasError) {
                   Navigator.pop(context, true);
                }
              },
            ),
          ],
        );
      default:
        return Container();
    }
  }
}
