import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_android/screens/home_screen.dart';
import 'package:flutter_web_android/screens/login_screen/login_screen.dart';
import 'package:flutter_web_android/storage/storage_services.dart';
import 'package:flutter_web_android/theme/theme_provider.dart';
import 'package:jwt_decode/jwt_decode.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Inicializar servicios en paralelo
    await Future.wait([
      StorageService.init(),
      dotenv.load(),
    ]);

    // Verificar sesión con mejor manejo de errores
    Widget initialScreen;
    try {
      final hasSession = await checkSession();
      initialScreen = hasSession ? const HomeScreen() : LoginScreen();
    } catch (e) {
      print('Error en verificación de sesión: $e');
      initialScreen = LoginScreen();
    }

    runApp(MyApp(initialScreen: initialScreen));
  } catch (e) {
    print('Error en inicialización: $e');
    runApp(MyApp(initialScreen: LoginScreen()));
  }
}

class MyApp extends StatefulWidget {
  final Widget initialScreen;

  const MyApp({Key? key, required this.initialScreen}) : super(key: key);

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
      home: widget.initialScreen,
    );
  }
}

Future<bool> checkSession() async {
  try {
    final savedToken = await StorageService.getToken();
    if (savedToken != null) {
      if (isTokenExpired(savedToken.accessToken)) {
        print('Token expirado, limpiando...');
        await StorageService.clearAll();
        return false;
      }
      return true;
    }
    print('No hay token guardado');
    return false;
  } catch (e) {
    print('Error checking session: $e');
    await StorageService.clearAll();
    return false;
  }
}

bool isTokenExpired(String token) {
  try {
    final Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
    final int expiration = decodedToken['exp'];
    final int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    print(
        'Token expira en: ${DateTime.fromMillisecondsSinceEpoch(expiration * 1000)}');
    return currentTime >= expiration;
  } catch (e) {
    print('Error al verificar expiración: $e');
    return true;
  }
}
