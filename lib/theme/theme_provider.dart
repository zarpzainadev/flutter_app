import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  static void switchTheme(BuildContext context, bool isLight) {
    // Usar Provider directamente
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ThemeMode themeMode = isLight ? ThemeMode.light : ThemeMode.dark;
    themeProvider.setThemeMode(themeMode);
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  ThemeData getTheme() {
    switch (_themeMode) {
      case ThemeMode.light:
        return AppTheme.lightTheme;
      case ThemeMode.dark:
        return AppTheme.darkTheme;
      default:
        return AppTheme.lightTheme;
    }
  }
}
