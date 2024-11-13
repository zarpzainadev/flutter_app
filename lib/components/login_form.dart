import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen/login_view_model.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginForm({
    Key? key,
    required this.onLoginSuccess,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  String _selectedGroup = '';

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ViewModel a través de Provider
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        // Mostramos un indicador de carga si está en proceso
        if (viewModel.status == LoginStatus.loading) {
          return Center(child: CircularProgressIndicator());
        }

        return Material(
          color: Colors.transparent,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedGroup.isEmpty ? null : _selectedGroup,
                  decoration: InputDecoration(
                    labelText: 'Grupo',
                    labelStyle: TextStyle(
                      color: Colors.grey[600],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFE0E3E7),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF1F4F8),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'Simbolica',
                      child: Text('Simbólica'),
                    ),
                    DropdownMenuItem(
                      value: 'Regular',
                      child: Text('Regular'),
                    ),
                  ],
                  dropdownColor: Color.fromARGB(255, 255, 255, 255),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGroup = value ?? '';
                    });
                  },
                  hint: Text('Selecciona un grupo'),
                ),
                SizedBox(height: 16),

                // Número
                TextFormField(
                  controller: _numberController,
                  decoration: InputDecoration(
                    labelText: 'Número',
                    labelStyle: TextStyle(
                      color: Colors.grey[600],
                    ),
                    hintText: 'Ingresa tu número',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFE0E3E7),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF1F4F8),
                  ),
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 16),

                // Correo o DNI
                TextFormField(
                  controller: _identifierController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico o DNI',
                    labelStyle: TextStyle(
                      color: Colors.grey[600],
                    ),
                    hintText: 'Ingresa tu correo o DNI',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFE0E3E7),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF1F4F8),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 16),

                // Contraseña
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(
                      color: Colors.grey[600],
                    ),
                    hintText: 'Ingresa tu contraseña',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFE0E3E7),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Color(0xFFF1F4F8),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 16),

                // Olvidó contraseña
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Implementar recuperación de contraseña
                    },
                    child: Text(
                      '¿Has olvidado tu contraseña?',
                      style: TextStyle(
                        color: Color(0xFF3A53FF),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Mostrar mensaje de error si existe
                if (viewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      viewModel.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                // Botón de inicio de sesión modificado
                ElevatedButton(
                  onPressed: () async {
                    if (_selectedGroup.isNotEmpty &&
                        _numberController.text.isNotEmpty &&
                        _identifierController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty) {
                      final success = await viewModel.login(
                        grupo: _selectedGroup,
                        numero: _numberController.text,
                        username: _identifierController.text,
                        password: _passwordController.text,
                      );

                      if (success) {
                        widget.onLoginSuccess();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3A53FF),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    minimumSize: Size(double.infinity, 56),
                  ),
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _numberController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
