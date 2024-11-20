import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_android/models/modulo_user_meetings.dart';
import 'package:flutter_web_android/services/api_service_usuario.dart';
import 'package:flutter_web_android/storage/storage_services.dart';

class CalendarViewModel extends ChangeNotifier {
  final ApiServiceUsuario _apiService = ApiServiceUsuario();
  List<MeetingModel> meetings = [];
  bool isLoading = false;
  String? errorMessage;

  DateTime? selectedDate; // Agregar para manejar la selección

  Future<void> initialize() async {
    try {
      isLoading = true;
      notifyListeners();

      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      try {
        meetings = await _apiService.getAllMeetings(token.accessToken);
        // Agregar logs de depuración
        debugPrint('Número total de reuniones cargadas: ${meetings.length}');
        for (var meeting in meetings) {
          debugPrint(
              'Reunión encontrada: ID=${meeting.id}, Fecha=${meeting.fecha}, Estado=${meeting.estado}');
        }

        selectedDate = null;
        errorMessage = null;
      } on DioException catch (e) {
        debugPrint('Error DioException: ${e.message}');
        debugPrint('Response: ${e.response?.data}');
        if (e.response?.statusCode == 404) {
          meetings = [];
          selectedDate = null;
          errorMessage = null;
        } else {
          errorMessage = 'Error de conexión';
        }
      }
    } catch (e) {
      debugPrint('Error general: $e');
      errorMessage = 'Error al cargar las reuniones';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearSelection() {
    selectedDate = null;
    notifyListeners();
  }

  List<MeetingModel> get getMeetings => meetings;

  MeetingModel? getMeetingForDate(DateTime date) {
    return meetings.firstWhere(
      (meeting) => isSameDay(meeting.fecha, date),
      orElse: () => MeetingModel(
        id: -1,
        fecha: date,
        lugar: '',
        agenda: '',
        estado: '',
      ),
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
