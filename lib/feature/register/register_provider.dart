import 'package:amary_story/data/api/repository/story_repository.dart';
import 'package:amary_story/feature/register/register_state.dart';
import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {
  final StoryRepository _repository;

  RegisterProvider({required StoryRepository repository})
    : _repository = repository;

  RegisterState _state = RegisterNoneState();
  RegisterState get state => _state;

  String _name = "";
  String get name => _name;

  String _email = "";
  String get email => _email;

  String _password = "";
  String get password => _password;

  bool _isEnableButton = false;
  bool get isEnableButton => _isEnableButton;

  set name(String value) {
    _name = value;
    notifyListeners();

    _checkButton();
  }

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
    if (_name.isNotEmpty && _email.isNotEmpty && _password.isNotEmpty) {
      _isEnableButton = true;
    } else {
      _isEnableButton = false;
    }
    notifyListeners();
  }

  Future<void> register() async {
    try {
      _state = RegisterLoadingState();
      notifyListeners();

      final result = await _repository.register(name, password, email);
      _state = RegisterLoadedState(message: result);
      notifyListeners();
    } catch (e) {
      _state = RegisterErrorState(message: e.toString());
      notifyListeners();
    }
  }

  void resetToast() {
    _state = RegisterNoneState();
    notifyListeners();
  }

  void resetText() {
    _name = "";
    _email = "";
    _password = "";
    _isEnableButton = false;
    notifyListeners();
  }
}
