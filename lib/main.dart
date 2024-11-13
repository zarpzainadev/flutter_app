import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_android/screens/home_screen.dart';
import 'package:flutter_web_android/screens/login_screen/login_screen.dart';
import 'package:flutter_web_android/storage/storage_services.dart';
import 'package:flutter_web_android/theme/theme_provider.dart';
import 'package:jwt_decode/jwt_decode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await dotenv.load();

  // Verificar si hay una sesión activa antes de iniciar la app
  final hasSession = await checkSession();

  runApp(MyApp(initialScreen: hasSession ? HomeScreen() : LoginScreen()));
}

class MyApp extends StatefulWidget {
  final Widget initialScreen;

  MyApp({required this.initialScreen});

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void setThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web to Android',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: widget.initialScreen, // Aquí se carga la pantalla inicial
    );
  }
}

// Verificar si hay una sesión activa y si el token es válido
Future<bool> checkSession() async {
  final savedToken = await StorageService.getToken();
  if (savedToken != null) {
    // Verificar si el token ha expirado
    if (isTokenExpired(savedToken.accessToken)) {
      // Si el token ha expirado, eliminarlo y redirigir al login
      await StorageService.deleteToken();
      return false;
    }
    return true; // Token válido
  }
  return false; // No hay token
}

// Función para verificar si el token ha expirado
bool isTokenExpired(String token) {
  final Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
  final int expiration = decodedToken['exp'];
  final int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  if (currentTime > expiration) {
    return true; // Token ha expirado
  }
  return false; // Token válido
}
