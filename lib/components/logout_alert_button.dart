import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/logout_confirmation_dialog.dart';

class LogoutAlertButton extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutAlertButton({
    Key? key,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () => _showLogoutDialog(context),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => const LogoutConfirmationDialog(),
    );

    if (shouldLogout ?? false) {
      onLogout();
    }
  }
}
