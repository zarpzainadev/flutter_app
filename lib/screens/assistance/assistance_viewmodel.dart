import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';

class AssistanceViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService;
  bool isLoading = false;
  String? errorMessage;
  bool _disposed = false;
  bool isEditing = false;

  // Estados para manejar los datos
  List<UsuarioAsistenciaModel> usuariosActivos = [];
  List<AsistenciaUpdateItem> asistenciasPendientes = [];
  Map<int, EstadoAsistencia> estadosAsistencia = {};
  Map<int, EstadoAsistencia> estadosOriginales = {};
  int? reunionId;

  AssistanceViewModel({ApiServiceAdmin? apiService})
      : _apiService = apiService ?? ApiServiceAdmin();

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> initialize(int reunionId, bool isEditing) async {
    try {
      this.isEditing = isEditing;
      isLoading = true;
      errorMessage = null;
      _safeNotifyListeners();

      final token = await _getToken();

      if (isEditing) {
        // Obtener asistencias existentes
        final asistencias =
            await _apiService.obtenerAsistenciasReunion(token, reunionId);
        await cargarUsuariosActivos();

        // Guardar estados originales y actuales
        for (var asistencia in asistencias) {
          estadosAsistencia[asistencia.usuarioId] = asistencia.estado;
          estadosOriginales[asistencia.usuarioId] = asistencia.estado;
        }

        // Estado default para usuarios sin asistencia
        for (var usuario in usuariosActivos) {
          if (!estadosAsistencia.containsKey(usuario.id)) {
            estadosAsistencia[usuario.id] = EstadoAsistencia.No_asistido;
            estadosOriginales[usuario.id] = EstadoAsistencia.No_asistido;
          }
        }
      } else {
        // Flujo normal para registro nuevo
        await cargarUsuariosActivos();
        for (var usuario in usuariosActivos) {
          estadosAsistencia[usuario.id] = EstadoAsistencia.No_asistido;
        }
      }
    } catch (e) {
      errorMessage = 'Error al inicializar: $e';
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  // Preparar asistencias modificadas para actualización
  void prepararActualizaciones() {
    asistenciasPendientes.clear();

    estadosAsistencia.forEach((usuarioId, estadoActual) {
      final estadoOriginal = estadosOriginales[usuarioId];
      if (estadoOriginal != null && estadoOriginal != estadoActual) {
        // Solo incluir los que han cambiado
        asistenciasPendientes.add(AsistenciaUpdateItem(
          usuarioId: usuarioId,
          estado: estadoActual,
        ));
      }
    });
  }

  // Actualizar asistencias
  Future<bool> actualizarAsistencias({
    required int reunionId,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      _safeNotifyListeners();

      if (asistenciasPendientes.isEmpty) {
        return true; // No hay cambios que actualizar
      }

      final token = await _getToken();

      final actualizacionMasiva = AsistenciaUpdateMasiva(
        reunionId: reunionId,
        asistencias: asistenciasPendientes,
      );

      await _apiService.actualizarAsistencias(token, actualizacionMasiva);

      // Actualizar estados originales
      for (var asistencia in asistenciasPendientes) {
        estadosOriginales[asistencia.usuarioId] = asistencia.estado;
      }

      return true;
    } catch (e) {
      errorMessage = 'Error al actualizar asistencias: $e';
      debugPrint(errorMessage);
      return false;
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  bool hayAsistenciasPendientes() {
    if (isEditing) {
      // Para modo edición, comparar con estados originales
      return estadosAsistencia.entries.any((entry) {
        final estadoOriginal = estadosOriginales[entry.key];
        return estadoOriginal != null && estadoOriginal != entry.value;
      });
    } else {
      // Para modo registro nuevo, verificar si hay estados diferentes al default
      return estadosAsistencia.values
          .any((estado) => estado != EstadoAsistencia.No_asistido);
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
      return AsistenciaUpdateItem(
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

      final asistenciaMasiva = AsistenciaMasiva(
        reunionId: reunionId,
        asistencias: asistenciasPendientes
            .map((item) => AsistenciaCreate(
                // Convertir a AsistenciaCreate
                usuarioId: item.usuarioId,
                estado: item.estado))
            .toList(),
        fecha: fecha,
      );

      await _apiService.registrarAsistencias(token, asistenciaMasiva);
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
