import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/screens/another_screen.dart';

// Widget auxiliar para construir items del sidebar según el estado de expansión
Widget buildSidebarItem({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  required bool isExpanded,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: EdgeInsets.symmetric(
          horizontal: isExpanded ? 16 : 0,
        ),
        child: Row(
          mainAxisAlignment:
              isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            if (isExpanded) ...[
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class TesoreroOptions extends StatelessWidget {
  final Function(Widget) onSelectScreen;
  final bool isExpanded;

  const TesoreroOptions({
    Key? key,
    required this.onSelectScreen,
    required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSidebarItem(
          icon: Icons.attach_money,
          label: 'Finanzas',
          isExpanded: isExpanded,
          onTap: () {
            onSelectScreen(AnotherScreen());
            if (!kIsWeb) {
              Navigator.of(context).pop();
            }
          },
        ),
        buildSidebarItem(
          icon: Icons.analytics,
          label: 'Reportes de Finanzas',
          isExpanded: isExpanded,
          onTap: () {
            onSelectScreen(
                const Center(child: Text('Pantalla de reportes de finanzas')));
            if (!kIsWeb) {
              Navigator.of(context).pop();
            }
          },
        ),
        buildSidebarItem(
          icon: Icons.account_balance,
          label: 'Cuentas Bancarias',
          isExpanded: isExpanded,
          onTap: () {
            onSelectScreen(
                const Center(child: Text('Pantalla de cuentas bancarias')));
            if (!kIsWeb) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

class SecretarioOptions extends StatelessWidget {
  final Function(Widget) onSelectScreen;
  final bool isExpanded;

  const SecretarioOptions({
    Key? key,
    required this.onSelectScreen,
    required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSidebarItem(
          icon: Icons.schedule,
          label: 'Agenda',
          isExpanded: isExpanded,
          onTap: () {
            onSelectScreen(const Center(child: Text('Pantalla de Agenda')));
            if (!kIsWeb) {
              Navigator.of(context).pop();
            }
          },
        ),
        buildSidebarItem(
          icon: Icons.mail,
          label: 'Correo',
          isExpanded: isExpanded,
          onTap: () {
            onSelectScreen(const Center(child: Text('Pantalla de correo')));
            if (!kIsWeb) {
              Navigator.of(context).pop();
            }
          },
        ),
        buildSidebarItem(
          icon: Icons.people,
          label: 'Contactos',
          isExpanded: isExpanded,
          onTap: () {
            onSelectScreen(const Center(child: Text('Pantalla de contactos')));
            if (!kIsWeb) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

class AdminOptions extends StatelessWidget {
  final Function(Widget) onSelectScreen;
  final bool isExpanded;

  const AdminOptions({
    Key? key,
    required this.onSelectScreen,
    required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSidebarItem(
          icon: Icons.settings,
          label: 'Configuración General',
          isExpanded: isExpanded,
          onTap: () {
            onSelectScreen(
                const Center(child: Text('Pantalla de configuracion general')));
            if (!kIsWeb) {
              Navigator.of(context).pop();
            }
          },
        ),
        buildSidebarItem(
          icon: Icons.security,
          label: 'Seguridad',
          isExpanded: isExpanded,
          onTap: () {
            onSelectScreen(const Center(
                child: Text('Pantalla de configuracion de seguridad')));
            if (!kIsWeb) {
              Navigator.of(context).pop();
            }
          },
        ),
        buildSidebarItem(
          icon: Icons.supervised_user_circle,
          label: 'Gestión de Usuarios',
          isExpanded: isExpanded,
          onTap: () {
            onSelectScreen(
                const Center(child: Text('Pantalla de gestion de usuarios')));
            if (!kIsWeb) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

class UserManagementOptions extends StatelessWidget {
  final Function(Widget) onSelectScreen;
  final bool isExpanded;

  const UserManagementOptions({
    Key? key,
    required this.onSelectScreen,
    required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSidebarItem(
          icon: Icons.person_add,
          label: 'Agregar Usuario',
          isExpanded: isExpanded,
          onTap: () {
            onSelectScreen(
                const Center(child: Text('Pantalla de agregar usuario')));
            if (!kIsWeb) {
              Navigator.of(context).pop();
            }
          },
        ),
        buildSidebarItem(
          icon: Icons.person_remove,
          label: 'Eliminar Usuario',
          isExpanded: isExpanded,
          onTap: () {
            onSelectScreen(
                const Center(child: Text('Pantalla de eliminar usuario')));
            if (!kIsWeb) {
              Navigator.of(context).pop();
            }
          },
        ),
        buildSidebarItem(
          icon: Icons.person_search,
          label: 'Buscar Usuario',
          isExpanded: isExpanded,
          onTap: () {
            onSelectScreen(
                const Center(child: Text('Pantalla de buscar usuario')));
            if (!kIsWeb) {
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
