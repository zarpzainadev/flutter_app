import 'package:dio/dio.dart';
import 'package:flutter_web_android/connection/api_connection_user.dart';
import 'package:flutter_web_android/models/modulo_user_meetings.dart';

class ApiServiceUsuario {
  final Dio _dio = ApiConnection.getDioInstance();

  Future<Meeting> getNextMeeting(String token) async {
    try {
      final response = await _dio.get(
        '/meetings/next',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Meeting.fromJson(response.data);
      } else {
        throw Exception('Error al obtener la próxima reunión');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<MeetingModel>> getAllMeetings(String token) async {
    try {
      final response = await _dio.get(
        '/meetings/all',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((meeting) => MeetingModel.fromJson(meeting))
            .toList();
      } else {
        throw Exception('Error al obtener las reuniones');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
