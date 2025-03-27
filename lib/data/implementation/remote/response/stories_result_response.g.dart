// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_result_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoriesResultResponse _$StoriesResultResponseFromJson(
  Map<String, dynamic> json,
) => StoriesResultResponse(
  error: json['error'] as bool,
  message: json['message'] as String,
  data: StoryResponse.fromJson(json['story'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StoriesResultResponseToJson(
  StoriesResultResponse instance,
) => <String, dynamic>{
  'error': instance.error,
  'message': instance.message,
  'story': instance.data,
};
