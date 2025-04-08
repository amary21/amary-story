import 'package:amary_story/data/api/repository/story_repository.dart';
import 'package:amary_story/feature/home/home_state.dart';
import 'package:flutter/material.dart';

import '../../data/api/model/story.dart';

class HomeProvider extends ChangeNotifier {
  final StoryRepository _repository;
  bool _isDisposed = false;

  HomeProvider({required StoryRepository repository})
      : _repository = repository;

  HomeState _state = HomeNoneState();
  HomeState get state => _state;

  String _name = "";
  String get name => _name;

  bool _isLogout = false;
  bool get isLogout => _isLogout;

  final int _size = 10;
  int? page = 1;
  List<Story> stories = [];

  Future<void> init() async {
    _name = await _repository.getName();
    _state = HomeLoadingState();
    _isLogout = false;
    fetchStories();
  }

  Future<void> fetchStories() async {
    try {
      if (page == 1) {
        _state = HomeLoadingState();
        notifyListeners();
      }

      final result = await _repository.fetchStories(page!, _size);
      
      stories.addAll(result);
      _state = HomeLoadedState();

      if (result.length < _size) {
        page = null;
      } else {
        page = page! + 1;
      }

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

  void resetPaging() {
    page = 1;
    stories.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }
}