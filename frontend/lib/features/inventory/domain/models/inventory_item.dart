import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/json_converters.dart';

part 'inventory_item.freezed.dart';
part 'inventory_item.g.dart';

/// Represents a specific inventory balance/batch in a location.
@freezed
class InventoryBalance with _$InventoryBalance {
  /// Ensures perfect JSON key matching with Rust (snake_case) 
  /// and robust ISO-8601 DateTime conversion.
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory InventoryBalance({
    required int id,
    required int productId,
    required int locationId,
    required String batchNumber,
    @DateTimeConverter() required DateTime expiryDate,
    required double quantity,
    required String status,
  }) = _InventoryBalance;

  factory InventoryBalance.fromJson(Map<String, dynamic> json) => _$InventoryBalanceFromJson(json);
}
