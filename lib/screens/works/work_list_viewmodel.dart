import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';
import 'package:intl/intl.dart';
import '../../../helpers/mobile_download_helper.dart'
    if (dart.library.html) '../../../helpers/web_download_helper.dart';

class WorkViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService;
  bool isLoading = false;
  String? errorMessage;
  bool _disposed = false;
  bool _isInitialized = false;

  // Data
  List<UsuarioConGrado> usuariosActivos = [];
  List<TrabajoListResponse> trabajos = [];
  List<MeetingListResponse> reunionesPublicadas = [];

  WorkViewModel({ApiServiceAdmin? apiService})
      : _apiService = apiService ?? ApiServiceAdmin();

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  // Inicializar datos
  Future<void> initialize() async {
    if (_isInitialized) return; // Evitar inicializaciones múltiples

    try {
      await Future.wait([
        loadUsuariosActivos(),
        loadReuniones(),
        listTrabajos(),
      ]);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error en initialize: $e');
      errorMessage = 'Error al inicializar: $e';
    }
  }

  // Future para cargar usuarios activos
  Future<void> loadUsuariosActivos() async {
    try {
      final token = await _getToken();
      usuariosActivos = await _apiService.getUsuariosConGrado(token);
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Error al cargar usuarios: $e';
      debugPrint(errorMessage);
      usuariosActivos = [];
    }
  }

  // Listar Trabajos
  Future<void> listTrabajos() async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await _getToken();
      trabajos = await _apiService.listTrabajos(token);
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Error al cargar trabajos: $e';
      debugPrint(errorMessage);
      trabajos = [];
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  // Listar Reuniones (para selector)
  Future<void> loadReuniones() async {
    try {
      final token = await _getToken();
      final reuniones = await _apiService.listMeetings(token);
      // Filtrar solo reuniones publicadas
      reunionesPublicadas =
          reuniones.where((r) => r.estado == 'Publicada').toList();
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Error al cargar reuniones: $e';
      debugPrint(errorMessage);
      reunionesPublicadas = [];
    }
  }

  // Crear Trabajo
  Future<bool> createTrabajo({
    required int reunionId,
    required int usuarioId,
    required String titulo,
    required String descripcion,
    required DateTime fechaPresentacion,
  }) async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await _getToken();
      await _apiService.createTrabajo(
        token,
        reunionId,
        usuarioId,
        titulo,
        descripcion,
        fechaPresentacion,
      );

      await listTrabajos(); // Recargar lista
      return true;
    } catch (e) {
      errorMessage = 'Error al crear trabajo: $e';
      debugPrint(errorMessage);
      return false;
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  // Método para formatear nombre de usuario
  String formatUserName(UsuarioConGrado usuario) {
    return '${usuario.nombres} ${usuario.apellidosPaterno}';
  }

  // Método para formatear reunión
  String formatMeeting(MeetingListResponse reunion) {
    return '${reunion.lugar} - ${DateFormat('dd/MM/yyyy').format(reunion.fecha)}';
  }

  // Actualizar Trabajo
  Future<bool> updateTrabajo({
    required int trabajoId,
    String? titulo,
    String? descripcion,
    String? estado,
    DateTime? fechaPresentacion,
  }) async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await _getToken();
      final update = TrabajoUpdateRequest(
        titulo: titulo,
        descripcion: descripcion,
        estado: estado,
        fechaPresentacion: fechaPresentacion,
      );

      await _apiService.updateTrabajo(token, trabajoId, update);
      await listTrabajos(); // Recargar lista
      return true;
    } catch (e) {
      errorMessage = 'Error al actualizar trabajo: $e';
      debugPrint(errorMessage);
      return false;
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

  Future<void> generateWorksReport(String formato) async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await _getToken();
      final bytes = await _apiService.generateWorksReport(token, formato);

      if (kIsWeb) {
        await handleWebDownload(
            bytes, 'trabajos', formato == 'excel' ? 'xlsx' : 'pdf');
      } else {
        await handleMobileDownload(
            bytes, 'trabajos', formato == 'excel' ? 'xlsx' : 'pdf');
      }
    } catch (e) {
      errorMessage = 'Error al generar reporte: $e';
      debugPrint('Error en generateWorksReport: $e');
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }
}
