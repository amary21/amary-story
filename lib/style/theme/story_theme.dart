import 'package:amary_story/style/colors/story_colors.dart';
import 'package:amary_story/style/typography/story_text_style.dart';
import 'package:flutter/material.dart';

class StoryTheme {

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: StoryTextStyle.displayLarge,
      displayMedium: StoryTextStyle.displayMedium,
      displaySmall: StoryTextStyle.displaySmall,
      headlineLarge: StoryTextStyle.headlineLarge,
      headlineMedium: StoryTextStyle.headlineMedium,
      headlineSmall: StoryTextStyle.headlineSmall,
      titleLarge: StoryTextStyle.titleLarge,
      titleMedium: StoryTextStyle.titleMedium,
      titleSmall: StoryTextStyle.titleSmall,
      bodyLarge: StoryTextStyle.bodyLargeBold,
      bodyMedium: StoryTextStyle.bodyLargeMedium,
      bodySmall: StoryTextStyle.bodyLargeRegular,
      labelLarge: StoryTextStyle.labelLarge,
      labelMedium: StoryTextStyle.labelMedium,
      labelSmall: StoryTextStyle.labelSmall,
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
        toolbarTextStyle: _textTheme.titleLarge,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(14),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: StoryColors.blue.color,
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: StoryColors.blue.color,
      brightness: Brightness.dark,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }
}