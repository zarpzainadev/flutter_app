// gestion_enlaces_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';

enum ViewState { initial, loading, loaded, error }

class GestionEnlacesViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService;
  ViewState _state = ViewState.initial;
  String? _errorMessage;
  bool _disposed = false;

  List<EnlaceResponse> _enlaces = [];
  List<URLListResponse> _urls = [];

  // Getters
  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  List<EnlaceResponse> get enlaces => _enlaces;
  List<URLListResponse> get urls => _urls;
  bool get isLoading => _state == ViewState.loading;

  GestionEnlacesViewModel({ApiServiceAdmin? apiService}) 
      : _apiService = apiService ?? ApiServiceAdmin() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    _setState(ViewState.loading);
    try {
      await Future.wait([
        _fetchEnlaces(),
        _fetchUrls(),
      ]);
      _setState(ViewState.loaded);
    } catch (e) {
      _setError('Error al inicializar datos: $e');
    }
  }

  Future<void> _fetchEnlaces() async {
    try {
      final token = await _getToken();
      _enlaces = await _apiService.getEnlaces(token);
    } catch (e) {
      throw Exception('Error al cargar enlaces: $e');
    }
  }

  Future<void> _fetchUrls() async {
    try {
      final token = await _getToken();
      _urls = await _apiService.getUrls(token);
    } catch (e) {
      throw Exception('Error al cargar URLs: $e');
    }
  }

  Future<void> refreshData() async {
    await _initializeData();
  }

  Future<bool> createEnlace(String nombre, {String? descripcion}) async {
    try {
      _setState(ViewState.loading);
      final token = await _getToken();
      
      await _apiService.createEnlace(
        token, 
        EnlaceCreate(nombre: nombre, descripcion: descripcion)
      );
      
      await _fetchEnlaces();
      _setState(ViewState.loaded);
      return true;
    } catch (e) {
      _setError('Error al crear enlace: $e');
      return false;
    }
  }

  Future<bool> createUrl(String url, int enlaceId) async {
    try {
      _setState(ViewState.loading);
      final token = await _getToken();
      
      await _apiService.createURL(
        token,
        URLCreate(url: url, enlaceId: enlaceId)
      );
      
      await _fetchUrls();
      _setState(ViewState.loaded);
      return true;
    } catch (e) {
      _setError('Error al crear URL: $e');
      return false;
    }
  }

  Future<bool> updateEnlaceStatus(int enlaceId, bool estado) async {
    try {
      _setState(ViewState.loading);
      final token = await _getToken();
      
      await _apiService.updateEnlace(
        token,
        enlaceId,
        EnlaceUpdate(estado: estado)
      );
      
      await _fetchEnlaces();
      _setState(ViewState.loaded);
      return true;
    } catch (e) {
      _setError('Error al actualizar estado: $e');
      return false;
    }
  }

  Future<bool> updateUrlStatus(int urlId, bool estado) async {
    try {
      _setState(ViewState.loading);
      final token = await _getToken();
      
      await _apiService.updateURL(
        token,
        urlId,
        URLUpdate(estado: estado)
      );
      
      await _fetchUrls();
      _setState(ViewState.loaded);
      return true;
    } catch (e) {
      _setError('Error al actualizar estado: $e');
      return false;
    }
  }

  Future<String> _getToken() async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('No hay token disponible');
    return token.accessToken;
  }

  void _setState(ViewState newState) {
    _state = newState;
    _safeNotifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _state = ViewState.error;
    _safeNotifyListeners();
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}