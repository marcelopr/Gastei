import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _lightPrimaryColor = Color(0xFF0fb9c5);
  static const Color _lightPrimaryVariantColor = Color(0xFF4fcfd8);
  static const Color _lightSecondaryColor = Color(0xFFf9811e);
  static const Color _lightOnPrimaryColor = Color(0xFF4fcfd8);
  static const Color _lightScaffoldColor = Colors.white;
  static const Color _lightTitle1TextColor = Colors.black;
  static const Color _lightSubHeadTextColor = Colors.black;
  static const Color _lightBody1TextColor = Colors.black;
  static const Color _lightBody2TextColor = Colors.black54;
  static const Color _lightSubTitleTextColor = Colors.black;
  static const Color _lightCaptionTextColor = Colors.black54;
  static const Color _lightCustomButtonTextColor = Color(0xFFeeeeee);
  static const Color _lightIconColor = Colors.black;
  static const Color _lightAccentIconColor = Colors.black54;
  static const Color _lightHintColor = Colors.black54;
  static const Color lightToastBackground = Color(0xFF636363);
  static const Color lightToastTextColor = Colors.white;

  static const Color _darkPrimaryColor = Color(0xFF0fb9c5);
  static const Color _darkPrimaryVariantColor = Color(0xFF4fcfd8);
  static const Color _darkSecondaryColor = Color(0xFFf9811e);
  static const Color _darkOnPrimaryColor = Color(0xFF4fcfd8);
  static const Color _darkScaffoldColor = Color(0xFF1E1E1E);
  static const Color _darkTitle1TextColor = Colors.white;
  static const Color _darkSubHeadTextColor = Colors.white;
  static const Color _darkBody1TextColor = Colors.white;
  static const Color _darkBody2TextColor = Colors.white54;
  static const Color _darkSubTitleTextColor = Colors.white;
  static const Color _darkCaptionTextColor = Colors.white54;
  static const Color _darkCustomButtonTextColor = Color(0xFF2f2f2f);
  static const Color _darkIconColor = Colors.white;
  static const Color _darkAccentIconColor = Colors.white54;
  static const Color _darkHintColor = Colors.white54;
  static const Color darkToastBackground = Color(0xFF636363);
  static const Color darkToastTextColor = Colors.white;

  //geral
  static const double borderRadius = 12.0;
  static const double categoryIconBorderRadius = 18.0;

  static final ThemeData lightTheme = ThemeData(
    backgroundColor: _lightScaffoldColor,
    scaffoldBackgroundColor: _lightScaffoldColor,
    fontFamily: 'Muli',
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(
        color: _lightIconColor,
      ),
    ),
    colorScheme: ColorScheme.light(
        primary: _lightPrimaryColor,
        primaryVariant: _lightPrimaryVariantColor,
        secondary: _lightSecondaryColor,
        onPrimary: _lightOnPrimaryColor),
    iconTheme: IconThemeData(color: _lightIconColor),
    accentIconTheme: IconThemeData(color: _lightAccentIconColor),
    textTheme: _lightTextTheme,
    buttonColor: _lightCustomButtonTextColor,
    dividerColor: Colors.black54,
    hintColor: _lightHintColor,
  );

  static final TextTheme _lightTextTheme = TextTheme(
    title: lightTitleTextStyle,
    subhead: lightSubHeadTextStyle,
    body1: lightBody1TextStyle,
    body2: lightBody2TextStyle,
    subtitle: lightSubTitleTextStyle,
    caption: lightCaptionTextStyle,
  );

  static final TextStyle lightTitleTextStyle = TextStyle(
    fontSize: 26.0,
    color: _lightTitle1TextColor,
  );

  static final TextStyle lightSubHeadTextStyle = TextStyle(
    fontSize: 20.0,
    color: _lightSubHeadTextColor,
  );

  static final TextStyle lightBody1TextStyle = TextStyle(
    fontSize: 17.0,
    color: _lightBody1TextColor,
  );

  static final TextStyle lightBody2TextStyle = TextStyle(
    fontSize: 16.0,
    color: _lightBody2TextColor,
  );

  static final TextStyle lightSubTitleTextStyle = TextStyle(
    fontSize: 13.0,
    color: _lightSubTitleTextColor,
  );

  static final TextStyle lightCaptionTextStyle = TextStyle(
    fontSize: 12.0,
    color: _lightCaptionTextColor,
  );

  ///DARK THEME

  static final ThemeData darkTheme = ThemeData(
      backgroundColor: _darkScaffoldColor,
      scaffoldBackgroundColor: _darkScaffoldColor,
      fontFamily: 'Muli',
      appBarTheme: AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: _darkIconColor,
        ),
      ),
      colorScheme: ColorScheme.dark(
          primary: _darkPrimaryColor,
          primaryVariant: _darkPrimaryVariantColor,
          secondary: _darkSecondaryColor,
          onPrimary: _darkOnPrimaryColor),
      iconTheme: IconThemeData(color: _darkIconColor),
      accentIconTheme: IconThemeData(color: _darkAccentIconColor),
      textTheme: _darkTextTheme,
      buttonColor: _darkCustomButtonTextColor,
      hintColor: _darkHintColor,
      dividerColor: Colors.white54);

  static final TextTheme _darkTextTheme = TextTheme(
    title: darkTitleTextStyle,
    subhead: darkSubHeadTextStyle,
    body1: darkBody1TextStyle,
    body2: darkBody2TextStyle,
    subtitle: darkSubTitleTextStyle,
    caption: darkCaptionTextStyle,
  );

  static final TextStyle darkTitleTextStyle =
      lightTitleTextStyle.copyWith(color: _darkTitle1TextColor);

  static final TextStyle darkSubHeadTextStyle =
      lightSubHeadTextStyle.copyWith(color: _darkSubHeadTextColor);

  static final TextStyle darkBody1TextStyle =
      lightBody1TextStyle.copyWith(color: _darkBody1TextColor);

  static final TextStyle darkBody2TextStyle =
      lightBody2TextStyle.copyWith(color: _darkBody2TextColor);

  static final TextStyle darkSubTitleTextStyle =
      lightSubTitleTextStyle.copyWith(color: _darkSubTitleTextColor);

  static final TextStyle darkCaptionTextStyle =
      lightCaptionTextStyle.copyWith(color: _darkCaptionTextColor);
}
