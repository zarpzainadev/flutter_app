// lib/screens/resources/resources_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';

class ResourcesViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService;
  bool _isLoading = true;
  String? _error;
  List<URLListResponse> _urls = [];
  bool _disposed = false;
  
  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<URLListResponse> get urls => _urls;

  // Grid configuration
  int getGridCrossAxisCount(double width) {
    if (width < 600) return 1;  // Mobile
    if (width < 900) return 2;  // Tablet
    if (width < 1200) return 3; // Small desktop
    return 4;                   // Large desktop
  }

  double getGridSpacing(double width) {
    if (width < 600) return 12;
    return 20;
  }

  ResourcesViewModel({ApiServiceAdmin? apiService}) 
      : _apiService = apiService ?? ApiServiceAdmin() {
    _loadUrls();
  }

  Future<void> _loadUrls() async {
    try {
      _setLoading(true);
      final token = await _getToken();
      _urls = await _apiService.getUrls(token);
      
      // Ordenar URLs por nombre
      _urls.sort((a, b) => 
        (a.enlaceNombre ?? '').compareTo(b.enlaceNombre ?? ''));
      
      _setLoading(false);
    } catch (e) {
      _setError('Error al cargar recursos: ${e.toString()}');
    }
  }

  Future<void> refreshUrls() async {
    try {
      await _loadUrls();
    } catch (e) {
      _setError('Error al actualizar recursos: ${e.toString()}');
    }
  }

  Future<void> openUrl(String url, BuildContext context) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo abrir el enlace'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        _setError('No se pudo abrir el enlace');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      _setError('Error al abrir el enlace: ${e.toString()}');
    }
  }

  Future<String> _getToken() async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('No hay token disponible');
    return token.accessToken;
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

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}