// user_list_widget.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';

class UserListWidget extends StatefulWidget {
  final List<User> users;
  final List<UserAction> actions;
  final Function(User)? onUserTap;
  final bool isLoading;

  const UserListWidget({
    Key? key,
    required this.users,
    this.actions = const [],
    this.onUserTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class UserAction {
  final IconData icon;
  final Color color;
  final String tooltip;
  final Function(User) onPressed;
  final bool Function(User)? isVisible;

  const UserAction({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
    this.isVisible,
  });
}

class _UserListWidgetState extends State<UserListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hay usuarios registrados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  user.nombres[0].toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                '${user.nombres} ${user.apellidos_paterno}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                user.email,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildInfoChip(
                            Icons.badge,
                            _getRolText(user.rol_nombre),
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            Icons.person_outline,
                            _getEstadoText(user.estado_usuario_nombre),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: widget.actions
                            .where((action) =>
                                action.isVisible == null ||
                                action.isVisible!(user))
                            .map((action) => Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: IconButton(
                                    icon: Icon(action.icon),
                                    color: action.color,
                                    tooltip: action.tooltip,
                                    onPressed: () => action.onPressed(user),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  String _getRolText(String rol) {
    switch (rol.toLowerCase()) {
      case "1":
      case "usuario":
        return "Usuario";
      case "2":
      case "administrador":
        return "Administrador";
      case "3":
      case "secretario":
        return "Secretario";
      case "4":
      case "tesorero":
        return "Tesorero";
      default:
        return rol; // Retornar el rol tal cual si no coincide con ningún caso
    }
  }

  String _getEstadoText(String estado) {
    switch (estado.toLowerCase()) {
      case "1":
      case "activo":
        return "Activo";
      case "2":
      case "en sueño":
        return "En sueño";
      case "3":
      case "irradiado":
        return "Irradiado";
      default:
        return estado; // Retornar el estado tal cual si no coincide con ningún caso
    }
  }
}
