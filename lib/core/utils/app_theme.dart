import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: kLightPrimary,
    cardColor: kLightSecondary,
    appBarTheme: AppBarTheme(
      backgroundColor: kLightPrimary,
      titleTextStyle: TextStyle(
        color: kLightTextColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: kLightButtonPrimary),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: kLightTextColor),
      bodyMedium: TextStyle(color: kLightTextColor),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: kDarkPrimary,
    cardColor: kDarkSecondary,
    appBarTheme: AppBarTheme(
      backgroundColor: kDarkPrimary,
      titleTextStyle: TextStyle(
        color: kDarkTextColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: kDarkButtonPrimary),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: kDarkTextColor),
      bodyMedium: TextStyle(color: kDarkTextColor),
    ),
    shadowColor: Colors.white.withOpacity(0.1),
  );
}
