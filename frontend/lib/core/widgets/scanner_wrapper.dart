import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../hardware/scanner_service.dart';

class ScannerWrapper extends StatefulWidget {
  final Widget child;

  const ScannerWrapper({super.key, required this.child});

  @override
  State<ScannerWrapper> createState() => _ScannerWrapperState();
}

class _ScannerWrapperState extends State<ScannerWrapper> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Luôn yêu cầu focus khi widget được tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Bấm ra ngoài màn hình sẽ tự động focus lại vào máy quét
      onTap: () => _focusNode.requestFocus(),
      child: Stack(
        children: [
          // UI thật của App
          widget.child,

          // TextField tàng hình hứng tia laser
          Offstage(
            offstage: true, // Ẩn hoàn toàn khỏi UI
            child: Material(
              child: TextField(
                focusNode: _focusNode,
                controller: _controller,
                autofocus: true,
                // MA THUẬT: Ép hệ điều hành KHÔNG bật bàn phím ảo
                keyboardType: TextInputType.none,
                onSubmitted: (value) {
                  // Nhận được mã (Scanner tự bắn Enter) -> Đẩy vào Service
                  GetIt.I<ScannerService>().onBarcodeScanned(value);
  
                  // Xóa ô nhập và giữ lại focus cho lần quét tiếp theo
                  _controller.clear();
                  _focusNode.requestFocus();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
