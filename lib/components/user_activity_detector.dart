import 'dart:async';
import 'package:flutter/material.dart';

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
    _inactivityTimer = Timer(widget.inactivityDuration, widget.onInactive);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App en segundo plano
      _inactivityTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      // App vuelve a primer plano
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
