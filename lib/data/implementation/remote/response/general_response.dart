import 'package:json_annotation/json_annotation.dart';

part 'general_response.g.dart';

@JsonSerializable()
class GeneralResponse {
  @JsonKey(name: "error")
  final bool error;
  @JsonKey(name: "message")
  final String message;

  GeneralResponse({required this.error, required this.message});

  factory GeneralResponse.fromJson(json) => _$GeneralResponseFromJson(json);
}
