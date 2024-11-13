import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_web_android/connection/api_connection_login.dart';
import '../models/login_model.dart';

class ApiService {
  final Dio _dio = ApiConnection.getDioInstance();

//ruta para iniciar sesion
  Future<Token> login(LoginRequest loginRequest) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: jsonEncode(loginRequest.toJson()),
      );

      if (response.statusCode == 200) {
        return Token.fromJson(response.data);
      } else {
        throw Exception('Error al iniciar sesión');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ruta para hacer cerrar sesion
  Future<LogoutResponse> logout(String token) async {
    try {
      final response = await _dio.post(
        '/auth/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return LogoutResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('No hay sesión activa para cerrar.');
      }
      throw Exception('Error al cerrar sesión: ${e.message}');
    }
  }
}
