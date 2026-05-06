import 'package:dio/dio.dart';
import '../models/inbound_models.dart';
import 'inbound_api_client.dart';

class InboundException implements Exception {
  final String message;
  InboundException(this.message);
  @override
  String toString() => message;
}

class InboundRepository {
  final InboundApiClient _apiClient;

  InboundRepository(this._apiClient);

  Future<List<InboundReceiptDto>> getPendingReceipts() async {
    try {
      return await _apiClient.getPendingReceipts();
    } on DioException catch (e) {
      throw InboundException(_handleError(e));
    }
  }

  Future<InboundReceiptDto> createReceipt(InboundReceiptDto receipt) async {
    try {
      return await _apiClient.createReceipt(receipt);
    } on DioException catch (e) {
      throw InboundException(_handleError(e));
    }
  }

  Future<List<PartnerDto>> getPartners() async {
    try {
      return await _apiClient.getPartners(type: 'supplier');
    } on DioException catch (e) {
      throw InboundException(_handleError(e));
    }
  }

  Future<List<InboundDetailDto>> getReceiptDetails(int id) async {
    try {
      return await _apiClient.getReceiptDetails(id);
    } on DioException catch (e) {
      throw InboundException(_handleError(e));
    }
  }

  Future<void> submitInboundItem(InboundItemRequest req) async {
    try {
      await _apiClient.submitInboundItem(req);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final data = e.response?.data;
        if (data is Map && data['message'] == "Missing COA") {
          throw InboundException("Hàng thiếu COA - Yêu cầu chuyển rổ Vàng");
        }
      }
      throw InboundException(_handleError(e));
    }
  }

  Future<void> finishReceipt(int id) async {
    try {
      await _apiClient.finishReceipt(id);
    } on DioException catch (e) {
      throw InboundException(_handleError(e));
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data != null && e.response?.data is Map) {
      return e.response?.data['message']?.toString() ?? e.message ?? "Lỗi không xác định";
    }
    return e.message ?? "Lỗi kết nối Server";
  }
}
