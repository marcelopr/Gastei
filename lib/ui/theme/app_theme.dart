import 'package:flutter/material.dart';
import 'package:carteira/constants/constants.dart';

class AppTheme {
  AppTheme._();

  static Color _iconColor = Colors.black;

  static const Color _lightPrimaryColor = kBlue;
  static const Color _lightPrimaryVariantColor = kBlueLight;
  static const Color _lightSecondaryColor = kOrange;
  static const Color _lightSecondaryVariantColor = kOrangeLight;
  static const Color _lightOnPrimaryColor = Colors.blueAccent;
  static const Color _lightScaffoldColor = Colors.white;

  static const Color _darkPrimaryColor = kBlue;
  static const Color _darkPrimaryVariantColor = kBlueLight;
  static const Color _darkSecondaryColor = kOrange;
  static const Color _darkSecondaryVariantColor = kOrangeLight;
  static const Color _darkOnPrimaryColor = Colors.white;
  static const Color _darkScaffoldColor = Colors.black54;

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: _darkScaffoldColor,
    fontFamily: 'Muli',
    appBarTheme: AppBarTheme(
      color: _darkPrimaryVariantColor,
      iconTheme: IconThemeData(
        color: _darkOnPrimaryColor,
      ),
    ),
    colorScheme: ColorScheme.light(
        primary: Colors.white24,
        primaryVariant: _darkPrimaryVariantColor,
        secondary: _darkSecondaryColor,
        onPrimary: _darkOnPrimaryColor),
    iconTheme: IconThemeData(
      color: _iconColor,
    ),
    textTheme: _darkTextTheme,
  );

  static final TextTheme _darkTextTheme = TextTheme(
    headline: _darkScreenHeadingTextStyle,
    body1: _darkScreenTaskNameTextStyle,
    body2: _darkScreenTaskDurationTextStyle,
  );

  static final TextStyle _darkScreenHeadingTextStyle =
      _lightScreenHeadingTextStyle.copyWith(color: _darkOnPrimaryColor);
  static final TextStyle _darkScreenTaskNameTextStyle =
      _lightScreenHeadingTextStyle.copyWith(color: _darkOnPrimaryColor);
  static final TextStyle _darkScreenTaskDurationTextStyle =
      _lightScreenHeadingTextStyle.copyWith(color: _darkOnPrimaryColor);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: _lightScaffoldColor,
    fontFamily: 'Muli',
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    colorScheme: ColorScheme.light(
        primary: _lightOnPrimaryColor,
        primaryVariant: _lightPrimaryVariantColor,
        secondary: _lightSecondaryColor,
        onPrimary: _lightOnPrimaryColor),
    iconTheme: IconThemeData(
      color: _iconColor,
    ),
    //textTheme: _lightTextTheme,
  );

  static final TextTheme _lightTextTheme = TextTheme(
    headline: _lightScreenHeadingTextStyle,
    body1: _lightScreenTaskNameTextStyle,
    body2: _lightScreenTaskDurationTextStyle,
  );

  static final TextStyle _lightScreenHeadingTextStyle =
      TextStyle(fontSize: 48, color: Colors.black);
  static final TextStyle _lightScreenTaskNameTextStyle =
      TextStyle(fontSize: 20, color: _lightOnPrimaryColor);
  static final TextStyle _lightScreenTaskDurationTextStyle =
      TextStyle(fontSize: 16, color: Colors.grey);
}
