// loading_session_widget.dart

import 'package:flutter/material.dart';
import 'dart:async';

class LoadingSessionWidget extends StatefulWidget {
  const LoadingSessionWidget({Key? key}) : super(key: key);

  @override
  _LoadingSessionWidgetState createState() => _LoadingSessionWidgetState();
}

class _LoadingSessionWidgetState extends State<LoadingSessionWidget> {
  String _dots = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dots = _dots.length >= 3 ? '' : _dots + '.';
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Cerrando sesión',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  width: 30,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _dots,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
