import 'package:dio/dio.dart';
import '../models/outbound_dto.dart';

class OutboundRepository {
  final Dio _dio;
  OutboundRepository(this._dio);

  Future<void> createOrder(CreateOrderReq req) async {
    await _dio.post('orders', data: req.toJson());
  }

  Future<void> scanPick(ScanPickReq req) async {
    await _dio.post('outbound/pick', data: req.toJson());
  }

  Future<void> packContainer(PackContainerReq req) async {
    await _dio.post('outbound/pack', data: req.toJson());
  }

  Future<void> dispatch(DispatchReq req) async {
    await _dio.post('outbound/dispatch', data: req.toJson());
  }

  Future<List<PickTask>> getPickTasks({String? containerId, String? locationCode}) async {
    final response = await _dio.get('outbound/pick-tasks', queryParameters: {
      if (containerId != null) 'container_id': containerId,
      if (locationCode != null) 'location_code': locationCode,
    });
    final List data = response.data;
    return data.map((j) => PickTask.fromJson(j)).toList();
  }
}
