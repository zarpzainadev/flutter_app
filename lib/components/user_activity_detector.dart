// user_activity_detector.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/loading_session_widget.dart';

class UserActivityDetector extends StatefulWidget {
  final Widget child;
  final Duration inactivityDuration;
  final VoidCallback onInactive;

  const UserActivityDetector({
    Key? key,
    required this.child,
    required this.onInactive,
    this.inactivityDuration = const Duration(minutes: 5),
  }) : super(key: key);

  @override
  State<UserActivityDetector> createState() => _UserActivityDetectorState();
}

class _UserActivityDetectorState extends State<UserActivityDetector>
    with WidgetsBindingObserver {
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _resetTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(widget.inactivityDuration, _handleInactivity);
  }

  Future<void> _handleInactivity() async {
    // Mostrar el LoadingSessionWidget
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const LoadingSessionWidget(),
      );

      // Esperar 2 segundos para mostrar la animación
      await Future.delayed(const Duration(seconds: 2));

      // Ejecutar el callback de inactividad (logout)
      widget.onInactive();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _inactivityTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      _resetTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKeyEvent: (_, event) {
        _resetTimer();
        return KeyEventResult.ignored;
      },
      child: Listener(
        onPointerDown: (_) => _resetTimer(),
        onPointerMove: (_) => _resetTimer(),
        behavior: HitTestBehavior.translucent,
        child: widget.child,
      ),
    );
  }
}
