// lib/screens/grados/grados_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';

class GradosViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService;
  bool isLoading = false;
  String? errorMessage;
  bool _disposed = false;

  List<UsuarioConGrado> usuarios = [];
  List<GradoSimpleResponse> gradosOrganizacion = []; 

  GradosViewModel({ApiServiceAdmin? apiService})
      : _apiService = apiService ?? ApiServiceAdmin() {
    initialize();
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> initialize() async {
    await Future.wait([
      loadUsuariosConGrado(),
      loadGradosOrganizacion(), // Nueva función
    ]);
  }

  // Cargar usuarios con sus grados
  Future<void> loadUsuariosConGrado() async {
    try {
      isLoading = true;
      errorMessage = null;
      _safeNotifyListeners();

      final token = await _getToken();
      usuarios = await _apiService.getUsuariosConGrado(token);
    } catch (e) {
      errorMessage = 'Error al cargar usuarios: $e';
      debugPrint(errorMessage);
      usuarios = [];
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<void> loadGradosOrganizacion() async {

    if (gradosOrganizacion.isNotEmpty) return;
    
    try {
      final token = await _getToken();
      final organizacion = await StorageService.getOrganizacionDescripcion();
      
      if (organizacion == null) {
        throw Exception('No se encontró la organización');
      }

      gradosOrganizacion = await _apiService.getGradosOrganizacion(token, organizacion);
    } catch (e) {
      errorMessage = 'Error al cargar grados: $e';
      debugPrint(errorMessage);
      gradosOrganizacion = [];
    }
  }

  // Crear nuevo grado
  Future<bool> crearGrado({
  required int usuarioId,
  required int idGrado,
  String estado = 'Activo',
}) async {
    try {
      isLoading = true;
      errorMessage = null;
      _safeNotifyListeners();

      final token = await _getToken();
      final gradoCreate = GradoCreate(
        usuario_id: usuarioId,
        id_grado: idGrado,
        estado: estado,
      );

      await _apiService.createGrado(token, gradoCreate);
      await loadUsuariosConGrado();
      return true;
    } catch (e) {
      errorMessage = 'Error al crear grado: $e';
      return false;
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  // Actualizar grado existente
  Future<bool> actualizarGrado({
  required int usuarioId,
  required int idGrado,
  String? estado,
}) async {
  try {
    isLoading = true;
    errorMessage = null;
    _safeNotifyListeners();

    final token = await _getToken();
    final gradoUpdate = GradoUpdate(
      id_grado: idGrado,
      estado: estado,
    );

    await _apiService.updateGrado(token, usuarioId, gradoUpdate);
    await loadUsuariosConGrado();
    return true;
  } catch (e) {
    errorMessage = 'Error al actualizar grado: $e';
    return false;
  } finally {
    isLoading = false;
    _safeNotifyListeners();
  }
}

  Future<String> _getToken() async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('Token no disponible');
    return token.accessToken;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
