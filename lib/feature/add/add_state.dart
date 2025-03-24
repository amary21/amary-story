sealed class AddState {}

class AddNoneState extends AddState {}

class AddLoadingState extends AddState {}

class AddErrorState extends AddState {
  final String message;

  AddErrorState({required this.message});
}

class AddLoadedState extends AddState {
  final String message;

  AddLoadedState({required this.message});
}