import 'dart:io';

import 'package:amary_story/data/implementation/remote/response/base_response.dart';
import 'package:amary_story/data/implementation/remote/response/login_response.dart';
import 'package:amary_story/data/implementation/remote/response/story_response.dart';

abstract class StoryApi {
  Future<BaseResponse<void>> register(
    String name,
    String password,
    String email,
  );

  Future<BaseResponse<LoginResponse>> login(String email, String password);

  Future<BaseResponse<List<StoryResponse>>> fetchStories(String token, int page, int size);

  Future<BaseResponse<void>> addStory(
    String token,
    String description,
    File photo, {
    double? lat,
    double? lon,
  });

  Future<BaseResponse<StoryResponse>> fetchStoryDetail(String token, String id);
}
