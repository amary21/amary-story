import 'package:amary_story/data/api/repository/story_repository.dart';
import 'package:amary_story/feature/home/home_state.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  final StoryRepository _repository;

  HomeProvider({required StoryRepository repository})
    : _repository = repository;

  HomeState _state = HomeNoneState();
  HomeState get state => _state;

  String _name = "";
  String get name => _name;

  bool _isLogout = false;
  bool get isLogout => _isLogout;

  Future<void> init() async {
    try {
      _name = await _repository.getName();
      _state = HomeLoadingState();
      _isLogout = false;

      final result = await _repository.fetchStories();
      _state = HomeLoadedState(stories: result);
      notifyListeners();
    } catch (e) {
      _state = HomeErrorState(message: e.toString());
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isLogout = await _repository.logout();
      notifyListeners();
    } catch (_) {
      _isLogout = false;
      notifyListeners();
    }
  }
}
