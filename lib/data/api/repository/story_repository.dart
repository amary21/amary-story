import 'dart:io';

import 'package:amary_story/data/api/model/story.dart';

abstract class StoryRepository {
  Future<String> register(String name, String password, String email);

  Future<String> login(String email, String password);

  Future<List<Story>> fetchStories(int page, int size);

  Future<String> addStory(
    String description,
    File photo, {
    double? lat,
    double? lon,
  });

  Future<Story> fetchStoryDetail(String id);

  Future<String> getToken();

  Future<String> getName();

  Future<bool> logout();
}
