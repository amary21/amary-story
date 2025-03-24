import 'package:amary_story/data/api/repository/story_repository.dart';
import 'package:amary_story/feature/add/add_screen.dart';
import 'package:amary_story/feature/detail/detail_screen.dart';
import 'package:amary_story/feature/home/home_screen.dart';
import 'package:amary_story/feature/login/login_screen.dart';
import 'package:amary_story/feature/register/register_screen.dart';
import 'package:amary_story/route/nav_route.dart';
import 'package:flutter/material.dart';

class NavRouteDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final StoryRepository _repository;

  NavRouteDelegate({required StoryRepository repository})
    : _repository = repository,
      _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  NavRoute _selectedRoute = NavRoute.mainRoute;
  bool _isReadyToken = false;
  String? detailId;

  Future<void> _init() async {
    String token = await _repository.getToken();
    _isReadyToken = token.isNotEmpty;
    _selectedRoute = _isReadyToken ? NavRoute.homeRoute : NavRoute.mainRoute;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    List<Page> pages = [];

    switch (_selectedRoute) {
      case NavRoute.registerRoute:
        pages.add(
          MaterialPage(
            key: ValueKey(NavRoute.registerRoute.name),
            child: RegisterScreen(
              onLogin: () {
                _selectedRoute = NavRoute.mainRoute;
                notifyListeners();
              },
            ),
          ),
        );
        break;

      case NavRoute.homeRoute:
        pages.add(
          MaterialPage(
            key: ValueKey(NavRoute.homeRoute.name),
            child: HomeScreen(
              onDetail: (id) {
                detailId = id;
                _selectedRoute = NavRoute.detailRoute;
                notifyListeners();
              },
              onAddStory: () {
                _selectedRoute = NavRoute.addRoute;
                notifyListeners();
              },
              onLogout: () {
                _selectedRoute = NavRoute.mainRoute;
                notifyListeners();
              },
            ),
          ),
        );
        break;

      case NavRoute.detailRoute:
        if (detailId != null) {
          pages.add(
            MaterialPage(
              key: ValueKey('${NavRoute.detailRoute.name}-$detailId'),
              child: DetailScreen(
                id: detailId!,
                onBack: () {
                  detailId = null;
                  _selectedRoute = NavRoute.homeRoute;
                  notifyListeners();
                },
              ),
            ),
          );
        }
        break;

      case NavRoute.addRoute:
        pages.add(
          MaterialPage(
            key: ValueKey(NavRoute.addRoute.name),
            child: AddScreen(
              onHome: () {
                _selectedRoute = NavRoute.homeRoute;
                notifyListeners();
              },
              onBack: () {
                _selectedRoute = NavRoute.homeRoute;
                notifyListeners();
              },
            ),
          ),
        );
        break;

      case NavRoute.mainRoute:
        pages.add(
          MaterialPage(
            key: ValueKey(NavRoute.mainRoute.name),
            child: LoginScreen(
              onHome: () {
                _selectedRoute = NavRoute.homeRoute;
                notifyListeners();
              },
              onRegister: () {
                _selectedRoute = NavRoute.registerRoute;
                notifyListeners();
              },
            ),
          ),
        );
        break;
    }

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onDidRemovePage: (page) {
        if (page.key is ValueKey) {
          String key = (page.key as ValueKey).value.toString();
          if (key.startsWith('${NavRoute.detailRoute.name}-')) {
            detailId = null;
          }
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* Do Nothing */
  }
}
