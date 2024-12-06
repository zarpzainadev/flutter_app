import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';
import '../../../helpers/mobile_download_helper.dart'
    if (dart.library.html) '../../../helpers/web_download_helper.dart';

class CalendarViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService = ApiServiceAdmin();
  List<MeetingListResponse> meetings = [];
  bool _disposed = false;
  bool isLoading = false;
  String? errorMessage;

  DateTime? selectedDate;

  final ValueNotifier<List<MeetingListResponse>> selectedDayEvents =
      ValueNotifier([]);
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  // Getters
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  List<MeetingListResponse> get getMeetings => meetings;

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    selectedDayEvents.dispose();
    _disposed = true;
    super.dispose();
  }

  void updateSelectedDay(DateTime selected, DateTime focused) {
    _selectedDay = selected;
    _focusedDay = focused;
    _updateSelectedDayEvents();
    _safeNotifyListeners();
  }

  void _updateSelectedDayEvents() {
    selectedDayEvents.value = meetings.where((meeting) {
      return isSameDay(meeting.fecha, _selectedDay);
    }).toList();
  }

  Future<void> initialize() async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      try {
        meetings = await _apiService.listMeetings(token.accessToken);

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
      _safeNotifyListeners();
    }
  }

  void clearSelection() {
    selectedDate = null;
    _safeNotifyListeners();
  }

  MeetingListResponse? getMeetingForDate(DateTime date) {
    return meetings.firstWhere(
      (meeting) => isSameDay(meeting.fecha, date),
      orElse: () => MeetingListResponse(
        id: -1,
        fecha: date,
        lugar: '',
        agenda: '',
        estado: '',
        creador_id: -1,
        tiene_asistencia: false,
      ),
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> generateAttendanceReport(String formato,
      {int? reunionId}) async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await StorageService.getToken();
      if (token == null) throw Exception('Token no disponible');

      final bytes = await _apiService.generateAttendanceReport(
          token.accessToken,
          formato: formato,
          reunionId: reunionId);

      if (kIsWeb) {
        await handleWebDownload(
            bytes, 'asistencias', formato == 'excel' ? 'xlsx' : 'pdf');
      } else {
        await handleMobileDownload(
            bytes, 'asistencias', formato == 'excel' ? 'xlsx' : 'pdf');
      }
    } catch (e) {
      errorMessage = 'Error al generar reporte: $e';
      debugPrint('Error en generateAttendanceReport: $e');
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }
}
