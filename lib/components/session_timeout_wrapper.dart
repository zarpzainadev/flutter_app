// lib/widgets/session_timeout_wrapper.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/modal_sesion_timeout.dart';
import 'package:flutter_web_android/main.dart';
import 'package:flutter_web_android/screens/home_screen_view_model.dart';

class SessionTimeoutWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onSessionTimeout;
  final int sessionTimeInMinutes;
  final int warningTimeInMinutes;

  const SessionTimeoutWrapper({
    Key? key,
    required this.child,
    required this.onSessionTimeout,
    this.sessionTimeInMinutes = AppConstants.sessionTimeout,
    this.warningTimeInMinutes = AppConstants.warningTimeout,
  }) : super(key: key);

  @override
  State<SessionTimeoutWrapper> createState() => _SessionTimeoutWrapperState();
}

class _SessionTimeoutWrapperState extends State<SessionTimeoutWrapper> {
  Timer? _sessionTimer;
  Timer? _warningTimer;
  bool _showingWarning = false;
  late final HomeScreenViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeScreenViewModel();
    _startTimers();
  }

  void _startTimers() {
    _sessionTimer?.cancel();
    _warningTimer?.cancel();

    final sessionTimeMs = widget.sessionTimeInMinutes * 60 * 1000;
    final warningTimeMs = widget.warningTimeInMinutes * 60 * 1000;

    _warningTimer = Timer(Duration(milliseconds: sessionTimeMs - warningTimeMs),
        _showWarningDialog);

    _sessionTimer =
        Timer(Duration(milliseconds: sessionTimeMs), widget.onSessionTimeout);
  }

  Future<void> _extendSession() async {
    try {
      // Cerrar modal inmediatamente
      Navigator.of(context).pop();

      // Reiniciar timers inmediatamente para UX fluida
      _resetTimers();

      // Refrescar token en segundo plano
      await _viewModel.refreshAccessToken(context);
    } catch (e) {
      // Si falla el refresh, mostrar error pero mantener timers reiniciados
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al extender sesión'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _resetTimers() {
    setState(() => _showingWarning = false);
    _startTimers();
  }

  void _showWarningDialog() {
    if (!_showingWarning && mounted) {
      setState(() => _showingWarning = true);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SessionTimeoutDialog(
            onExtendSession: _extendSession,
          );
        },
      );
    }
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
