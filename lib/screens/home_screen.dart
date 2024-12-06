import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/loading_session_widget.dart';
import 'package:flutter_web_android/components/logout_confirmation_dialog.dart';
import 'package:flutter_web_android/components/meeting_modal_overlay.dart';
import 'package:flutter_web_android/components/meeting_reminder_card.dart';
import 'package:flutter_web_android/components/session_timeout_wrapper.dart';
import 'package:flutter_web_android/components/user_activity_detector.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/screens/Profile/profile_viewmodel.dart';
import 'package:flutter_web_android/screens/Users/user_details/user_detail_screen.dart';
import 'package:flutter_web_android/screens/calendar/calendar_screen.dart';
import 'package:flutter_web_android/screens/home_screen_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_android/components/sidebar.dart';
import '../theme/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool isRedTheme = true;
  bool showMeetingModal = true;
  Widget _currentScreen = CalendarScreen(
    meetings: const [],
    onMeetingTap: (MeetingListResponse meeting) {
      debugPrint('Reunión seleccionada: ${meeting.lugar}');
    },
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late HomeScreenViewModel _viewModel;
  List<String> userAllowedGroups = [];

  @override
  void initState() {
    super.initState();
    _viewModel = HomeScreenViewModel();
    _loadUserAllowedGroups();
    _viewModel.fetchNextMeeting();
  }

  void _loadUserAllowedGroups() async {
    try {
      final groups = await _viewModel.fetchUserAllowedGroups();
      if (mounted) {
        setState(() {
          userAllowedGroups = groups;
        });
      }
    } catch (e) {
      _handleError(Exception('Error al cargar grupos: $e'));
    }
  }

  void _handleError(Exception error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.toString()),
        backgroundColor: Colors.red,
      ),
    );
  }

  void changeScreen(Widget newScreen) {
    setState(() {
      _currentScreen = newScreen;
    });
  }

  void navigateToUserDetail(int userId) {
    changeScreen(UserDetailScreen(
      userId: userId,
      onBack: () {},
    ));
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (_) => const LogoutConfirmationDialog(),
      );

      if (shouldLogout ?? false) {
        // Mostrar el LoadingSessionWidget en lugar del CircularProgressIndicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const LoadingSessionWidget(),
        );

        // Esperar un poco para mostrar la animación (opcional)
        await Future.delayed(const Duration(seconds: 2));

        // Realizar el logout
        await _viewModel.logout(context);
      }
    } catch (e) {
      // Si hay error, cerrar el LoadingSessionWidget
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      _handleError(Exception(e.toString()));
    }
  }

  void _hideMeetingModal() => setState(() => showMeetingModal = false);

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Tema oscuro', style: TextStyle(fontSize: 14)),
              Switch(
                value: isRedTheme,
                onChanged: (value) {
                  setState(() {
                    isRedTheme = value;
                    AppTheme.switchTheme(context, isRedTheme);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Cerrar Sesión',
                onPressed: () => _handleLogout(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              background: Colors.white,
              surface: Colors.white,
            ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: kIsWeb ? null : _buildAppBar(),
        drawer: kIsWeb ? null : _buildSidebar(),
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Row(
                children: [
                  if (kIsWeb) _buildSidebar(),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _currentScreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (showMeetingModal)
                MeetingModalOverlay(
                  onDismiss: _hideMeetingModal,
                  child: Consumer<HomeScreenViewModel>(
                    builder: (context, viewModel, _) {
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
                          agenda: ['No hay reuniones programadas actualmente'],
                        );
                      }

                      if (viewModel.errorMessage != null) {
                        return MeetingReminderCard(
                          date: 'Error',
                          place: 'Error',
                          agenda: [
                            viewModel.errorMessage ?? 'Error desconocido'
                          ],
                        );
                      }

                      return MeetingReminderCard(
                        date: viewModel.getFormattedDate(),
                        place:
                            viewModel.meeting?.lugar ?? 'Lugar no especificado',
                        agenda: viewModel.getAgendaItems(),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Sidebar(
      onSelectScreen: changeScreen,
      allowedGroups: userAllowedGroups,
      onLogout: _handleLogout,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SessionTimeoutWrapper(
      onSessionTimeout: () => _viewModel.logout(context),
      child: MultiProvider(
        // Cambiar a MultiProvider
        providers: [
          ChangeNotifierProvider.value(value: _viewModel),
          ChangeNotifierProvider(
              create: (_) => ProfileViewModel()), // Agregar ProfileViewModel
        ],
        child: _buildMainContent(),
      ),
    );

    if (kIsWeb) {
      content = UserActivityDetector(
        inactivityDuration: const Duration(minutes: 5),
        onInactive: () => _viewModel.logout(context),
        child: content,
      );
    }

    return content;
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
