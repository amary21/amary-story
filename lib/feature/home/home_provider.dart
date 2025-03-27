import 'package:amary_story/data/api/model/story.dart';
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

  List<Story> _stories = [];
  int _page = 1;
  final int _size = 10;
  bool _isFetchingMore = false;

  Future<void> init() async {
    _name = await _repository.getName();
    _isLogout = false;
    fetchStories();
  }

  Future<void> fetchStories({bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        if (_isFetchingMore) return;
        _isFetchingMore = true;
        _state = HomeLoadingMoreState();
      } else {
        _state = HomeLoadingState();
      }
      notifyListeners();

      final newStories = await _repository.fetchStories(_page, _size);

      if (isLoadMore) {
        _stories = List.from(_stories)..addAll(newStories);
      } else {
        _stories = newStories;
      }

      _state = HomeLoadedState(
        stories: List.from(_stories),
        hasMore: newStories.length == _size,
      );
      if (newStories.length == _size) _page++;

      _isFetchingMore = false;
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
