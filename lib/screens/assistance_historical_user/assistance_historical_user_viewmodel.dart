// lib/screens/assistance/assistance_historical_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_user_meetings.dart';
import 'package:flutter_web_android/services/api_service_usuario.dart';
import 'package:flutter_web_android/storage/storage_services.dart';

class AssistanceHistoricalViewModel extends ChangeNotifier {
  final ApiServiceUsuario _apiService;
  bool isLoading = false;
  String? errorMessage;
  bool _disposed = false;
  List<AsistenciaUser> asistencias = [];
  bool sortAscending = false;

  AssistanceHistoricalViewModel({ApiServiceUsuario? apiService})
      : _apiService = apiService ?? ApiServiceUsuario();

  Future<void> initialize() async {
    await loadAssistances();
  }

  Future<void> loadAssistances() async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await _getToken();
      asistencias = await _apiService.getUserAssistances(token);
      _sortAssistances();

      errorMessage = null;
    } catch (e) {
      errorMessage = 'Error al cargar asistencias: $e';
      asistencias = [];
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  void toggleSort() {
    sortAscending = !sortAscending;
    _sortAssistances();
    _safeNotifyListeners();
  }

  void _sortAssistances() {
    asistencias.sort((a, b) {
      return sortAscending
          ? a.fecha.compareTo(b.fecha)
          : b.fecha.compareTo(a.fecha);
    });
  }

  Future<String> _getToken() async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('Token no disponible');
    return token.accessToken;
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
