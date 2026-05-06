import 'package:flutter/material.dart';

// 1. Cập nhật Widget Build
@override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false, // Luôn chặn mặc định để xử lý logic GSP riêng
    onPopInvokedWithResult: (didPop, result) async {
      if (didPop) return; // Nếu đã pop thành công thì không làm gì cả

      // Gọi hàm helper để hiện Dialog
      final bool shouldExit = await _showExitConfirmation(context);

      if (shouldExit && context.mounted) {
        // Nếu chọn thoát, ta đóng màn hình thủ công
        Navigator.of(context).pop();
      }
    },
    child: Scaffold(
      appBar: AppBar(title: const Text("Quét nhận hàng")),
      body: const Center(child: Text("Nội dung Inbound...")),
    ),
  );
}

// 2. Định nghĩa hàm helper _showExitConfirmation (Phải nằm trong class State)
Future<bool> _showExitConfirmation(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Xác nhận hủy'),
          content: const Text(
            'Bạn có chắc muốn hủy toàn bộ phiên nhập hàng này? Mọi dữ liệu quét sẽ bị xóa.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('QUAY LẠI'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('HỦY PHIẾU'),
            ),
          ],
        ),
      ) ??
      false; // Nếu bấm ra ngoài dialog thì mặc định là false
}
