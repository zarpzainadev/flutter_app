import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';
import '../../../helpers/mobile_download_helper.dart'
    if (dart.library.html) '../../../helpers/web_download_helper.dart';

// ViewModel optimizado
class UserDetailViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService;

  // Estados
  bool isLoading = true;
  String? errorMessage;

  // Datos
  ListaDocumentosResponse? documentsList;
  Future<Uint8List>? _futureUserPhoto;
  late Future<UserDetail> _futureUserDetail;

  // Getters
  Future<UserDetail> get futureUserDetail => _futureUserDetail;
  Future<Uint8List>? get futureUserPhoto => _futureUserPhoto;
  bool get hasError => errorMessage != null;

  UserDetailViewModel({ApiServiceAdmin? apiService})
      : _apiService = apiService ?? ApiServiceAdmin();

  /// Inicializa los datos del usuario
  Future<void> initialize(int userId) async {
    try {
      _setLoadingState(true);
      await _loadUserData(userId);
    } catch (e) {
      _handleError(e);
    } finally {
      _setLoadingState(false);
    }
  }

  /// Carga los datos del usuario en paralelo
  Future<void> _loadUserData(int userId) async {
    final token = await _getToken();

    // Carga paralela de datos
    await Future.wait([
      _loadUserDetails(userId, token),
      _loadUserPhoto(userId, token),
      _loadUserDocuments(userId, token),
    ]);
  }

  /// Obtiene el token de autenticación
  Future<String> _getToken() async {
    final token = await StorageService.getToken();
    if (token == null) throw CustomError('No se pudo obtener el token');
    return token.accessToken;
  }

  /// Carga los detalles del usuario
  Future<void> _loadUserDetails(int userId, String token) async {
    try {
      _futureUserDetail = _apiService.getUserDetails(token, userId);
    } catch (e) {
      throw CustomError('Error al cargar detalles: $e');
    }
  }

  /// Carga la foto del usuario
  Future<void> _loadUserPhoto(int userId, String token) async {
    try {
      _futureUserPhoto =
          _apiService.getUserPhoto(token, userId).catchError((e) {
        print('Error controlado al cargar foto: $e');
        return Uint8List(0); // Retorna lista vacía en lugar de error
      });
    } catch (e) {
      print('Error al cargar foto: $e');
      _futureUserPhoto = Future.value(Uint8List(0)); // Valor por defecto
    }
  }

  /// Carga los documentos del usuario
  Future<void> _loadUserDocuments(int userId, String token) async {
    try {
      documentsList = await _apiService.getUserDocuments(token, userId);
    } catch (e) {
      throw CustomError('Error al cargar documentos: $e');
    }
  }

  /// Descarga un documento específico
  Future<void> downloadDocument(int documentId, String nombre) async {
    try {
      _setLoadingState(true);

      final token = await _getToken();
      final bytes =
          await _apiService.downloadDocument(token, documentId, nombre);
      await handleDocumentDownload(bytes, nombre, _getFileExtension(nombre));
    } catch (e) {
      _handleDownloadError(e);
    } finally {
      _setLoadingState(false);
    }
  }

  /// Maneja errores de descarga
  void _handleDownloadError(dynamic e) {
    if (e is DioException && e.response?.statusCode == 404) {
      errorMessage = DocumentError.fromJson(e.response?.data).detail;
    } else {
      errorMessage = 'Error al descargar documento: $e';
    }
  }

  /// Obtiene la extensión del archivo
  String _getFileExtension(String fileName) =>
      fileName.contains('.') ? fileName.split('.').last : 'pdf';

  /// Actualiza el estado de carga
  void _setLoadingState(bool loading) {
    isLoading = loading;
    if (loading) errorMessage = null;
    notifyListeners();
  }

  /// Maneja errores generales
  void _handleError(dynamic e) {
    errorMessage = e is CustomError ? e.message : e.toString();
    print('Error: $errorMessage');
  }

  @override
  void dispose() {
    // Limpieza de recursos si es necesario
    super.dispose();
  }
}

/// Error personalizado para mejor manejo
class CustomError implements Exception {
  final String message;
  CustomError(this.message);

  @override
  String toString() => message;
}
