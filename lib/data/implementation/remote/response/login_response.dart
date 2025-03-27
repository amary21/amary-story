import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: "userId")
  final String userId;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "token")
  final String token;

  LoginResponse({
    required this.userId, 
    required this.name, 
    required this.token
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}