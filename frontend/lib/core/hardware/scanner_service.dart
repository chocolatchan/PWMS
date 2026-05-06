import 'dart:async';

class ScannerService {
  final StreamController<String> _barcodeController =
      StreamController<String>.broadcast();

  Stream<String> get barcodeStream => _barcodeController.stream;

  // Hàm này sẽ được gọi bởi TextField tàng hình
  void onBarcodeScanned(String barcode) {
    if (barcode.trim().isNotEmpty) {
      _barcodeController.add(barcode.trim());
    }
  }

  void dispose() {
    _barcodeController.close();
  }
}
