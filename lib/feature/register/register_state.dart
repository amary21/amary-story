sealed class RegisterState {}

class RegisterNoneState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  final String message;

  RegisterErrorState({required this.message});
}

class RegisterLoadedState extends RegisterState {
  final String message;

  RegisterLoadedState({required this.message});
}
