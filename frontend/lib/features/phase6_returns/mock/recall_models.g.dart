// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recall_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) =>
    _InventoryItem(
      id: json['id'] as String,
      batchCode: json['batchCode'] as String,
      location: json['location'] as String,
      quantity: (json['quantity'] as num).toInt(),
      status: $enumDecode(_$InventoryStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$InventoryItemToJson(_InventoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'batchCode': instance.batchCode,
      'location': instance.location,
      'quantity': instance.quantity,
      'status': _$InventoryStatusEnumMap[instance.status]!,
    };

const _$InventoryStatusEnumMap = {
  InventoryStatus.available: 'available',
  InventoryStatus.picking: 'picking',
  InventoryStatus.dispatch: 'dispatch',
  InventoryStatus.recalled: 'recalled',
  InventoryStatus.quarantined: 'quarantined',
  InventoryStatus.rejected: 'rejected',
};

_ReturnItem _$ReturnItemFromJson(Map<String, dynamic> json) => _ReturnItem(
  id: json['id'] as String,
  barcode: json['barcode'] as String,
  reason: $enumDecode(_$ReturnReasonEnumMap, json['reason']),
  isColdChain: json['isColdChain'] as bool,
  assignedTote: json['assignedTote'] as String,
  returnedAt: DateTime.parse(json['returnedAt'] as String),
);

Map<String, dynamic> _$ReturnItemToJson(_ReturnItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'barcode': instance.barcode,
      'reason': _$ReturnReasonEnumMap[instance.reason]!,
      'isColdChain': instance.isColdChain,
      'assignedTote': instance.assignedTote,
      'returnedAt': instance.returnedAt.toIso8601String(),
    };

const _$ReturnReasonEnumMap = {
  ReturnReason.change_of_mind: 'change_of_mind',
  ReturnReason.expired: 'expired',
  ReturnReason.damaged: 'damaged',
  ReturnReason.wrong_item: 'wrong_item',
};

_Phase6State _$Phase6StateFromJson(Map<String, dynamic> json) => _Phase6State(
  inventory:
      (json['inventory'] as List<dynamic>?)
          ?.map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  returns:
      (json['returns'] as List<dynamic>?)
          ?.map((e) => ReturnItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isRecallActive: json['isRecallActive'] as bool? ?? false,
  recallReport: json['recallReport'] as String?,
);

Map<String, dynamic> _$Phase6StateToJson(_Phase6State instance) =>
    <String, dynamic>{
      'inventory': instance.inventory,
      'returns': instance.returns,
      'isRecallActive': instance.isRecallActive,
      'recallReport': instance.recallReport,
    };
