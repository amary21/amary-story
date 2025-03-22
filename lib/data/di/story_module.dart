import 'package:amary_story/data/api/repository/story_repository.dart';
import 'package:amary_story/data/implementation/preference/story_preference.dart';
import 'package:amary_story/data/implementation/preference/story_preference_impl.dart';
import 'package:amary_story/data/implementation/remote/api/story_api.dart';
import 'package:amary_story/data/implementation/remote/api/story_api_impl.dart';
import 'package:amary_story/data/implementation/repository/story_repository_impl.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<SingleChildWidget> storyModule({
  required String baseUrl,
  required SharedPreferences preferences,
}) => [
  Provider<StoryApi>(create: (_) => StoryApiImpl(baseUrl: baseUrl)),
  Provider<StoryPreference>(
    create: (_) => StoryPreferenceImpl(preferences: preferences),
  ),
  ProxyProvider2<StoryApi, StoryPreference, StoryRepository>(
    update:
        (_, storyApi, storyPreference, _) => StoryRepositoryImpl(
          storyApi: storyApi,
          storyPreference: storyPreference,
        ),
  ),
];
