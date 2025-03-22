import 'package:amary_story/data/api/repository/story_repository.dart';
import 'package:amary_story/feature/detail/detail_state.dart';
import 'package:flutter/material.dart';

class DetailProvider extends ChangeNotifier {
  final StoryRepository _repository;

  DetailProvider({required StoryRepository repository})
    : _repository = repository;

  DetailState _state = DetailNoneState();
  DetailState get state => _state;

  Future<void> getDetail(String id) async {
    try {
      _state = DetailLoadingState();
      notifyListeners();

      final result = await _repository.fetchStoryDetail(id);
      _state = DetailLoadedState(story: result);
      notifyListeners();
    } catch (e) {
      _state = DetailErrorState(message: e.toString());
      notifyListeners();
    }
  }
}
