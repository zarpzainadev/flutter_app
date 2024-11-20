import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';
import '../../../helpers/mobile_download_helper.dart'
    if (dart.library.html) '../../../helpers/web_download_helper.dart';

class UserDetailViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService;
  String? errorMessage;

  ListaDocumentosResponse? documentsList;
  Future<Uint8List>? _futureUserPhoto;
  late Future<UserDetail> _futureUserDetail;

  Future<UserDetail> get futureUserDetail => _futureUserDetail;
  Future<Uint8List>? get futureUserPhoto => _futureUserPhoto;

  UserDetailViewModel({ApiServiceAdmin? apiService})
      : _apiService = apiService ?? ApiServiceAdmin() {
    _initializeDefaultUserDetail();
  }

  void _initializeDefaultUserDetail() {
    _futureUserDetail = Future.value(UserDetail(
      id: 0,
      dni: '',
      email: '',
      nombres: '',
      apellidos_paterno: '',
      apellidos_materno: '',
      fecha_nacimiento: DateTime.now(),
      celular: '',
      rol_nombre: '',
      estado_usuario_nombre: '',
      fecha_registro: DateTime.now(),
      password_hash: '',
      rol_id: 0,
      estado_id: 0,
      grados: null,
      informacion_profesional: null,
      direcciones: null,
      informacion_familiar: null,
      dependientes: null,
      informacion_adicional: null,
    ));
  }

  Future<String?> _getToken() async {
    final token = await StorageService.getToken();
    if (token == null) {
      _handleError('No se pudo obtener el token');
      return null;
    }
    return token.accessToken;
  }

  void _handleError(String message) {
    print(message);
  }

  Future<void> _loadUserDocuments(int userId, String token) async {
    try {
      documentsList = await _apiService.getUserDocuments(token, userId);
      notifyListeners();
    } catch (e) {
      _handleError('Error al cargar los documentos: $e');
    }
  }

  Future<void> _loadUserPhoto(int userId, String token) async {
    try {
      _futureUserPhoto = _apiService.getUserPhoto(token, userId);
      notifyListeners();
    } catch (e) {
      _handleError('Error al cargar la foto: $e');
    }
  }

  Future<void> initialize(int userId) async {
    final token = await _getToken();
    if (token != null) {
      try {
        print('Token obtenido: $token');
        _futureUserDetail = _apiService.getUserDetails(token, userId);
        await _loadUserPhoto(userId, token);
        await getUserDocuments(userId);
        notifyListeners();
      } catch (e) {
        _handleError('Error de conexión: $e');
      }
    }
  }

  Future<void> getUserDocuments(int userId) async {
    final token = await _getToken();
    if (token != null) {
      await _loadUserDocuments(userId, token);
    }
  }

  Future<void> downloadDocument(int documentId, String nombre) async {
    try {
      final token = await StorageService.getToken();
      if (token != null) {
        final bytes = await _apiService.downloadDocument(
            token.accessToken, documentId, nombre);

        await handleDocumentDownload(bytes, nombre, _getFileExtension(nombre));
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        final error = DocumentError.fromJson(e.response?.data);
        errorMessage = error.detail;
      } else {
        errorMessage = 'Error al descargar documento: ${e.message}';
      }
      notifyListeners();
    } catch (e) {
      errorMessage = 'Error al descargar documento: $e';
      notifyListeners();
    }
  }

  String _getFileExtension(String fileName) {
    return fileName.contains('.')
        ? fileName.split('.').last
        : 'pdf'; // Extensión por defecto
  }
}
