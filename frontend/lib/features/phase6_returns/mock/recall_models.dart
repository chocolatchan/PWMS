import 'package:freezed_annotation/freezed_annotation.dart';

part 'recall_models.freezed.dart';
part 'recall_models.g.dart';

enum InventoryStatus { available, picking, dispatch, recalled, quarantined, rejected }

enum ReturnReason { change_of_mind, expired, damaged, wrong_item }

@freezed
abstract class InventoryItem with _$InventoryItem {
  const factory InventoryItem({
    required String id,
    required String batchCode,
    required String location,
    required int quantity,
    required InventoryStatus status,
  }) = _InventoryItem;

  factory InventoryItem.fromJson(Map<String, dynamic> json) => _$InventoryItemFromJson(json);
}

@freezed
abstract class ReturnItem with _$ReturnItem {
  const factory ReturnItem({
    required String id,
    required String barcode,
    required ReturnReason reason,
    required bool isColdChain,
    required String assignedTote,
    required DateTime returnedAt,
  }) = _ReturnItem;

  factory ReturnItem.fromJson(Map<String, dynamic> json) => _$ReturnItemFromJson(json);
}

@freezed
abstract class Phase6State with _$Phase6State {
  const factory Phase6State({
    @Default([]) List<InventoryItem> inventory,
    @Default([]) List<ReturnItem> returns,
    @Default(false) bool isRecallActive,
    String? recallReport,
  }) = _Phase6State;

  factory Phase6State.fromJson(Map<String, dynamic> json) => _$Phase6StateFromJson(json);
}
