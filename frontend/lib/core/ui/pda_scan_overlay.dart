import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'pda_button.dart';

class PdaScanOverlay extends StatefulWidget {
  final Function(String barcode) onScan;

  const PdaScanOverlay({super.key, required this.onScan});

  @override
  State<PdaScanOverlay> createState() => _PdaScanOverlayState();
}

class _PdaScanOverlayState extends State<PdaScanOverlay> {
  final _manualController = TextEditingController();

  @override
  void dispose() {
    _manualController.dispose();
    super.dispose();
  }

  void _submitManual() {
    final text = _manualController.text.trim();
    if (text.isNotEmpty) {
      widget.onScan(text);
    }
  }

  bool get _isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan or Type Barcode'),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Scanner or Placeholder
          if (_isMobile)
            MobileScanner(
              onDetect: (capture) {
                final barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                  widget.onScan(barcodes.first.rawValue!);
                }
              },
            )
          else
            Container(
              color: Colors.black,
              child: const Center(
                child: Text(
                  'Camera scanning not supported on this platform.\nPlease type the code manually.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ),
            
          // Manual Input Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _manualController,
                    decoration: InputDecoration(
                      labelText: 'Manual Entry',
                      hintText: 'Enter barcode...',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: _submitManual,
                      ),
                    ),
                    onSubmitted: (_) => _submitManual(),
                  ),
                  const SizedBox(height: 16),
                  PdaButton(
                    label: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
