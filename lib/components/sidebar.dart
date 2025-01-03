import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/screens/Profile/profiel_screen.dart';
import 'package:flutter_web_android/screens/Users/list_user_screen.dart';
import 'package:flutter_web_android/screens/Users/user_register/user_register_screen.dart';
import 'package:flutter_web_android/screens/assistance_historical_user/assistance_historical_user_screen.dart';
import 'package:flutter_web_android/screens/calendar/calendar_screen.dart';
import 'package:flutter_web_android/screens/grados/grados_screen.dart';
import 'package:flutter_web_android/screens/meetings/list_meetings.dart';
import 'package:flutter_web_android/screens/password/change_password_screen.dart';
import 'package:flutter_web_android/screens/works/work_list_screen.dart';
import 'package:flutter_web_android/screens/works_user/works_screen.dart';

class ScreenGroup {
  final String identifier;
  final String name;
  final List<SidebarItem> items;

  ScreenGroup({
    required this.identifier,
    required this.name,
    required this.items,
  });
}

class SidebarItem {
  final IconData icon;
  final String label;
  final Widget screen;

  SidebarItem({
    required this.icon,
    required this.label,
    required this.screen,
  });
}

// Definición del mapa screenGroups
final Map<String, ScreenGroup> screenGroups = {
  'tesorero_options': ScreenGroup(
    identifier: 'tesorero_options',
    name: 'Tesorero',
    items: [
      SidebarItem(
        icon: Icons.account_balance_wallet,
        label: 'Dashboard Financiero',
        screen: const Center(child: Text('Dashboard Financiero')),
      ),
      SidebarItem(
        icon: Icons.receipt_long,
        label: 'Transacciones',
        screen: const Center(child: Text('Transacciones')),
      ),
      SidebarItem(
        icon: Icons.assessment,
        label: 'Reportes',
        screen: const Center(child: Text('Reportes')),
      ),
    ],
  ),
  'admin_options': ScreenGroup(
    identifier: 'admin_options',
    name: 'Gestión de usuarios',
    items: [
      SidebarItem(
        icon: Icons.admin_panel_settings,
        label: 'Usuarios',
        screen: const ListUserScreen(),
      ),
      SidebarItem(
        icon: Icons.person_add,
        label: 'Registrar Usuario',
        screen: const UserRegisterScreen(),
      ),
      SidebarItem(
        icon: Icons.grade_rounded,
        label: 'Grados',
        screen: const GradosScreen(),
      ),
    ],
  ),
  'secretario_options': ScreenGroup(
    identifier: 'secretario_options',
    name: 'Secretario',
    items: [
      SidebarItem(
        icon: Icons.assignment,
        label: 'Reuniones',
        screen: const ListMeetings(),
      ),
      SidebarItem(
        icon: Icons.calendar_today,
        label: 'Calendario de Reuniones',
        screen: CalendarScreen(
          meetings: const [], // Esto realmente no se usa
          onMeetingTap: (MeetingListResponse meeting) {
            debugPrint('Reunión seleccionada: ${meeting.id}');
          },
        ),
      ),
      SidebarItem(
        icon: Icons.notifications,
        label: 'Trabajos',
        screen: const WorkListScreen(),
      ),
    ],
  ),
  'usuario_options': ScreenGroup(
    identifier: 'usuario_options',
    name: 'Usuario',
    items: [
      SidebarItem(
        icon: Icons.person,
        label: 'Mi Perfil',
        screen: const ProfileScreen(),
      ),
      SidebarItem(
        icon: Icons.calendar_today,
        label: 'Calendario de Reuniones',
        screen: CalendarScreen(
          meetings: [],
          onMeetingTap: (meeting) {},
        ),
      ),
      SidebarItem(
        icon: Icons.assistant,
        label: 'Asistencias',
        screen: const AssistanceHistoricalScreen(),
      ),
      SidebarItem(
        icon: Icons.work_history,
        label: 'Trabajos',
        screen: const WorksScreen(),
      ),
      SidebarItem(
        icon: Icons.payment,
        label: 'Pagos',
        screen: const Center(child: Text('Pagos')),
      ),
      SidebarItem(
        icon: Icons.lock_reset,
        label: 'Cambiar contraseña',
        screen: const ChangePasswordScreen(), // Usar la nueva pantalla
      ),
    ],
  ),
};

class Sidebar extends StatefulWidget {
  final Function(Widget) onSelectScreen;
  final List<String> allowedGroups;
  final Function(BuildContext) onLogout;

  const Sidebar({
    Key? key,
    required this.onSelectScreen,
    required this.allowedGroups,
    required this.onLogout,
  }) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Updated color scheme with softer blue
  static const Color primaryBlue = Color(0xFF4E67F7);
  static const Color hoverColor = Color(0xFF5C73F7);
  static const Color backgroundColor = Color(0xFF4E67F7);
  static const double expandedWidth = 270;
  static const double collapsedWidth = 70;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Android version (Drawer) with updated colors
    if (!kIsWeb) {
      return Drawer(
        child: Container(
          color: backgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: backgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ...widget.allowedGroups.expand((groupId) {
                final group = screenGroups[groupId];
                if (group == null) return <Widget>[];
                return [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Text(
                      group.name.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  ...group.items.map(
                    (item) => buildModernSidebarItem(
                      icon: _getUpdatedIcon(item.label, item.icon),
                      label: item.label,
                      isExpanded: true,
                      onTap: () {
                        widget.onSelectScreen(item.screen);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ];
              }).toList(),
            ],
          ),
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: _isHovered ? expandedWidth : collapsedWidth,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Logo section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        const Icon(Icons.apps, color: Colors.white, size: 20),
                  ),
                  if (_isHovered) ...[
                    const SizedBox(width: 12),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'Aqumex',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Menu items
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.allowedGroups.expand((groupId) {
                    final group = screenGroups[groupId];
                    if (group == null) return <Widget>[];
                    return [
                      if (_isHovered)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Text(
                              group.name.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ...group.items.map(
                        (item) => ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          dense: true,
                          leading: Icon(
                            item.icon,
                            color: Colors.white,
                            size: 28,
                          ),
                          title: _isHovered
                              ? SlideTransition(
                                  // Aquí va la nueva animación
                                  position: _slideAnimation,
                                  child: FadeTransition(
                                    opacity: _fadeAnimation,
                                    child: Text(
                                      item.label,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                              : null,
                          onTap: () => widget.onSelectScreen(item.screen),
                          hoverColor: hoverColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ];
                  }).toList(),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: _isHovered
                  ? Text(
                      'Logout',
                      style: const TextStyle(color: Colors.white),
                    )
                  : null,
              onTap: () {
                widget.onLogout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildModernSidebarItem({
    required IconData icon,
    required String label,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          hoverColor: hoverColor,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
                if (isExpanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getUpdatedIcon(String label, IconData defaultIcon) {
    // Map labels to more modern icons while keeping functionality
    switch (label.toLowerCase()) {
      case 'dashboard':
        return Icons.dashboard_outlined;
      case 'projects':
        return Icons.folder_outlined;
      case 'messages':
        return Icons.chat_outlined;
      case 'analytics':
        return Icons.analytics_outlined;
      case 'tasks':
        return Icons.task_outlined;
      case 'help':
        return Icons.help_outline;
      case 'settings':
        return Icons.settings_outlined;
      default:
        return defaultIcon;
    }
  }
}
