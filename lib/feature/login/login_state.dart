sealed class LoginState {}

class LoginNoneState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginErrorState extends LoginState {
  final String message;

  LoginErrorState({required this.message});
}

class LoginLoadedState extends LoginState {
  final String message;

  LoginLoadedState({required this.message});
}
