import 'package:amary_story/data/implementation/preference/story_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoryPreferenceImpl implements StoryPreference {
  final SharedPreferences _preferences;

  StoryPreferenceImpl({required SharedPreferences preferences})
    : _preferences = preferences;

  static const String _keyToken = "KEY_TOKEN";
  static const String _keyName = "KEY_NAME";

  @override
  Future<String> getToken() async {
    try {
      return _preferences.getString(_keyToken) ?? "";
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> setToken(String token) async {
    try {
      await _preferences.setString(_keyToken, token);
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Future<String> getName() async {
    try {
      return _preferences.getString(_keyName) ?? "";
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> setName(String name) async {
    try {
      await _preferences.setString(_keyName, name);
    } catch (e) {
      Future.error(e);
    }
  }

  @override
  Future<bool> removePref() async {
    await _preferences.remove(_keyName);
    return await _preferences.remove(_keyToken);
  }
}
