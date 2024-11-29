import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_user_meetings.dart';
import 'package:flutter_web_android/services/api_service_usuario.dart';
import 'package:flutter_web_android/storage/storage_services.dart';

class WorksViewModel extends ChangeNotifier {
  final ApiServiceUsuario _apiService;
  bool isLoading = false;
  String? errorMessage;
  bool _disposed = false;
  List<UserWork> works = [];
  List<UserWork> filteredWorks = [];

  // Filtros
  String searchQuery = '';
  bool sortAscending = true;
  String sortBy = 'fecha'; // 'fecha' o 'titulo'

  WorksViewModel({ApiServiceUsuario? apiService})
      : _apiService = apiService ?? ApiServiceUsuario() {
    initialize();
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> initialize() async {
    await loadWorks();
  }

  Future<void> loadWorks() async {
    try {
      isLoading = true;
      errorMessage = null;
      _safeNotifyListeners();

      final token = await _getToken();
      works = await _apiService.getUserWorks(token);
      applyFilters(); // Aplicar filtros iniciales
    } catch (e) {
      errorMessage = 'Error al cargar trabajos: $e';
      debugPrint(errorMessage);
      works = [];
      filteredWorks = [];
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  void applyFilters() {
    filteredWorks = List<UserWork>.from(works);

    // Aplicar búsqueda
    if (searchQuery.isNotEmpty) {
      filteredWorks = filteredWorks.where((work) {
        return work.titulo.toLowerCase().contains(searchQuery.toLowerCase()) ||
            work.descripcion.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Aplicar ordenamiento
    filteredWorks.sort((a, b) {
      if (sortBy == 'fecha') {
        return sortAscending
            ? a.fechaPresentacion.compareTo(b.fechaPresentacion)
            : b.fechaPresentacion.compareTo(a.fechaPresentacion);
      } else {
        return sortAscending
            ? a.titulo.compareTo(b.titulo)
            : b.titulo.compareTo(a.titulo);
      }
    });

    _safeNotifyListeners();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    applyFilters();
  }

  void toggleSort(String field) {
    if (sortBy == field) {
      sortAscending = !sortAscending;
    } else {
      sortBy = field;
      sortAscending = true;
    }
    applyFilters();
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
