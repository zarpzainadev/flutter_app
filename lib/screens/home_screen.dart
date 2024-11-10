import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/modal_meeting.dart';
import '../components/sidebar.dart';
import '../theme/theme_provider.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isRedTheme = true;
  bool showMeetingModal = true;
  Widget _currentScreen = Center(child: Text('Bienvenido al Home Screen!'));
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _sessionTimer; // Agregado: Timer para la sesión

  @override
  void initState() {
    super.initState();
    // Agregado: Iniciar el timer cuando se carga el HomeScreen
    _sessionTimer = Timer(Duration(minutes: 2), () {
      _showTimeoutDialog();
    });
  }

  // Agregado: Método para mostrar el diálogo de timeout
  void _showTimeoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final isWeb = kIsWeb;

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: isWeb ? 400 : 320,
            padding: EdgeInsets.all(isWeb ? 32.0 : 24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sesión por expirar',
                  style: TextStyle(
                    fontSize: isWeb ? 24.0 : 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: isWeb ? 16.0 : 12.0),
                Text(
                  'Su sesión está por expirar. ¿Desea continuar con la sesión activa?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isWeb ? 16.0 : 14.0,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: isWeb ? 24.0 : 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Reinicia el timer cuando el usuario continúa la sesión
                      _sessionTimer?.cancel();
                      _sessionTimer = Timer(Duration(minutes: 2), () {
                        _showTimeoutDialog();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: isWeb ? 12.0 : 10.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Continuar sesión',
                      style: TextStyle(
                        fontSize: isWeb ? 16.0 : 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Agregado: Limpiar el timer cuando se destruye el widget
  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }

  void _changeScreen(Widget screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  void _hideMeetingModal() {
    setState(() {
      showMeetingModal = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: kIsWeb
          ? null
          : AppBar(
              title: Text('Home'),
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Tema Rojo', style: TextStyle(fontSize: 14)),
                      Switch(
                        value: isRedTheme,
                        onChanged: (bool value) {
                          setState(() {
                            isRedTheme = value;
                            AppTheme.switchTheme(context, isRedTheme);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
      drawer: kIsWeb ? null : Sidebar(onSelectScreen: _changeScreen),
      body: Stack(
        children: [
          Row(
            children: [
              if (kIsWeb)
                Sidebar(
                  onSelectScreen: _changeScreen,
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: _currentScreen,
                  ),
                ),
              ),
            ],
          ),
          if (showMeetingModal)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: _hideMeetingModal,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Center(
                      child: IgnorePointer(
                        ignoring: false,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: _getModalWidth(context),
                          child: MeetingReminderCard(
                            date: 'June 15, 2023',
                            place: 'Conference Room A',
                            agenda: [
                              'Project status update',
                              'Budget review',
                              'Team assignments',
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _getModalWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (kIsWeb) {
      double modalWidth = screenWidth * 0.3;
      return modalWidth.clamp(300.0, 500.0);
    } else {
      return screenWidth * 0.9;
    }
  }
}
