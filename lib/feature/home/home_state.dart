sealed class HomeState {}

class HomeNoneState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState({required this.message});
}

class HomeLoadedState extends HomeState {}