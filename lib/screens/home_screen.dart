import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/logout_alert_button.dart';
import 'package:flutter_web_android/components/modal_meeting.dart';
import 'package:flutter_web_android/components/modal_sesion_timeout.dart';
import 'package:flutter_web_android/components/session_timeout_wrapper.dart';
import 'package:flutter_web_android/models/modulo_user_meetings.dart';
import 'package:flutter_web_android/screens/Users/user_details/user_detail_screen.dart';
import 'package:flutter_web_android/screens/calendar/calendar_screen.dart';
import 'package:flutter_web_android/screens/home_screen_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_android/components/sidebar.dart';
import '../theme/theme_provider.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState(); // Cambiar a público
}

class HomeScreenState extends State<HomeScreen> {
  bool isRedTheme = true;
  bool showMeetingModal = true;
  Widget _currentScreen = CalendarScreen(
    meetings: const [], // Lista vacía inicial
    onMeetingTap: (MeetingModel meeting) {
      // Aquí puedes manejar el tap
      print('Reunión seleccionada: ${meeting.lugar}');
    },
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _sessionTimer; // Agregado: Timer para la sesión
  late HomeScreenViewModel _viewModel;
  List<String> userAllowedGroups = [];

  @override
  void initState() {
    super.initState();
    // Agregado: Iniciar el timer cuando se carga el HomeScreen
    _sessionTimer = Timer(Duration(minutes: 13), () {
      _showTimeoutDialog();
    });
    _viewModel = HomeScreenViewModel();
    _loadUserAllowedGroups();
    _viewModel.fetchNextMeeting();
  }

  // Agregar este método para cambiar pantallas
  void changeScreen(Widget newScreen) {
    setState(() {
      _currentScreen = newScreen;
    });
  }

  // Método específico para navegar al detalle de usuario
  void navigateToUserDetail(int userId) {
    changeScreen(UserDetailScreen(userId: userId));
  }

  void _loadUserAllowedGroups() async {
    try {
      final groups = await _viewModel.fetchUserAllowedGroups();
      print(groups);
      setState(() {
        userAllowedGroups = groups;
      });
    } catch (e) {
      // Maneja el error si es necesario
      print('Error al obtener los grupos: $e');
    }
  }

  void _logout(BuildContext context) async {
    try {
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => const LogoutConfirmationDialog(),
      );

      if (shouldLogout == true) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Primero hacer logout en API
        await _viewModel.logout(context);
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showTimeoutDialog() {
    showSessionTimeoutDialog(
      context,
    );
  }

  // Agregado: Limpiar el timer cuando se destruye el widget
  @override
  void dispose() {
    _sessionTimer?.cancel();
    _viewModel.dispose();
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
    return SessionTimeoutWrapper(
      onSessionTimeout: () {
        _viewModel.logout(context);
      },
      child: ChangeNotifierProvider.value(
        value: _viewModel,
        child: Theme(
          // Añadir un Theme explícito
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.white,
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  background: Colors.white,
                  surface: Colors.white,
                ),
          ),
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white, // Color explícito
            appBar: kIsWeb
                ? null
                : AppBar(
                    title: Text(''),
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
                            Text('Tema oscuro', style: TextStyle(fontSize: 14)),
                            Switch(
                              value: isRedTheme,
                              onChanged: (bool value) {
                                setState(() {
                                  isRedTheme = value;
                                  AppTheme.switchTheme(context, isRedTheme);
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.logout),
                              tooltip: 'Cerrar Sesión',
                              onPressed: () => _logout(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            drawer: kIsWeb
                ? null
                : Sidebar(
                    onSelectScreen: _changeScreen,
                    allowedGroups: userAllowedGroups,
                    onLogout: _logout,
                  ),
            body: Container(
              color: Colors.white,
              child: Stack(
                children: [
                  Row(
                    children: [
                      if (kIsWeb)
                        Sidebar(
                          onSelectScreen: _changeScreen,
                          allowedGroups: userAllowedGroups,
                          onLogout: _logout,
                        ),
                      Expanded(
                        child: Container(
                          color: Colors.white, // Añadir color explícito
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: _currentScreen,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // En HomeScreen, modificar la parte del modal:
                  // En HomeScreen.dart, reemplazar la parte del modal:

                  if (showMeetingModal)
                    Positioned.fill(
                      child: Material(
                        color: Colors.black.withOpacity(0.5),
                        child: Stack(
                          children: [
                            // Overlay para cerrar al hacer clic fuera
                            Positioned.fill(
                              child: GestureDetector(
                                onTap: _hideMeetingModal,
                                child: Container(color: Colors.transparent),
                              ),
                            ),
                            // Modal centrado
                            Center(
                              child: Consumer<HomeScreenViewModel>(
                                builder: (context, viewModel, child) {
                                  if (viewModel.isLoading) {
                                    return const MeetingReminderCard(
                                      date: 'Cargando...',
                                      place: 'Cargando...',
                                      agenda: ['Cargando agenda...'],
                                    );
                                  }

                                  if (viewModel.hasNoMeetings) {
                                    return const MeetingReminderCard(
                                      date: 'No hay reuniones programadas',
                                      place: 'Sin lugar asignado',
                                      agenda: [
                                        'No hay reuniones programadas actualmente'
                                      ],
                                    );
                                  }

                                  if (viewModel.errorMessage != null) {
                                    return MeetingReminderCard(
                                      date: 'Error',
                                      place: 'Error',
                                      agenda: [
                                        viewModel.errorMessage ??
                                            'Error desconocido'
                                      ],
                                    );
                                  }

                                  return MeetingReminderCard(
                                    date: viewModel.getFormattedDate(),
                                    place: viewModel.meeting?.lugar ??
                                        'Lugar no especificado',
                                    agenda: viewModel.getAgendaItems(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
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
