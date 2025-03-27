import 'package:amary_story/data/implementation/remote/response/story_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stories_result_response.g.dart';

@JsonSerializable()
class StoriesResultResponse {
  @JsonKey(name: "error")
  final bool error;
  @JsonKey(name: "message")
  final String message;
  @JsonKey(name: "story")
  final StoryResponse data;

  StoriesResultResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory StoriesResultResponse.fromJson(json) => _$StoriesResultResponseFromJson(json);
}