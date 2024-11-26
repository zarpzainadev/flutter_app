import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_android/screens/home_screen_view_model.dart';
import 'package:flutter_web_android/screens/login_screen/connectivity_handler.dart';
import 'package:flutter_web_android/screens/login_screen/login_screen.dart';
import 'package:flutter_web_android/storage/storage_services.dart';
import 'package:flutter_web_android/theme/theme_provider.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';

// Logger para mejor seguimiento de errores
final _logger = Logger('MainApp');

// Constantes de la aplicación
class AppConstants {
  static const String appTitle = 'Flutter Web to Android';
  static const int sessionTimeout = 15; // minutos
  static const int warningTimeout = 2;
}

// main.dart optimizado
void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load(fileName: ".env");
    await StorageService.init();

    Widget initialScreen;
    try {
      final hasSession = await checkSession();
      initialScreen = hasSession ? const HomeScreen() : const LoginScreen();
    } catch (e) {
      initialScreen = const LoginScreen();
    }

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: MyApp(
          initialScreen: ConnectivityHandler(
            child: initialScreen,
          ),
          navigatorKey: GlobalKey<NavigatorState>(),
        ),
      ),
    );
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error crítico: $e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({
    Key? key,
    required this.initialScreen,
    required this.navigatorKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: context.watch<ThemeProvider>().getTheme(),
      home: initialScreen,
    );
  }
}

// Helper para verificar sesión
Future<bool> checkSession() async {
  try {
    final token = await StorageService.getToken();
    return token != null;
  } catch (e) {
    _logger.warning('Error al verificar token: $e');
    return false;
  }
}
