import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';

class AssistanceViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService;
  bool isLoading = false;
  String? errorMessage;
  bool _disposed = false;

  // Estados para manejar los datos
  List<UsuarioAsistenciaModel> usuariosActivos = [];
  List<AsistenciaCreate> asistenciasPendientes = [];
  Map<int, EstadoAsistencia> estadosAsistencia = {};
  int? reunionId;

  AssistanceViewModel({ApiServiceAdmin? apiService})
      : _apiService = apiService ?? ApiServiceAdmin();

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  // Obtener usuarios activos
  Future<void> cargarUsuariosActivos() async {
    try {
      isLoading = true;
      errorMessage = null;
      _safeNotifyListeners();

      final token = await _getToken();
      usuariosActivos = await _apiService.getUsuariosActivos(token);

      // Inicializar estados de asistencia
      for (var usuario in usuariosActivos) {
        estadosAsistencia[usuario.id] = EstadoAsistencia.No_asistido;
      }
    } catch (e) {
      errorMessage = 'Error al obtener usuarios activos: $e';
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  // Cambiar estado de asistencia de un usuario
  void cambiarEstadoAsistencia(int usuarioId, EstadoAsistencia estado) {
    estadosAsistencia[usuarioId] = estado;
    _safeNotifyListeners();
  }

  // Preparar asistencias para envío
  void prepararAsistencias() {
    asistenciasPendientes = estadosAsistencia.entries.map((entry) {
      return AsistenciaCreate(
        usuarioId: entry.key,
        estado: entry.value,
      );
    }).toList();
  }

  // Registrar asistencias
  Future<bool> registrarAsistencias({
    required int reunionId,
    required DateTime fecha,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      _safeNotifyListeners();

      final token = await _getToken();

      // Preparar el objeto de asistencia masiva
      final asistenciaMasiva = AsistenciaMasiva(
        reunionId: reunionId,
        asistencias: asistenciasPendientes,
        fecha: fecha,
      );

      // Enviar al servidor
      await _apiService.registrarAsistencias(token, asistenciaMasiva);

      // Limpiar estados después de registro exitoso
      asistenciasPendientes.clear();
      estadosAsistencia.clear();

      return true;
    } catch (e) {
      errorMessage = 'Error al registrar asistencias: $e';
      debugPrint(errorMessage);
      return false;
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  // Método para obtener asistencias de una reunión específica
  Future<List<AsistenciaResponse>> obtenerAsistenciasReunion(
      int reunionId) async {
    try {
      isLoading = true;
      errorMessage = null;
      _safeNotifyListeners();

      final token = await _getToken();
      return await _apiService.obtenerAsistenciasReunion(token, reunionId);
    } catch (e) {
      errorMessage = 'Error al obtener asistencias de la reunión: $e';
      debugPrint(errorMessage);
      throw Exception(errorMessage);
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  // Verificar si hay cambios pendientes
  bool hayAsistenciasPendientes() {
    return estadosAsistencia.values
        .any((estado) => estado != EstadoAsistencia.No_asistido);
  }

  // Reset de estados
  void resetEstados() {
    estadosAsistencia.clear();
    asistenciasPendientes.clear();
    _safeNotifyListeners();
  }

  // Helpers
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
