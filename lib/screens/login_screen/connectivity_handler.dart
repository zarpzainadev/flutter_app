// connectivity_handler.dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_web_android/components/connection_error_widget.dart';
import 'package:provider/provider.dart';

class ConnectivityHandler extends StatefulWidget {
  final Widget child;

  const ConnectivityHandler({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ConnectivityHandler> createState() => _ConnectivityHandlerState();
}

class _ConnectivityHandlerState extends State<ConnectivityHandler> {
  late Future<bool> _checkConnection;

  @override
  void initState() {
    super.initState();
    _checkConnection = _checkConnectivity();
  }

  Future<bool> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkConnection,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!) {
            return widget.child;
          } else {
            return ConnectionErrorWidget(
              onRetry: () {
                setState(() {
                  _checkConnection = _checkConnectivity();
                });
              },
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
