// list_meeting_viewmodel.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/create_meeting_modal.dart';
import 'package:flutter_web_android/components/table_flexible.dart';
import 'package:flutter_web_android/components/update_meeting_modal.dart';
import 'package:flutter_web_android/components/upload_acta_modal.dart';
import 'package:flutter_web_android/screens/assistance/assistance_screen.dart';
import 'package:flutter_web_android/screens/home_screen.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import '../../../helpers/mobile_download_helper.dart'
    if (dart.library.html) '../../../helpers/web_download_helper.dart';
import 'package:intl/intl.dart';

class ListMeetingViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService;

  final _cache = <int, MeetingResponse>{};
  final _debouncer = Debouncer(milliseconds: 500);

  bool isLoading = false;
  bool isInitialLoading = false;
  String? errorMessage;
  List<MeetingListResponse> meetings = [];
  Timer? _refreshTimer;
  bool _disposed = false;

  ListMeetingViewModel({ApiServiceAdmin? apiService})
      : _apiService = apiService ?? ApiServiceAdmin() {
    _initializeRefreshTimer();
    initialize();
  }

  // Configuración de columnas para la tabla
  List<ColumnConfig> get columns => [
      ColumnConfig(label: 'Título', field: 'titulo', width: 200), // Nueva columna
      ColumnConfig(label: 'Agenda', field: 'descripcion', width: 300),
      ColumnConfig(label: 'Fecha', field: 'fecha', width: 150),
      ColumnConfig(label: 'Lugar', field: 'lugar', width: 150),
      ColumnConfig(label: 'Estado', field: 'estado', width: 100),
    ];

  // Acciones de la tabla
  // In list_meeting_viewmodel.dart

  List<TableAction> getActions(BuildContext context) => [
        TableAction(
          icon: Icons.edit,
          color: const Color(0xFF1E40AF),
          tooltip: 'Actualizar Reunión',
          onPressed: (row) => onUpdateMeeting(context, row),
        ),
        TableAction(
          icon: Icons.publish,
          color: Colors.green,
          tooltip: 'Publicar Reunión',
          onPressed: (row) {
            if (row['estado'] == 'Publicada' || row['estado'] == 'Inactiva') {
              return null;
            }
            onPublish(context, row);
          },
          getColor: (row) {
            switch (row['estado']) {
              case 'Publicada':
                return Colors.grey;
              case 'Inactiva':
                return Colors.red.shade300;
              default:
                return Colors.green;
            }
          },
          getTooltip: (row) {
            switch (row['estado']) {
              case 'Publicada':
                return 'Ya está publicada';
              case 'Inactiva':
                return 'No se puede publicar una reunión inactiva';
              default:
                return 'Publicar Reunión';
            }
          },
        ),
        TableAction(
          icon: Icons.description,
          color: Colors.orange,
          tooltip: 'Registrar Acta',
          onPressed: (row) => onRegisterActa(context, row),
        ),
        TableAction(
          icon: Icons.people,
          color: Colors.blue,
          tooltip: 'Gestionar Asistencia',
          onPressed: (row) => onManageAssistance(context, row),
          // Solo permitir gestionar asistencia si la reunión está publicada
          getTooltip: (row) {
            if (row['estado'] != 'Publicada') {
              return 'Solo disponible para reuniones publicadas';
            }
            return 'Gestionar Asistencia';
          },
          getColor: (row) {
            if (row['estado'] != 'Publicada') {
              return Colors.grey;
            }
            return Colors.blue;
          },
        ),
      ];

  void onManageAssistance(
      BuildContext context, Map<String, dynamic> row) async {
    if (row['estado'] != 'Publicada') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Solo se puede gestionar asistencia de reuniones publicadas'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Verificar si tiene asistencia registrada
    final bool tieneAsistencia = row['tiene_asistencia'] as bool;

    // En lugar de Navigator.push, usar el método changeScreen del HomeScreen
    if (context.findAncestorStateOfType<HomeScreenState>() != null) {
      context.findAncestorStateOfType<HomeScreenState>()?.changeScreen(
            AssistanceScreen(
              title: tieneAsistencia
                  ? 'Editar Asistencia'
                  : 'Registrar Asistencia',
              reunionId: row['id'],
              isEditing:
                  tieneAsistencia, // Pasamos el estado para controlar el modo
            ),
          );
    }
  }

  // En list_meeting_viewmodel.dart
  void onRegisterActa(BuildContext context, Map<String, dynamic> row) async {
  if (row['estado'] != 'Publicada') {
    debugPrint('Solo se pueden registrar actas para reuniones publicadas');
    return;
  }

  final result = await showUploadActaModal(context, row['id'], this);

  if (result != null) {
    try {
      // Ya no establecemos isLoading aquí
      final meetingId = row['id'] as int;
      final fileBytes = result['file'] as List<int>;
      final fileName = result['fileName'] as String;

      final success = await createAndUploadActa(
        meetingId,
        fileBytes,
        fileName,
      );

      if (success && context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Éxito'),
            content: const Text('Acta registrada exitosamente'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('Error al registrar acta: $e');
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Error al registrar acta: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}

  // Métodos temporales para las acciones
  void onUpdateMeeting(BuildContext context, Map<String, dynamic> row) async {
    final result = await showUpdateMeetingModal(context, row);

    if (result != null) {
      try {
        isLoading = true;
        _safeNotifyListeners();

        final token = await StorageService.getToken();
        if (token == null) {
          throw Exception('No hay sesión activa');
        }

        final meeting = MeetingUpdate(
  fecha: result['fecha'] as DateTime,
  lugar: result['lugar'] as String,
  agenda: result['agenda'] as Map<String, dynamic>,
  estado: result['estado'] as String,
  cabecera_invitacion: result['titulo'] as String, // Incluir el título
);

        debugPrint('Actualizando reunión con datos:');
        debugPrint('ID: ${result['id']}');
        debugPrint('Fecha: ${meeting.fecha}');
        debugPrint('Lugar: ${meeting.lugar}');
        debugPrint('Agenda: ${meeting.agenda}');
        debugPrint('Estado: ${meeting.estado}');

        await _apiService.updateMeeting(
            token.accessToken, result['id'] as int, meeting);

        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Éxito'),
              content: const Text('Reunión actualizada exitosamente'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }

        await listMeetings(forceRefresh: true);
      } catch (e) {
        errorMessage = 'Error al actualizar la reunión: $e';
        debugPrint(errorMessage);
      } finally {
        isLoading = false;
        _safeNotifyListeners();
      }
    }
  }

  void onPublishMeeting(BuildContext context, Map<String, dynamic> row) {
    debugPrint('Publicar reunión: ${row['id']}');
    // Implementación futura
  }

  // Método para crear nueva reunión (se usará en el botón)
  // En list_meeting_viewmodel.dart, modificar:
  void onCreateMeeting(BuildContext context) async {
  final result = await showCreateMeetingModal(context);

  if (result != null) {
    debugPrint('=== DEBUG VIEW MODEL ===');
    debugPrint('Datos recibidos del modal:');
    debugPrint(jsonEncode(result));
    
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('No hay sesión activa');
      }

      // Convertir la fecha string a DateTime
      final meeting = MeetingCreate(
        fecha: DateTime.parse(result['fecha'] as String), // Aquí está el cambio
        lugar: result['lugar'] as String,
        agenda: result['agenda'] as Map<String, dynamic>,
        cabecera_invitacion: result['titulo'] as String,
      );

      debugPrint('Datos completos a enviar:');
      debugPrint(jsonEncode(meeting));

      await _apiService.createMeeting(token.accessToken, meeting);

        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Éxito'),
              content: const Text('Reunión creada exitosamente'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }

        await listMeetings(forceRefresh: true);
      } catch (e) {
        errorMessage = 'Error al crear la reunión: $e';
        debugPrint(errorMessage);
      } finally {
        isLoading = false;
        _safeNotifyListeners();
      }
    }
  }

  Future<void> initialize() async {
    await listMeetings();
  }

  Future<void> listMeetings({bool forceRefresh = false}) async {
    if (isLoading && !forceRefresh) return;

    try {
      isLoading = true;
      errorMessage = null;
      _safeNotifyListeners();

      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('No hay sesión activa');
      }

      debugPrint('Obteniendo reuniones...');
      meetings = await _apiService.listMeetings(token.accessToken);
      debugPrint('Reuniones obtenidas: ${meetings.length}');
    } on Exception catch (e) {
      debugPrint('Exception en listMeetings ViewModel: $e');
      errorMessage = e.toString();
      meetings = [];
    } catch (e) {
      debugPrint('Error inesperado en listMeetings ViewModel: $e');
      errorMessage = 'Error inesperado: $e';
      meetings = [];
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<bool> createMeeting(MeetingCreate meeting) async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await _getToken();
      await _apiService.createMeeting(token, meeting);
      await listMeetings(forceRefresh: true);
      return true;
    } catch (e) {
      errorMessage = 'Error al crear reunión: $e';
      debugPrint('Error en createMeeting: $e');
      return false;
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<bool> updateMeeting(int meetingId, MeetingUpdate meeting) async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await _getToken();
      await _apiService.updateMeeting(token, meetingId, meeting);
      await listMeetings(forceRefresh: true);
      return true;
    } catch (e) {
      errorMessage = 'Error al actualizar reunión: $e';
      debugPrint('Error en updateMeeting: $e');
      return false;
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<bool> publishMeeting(int meetingId) async {
  try {
    isLoading = true;
    _safeNotifyListeners();

    debugPrint('Publicando reunión: $meetingId');
    final token = await _getToken();

    // Agregar log para ver la respuesta
    final response = await _apiService.publishMeeting(token, meetingId);
    debugPrint('Respuesta de publicación: ${jsonEncode(response.toJson())}');

    await listMeetings(forceRefresh: true);
    return true;
  } catch (e) {
    errorMessage = 'Error al publicar reunión: $e';
    debugPrint('Error en publishMeeting: $e');
    return false;
  } finally {
    isLoading = false;
    _safeNotifyListeners();
  }
}

  //funciones para la creacion y subida del acta
  Future<bool> createAndUploadActa(
      int meetingId, List<int> fileBytes, String fileName) async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await _getToken();

      // Paso 1: Crear el acta
      final actaResponse = await _apiService.createActa(token, meetingId);

      // Paso 2: Subir el contenido usando el ID del acta creada
      await _apiService.uploadContenidoActa(
        token,
        actaResponse.id,
        fileBytes,
        fileName,
      );

      await listMeetings(forceRefresh: true);
      return true;
    } catch (e) {
      errorMessage = 'Error al crear/subir acta: $e';
      debugPrint('Error en createAndUploadActa: $e');
      return false;
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<bool> uploadActaContent(
      int actaId, List<int> fileBytes, String fileName) async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await _getToken();
      await _apiService.uploadContenidoActa(
        token,
        actaId,
        fileBytes,
        fileName,
      );

      await listMeetings(forceRefresh: true);
      return true;
    } catch (e) {
      errorMessage = 'Error al subir contenido del acta: $e';
      debugPrint('Error en uploadActaContent: $e');
      return false;
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<List<ActaDetailResponse>> getActasByMeeting(int reunionId) async {
  try {
    final token = await _getToken();
    final actas = await _apiService.getActasByReunion(token, reunionId);
    return actas;
  } catch (e) {
    // No lanzamos error si es 404, simplemente retornamos lista vacía
    if (e is ActaError && e.statusCode == 404) {
      return [];
    }
    debugPrint('Error al obtener actas: $e');
    throw e; // Propagamos otros errores
  }
}

Future<bool> deleteActa(int actaId) async {
  try {
    // Quitamos el isLoading global
    final token = await _getToken();
    await _apiService.deleteActa(token, actaId);
    return true;
  } on ActaError catch (e) {
    errorMessage = 'Error al eliminar acta: ${e.message}';
    debugPrint('ActaError en deleteActa: ${e.message}');
    return false;
  } catch (e) {
    errorMessage = 'Error inesperado al eliminar acta: $e';
    debugPrint('Error inesperado en deleteActa: $e');
    return false;
  }
}

  Future<void> generateMeetingsReport(String formato) async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await _getToken();
      final bytes = await _apiService.generateMeetingsReport(token, formato);

      final extension = formato == 'excel' ? 'xlsx' : 'pdf';

      // Manejar la descarga según la plataforma
      if (kIsWeb) {
        await handleMeetingWebDownload(bytes, extension);
      } else {
        await handleMeetingMobileDownload(bytes, extension);
      }
    } catch (e) {
      errorMessage = 'Error al generar reporte: $e';
      debugPrint('Error en generateMeetingsReport: $e');
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  List<Map<String, dynamic>> transformMeetingData(
    List<MeetingListResponse> meetings) {
  return meetings.map((meeting) {
    return {
      'id': meeting.id,
      'titulo': meeting.cabecera_invitacion,
      'descripcion': meeting.agenda,
      'fecha': _formatDate(meeting.fecha),
      'lugar': meeting.lugar,
      'estado': meeting.estado,
      'tiene_asistencia': meeting.tiene_asistencia
    };
  }).toList();
}

  void onViewDetails(BuildContext context, Map<String, dynamic> row) {
    // Implementar vista de detalles
    debugPrint('Ver detalles de reunión: ${row['id']}');
  }

  void onEdit(BuildContext context, Map<String, dynamic> row) {
    // Implementar edición
    debugPrint('Editar reunión: ${row['id']}');
  }

  void onPublish(BuildContext context, Map<String, dynamic> row) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Publicar Reunión'),
        content: const Text('¿Está seguro de publicar esta reunión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await publishMeeting(row['id']);

              if (success && context.mounted) {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Éxito'),
                    content: const Text('Reunión Publicada'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );

                // Refrescar la lista
                await listMeetings(forceRefresh: true);
              }
            },
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  Future<String> _getToken() async {
    final token = await StorageService.getToken();
    if (token == null || token.accessToken.isEmpty) {
      throw Exception('Token no disponible o inválido');
    }
    return token.accessToken;
  }

  void _initializeRefreshTimer() {
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => listMeetings(forceRefresh: true),
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _refreshTimer?.cancel();
    if (!kIsWeb) {
      // Limpieza adicional para móvil
      _cache.clear();
    }
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
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
