import 'package:flutter/material.dart';
import '../main.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.red,
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
  );

  static void switchTheme(BuildContext context, bool isRed) {
    ThemeMode themeMode = isRed ? ThemeMode.light : ThemeMode.dark;
    MyApp.of(context)?.setThemeMode(themeMode);
  }
}
