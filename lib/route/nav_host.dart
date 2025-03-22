import 'package:amary_story/feature/detail/detail_screen.dart';
import 'package:amary_story/feature/home/home_screen.dart';
import 'package:amary_story/feature/login/login_screen.dart';
import 'package:amary_story/feature/register/register_screen.dart';
import 'package:amary_story/route/nav_route.dart';
import 'package:flutter/material.dart';

class NavHost {
  static String initialHost(bool isReadyToken) {
    if (isReadyToken) {
      return NavRoute.homeRoute.name;
    } else {
      return NavRoute.mainRoute.name;
    }
  }

  static Map<String, WidgetBuilder> get host {
    return {
      NavRoute.mainRoute.name: (_) => LoginScreen(),
      NavRoute.registerRoute.name: (_) => RegisterScreen(),
      NavRoute.homeRoute.name: (_) => HomeScreen(),
      NavRoute.detailRoute.name: (context) => DetailScreen(
            id: ModalRoute.of(context)?.settings.arguments as String,
          ),
    };
  }
}
