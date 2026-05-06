import 'package:dio/dio.dart';
import '../models/inbound_models.dart';

class InboundApiClient {
  final Dio _dio;

  InboundApiClient(this._dio);

  Future<List<InboundReceiptDto>> getPendingReceipts() async {
    final response = await _dio.get('/inbound/pending');
    final data = response.data as List;
    return data.map((json) => InboundReceiptDto.fromJson(json as Map<String, dynamic>)).toList();
  }
  Future<InboundReceiptDto> createReceipt(InboundReceiptDto receipt) async {
    final response = await _dio.post('/inbound/receipts', data: receipt.toJson());
    return InboundReceiptDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<PartnerDto>> getPartners({String type = 'supplier'}) async {
    final response = await _dio.get('/partners', queryParameters: {'type': type});
    final data = response.data as List;
    return data.map((json) => PartnerDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<InboundDetailDto>> getReceiptDetails(int id) async {
    final response = await _dio.get('/inbound/receipts/$id');
    final data = response.data as List;
    return data.map((json) => InboundDetailDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<void> submitInboundItem(InboundItemRequest req) async {
    await _dio.post('/inbound/item', data: req.toJson());
  }

  Future<void> finishReceipt(int id) async {
    await _dio.post('/inbound/receipts/$id/complete');
  }
}
