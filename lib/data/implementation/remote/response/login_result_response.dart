import 'package:amary_story/data/implementation/remote/response/login_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_result_response.g.dart';

@JsonSerializable()
class LoginResultResponse {
  @JsonKey(name: "error")
  final bool error;
  @JsonKey(name: "message")
  final String message;
  @JsonKey(name: "loginResult")
  final LoginResponse data;

  LoginResultResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory LoginResultResponse.fromJson(json) => _$LoginResultResponseFromJson(json);
}
