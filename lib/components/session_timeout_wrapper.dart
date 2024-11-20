// lib/widgets/session_timeout_wrapper.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/modal_sesion_timeout.dart';

class SessionTimeoutWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onSessionTimeout;
  final int sessionTimeInMinutes;
  final int warningTimeInMinutes;

  const SessionTimeoutWrapper({
    Key? key,
    required this.child,
    required this.onSessionTimeout,
    this.sessionTimeInMinutes = 15, // Tiempo total de sesión
    this.warningTimeInMinutes = 2, // Tiempo de advertencia
  }) : super(key: key);

  @override
  State<SessionTimeoutWrapper> createState() => _SessionTimeoutWrapperState();
}

class _SessionTimeoutWrapperState extends State<SessionTimeoutWrapper> {
  Timer? _sessionTimer;
  Timer? _warningTimer;
  bool _showingWarning = false;

  @override
  void initState() {
    super.initState();
    _startTimers();
  }

  void _startTimers() {
    // Cancelar timers existentes si los hay
    _sessionTimer?.cancel();
    _warningTimer?.cancel();

    // Tiempo total en millisegundos
    final sessionTimeMs = widget.sessionTimeInMinutes * 60 * 1000;
    // Tiempo para mostrar la advertencia
    final warningTimeMs = widget.warningTimeInMinutes * 60 * 1000;

    // Timer para mostrar la advertencia
    _warningTimer =
        Timer(Duration(milliseconds: sessionTimeMs - warningTimeMs), () {
      if (!_showingWarning) {
        _showingWarning = true;
        _showWarningDialog();
      }
    });

    // Timer para el timeout de la sesión
    _sessionTimer = Timer(Duration(milliseconds: sessionTimeMs), () {
      widget.onSessionTimeout();
    });
  }

  void _resetTimers() {
    setState(() {
      _showingWarning = false;
    });
    _startTimers();
  }

  void _showWarningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SessionTimeoutDialog(
          onExtendSession: () {
            Navigator.of(context).pop();
            _resetTimers();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _warningTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
