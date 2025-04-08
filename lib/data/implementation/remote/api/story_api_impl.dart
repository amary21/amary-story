import 'dart:convert';
import 'dart:io';

import 'package:amary_story/data/implementation/remote/api/story_api.dart';
import 'package:amary_story/data/implementation/remote/response/general_response.dart';
import 'package:amary_story/data/implementation/remote/response/login_response.dart';
import 'package:amary_story/data/implementation/remote/response/login_result_response.dart';
import 'package:amary_story/data/implementation/remote/response/stories_response.dart';
import 'package:amary_story/data/implementation/remote/response/stories_result_response.dart';
import 'package:amary_story/data/implementation/remote/response/story_response.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class StoryApiImpl implements StoryApi {
  final String _baseUrl;

  StoryApiImpl({required String baseUrl}) : _baseUrl = baseUrl;

  final http.Client _client = ChuckerHttpClient(http.Client());

  @override
  Future<LoginResultResponse> login(String email, String password) async {
    final response = await _client.post(
      Uri.parse("$_baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    if (response.statusCode == 200) {
      return LoginResultResponse.fromJson(jsonDecode(response.body));
    } else {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Future.error(json["message"]);
    }
  }

  @override
  Future<GeneralResponse> register(
    String name,
    String password,
    String email,
  ) async {
    final response = await _client.post(
      Uri.parse("$_baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode == 201) {
      return GeneralResponse.fromJson(jsonDecode(response.body));
    } else {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Future.error(json["message"]);
    }
  }

  @override
  Future<GeneralResponse> addStory(
    String token,
    String description,
    File photo, {
    double? lat,
    double? lon,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse("$_baseUrl/stories"),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.headers["Content-Type"] = "multipart/form-data";
    request.fields['description'] = description;
    if (lat != null) request.fields['lat'] = lat.toString();
    if (lon != null) request.fields['lon'] = lon.toString();
    final mimeType = lookupMimeType(photo.path);
    final file = await http.MultipartFile.fromPath(
      "photo",
      photo.path,
      contentType: mimeType != null ? MediaType.parse(mimeType) : null,
    );

    request.files.add(file);

    final response = await request.send();

    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      return GeneralResponse.fromJson(jsonDecode(responseBody));
    } else {
      return Future.error("Failed to add story");
    }
  }

  @override
  Future<StoriesResponse> fetchStories(String token, int page, int size) async {
    final response = await _client.get(
      Uri.parse("$_baseUrl/stories?page=$page&size=$size"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return StoriesResponse.fromJson(jsonDecode(response.body));
    } else {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Future.error(json["message"]);
    }
  }

  @override
  Future<StoriesResultResponse> fetchStoryDetail(
    String token,
    String id,
  ) async {
    final response = await _client.get(
      Uri.parse("$_baseUrl/stories/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return StoriesResultResponse.fromJson(jsonDecode(response.body));
    } else {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Future.error(json["message"]);
    }
  }
}
