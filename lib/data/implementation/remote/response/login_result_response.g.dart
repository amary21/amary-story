// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_result_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResultResponse _$LoginResultResponseFromJson(Map<String, dynamic> json) =>
    LoginResultResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: LoginResponse.fromJson(json['loginResult'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResultResponseToJson(
  LoginResultResponse instance,
) => <String, dynamic>{
  'error': instance.error,
  'message': instance.message,
  'loginResult': instance.data,
};
