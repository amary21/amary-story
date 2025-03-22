import 'package:amary_story/data/api/model/story.dart';

sealed class DetailState {}

class DetailNoneState extends DetailState {}

class DetailLoadingState extends DetailState {}

class DetailErrorState extends DetailState {
  final String message;

  DetailErrorState({required this.message});
}

class DetailLoadedState extends DetailState {
  final Story story;

  DetailLoadedState({required this.story});
}