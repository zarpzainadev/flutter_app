// list_user_viewmodel.dart
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/admin_change_password_modal.dart';
import 'package:flutter_web_android/components/cambio_estado_usuario_modal.dart';
import 'package:flutter_web_android/components/table_flexible.dart';
import 'package:flutter_web_android/screens/Users/user_edit/user_edit_screen.dart';
import 'package:flutter_web_android/screens/home_screen.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import '../../../helpers/mobile_download_helper.dart'
    if (dart.library.html) '../../../helpers/web_download_helper.dart';
import '../../../models/modulo_gestion_usuario_model.dart';

class ListUserViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService;
  final _cache = <int, UserDetail>{};
  final _debouncer = Debouncer(milliseconds: 500);
  bool isLoading = false;
  bool _disposed = false;
  String? errorMessage;
  List<User> users = [];
  Timer? _refreshTimer;

  ListUserViewModel({ApiServiceAdmin? apiService})
      : _apiService = apiService ?? ApiServiceAdmin();

  // Mantener columnas existentes
  List<ColumnConfig> get columns => [
        ColumnConfig(label: 'DNI', field: 'dni', width: 100),
        ColumnConfig(label: 'Email', field: 'email', width: 200),
        ColumnConfig(
            label: 'Nombre Completo', field: 'nombre_completo', width: 200),
        ColumnConfig(
            label: 'Fecha de Nacimiento',
            field: 'fecha_nacimiento',
            width: 150),
        ColumnConfig(label: 'Celular', field: 'celular', width: 100),
        ColumnConfig(label: 'Rol', field: 'rol_nombre', width: 100),
        ColumnConfig(
            label: 'Estado', field: 'estado_usuario_nombre', width: 150),
      ];

  List<TableAction> getActions(BuildContext context) => [
        TableAction(
          icon: Icons.visibility,
          color: const Color(0xFF6B7280),
          tooltip: 'Ver Detalles',
          onPressed: (row) => onViewDetails(context, row),
        ),
        TableAction(
          icon: Icons.edit,
          color: const Color(0xFF1E40AF),
          tooltip: 'Editar',
          onPressed: (row) => onEdit(context, row), // Pasar context aquí
        ),
        TableAction(
          icon: Icons.loop,
          color: Colors.orange,
          tooltip: 'Cambiar Estado',
          onPressed: (row) => showChangeEstadoModal(context, row),
        ),
        TableAction(
        icon: Icons.password,
        color: Colors.purple,
        tooltip: 'Cambiar Contraseña',
        onPressed: (row) => showChangePasswordModal(context, row),
      ),
      ];

  Future<void> initialize() async {
    await listUsers();
  }

  Future<void> listUsers({bool forceRefresh = false}) async {
    if (isLoading && !forceRefresh) return;

    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await _getToken();
      users = await _apiService.listUsers(token);
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Error al cargar usuarios: $e';
      debugPrint('Error en listUsers: $e');
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<bool> cambiarEstadoUsuario(
      CambioEstadoCreate cambio, List<Uint8List> documentos) async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await _getToken();
      final response = await _apiService.cambiarEstadoUsuario(token, cambio);

      if (documentos.isNotEmpty) {
        await _subirDocumentosCambioEstado(token, response.id, documentos);
      }

      _debouncer.run(() => listUsers(forceRefresh: true));
      return true;
    } catch (e) {
      errorMessage = 'Error en cambio de estado: $e';
      debugPrint('Error en cambiarEstadoUsuario: $e');
      return false;
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<bool> updateUserPassword(int userId, String newPassword) async {
  try {
    isLoading = true;
    _safeNotifyListeners();

    final token = await _getToken();
    await _apiService.updateUserPassword(token, userId, newPassword);
    return true;
  } catch (e) {
    errorMessage = 'Error al actualizar contraseña: $e';
    debugPrint(errorMessage);
    return false;
  } finally {
    isLoading = false;
    _safeNotifyListeners();
  }
}

// Agregar este método para mostrar el modal
void showChangePasswordModal(BuildContext context, Map<String, dynamic> row) {
  showDialog(
    context: context,
    builder: (context) => AdminChangePasswordModal(
      onChangePassword: (newPassword) async {
        final success = await updateUserPassword(row['id'], newPassword);
        
        if (success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contraseña actualizada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
    ),
  );
}

  Future<void> generateReport({
    required String estadoNombre,
    required String formato,
    required String title,
  }) async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await _getToken();
      final reportRequest = ReportRequest(
        estado_nombre: estadoNombre,
        formato: formato,
        template: ReportTemplate(title: title),
      );

      final bytes = await _apiService.generateUserReport(token, reportRequest);
      final extension = formato == 'excel' ? 'xlsx' : formato;

      if (kIsWeb) {
        await handleWebDownload(bytes, estadoNombre, extension);
      } else {
        await handleMobileDownload(bytes, estadoNombre, extension);
      }
    } catch (e) {
      errorMessage = 'Error al generar reporte: $e';
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  List<Map<String, dynamic>> transformUserData(List<User> users) {
    return users.map((user) {
      return {
        'dni': user.dni,
        'email': user.email,
        'nombre_completo':
            '${user.nombres} ${user.apellidos_paterno} ${user.apellidos_materno}',
        'fecha_nacimiento': _formatDate(user.fecha_nacimiento),
        'celular': user.celular,
        'rol_nombre': user.rol_nombre,
        'estado_usuario_nombre': user.estado_usuario_nombre,
        'id': user.id,
      };
    }).toList();
  }

  // Métodos auxiliares
  Future<String> _getToken() async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('Token no disponible');
    return token.accessToken;
  }

  Future<void> _subirDocumentosCambioEstado(
    String token,
    int cambioId,
    List<Uint8List> documentos,
  ) async {
    final files = documentos
        .map((doc) => MultipartFile.fromBytes(
              doc,
              filename:
                  'cambio_estado_${DateTime.now().millisecondsSinceEpoch}.pdf',
              contentType: MediaType('application', 'pdf'),
            ))
        .toList();

    await _apiService.subirDocumentosCambioEstado(token, cambioId, files);
  }

  void _initializeRefreshTimer() {
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => listUsers(forceRefresh: true),
    );
  }

  void onEdit(BuildContext context, Map<String, dynamic> row) {
    final userId = row['id'];
    // Usar HomeScreenState para cambiar la pantalla
    context.findAncestorStateOfType<HomeScreenState>()?.changeScreen(
          UserEditScreen(
            userId: userId,
          ),
        );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void onViewDetails(BuildContext context, Map<String, dynamic> row) {
    final userId = row['id'];
    context
        .findAncestorStateOfType<HomeScreenState>()
        ?.navigateToUserDetail(userId);
  }

  @override
  void dispose() {
    _disposed = true;
    _refreshTimer?.cancel();
    _cache.clear();
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  // list_user_viewmodel.dart
  void showChangeEstadoModal(BuildContext context, Map<String, dynamic> row) {
    if (_disposed) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ChangeEstadoModal(
        estadoActual: row['estado_usuario_nombre'],
        onSubmit: (estadoId, comentario, fileBytes) async {
          try {
            final cambio = CambioEstadoCreate(
              usuario_id: row['id'],
              estado_nuevo_id: estadoId,
              comentario: comentario,
            );

            // 1. Cerrar modal principal
            Navigator.pop(dialogContext);

            // 2. Procesar cambio de estado
            final success = await cambiarEstadoUsuario(
                cambio, [Uint8List.fromList(fileBytes)]);

            // 3. Si fue exitoso, mostrar mensaje y actualizar lista
            if (success && context.mounted) {
              // Actualizar lista
              await listUsers(forceRefresh: true);

              // Mostrar mensaje de éxito
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Estado actualizado correctamente'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $e'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
