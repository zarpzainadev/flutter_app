import 'package:dio/dio.dart';
import 'package:flutter_web_android/connection/api_connection_user.dart';
import 'package:flutter_web_android/models/modulo_profile_usuario.dart';
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

  Future<UserProfileResponse> getUserProfile(String token) async {
    try {
      final response = await _dio.get(
        '/profile/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        return UserProfileResponse.fromJson(response.data);
      }

      if (response.statusCode == 401) {
        throw Exception(
            'No autorizado - Token inválido o usuario no encontrado');
      }

      throw Exception(
        response.data['detail'] ?? 'Error al obtener perfil del usuario',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('No autorizado');
      }
      throw Exception('Error de red: ${e.message}');
    }
  }

  Future<PhotoResponse> getUserPhoto(String token) async {
    try {
      final response = await _dio.get(
        '/profile/me/photo',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          responseType: ResponseType.bytes,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        return PhotoResponse(
          bytes: response.data,
          mimeType: response.headers.value('content-type') ?? 'image/jpeg',
        );
      }

      if (response.statusCode == 404) {
        throw UserPhotoException(
          message: 'Foto no encontrada para este usuario',
          statusCode: 404,
        );
      }

      throw UserPhotoException(
        message: 'Error al obtener la foto del usuario',
        statusCode: response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      throw UserPhotoException(
        message: 'Error de red: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }

  Future<PasswordChangeResponse> changePassword(
      String token, String newPassword) async {
    try {
      final response = await _dio.post(
        '/profile/change-password',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status! < 500,
        ),
        data: PasswordChangeRequest(newPassword: newPassword).toJson(),
      );

      if (response.statusCode == 200) {
        return PasswordChangeResponse.fromJson(response.data);
      }

      throw PasswordChangeException(
        message: response.data['detail'] ?? 'Error al cambiar la contraseña',
        statusCode: response.statusCode ?? 500,
      );
    } on DioException catch (e) {
      throw PasswordChangeException(
        message: 'Error de red: ${e.message}',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }
}
