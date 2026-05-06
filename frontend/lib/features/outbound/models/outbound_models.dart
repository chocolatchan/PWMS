class PickingTaskDto {
  final int id;
  final int orderId;
  final int? toteId;
  final String zoneType;
  final String status;

  PickingTaskDto({
    required this.id,
    required this.orderId,
    this.toteId,
    required this.zoneType,
    required this.status,
  });

  factory PickingTaskDto.fromJson(Map<String, dynamic> json) {
    return PickingTaskDto(
      id: json['id'] as int,
      orderId: json['order_id'] as int,
      toteId: json['tote_id'] as int?,
      zoneType: json['zone_type'] as String,
      status: json['status'] as String,
    );
  }
}

class StartTaskRequest {
  final int taskId;
  final String toteCode;

  StartTaskRequest({required this.taskId, required this.toteCode});

  Map<String, dynamic> toJson() => {
        'task_id': taskId,
        'tote_code': toteCode,
      };
}

class SubmitPickRequest {
  final int taskId;
  final int orderId;
  final int productId;
  final int batchId;
  final int locationId;
  final int qty;

  SubmitPickRequest({
    required this.taskId,
    required this.orderId,
    required this.productId,
    required this.batchId,
    required this.locationId,
    required this.qty,
  });

  Map<String, dynamic> toJson() => {
        'task_id': taskId,
        'order_id': orderId,
        'product_id': productId,
        'batch_id': batchId,
        'location_id': locationId,
        'qty': qty,
      };
}
