import 'package:dio/dio.dart';
import '../models/inbound_dto.dart';

class InboundRepository {
  final Dio _dio;
  InboundRepository(this._dio);

  Future<void> receiveInbound(ReceiveInboundReq req) async {
    await _dio.post('/inbound', data: req.toJson());
  }

  Future<void> submitQc(SubmitQcReq req) async {
    await _dio.post('/qc', data: req.toJson());
  }
}
