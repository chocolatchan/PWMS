import 'package:dio/dio.dart';
import '../models/outbound_models.dart';

class OutboundApiClient {
  final Dio _dio;

  OutboundApiClient(this._dio);

  Future<void> startTask(StartTaskRequest req) async {
    await _dio.post('/picking/start', data: req.toJson());
  }

  Future<void> submitPick(SubmitPickRequest req) async {
    await _dio.post('/picking/submit', data: req.toJson());
  }

  Future<void> completeTask(int taskId) async {
    await _dio.post('/picking/complete/$taskId');
  }
}
