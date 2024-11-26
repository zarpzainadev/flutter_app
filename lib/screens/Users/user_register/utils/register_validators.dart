import 'package:flutter/material.dart';

class RegisterValidators {
  static Map<String, String?> validateFields({
    required String nombres,
    required String apellidoPaterno,
    required String dni,
    required String email,
    required String password,
    required String celular,
    required DateTime? fechaNacimiento,
    required int? rolSeleccionado,
    required int? estadoSeleccionado,
    required int? organizacionSeleccionada,
  }) {
    Map<String, String?> errors = {};

    // Validar nombres
    if (nombres.isEmpty) {
      errors['nombres'] = 'El nombre es requerido';
      debugPrint('Error: nombres vacío');
    }

    // Validar apellido paterno
    if (apellidoPaterno.isEmpty) {
      errors['apellidoPaterno'] = 'El apellido paterno es requerido';
      debugPrint('Error: apellido paterno vacío');
    }

    // Validar DNI
    if (dni.isEmpty) {
      errors['dni'] = 'El DNI es requerido';
    } else if (dni.length != 8) {
      errors['dni'] = 'El DNI debe tener 8 dígitos';
    }

    // Validar email
    if (email.isEmpty) {
      errors['email'] = 'El email es requerido';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors['email'] = 'Email inválido';
    }

    // Validar password
    if (password.isEmpty) {
      errors['password'] = 'La contraseña es requerida';
    } else if (password.length < 6) {
      errors['password'] = 'La contraseña debe tener al menos 6 caracteres';
    }

    // Validar celular
    if (celular.isEmpty) {
      errors['celular'] = 'El celular es requerido';
    } else if (celular.length != 9) {
      errors['celular'] = 'El celular debe tener 9 dígitos';
    }

    // Validar fecha nacimiento
    if (fechaNacimiento == null) {
      errors['fechaNacimiento'] = 'La fecha de nacimiento es requerida';
      debugPrint('Error: fecha nacimiento null');
    }

    // Validar rol
    if (rolSeleccionado == null) {
      errors['rol'] = 'El rol es requerido';
      debugPrint('Error: rol null');
    }

    // Validar estado
    if (estadoSeleccionado == null) {
      errors['estado'] = 'El estado es requerido';
      debugPrint('Error: estado null');
    }

    // Validar organización
    if (organizacionSeleccionada == null) {
      errors['organizacion'] = 'La organización es requerida';
      debugPrint('Error: organización null');
    }

    return errors;
  }
}
