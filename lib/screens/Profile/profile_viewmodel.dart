// profile_viewmodel.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/loading_session_widget.dart';
import 'package:flutter_web_android/models/modulo_profile_usuario.dart';
import 'package:flutter_web_android/screens/home_screen.dart';
import 'package:flutter_web_android/screens/home_screen_view_model.dart';
import 'package:flutter_web_android/services/api_service_usuario.dart';
import 'package:flutter_web_android/storage/storage_services.dart';
import 'package:provider/provider.dart';

class ProfileViewModel extends ChangeNotifier {
  final ApiServiceUsuario _apiService;

  // Estados
  bool isLoading = true;
  String? errorMessage;

  // Datos
  late Future<UserProfileResponse> _futureUserProfile;
  Future<Uint8List>? _futureUserPhoto;
  bool _disposed = false;

  // Getters
  Future<UserProfileResponse> get futureUserProfile => _futureUserProfile;
  Future<Uint8List>? get futureUserPhoto => _futureUserPhoto;
  bool get hasError => errorMessage != null;

  ProfileViewModel({ApiServiceUsuario? apiService})
      : _apiService = apiService ?? ApiServiceUsuario();

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> initialize() async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await _getToken();

      // Cargar datos en paralelo
      await Future.wait([
        _loadUserProfile(token),
        _loadUserPhoto(token),
      ]);

      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint('Error en initialize: $e');
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<void> _loadUserProfile(String token) async {
    try {
      _futureUserProfile = _apiService.getUserProfile(token);
    } catch (e) {
      throw Exception('Error al cargar perfil: $e');
    }
  }

  Future<void> _loadUserPhoto(String token) async {
    try {
      final photoResponse = await _apiService.getUserPhoto(token);
      _futureUserPhoto = Future.value(photoResponse.bytes);
    } catch (e) {
      debugPrint('Error al cargar foto: $e');
      _futureUserPhoto = Future.value(Uint8List(0)); // Valor por defecto
    }
  }

  Future<void> changePassword(String newPassword, BuildContext context) async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await _getToken();
      await _apiService.changePassword(token, newPassword);
    } catch (e) {
      errorMessage = 'Error al cambiar contraseña: $e';
      debugPrint(errorMessage);
      rethrow;
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
