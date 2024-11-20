// list_meeting_viewmodel.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/create_meeting_modal.dart';
import 'package:flutter_web_android/components/table_flexible.dart';
import 'package:flutter_web_android/components/update_meeting_modal.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:intl/intl.dart';

class ListMeetingViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService;

  final _cache = <int, MeetingResponse>{};
  final _debouncer = Debouncer(milliseconds: 500);

  bool isLoading = false;
  bool isInitialLoading = false;
  String? errorMessage;
  List<MeetingResponse> meetings = [];
  Timer? _refreshTimer;

  ListMeetingViewModel({ApiServiceAdmin? apiService})
      : _apiService = apiService ?? ApiServiceAdmin() {
    _initializeRefreshTimer();
    initialize();
  }

  // Configuración de columnas para la tabla
  List<ColumnConfig> get columns => [
        ColumnConfig(label: 'Título', field: 'titulo', width: 200),
        ColumnConfig(label: 'Descripción', field: 'descripcion', width: 300),
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
          color: Colors.green, // Default color
          tooltip: 'Publicar Reunión',
          onPressed: (row) {
            if (row['estado'] == 'Publicada') {
              return null;
            }
            onPublish(context, row);
          },
          getColor: (row) =>
              row['estado'] == 'Publicada' ? Colors.grey : Colors.green,
          getTooltip: (row) => row['estado'] == 'Publicada'
              ? 'Ya está publicada'
              : 'Publicar Reunión',
        ),
      ];

  // Métodos temporales para las acciones
  void onUpdateMeeting(BuildContext context, Map<String, dynamic> row) async {
    final result = await showUpdateMeetingModal(context, row);

    if (result != null) {
      try {
        isLoading = true;
        notifyListeners();

        final token = await StorageService.getToken();
        if (token == null) {
          throw Exception('No hay sesión activa');
        }

        final meeting = MeetingUpdate(
          fecha: result['fecha'] as DateTime,
          lugar: result['lugar'] as String,
          agenda: result['agenda'] as String,
        );

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
        notifyListeners();
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
      try {
        isLoading = true;
        notifyListeners();

        final token = await StorageService.getToken();
        if (token == null) {
          throw Exception('No hay sesión activa');
        }

        final meeting = MeetingCreate(
          fecha: result['fecha'] as DateTime,
          lugar: result['lugar'] as String,
          agenda: result['agenda'] as String,
        );

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
        notifyListeners();
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
      notifyListeners();

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
      notifyListeners();
    }
  }

  Future<bool> createMeeting(MeetingCreate meeting) async {
    try {
      isLoading = true;
      notifyListeners();

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
      notifyListeners();
    }
  }

  Future<bool> updateMeeting(int meetingId, MeetingUpdate meeting) async {
    try {
      isLoading = true;
      notifyListeners();

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
      notifyListeners();
    }
  }

  Future<bool> publishMeeting(int meetingId) async {
    try {
      isLoading = true;
      notifyListeners();

      final token = await _getToken();
      await _apiService.publishMeeting(token, meetingId);
      await listMeetings(forceRefresh: true);
      return true;
    } catch (e) {
      errorMessage = 'Error al publicar reunión: $e';
      debugPrint('Error en publishMeeting: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> transformMeetingData(
      List<MeetingResponse> meetings) {
    return meetings.map((meeting) {
      return {
        'id': meeting.id,
        'titulo': meeting.agenda, // Cambiado de titulo a agenda
        'descripcion': meeting.agenda, // Usando agenda como descripción
        'fecha': _formatDate(meeting.fecha),
        'lugar': meeting.lugar,
        'estado': meeting.estado,
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
    _refreshTimer?.cancel();
    _cache.clear();
    super.dispose();
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
