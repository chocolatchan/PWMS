import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// Represents the temperature storage zone for a product.
@JsonEnum()
enum TempZone {
  @JsonValue('Ambient')
  ambient,
  @JsonValue('Cold')
  cold,
  @JsonValue('DeepFreeze')
  deepFreeze;
}

/// Represents a product in the PWMS system.
@freezed
class Product with _$Product {
  /// Ensures perfect JSON key matching with Rust (snake_case).
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory Product({
    required int id,
    required String name,
    required bool isLasa,
    String? lasaGroup,
    required TempZone tempZone,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
