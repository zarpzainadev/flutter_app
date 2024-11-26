// lib/components/custom_loading.dart
import 'package:flutter/material.dart';

class CustomLoading extends StatefulWidget {
  const CustomLoading({Key? key}) : super(key: key);

  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

// Cambiar SingleTickerProviderStateMixin por TickerProviderStateMixin
class _CustomLoadingState extends State<CustomLoading>
    with TickerProviderStateMixin {
  late AnimationController _heightController1;
  late AnimationController _heightController2;
  late AnimationController _heightController3;
  late AnimationController _opacityController;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();

    _heightController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _heightController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _heightController3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    if (_mounted) {
      _heightController1.repeat(reverse: true);
      _heightController2.repeat(reverse: true);
      _heightController3.repeat(reverse: true);
      _opacityController.forward();
    }
  }

  @override
  void dispose() {
    // Asegurar que todos los controladores se detengan
    _mounted = false;

    _heightController1.stop();
    _heightController2.stop();
    _heightController3.stop();
    _opacityController.stop();

    // Disponer los controladores
    _heightController1.dispose();
    _heightController2.dispose();
    _heightController3.dispose();
    _opacityController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 4. Envolver en un Container con color de fondo
    return Container(
      color: Colors.white, // Fondo blanco para asegurar visibilidad
      child: Center(
        child: FadeTransition(
          opacity: _opacityController,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBar(_heightController1),
              const SizedBox(width: 5),
              _buildBar(_heightController2),
              const SizedBox(width: 5),
              _buildBar(_heightController3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBar(AnimationController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: 4,
          height: 25 * controller.value,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }
}
