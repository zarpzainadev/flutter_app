import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/screens/Profile/profiel_screen.dart';
import 'package:flutter_web_android/screens/Users/list_user_screen.dart';
import 'package:flutter_web_android/screens/Users/user_register/user_register_screen.dart';
import 'package:flutter_web_android/screens/assistance_historical_user/assistance_historical_user_screen.dart';
import 'package:flutter_web_android/screens/calendar/calendar_screen.dart';
import 'package:flutter_web_android/screens/cargos/cargos_screen.dart';
import 'package:flutter_web_android/screens/cuadro/cuadro_screen.dart';
import 'package:flutter_web_android/screens/enlaces/gestion_enlaces_screen.dart';
import 'package:flutter_web_android/screens/grados/grados_screen.dart';
import 'package:flutter_web_android/screens/meetings/list_meetings.dart';
import 'package:flutter_web_android/screens/password/change_password_screen.dart';
import 'package:flutter_web_android/screens/resources/resources_screen.dart';
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

  const SidebarItem({
    required this.icon,
    required this.label,
    required this.screen,
  });
}

final Map<String, ScreenGroup> screenGroups = {
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

  'cuadro_options': ScreenGroup(
  identifier: 'cuadro_options',
  name: 'Cuadro',
  items: [
    SidebarItem(
      icon: Icons.grid_view,
      label: 'Cuadro',
      screen: const CuadroScreen(),
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
          meetings: const [],
          onMeetingTap: (meeting) {
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
  'url_options': ScreenGroup(
    identifier: 'url_options',
    name: 'Url',
    items: [
      SidebarItem(
        icon: Icons.link,
        label: 'Enlaces y urls',
        screen: const GestionEnlacesScreen(),
      ),
    ]
  ),
  'vigilante_options': ScreenGroup(
    identifier: 'vigilante_options',
    name: 'Vigilante',
    items: [
      SidebarItem(
        icon: Icons.shield,
        label: 'Cargos',
        screen: const CargosScreen(),
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
        icon: Icons.lock_reset,
        label: 'Cambiar contraseña',
        screen: const ChangePasswordScreen(),
      ),
      SidebarItem(
        icon: Icons.library_books_outlined,
        label: 'Recursos',
        screen: const ResourcesScreen(),
      ),
    ],
  ),
};

class Sidebar extends StatefulWidget {
  final Function(Widget) onSelectScreen;
  final List<String> allowedGroups;
  final Function(BuildContext) onLogout;
  final String organizacionDescripcion;

  const Sidebar({
    Key? key,
    required this.onSelectScreen,
    required this.allowedGroups,
    required this.onLogout,
    required this.organizacionDescripcion,
  }) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Constantes optimizadas
  static const Duration _animationDuration = Duration(milliseconds: 150);
  static const Curve _animationCurve = Curves.fastOutSlowIn;
  static const Color primaryColor = Color(0xFF4E67F7);
  static const Color hoverColor = Color(0xFF5C73F7);
  static const Color backgroundColor = Color(0xFF1E3A8A);
  static const double expandedWidth = 270;
  static const double collapsedWidth = 70;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: _animationCurve,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLazyMenuItems() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.allowedGroups.map((groupId) {
            final group = screenGroups[groupId];
            if (group == null) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isHovered)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                ...group.items.map((item) => _buildLazyMenuItem(item)),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildLazyMenuItem(SidebarItem item) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          dense: true,
          leading: Icon(
            item.icon,
            color: Colors.white,
            size: 24,
          ),
          title: _isHovered
              ? FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    item.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                )
              : null,
          onTap: () => widget.onSelectScreen(item.screen),
          hoverColor: hoverColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;

    return RepaintBoundary(
      child: isWeb 
        ? MouseRegion(
            onEnter: (_) {
              setState(() => _isHovered = true);
              _controller.forward();
            },
            onExit: (_) {
              setState(() => _isHovered = false);
              _controller.reverse();
            },
            child: AnimatedContainer(
              duration: _animationDuration,
              curve: _animationCurve,
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
                  // Logo section con lazy loading
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.apps, color: Colors.white, size: 20),
                            ),
                            if (_isHovered) ...[
        const SizedBox(width: 12),
        Flexible( // Envolver con Flexible
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              widget.organizacionDescripcion,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis, // Añadir esto
              maxLines: 1, // Añadir esto
            ),
          ),
        ),
      ],
                          ],
                        ),
                      );
                    },
                  ),
                  
                  // Menu items con lazy loading
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildLazyMenuItems(),
                    ),
                  ),

                  // Logout button con lazy loading
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return ListTile(
                        leading: const Icon(Icons.logout, color: Colors.white),
                        title: _isHovered
                            ? FadeTransition(
                                opacity: _fadeAnimation,
                                child: const Text(
                                  'Cerrar Sesión',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : null,
                        onTap: () => widget.onLogout(context),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        : Drawer(
            child: Container(
              color: backgroundColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: backgroundColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white, size: 30),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.organizacionDescripcion,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      ...group.items.map(
                        (item) => ListTile(
                          leading: Icon(item.icon, color: Colors.white),
                          title: Text(
                            item.label,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            widget.onSelectScreen(item.screen);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ];
                  }).toList(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: const Text(
                      'Cerrar Sesión',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => widget.onLogout(context),
                  ),
                ],
              ),
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
