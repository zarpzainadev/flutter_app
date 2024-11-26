import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';

class UserRegisterViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService;
  bool isLoading = false;
  String? errorMessage;
  int? usuarioId;
  bool _disposed = false;

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

  UserRegisterViewModel({ApiServiceAdmin? apiService})
      : _apiService = apiService ?? ApiServiceAdmin();

  Future<bool> registerUsuarioCompleto({
    required UsuarioCreate usuario,
    Uint8List? fotoBytes,
    String? fotoNombre,
    String? fotoMimeType,
    Uint8List? documentoBytes,
    required String nombres,
    required String apellidos,
  }) async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await StorageService.getToken();
      if (token == null) throw Exception('Token no disponible');

      // 1. Crear usuario
      final usuarioResponse =
          await _apiService.createUsuario(token.accessToken, usuario);
      usuarioId = usuarioResponse.id;
      debugPrint('Usuario creado con ID: $usuarioId');

      // 2. Subir foto si existe
      if (fotoBytes != null && fotoNombre != null && fotoMimeType != null) {
        await _subirFoto(
            token.accessToken, fotoBytes, fotoNombre, fotoMimeType);
      }

      // 3. Subir documento si existe
      if (documentoBytes != null) {
        await _subirDocumento(
            token.accessToken, documentoBytes, nombres, apellidos);
      }

      isLoading = false;
      _safeNotifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error en registerUsuarioCompleto: $e');
      isLoading = false;
      errorMessage = 'Error en el registro: $e';
      _safeNotifyListeners();
      return false;
    }
  }

  Future<void> _subirFoto(
      String token, Uint8List bytes, String nombre, String mimeType) async {
    debugPrint('Subiendo foto para usuario $usuarioId');
    await _apiService.uploadUserPhoto(
        token, usuarioId!, bytes, nombre, mimeType);
    debugPrint('Foto subida exitosamente');
  }

  Future<void> _subirDocumento(
      String token, Uint8List bytes, String nombres, String apellidos) async {
    debugPrint('Subiendo documento para usuario $usuarioId');
    final documentoNombre =
        'Documento_${nombres}_$apellidos'.replaceAll(' ', '_');
    await _apiService.uploadUserDocument(
      token,
      usuarioId!,
      documentoNombre,
      'pdf',
      bytes,
      '$documentoNombre.pdf',
      'application/pdf',
    );
    debugPrint('Documento subido exitosamente');
  }

  void reset() {
    isLoading = false;
    errorMessage = null;
    usuarioId = null;
    _safeNotifyListeners();
  }
}
