import 'package:flutter/material.dart';

class SessionTimeoutDialog extends StatelessWidget {
  final VoidCallback onExtendSession;

  const SessionTimeoutDialog({
    Key? key,
    required this.onExtendSession,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Detectar si estamos en móvil o web
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: isWeb ? 400 : 320, // Más estrecho en móvil
        padding: EdgeInsets.all(isWeb ? 32.0 : 24.0), // Menos padding en móvil
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
                onPressed: onExtendSession,
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
  }
}

// Ejemplo de uso:
void showSessionTimeoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible:
        false, // El usuario no puede cerrar el dialog haciendo tap fuera
    builder: (BuildContext context) {
      return SessionTimeoutDialog(
        onExtendSession: () {
          // Aquí va tu lógica para extender la sesión
          Navigator.of(context).pop(); // Cerrar el dialog
        },
      );
    },
  );
}
