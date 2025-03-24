import 'package:amary_story/data/api/repository/story_repository.dart';
import 'package:amary_story/feature/login/login_state.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final StoryRepository _repository;

  LoginProvider({required StoryRepository repository})
    : _repository = repository;

  LoginState _state = LoginNoneState();
  LoginState get state => _state;

  String _email = "";
  String get email => _email;

  String _password = "";
  String get password => _password;

  bool _isEnableButton = false;
  bool get isEnableButton => _isEnableButton;


  set email(String value) {
    _email = value;
    notifyListeners();

    _checkButton();
  }

  set password(String value) {
    _password = value;
    notifyListeners();

    _checkButton();
  }

  void _checkButton() {
    if (_email.isNotEmpty && _password.isNotEmpty) {
      _isEnableButton = true;
    } else {
      _isEnableButton = false;
    }
    notifyListeners();
  }

  Future<void> login() async {
    try {
      _state = LoginLoadingState();
      notifyListeners();

      final result = await _repository.login(email, password);
      _state = LoginLoadedState(message: result);
      notifyListeners();
    } catch (e) {
      _state = LoginErrorState(message: e.toString());
      notifyListeners();
    }
  }

  void resetToast() {
    _state = LoginNoneState();
    notifyListeners();
  }

  void resetText() {
    _email = "";
    _password = "";
    _isEnableButton = false;
    notifyListeners();
  }
}
