import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'pda_button.dart';

class PdaScanOverlay extends StatelessWidget {
  final Function(String barcode) onScan;

  const PdaScanOverlay({super.key, required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                onScan(barcodes.first.rawValue!);
              }
            },
          ),
          Positioned(
            bottom: 50,
            left: 24,
            right: 24,
            child: PdaButton(
              label: 'Cancel',
              onPressed: () => Navigator.pop(context),
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
