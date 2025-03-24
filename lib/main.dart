import 'package:amary_story/data/api/repository/story_repository.dart';
import 'package:amary_story/data/di/story_module.dart';
import 'package:amary_story/feature/add/add_provider.dart';
import 'package:amary_story/feature/detail/detail_provider.dart';
import 'package:amary_story/feature/home/home_provider.dart';
import 'package:amary_story/feature/login/login_provider.dart';
import 'package:amary_story/feature/register/register_provider.dart';
import 'package:amary_story/route/nav_route_delegate.dart';
import 'package:amary_story/style/theme/story_theme.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  ChuckerFlutter.showOnRelease = true;
  runApp(
    MultiProvider(
      providers: [
        ...storyModule(
          baseUrl: "https://story-api.dicoding.dev/v1",
          preferences: preferences,
        ),
        ChangeNotifierProxyProvider<StoryRepository, RegisterProvider>(
          create:
              (context) =>
                  RegisterProvider(repository: context.read<StoryRepository>()),
          update:
              (_, storyRepository, previous) =>
                  RegisterProvider(repository: storyRepository),
        ),
        ChangeNotifierProxyProvider<StoryRepository, LoginProvider>(
          create:
              (context) =>
                  LoginProvider(repository: context.read<StoryRepository>()),
          update:
              (_, storyRepository, previous) =>
                  LoginProvider(repository: storyRepository),
        ),
        ChangeNotifierProxyProvider<StoryRepository, HomeProvider>(
          create:
              (context) =>
                  HomeProvider(repository: context.read<StoryRepository>()),
          update:
              (_, storyRepository, previous) =>
                  HomeProvider(repository: storyRepository),
        ),
        ChangeNotifierProxyProvider<StoryRepository, DetailProvider>(
          create:
              (context) =>
                  DetailProvider(repository: context.read<StoryRepository>()),
          update:
              (_, storyRepository, previous) =>
                  DetailProvider(repository: storyRepository),
        ),
        ChangeNotifierProxyProvider<StoryRepository, AddProvider>(
          create:
              (context) =>
                  AddProvider(repository: context.read<StoryRepository>()),
          update:
              (_, storyRepository, previous) =>
                  AddProvider(repository: storyRepository),
        ),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late NavRouteDelegate navRouteDelegate;

  @override
  void initState() {
    final repository = context.read<StoryRepository>();
    navRouteDelegate = NavRouteDelegate(repository: repository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amary Cafe',
      theme: StoryTheme.lightTheme,
      darkTheme: StoryTheme.darkTheme,
      themeMode: ThemeMode.system,
      navigatorObservers: [ChuckerFlutter.navigatorObserver],
      home: Router(
        routerDelegate: navRouteDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
