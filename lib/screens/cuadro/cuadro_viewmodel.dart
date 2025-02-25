// lib/screens/cuadro/cuadro_viewmodel.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';

class CuadroViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService;
  bool _isLoading = true;
  String? _error;
  List<CargoDetailResponse> _cargos = [];
  bool _disposed = false;
  final Map<int, Future<Uint8List>> _photoCache = {};
  String? _token;
  static const int _maxCacheSize = 50; // Límite de caché

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<CargoDetailResponse> get cargos => _cargos;

  CuadroViewModel({ApiServiceAdmin? apiService}) 
      : _apiService = apiService ?? ApiServiceAdmin() {
    _loadCargos();
  }

  Future<void> _loadCargos() async {
    try {
      _setLoading(true);
      final token = await _getToken();
      _token = token;
      _cargos = await _apiService.getCargoDetails(token);
      
      // Precargar todas las fotos en paralelo
      await _precacheUserPhotos();
      
      _setLoading(false);
    } catch (e) {
      _setError('Error al cargar el cuadro: ${e.toString()}');
    }
  }

  Future<void> _precacheUserPhotos() async {
    if (_token == null || _cargos.isEmpty) return;

    try {
      // Crear una lista de futures para todas las fotos
      final futures = _cargos.map((cargo) async {
        try {
          if (!_photoCache.containsKey(cargo.idUsuario)) {
            final photo = await _apiService.getUserPhoto(_token!, cargo.idUsuario);
            _photoCache[cargo.idUsuario] = Future.value(photo);
          }
        } catch (e) {
          debugPrint('Error al precargar foto de usuario ${cargo.idUsuario}: $e');
          _photoCache[cargo.idUsuario] = Future.value(Uint8List(0));
        }
      }).toList();

      // Ejecutar todas las peticiones en paralelo con un límite de concurrencia
      await Future.wait(
        futures,
        eagerError: false, // Continuar incluso si alguna falla
      );

      _limpiaCacheExcedente();
    } catch (e) {
      debugPrint('Error en precarga de fotos: $e');
    }
  }

  void _limpiaCacheExcedente() {
    if (_photoCache.length > _maxCacheSize) {
      final keysToRemove = _photoCache.keys.toList().sublist(_maxCacheSize);
      for (var key in keysToRemove) {
        _photoCache.remove(key);
      }
    }
  }

  Future<void> refreshCargos() async {
    _photoCache.clear();
    await _loadCargos();
  }

  Future<String> _getToken() async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('Token no disponible');
    return token.accessToken;
  }

  Future<Uint8List> getUserPhoto(int userId) async {
    try {
      // Verificar si ya existe en caché
      if (_photoCache.containsKey(userId)) {
        return await _photoCache[userId]!;
      }

      // Si no hay token, obtenerlo
      if (_token == null) {
        _token = await _getToken();
      }

      // Crear nueva Future para la foto y guardarla en caché
      final photo = await _apiService.getUserPhoto(_token!, userId);
      _photoCache[userId] = Future.value(photo); // Guardar como Future.value para evitar múltiples peticiones
      return photo;
    } catch (e) {
      debugPrint('Error en getUserPhoto: $e');
      return Uint8List(0);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    _safeNotifyListeners();
  }

  void _setError(String error) {
    _error = error;
    _isLoading = false;
    _safeNotifyListeners();
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  void clearPhotoCache() {
    _photoCache.clear();
  }

  @override
  void dispose() {
    _disposed = true;
    clearPhotoCache();
    super.dispose();
  }
}