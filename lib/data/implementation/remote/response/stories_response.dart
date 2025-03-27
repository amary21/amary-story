import 'package:amary_story/data/implementation/remote/response/story_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stories_response.g.dart';

@JsonSerializable()
class StoriesResponse {
  @JsonKey(name: "error")
  final bool error;
  @JsonKey(name: "message")
  final String message;
  @JsonKey(name: "listStory")
  final List<StoryResponse> data;

  StoriesResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory StoriesResponse.fromJson(json) => _$StoriesResponseFromJson(json);
}