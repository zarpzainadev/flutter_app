// lib/screens/cargos/cargos_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';

class CargosViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService;
  bool isLoading = false;
  String? errorMessage;
  bool _disposed = false;
  List<CargoResponse> cargos = [];
  List<UsuarioBasicInfo> usuarios = [];

  CargosViewModel({ApiServiceAdmin? apiService})
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
      listCargos(),
      loadUsuarios(),
    ]);
  }


  Future<void> loadUsuarios() async {
    try {
      final token = await _getToken();
      usuarios = await _apiService.getUsuariosBasicInfo(token);
    } catch (e) {
      errorMessage = 'Error al cargar usuarios: $e';
      debugPrint(errorMessage);
    }
  }

  // Listar todos los cargos
  Future<void> listCargos({bool forceRefresh = false}) async {
    if (isLoading && !forceRefresh) return;

    try {
      isLoading = true;
      errorMessage = null;
      _safeNotifyListeners();

      final token = await _getToken();
      cargos = await _apiService.listCargos(token);
    } catch (e) {
      errorMessage = 'Error al cargar cargos: $e';
      debugPrint(errorMessage);
      cargos = [];
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  // Crear nuevo cargo
  Future<bool> createCargo({
  required int idOrganizacion,
  required int idUsuario,
  required String abreviatura,
  required String cargoNombre, 
}) async {
  try {
    isLoading = true;
    errorMessage = null;
    _safeNotifyListeners();

    final token = await _getToken();
    final cargoCreate = CargoCreate(
      idOrganizacion: idOrganizacion,
      idUsuario: idUsuario,
      abreviatura: abreviatura,
      cargoNombre: cargoNombre, 
    );

    await _apiService.createCargo(token, cargoCreate);
    await listCargos(forceRefresh: true);
    return true;
  } catch (e) {
    errorMessage = 'Error al crear cargo: $e';
    debugPrint(errorMessage);
    return false;
  } finally {
    isLoading = false;
    _safeNotifyListeners();
  }
}

  // Actualizar cargo existente
  Future<bool> updateCargo({
  required int cargoId,
  int? idOrganizacion,
  int? idUsuario,
  String? abreviatura,
  String? cargoNombre, 
}) async {
  try {
    isLoading = true;
    errorMessage = null;
    _safeNotifyListeners();

    final token = await _getToken();
    final cargoUpdate = CargoUpdate(
      idOrganizacion: idOrganizacion,
      idUsuario: idUsuario,
      abreviatura: abreviatura,
      cargoNombre: cargoNombre, 
    );

    await _apiService.updateCargo(token, cargoId, cargoUpdate);
    await listCargos(forceRefresh: true);
    return true;
  } catch (e) {
    errorMessage = 'Error al actualizar cargo: $e';
    debugPrint(errorMessage);
    return false;
  } finally {
    isLoading = false;
    _safeNotifyListeners();
  }
}

  // Eliminar cargo
  Future<bool> deleteCargo(int cargoId) async {
    try {
      isLoading = true;
      errorMessage = null;
      _safeNotifyListeners();

      final token = await _getToken();
      await _apiService.deleteCargo(token, cargoId);
      await listCargos(forceRefresh: true);
      return true;
    } catch (e) {
      errorMessage = 'Error al eliminar cargo: $e';
      debugPrint(errorMessage);
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