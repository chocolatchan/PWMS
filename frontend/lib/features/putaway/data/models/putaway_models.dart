import 'package:freezed_annotation/freezed_annotation.dart';

part 'putaway_models.freezed.dart';
part 'putaway_models.g.dart';

@freezed
abstract class PutawayItem with _$PutawayItem {
  const factory PutawayItem({
    required String sku,
    required String productName,
    required int expectedQty,
    required int scannedQty,
    required String suggestedLocation,
  }) = _PutawayItem;

  factory PutawayItem.fromJson(Map<String, dynamic> json) => _$PutawayItemFromJson(json);
}

@freezed
abstract class PutawayTask with _$PutawayTask {
  const factory PutawayTask({
    required String toteBarcode,
    required List<PutawayItem> items,
    required String status,
  }) = _PutawayTask;

  factory PutawayTask.fromJson(Map<String, dynamic> json) => _$PutawayTaskFromJson(json);
}
