import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/login_model.dart';
import 'package:flutter_web_android/services/api_service_login.dart';
import 'package:flutter_web_android/storage/storage_services.dart';

// Enum para manejar los diferentes estados del login
enum LoginStatus { initial, loading, success, error }

class LoginViewModel extends ChangeNotifier {
  // Instancia del servicio API
  final ApiService _apiService = ApiService();

  // Estado actual del login
  LoginStatus _status = LoginStatus.initial;
  LoginStatus get status => _status;

  // Mensaje de error si algo falla
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Token resultante del login
  Token? _token;
  Token? get token => _token;

  // Verificar si hay una sesión activa
  Future<bool> checkSession() async {
    final savedToken = await StorageService.getToken();
    if (savedToken != null) {
      _token = savedToken;
      _status = LoginStatus.success;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Método principal para realizar el login
  Future<bool> login({
    required String grupo,
    required String numero,
    required String username,
    required String password,
  }) async {
    try {
      _status = LoginStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final loginRequest = LoginRequest(
        grupo: grupo,
        numero: numero,
        username: username,
        password: password,
      );

      _token = await _apiService.login(loginRequest);
      await StorageService.saveToken(_token!);

      _status = LoginStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = LoginStatus.error;

      // Manejar diferentes tipos de errores
      if (e.toString().contains('404')) {
        _errorMessage =
            'Organización no encontrada para el grupo y número ingresados';
      } else if (e.toString().contains('401')) {
        _errorMessage = 'Usuario o contraseña incorrectos';
      } else if (e.toString().contains('403')) {
        if (e.toString().contains('bloqueada')) {
          _errorMessage = 'Cuenta bloqueada por múltiples intentos fallidos';
        } else {
          _errorMessage = 'El usuario no pertenece a esta organización';
        }
      } else {
        _errorMessage = 'Error de conexión. Por favor, intente más tarde';
      }

      notifyListeners();
      return false;
    }
  }

  // Método para resetear el estado
  void reset() {
    _status = LoginStatus.initial;
    _errorMessage = null;
    _token = null;
    notifyListeners();
  }
}
