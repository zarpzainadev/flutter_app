import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/login_model.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/services/api_service_login.dart';
import 'package:flutter_web_android/storage/storage_services.dart';

enum LoginStatus { initial, loading, success, error }

class LoginViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final ApiServiceAdmin _apiServiceAdmin = ApiServiceAdmin();
  

  LoginStatus _status = LoginStatus.initial;
  LoginStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Token? _token;
  Token? get token => _token;

  List<NewOrganizacionResponse> _organizaciones = [];
  List<NewOrganizacionResponse> get organizaciones => _organizaciones;

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

  Future<void> fetchGrupos() async {
  try {
    _status = LoginStatus.loading;
    notifyListeners();

    _organizaciones = await _apiServiceAdmin.listOrganizations('');
    _status = LoginStatus.success;
  } catch (e) {
    _status = LoginStatus.error;
    _errorMessage = 'Error al cargar organizaciones: $e';
    debugPrint('Error en fetchGrupos: $e');
  } finally {
    notifyListeners();
  }
}

List<NewOrganizacionResponse> get organizacionesFiltradas {
    // Crear un mapa para mantener una organización por grupo
    final Map<String, NewOrganizacionResponse> gruposFiltrados = {};
    
    for (var org in _organizaciones) {
      // Si el grupo no existe en el mapa o si el número es menor, lo guardamos
      if (!gruposFiltrados.containsKey(org.grupo)) {
        gruposFiltrados[org.grupo] = org;
      }
    }
    
    // Convertir el mapa a lista
    return gruposFiltrados.values.toList();
  }

  String _selectedOrganizacionDescripcion = '';
  String get selectedOrganizacionDescripcion => _selectedOrganizacionDescripcion;

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

      // Obtener la descripción de la organización seleccionada
      final organizacion = _organizaciones.firstWhere(
        (org) => org.grupo == grupo && org.numero == numero,
      );
      _selectedOrganizacionDescripcion = organizacion.descripcion;

      final loginRequest = LoginRequest(
        grupo: grupo,
        numero: numero,
        username: username,
        password: password,
      );

      _token = await _apiService.login(loginRequest);
      // Guardar la descripción junto con el token
      await StorageService.saveOrganizacionDescripcion(_selectedOrganizacionDescripcion);
      await StorageService.saveToken(_token!);

      _status = LoginStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = LoginStatus.error;

      if (e.toString().contains('404')) {
        _errorMessage = 'Organización no encontrada para el grupo y número ingresados';
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

  void reset() {
    _status = LoginStatus.initial;
    _errorMessage = null;
    _token = null;
    notifyListeners();
  }
}