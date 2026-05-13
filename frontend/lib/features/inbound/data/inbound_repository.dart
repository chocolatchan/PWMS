import 'package:dio/dio.dart';
import '../models/inbound_dto.dart';
import '../models/product.dart';

class InboundRepository {
  final Dio _dio;
  InboundRepository(this._dio);

  Future<Product> getProductByBarcode(String barcode) async {
    final response = await _dio.get('products/barcode/$barcode');
    return Product.fromJson(response.data);
  }

  Future<List<Map<String, dynamic>>> listActiveDrafts() async {
    final response = await _dio.get('inbound/drafts');
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<void> receiveInbound(ReceiveInboundReq req) async {
    await _dio.post('inbound', data: req.toJson());
  }

  Future<void> submitQc({
    required String batchNumber,
    required String decision,
    double? minTemp,
    double? maxTemp,
    String? deviationReportId,
  }) async {
    await _dio.post('qc', data: {
      'batch_number': batchNumber,
      'decision': decision,
      if (minTemp != null) 'min_temp': minTemp,
      if (maxTemp != null) 'max_temp': maxTemp,
      if (deviationReportId != null) 'deviation_report_id': deviationReportId,
    });
  }

  Future<Map<String, dynamic>> getQcBatch(String batchNumber) async {
    final response = await _dio.get('qc/batch/$batchNumber');
    return response.data as Map<String, dynamic>;
  }

  Future<void> moveToQuarantine(MoveToQuarantineReq req) async {
    await _dio.post('inbound/quarantine', data: req.toJson());
  }

  Future<Map<String, dynamic>?> bindDraft(BindDraftReq req) async {
    final response = await _dio.post('inbound/draft/bind', data: req.toJson());
    if (response.data['status'] == 'bound') {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> saveDraft(SaveDraftReq req) async {
    await _dio.post('inbound/draft/save', data: req.toJson());
  }

  Future<void> unbindDraft(UnbindDraftReq req) async {
    await _dio.post('inbound/draft/unbind', data: req.toJson());
  }

  Future<Map<String, dynamic>?> getActiveDraft() async {
    final response = await _dio.get('inbound/draft/active');
    if (response.data['status'] == 'active') {
      return response.data;
    }
    return null;
  }
}
