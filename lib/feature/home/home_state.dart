import 'package:amary_story/data/api/model/story.dart';

sealed class HomeState {}

class HomeNoneState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState({required this.message});
}

class HomeLoadedState extends HomeState {
  final List<Story> stories;

  HomeLoadedState({required this.stories});
}