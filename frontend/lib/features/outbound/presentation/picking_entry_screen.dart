import 'package:flutter/material.dart';
import '../../../core/ui/pda_scaffold.dart';
import '../../../core/ui/pda_button.dart';
import '../../../core/ui/pda_scan_overlay.dart';
import 'pick_list_screen.dart';

class PickingEntryScreen extends StatefulWidget {
  const PickingEntryScreen({super.key});

  @override
  State<PickingEntryScreen> createState() => _PickingEntryScreenState();
}

class _PickingEntryScreenState extends State<PickingEntryScreen> {
  String? _containerId;
  String? _locationCode;

  void _scanContainer() async {
    final containerId = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PdaScanOverlay(onScan: (barcode) => Navigator.pop(context, barcode))),
    );
    if (containerId != null) setState(() => _containerId = containerId as String);
  }

  void _scanLocation() async {
    final location = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PdaScanOverlay(onScan: (barcode) => Navigator.pop(context, barcode))),
    );
    if (location != null) setState(() => _locationCode = location as String);
  }

  void _startPicking() {
    if (_containerId != null && _locationCode != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PickListScreen(containerId: _containerId!, locationCode: _locationCode!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PdaScaffold(
      title: 'Picking',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_containerId == null)
            PdaButton(label: 'Scan Container No.', onPressed: _scanContainer)
          else
            _buildInfoRow('Container: $_containerId', Icons.check_circle),
          const SizedBox(height: 24),
          if (_containerId != null && _locationCode == null)
            PdaButton(label: 'Scan Location', onPressed: _scanLocation)
          else if (_locationCode != null)
            _buildInfoRow('Location: $_locationCode', Icons.check_circle),
          const SizedBox(height: 40),
          if (_containerId != null && _locationCode != null)
            PdaButton(label: 'Start Picking', onPressed: _startPicking),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green, size: 32),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
