import 'package:amary_story/data/api/repository/story_repository.dart';
import 'package:flutter/material.dart';

class NavProvider extends ChangeNotifier {
  final StoryRepository _repository;

  NavProvider({required StoryRepository repository}) : _repository = repository;

  bool _isReadyToken = false;
  bool get isReadyToken => _isReadyToken;

  Future<void> init() async {
    String token = await _repository.getToken();
    _isReadyToken = token.isNotEmpty;
    notifyListeners();
  }
}
