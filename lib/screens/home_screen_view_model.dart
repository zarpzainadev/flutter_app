import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_web_android/models/login_model.dart';
import 'package:flutter_web_android/models/modulo_user_meetings.dart';
import 'package:flutter_web_android/screens/login_screen/login_screen.dart';
import 'package:flutter_web_android/services/api_service_login.dart';
import 'package:flutter_web_android/services/api_service_usuario.dart';
import 'package:flutter_web_android/storage/storage_services.dart';
import 'package:intl/intl.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final ApiServiceUsuario _apiService = ApiServiceUsuario();

  Meeting? nextMeeting;
  String? errorMessage;
  bool hasNoMeetings = false;
  bool isLoading = false;
  bool shouldShowModal = true;
  bool _disposed = false;

  Future<void> initialize() async {
    try {
      await fetchNextMeeting();
    } catch (e) {
      debugPrint('Error en initialize: $e');
    }
  }

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

  Meeting? get meeting => nextMeeting;

  Future<void> logout(BuildContext context) async {
    ApiService _apiService = ApiService();
    try {
      final token = await StorageService.getToken();
      if (token != null) {
        // Primero hacer la llamada API con el token
        await _apiService.logoutSession(token.accessToken);

        // Después de éxito, limpiar storage
        await StorageService.clearAll();

        // Finalmente navegar
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  Future<List<String>> fetchUserAllowedGroups() async {
    try {
      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      final apiService = ApiService();
      final response =
          await apiService.getScreenGroupsForCurrentUser(token.accessToken);

      // Extraer solo los valores de 'identifier' de la respuesta
      print('Token guardado: $response');

      List<String> userAllowedGroups = response.screenGroups
          .map((screenGroup) => screenGroup.identifier)
          .toList();

      return userAllowedGroups;
    } catch (e) {
      throw Exception('Error al obtener los grupos de pantallas: $e');
    }
  }

  Future<void> fetchNextMeeting() async {
    if (_disposed) return;
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      try {
        nextMeeting = await _apiService.getNextMeeting(token.accessToken);
        hasNoMeetings = false;
        errorMessage = null;
        shouldShowModal = true; // Mantener modal visible
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          hasNoMeetings = true;
          nextMeeting = null;
          errorMessage = null;
          shouldShowModal =
              true; // Mantener modal visible para mostrar "no hay reuniones"
        } else {
          errorMessage = 'Error de conexión';
          hasNoMeetings = false;
          shouldShowModal = true; // Mantener modal visible para mostrar error
        }
      }
    } catch (e) {
      errorMessage = 'Error al obtener la próxima reunión';
      hasNoMeetings = false;
      shouldShowModal = true; // Mantener modal visible para mostrar error
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  String getFormattedDate() {
    if (isLoading) return 'Cargando...';
    if (hasNoMeetings) return 'No hay reuniones programadas';
    if (nextMeeting == null) return '';
    return DateFormat('dd/MM/yyyy').format(nextMeeting!.fecha);
  }

  List<String> getAgendaItems() {
    if (isLoading) return ['Cargando agenda...'];
    if (hasNoMeetings) return ['No hay reuniones programadas actualmente'];
    if (nextMeeting == null) return [];
    return [nextMeeting!.agenda];
  }

  Future<void> refreshAccessToken(BuildContext context) async {
    try {
      isLoading = true;
      _safeNotifyListeners();

      final token = await StorageService.getToken();
      if (token == null) {
        throw Exception('No hay token almacenado');
      }

      final ApiService _apiService = ApiService();
      final newToken = await _apiService.refreshToken(token.refreshToken);

      final updatedToken = Token(
        accessToken: newToken.accessToken,
        refreshToken: token.refreshToken,
        tokenType: newToken.tokenType,
      );

      await StorageService.saveToken(updatedToken);
    } on RefreshTokenException catch (e) {
      if (e.statusCode == 401) {
        errorMessage = 'Sesión expirada';
        await logout(context); // Usar el contexto pasado como parámetro
      } else {
        errorMessage = 'Error al refrescar sesión';
      }
    } catch (e) {
      errorMessage = 'Error inesperado: $e';
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }
}
