import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Variables para controlar errores
  String? _numberError;
  String? _identifierError;
  String? _passwordError;
  bool _rememberMe = false;

  // Validador para el número
  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'El número es requerido';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Solo se permiten números';
    }
    if (value.length > 4) {
      return 'Máximo 4 números';
    }
    return null;
  }

  // Validador para email o DNI
  String? _validateIdentifier(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }

    if (value.contains('@')) {
      // Validación de email
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Correo electrónico inválido';
      }
    } else {
      // Validación de DNI
      if (!RegExp(r'^[0-9]{8}$').hasMatch(value)) {
        return 'DNI debe tener 8 dígitos';
      }
    }
    return null;
  }

  // Validador para contraseña
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    return null;
  }

  // Verificar si el formulario es válido
  bool _isFormValid() {
    return _selectedGroup.isNotEmpty &&
        _numberError == null &&
        _identifierError == null &&
        _passwordError == null &&
        _numberController.text.isNotEmpty &&
        _identifierController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  @override
void initState() {
  super.initState();
  _loadSavedCredentials();
  // Agregar listeners para validación en tiempo real
  _numberController.addListener(() {
    setState(() {
      _numberError = _validateNumber(_numberController.text);
    });
  });

  _identifierController.addListener(() {
    setState(() {
      _identifierError = _validateIdentifier(_identifierController.text);
    });
  });

  _passwordController.addListener(() {
    setState(() {
      _passwordError = _validatePassword(_passwordController.text);
    });
  });

  // Cargar los grupos al iniciar
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<LoginViewModel>().fetchGrupos();
  });
}


  Future<void> _loadSavedCredentials() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    _rememberMe = prefs.getBool('remember_me') ?? false;
    if (_rememberMe) {
      _selectedGroup = prefs.getString('saved_group') ?? '';
      _numberController.text = prefs.getString('saved_number') ?? '';
      _identifierController.text = prefs.getString('saved_identifier') ?? '';
    }
  });
}

Future<void> _saveCredentials() async {
  final prefs = await SharedPreferences.getInstance();
  if (_rememberMe) {
    await prefs.setString('saved_group', _selectedGroup);
    await prefs.setString('saved_number', _numberController.text);
    await prefs.setString('saved_identifier', _identifierController.text);
    await prefs.setBool('remember_me', true);
  } else {
    await prefs.remove('saved_group');
    await prefs.remove('saved_number');
    await prefs.remove('saved_identifier');
    await prefs.remove('remember_me');
  }
}

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.status == LoginStatus.loading) {
          return const Center(child: CircularProgressIndicator());
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
    prefixIcon: const Icon(Icons.group_outlined),
    labelStyle: TextStyle(color: Colors.grey[600]),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFE0E3E7)),
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: const Color(0xFFF1F4F8),
  ),
  items: viewModel.organizacionesFiltradas.map((org) {
  return DropdownMenuItem(
    value: org.grupo,
    child: Text(org.grupo),
  );
}).toList(),
  dropdownColor: const Color.fromARGB(255, 255, 255, 255),
  onChanged: (String? value) {
    setState(() {
      _selectedGroup = value ?? '';
    });
  },
  hint: const Text('Selecciona un grupo'),
),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _numberController,
                  decoration: InputDecoration(
                    labelText: 'Número',
                    prefixIcon: Icon(
                      Icons.tag,
                      color:
                          _numberError != null ? Colors.red : Colors.grey[600],
                    ),
                    errorText: _numberError,
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    hintText: 'Ingresa tu número (máx. 4 dígitos)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _numberError != null
                            ? Colors.red
                            : const Color(0xFFE0E3E7),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF1F4F8),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  onChanged: (value) {
                    setState(() {
                      _numberError = _validateNumber(value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _identifierController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico o DNI',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: _identifierError != null
                          ? Colors.red
                          : Colors.grey[600],
                    ),
                    errorText: _identifierError,
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    hintText: 'Ingresa tu correo o DNI',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _identifierError != null
                            ? Colors.red
                            : const Color(0xFFE0E3E7),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF1F4F8),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _identifierError = _validateIdentifier(value);
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    errorText: _passwordError,
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    hintText: 'Ingresa tu contraseña',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _passwordError != null
                            ? Colors.red
                            : const Color(0xFFE0E3E7),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF1F4F8),
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
                ),
                const SizedBox(height: 16),
                Row(
  children: [
    Checkbox(
      value: _rememberMe,
      onChanged: (value) {
        setState(() {
          _rememberMe = value ?? false;
        });
      },
      activeColor: const Color(0xFF3A53FF),
    ),
    const Text(
      'Recordar mis datos',
      style: TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
    ),
  ],
),
                const SizedBox(height: 24),
                if (viewModel.errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            viewModel.errorMessage!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ElevatedButton(
  onPressed: _isFormValid()
    ? () async {
        if (_rememberMe) {
          await _saveCredentials();
        }
        
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
    : null,
  style: ElevatedButton.styleFrom(
    // ... resto del código del botón
  ),
  child: viewModel.status == LoginStatus.loading
    ? const SizedBox(
      // ... resto del código del loading
    )
    : const Text('Iniciar Sesión'),
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
