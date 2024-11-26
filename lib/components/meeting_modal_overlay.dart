import 'package:flutter/material.dart';

class MeetingModalOverlay extends StatelessWidget {
  final VoidCallback onDismiss;
  final Widget child;

  const MeetingModalOverlay({
    Key? key,
    required this.onDismiss,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 600;

    return Material(
      color: Colors.black54,
      child: InkWell(
        onTap: onDismiss,
        child: Center(
          child: Container(
            width: isWeb ? size.width * 0.4 : size.width * 0.85,
            constraints: BoxConstraints(
              maxWidth: 500,
              minHeight: 200,
              maxHeight: size.height * 0.7,
            ),
            margin: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
