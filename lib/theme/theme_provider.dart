import 'package:flutter/material.dart';
import '../main.dart';

class AppTheme {
  // En theme_provider.dart, actualiza el ThemeData:
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      background: Colors.white,
      surface: Colors.white,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[900]!,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      background: Colors.grey[900]!,
      surface: Colors.grey[900]!,
    ),
  );

  static void switchTheme(BuildContext context, bool isRed) {
    ThemeMode themeMode = isRed ? ThemeMode.light : ThemeMode.dark;
    MyApp.of(context)?.setThemeMode(themeMode);
  }
}
