abstract class StoryPreference {
  Future<void> setToken(String token);

  Future<String> getToken();

  Future<void> setName(String name);

  Future<String> getName();

  Future<bool> removePref();
}
