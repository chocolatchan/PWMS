class ProductDto {
  final String id;
  final String code;
  final String name;
  final bool isToxic;
  final bool isLasa;

  ProductDto({
    required this.id,
    required this.code,
    required this.name,
    required this.isToxic,
    required this.isLasa,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      isToxic: json['is_toxic'] as bool? ?? false,
      isLasa: json['is_lasa'] as bool? ?? false,
    );
  }
}

class LocationDto {
  final String id;
  final String code;
  final String lockState;

  LocationDto({
    required this.id,
    required this.code,
    required this.lockState,
  });

  factory LocationDto.fromJson(Map<String, dynamic> json) {
    return LocationDto(
      id: json['id'] as String,
      code: json['code'] as String,
      lockState: json['lock_state'] as String? ?? 'unlocked',
    );
  }
}
