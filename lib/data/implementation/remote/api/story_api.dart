import 'dart:io';

import 'package:amary_story/data/implementation/remote/response/general_response.dart';
import 'package:amary_story/data/implementation/remote/response/login_result_response.dart';
import 'package:amary_story/data/implementation/remote/response/stories_response.dart';
import 'package:amary_story/data/implementation/remote/response/stories_result_response.dart';

abstract class StoryApi {
  Future<GeneralResponse> register(
    String name,
    String password,
    String email,
  );

  Future<LoginResultResponse> login(String email, String password);

  Future<StoriesResponse> fetchStories(String token, int page, int size);

  Future<GeneralResponse> addStory(
    String token,
    String description,
    File photo, {
    double? lat,
    double? lon,
  });

  Future<StoriesResultResponse> fetchStoryDetail(String token, String id);
}
