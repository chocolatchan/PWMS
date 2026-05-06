import 'package:dio/dio.dart';
import '../models/outbound_models.dart';
import 'outbound_api_client.dart';

class OutboundRepository {
  final OutboundApiClient _apiClient;

  OutboundRepository(this._apiClient);

  Future<void> startPicking(int taskId, String toteCode) async {
    try {
      final req = StartTaskRequest(taskId: taskId, toteCode: toteCode);
      await _apiClient.startTask(req);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> submitPick(SubmitPickRequest req) async {
    try {
      await _apiClient.submitPick(req);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> completePicking(int taskId) async {
    try {
      await _apiClient.completeTask(taskId);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('error')) {
        return data['error'].toString();
      }
      return data.toString();
    }
    return "Lỗi kết nối Server: ${e.message}";
  }
}
