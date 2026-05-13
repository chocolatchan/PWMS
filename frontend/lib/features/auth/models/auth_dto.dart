import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_dto.freezed.dart';
part 'auth_dto.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LoginResponse({
    required String token,
    String? role,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}
