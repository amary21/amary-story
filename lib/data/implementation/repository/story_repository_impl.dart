import 'dart:io';

import 'package:amary_story/data/api/model/story.dart';
import 'package:amary_story/data/api/repository/story_repository.dart';
import 'package:amary_story/data/implementation/helper/image_compress.dart';
import 'package:amary_story/data/implementation/mapper/story_mapper.dart';
import 'package:amary_story/data/implementation/preference/story_preference.dart';
import 'package:amary_story/data/implementation/remote/api/story_api.dart';
import 'package:amary_story/data/implementation/remote/response/base_response.dart';
import 'package:amary_story/data/implementation/remote/response/login_response.dart';
import 'package:amary_story/data/implementation/remote/response/story_response.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryApi _storyApi;
  final StoryPreference _storyPreference;

  StoryRepositoryImpl({
    required StoryApi storyApi,
    required StoryPreference storyPreference,
  }) : _storyApi = storyApi,
       _storyPreference = storyPreference;

  @override
  Future<String> addStory(
    String description,
    File photo, {
    double? lat,
    double? lon,
  }) async {
    try {
      String token = await _storyPreference.getToken();
      final File imageCompressed = await imageCompress(photo);

      BaseResponse<void> response = await _storyApi.addStory(
        token,
        description,
        imageCompressed,
        lat: lat,
        lon: lon,
      );

      return response.message;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<List<Story>> fetchStories(int page, int size) async {
    try {
      String token = await _storyPreference.getToken();
      BaseResponse<List<StoryResponse>> response = await _storyApi.fetchStories(
        token,
        page,
        size,
      );
      if (response.error) {
        return Future.error(response.message);
      } else {
        return response.data?.map((element) => element.toStory()).toList() ??
            [];
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<Story> fetchStoryDetail(String id) async {
    try {
      String token = await _storyPreference.getToken();
      BaseResponse<StoryResponse> response = await _storyApi.fetchStoryDetail(
        token,
        id,
      );
      if (response.error) {
        return Future.error(response.message);
      } else {
        Story story =
            response.data?.toStory() ??
            Story(
              id: "",
              name: "",
              description: "",
              photoUrl: "",
              createdAt: "",
            );
        return story;
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      BaseResponse<LoginResponse> response = await _storyApi.login(
        email,
        password,
      );

      if (response.error) {
        return Future.error(response.message);
      } else {
        await _storyPreference.setToken(response.data?.token ?? "");
        await _storyPreference.setName(response.data?.name ?? "");
        return response.message;
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<String> register(String name, String password, String email) async {
    try {
      BaseResponse<void> response = await _storyApi.register(
        name,
        password,
        email,
      );
      return response.message;
    } on Exception catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<String> getToken() async {
    return await _storyPreference.getToken();
  }

  @override
  Future<String> getName() async {
    return await _storyPreference.getName();
  }

  @override
  Future<bool> logout() async {
    return await _storyPreference.removePref();
  }
}
