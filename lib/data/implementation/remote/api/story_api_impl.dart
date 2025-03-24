import 'dart:convert';
import 'dart:io';

import 'package:amary_story/data/implementation/remote/api/story_api.dart';
import 'package:amary_story/data/implementation/remote/response/base_response.dart';
import 'package:amary_story/data/implementation/remote/response/login_response.dart';
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
  Future<BaseResponse<LoginResponse>> login(
    String email,
    String password,
  ) async {
    final response = await _client.post(
      Uri.parse("$_baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    if (response.statusCode == 200) {
      return BaseResponse<LoginResponse>.fromJson(
        jsonDecode(response.body),
        (json) => LoginResponse.fromJson(json),
        "loginResult"
      );
    } else {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Future.error(json["message"]);
    }
  }

  @override
  Future<BaseResponse<void>> register(
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
      return BaseResponse<void>.fromJson(jsonDecode(response.body), null, null);
    } else {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Future.error(json["message"]);
    }
  }

  @override
  Future<BaseResponse<void>> addStory(
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
      return BaseResponse<void>.fromJson(jsonDecode(responseBody), null, null);
    } else {
      return Future.error("Failed to add story");
    }
  }

  @override
  Future<BaseResponse<List<StoryResponse>>> fetchStories(String token) async {
    final response = await _client.get(
      Uri.parse("$_baseUrl/stories"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final List<StoryResponse> stories =
          (decoded['listStory'] as List)
              .map((json) => StoryResponse.fromJson(json))
              .toList();
      return BaseResponse<List<StoryResponse>>(
        error: decoded['error'],
        message: decoded['message'],
        data: stories,
      );
    } else {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Future.error(json["message"]);
    }
  }

  @override
  Future<BaseResponse<StoryResponse>> fetchStoryDetail(
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
      return BaseResponse<StoryResponse>.fromJson(
        jsonDecode(response.body),
        (json) => StoryResponse.fromJson(json),
        "story"
      );
    } else {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Future.error(json["message"]);
    }
  }
}
