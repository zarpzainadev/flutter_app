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
  Future<LogoutResponse> logoutSession(String token) async {
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
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  // Método para obtener los grupos de pantallas
  Future<UserScreenGroupsResponse> getScreenGroupsForCurrentUser(
      String token) async {
    try {
      // Configurar los encabezados para incluir el token
      _dio.options.headers = {
        'Authorization': 'Bearer $token', // Usar el token en los encabezados
      };

      // Hacer la solicitud GET a la nueva ruta
      final response = await _dio.get('/auth/screen-group');

      if (response.statusCode == 200) {
        // Convertir la respuesta en el modelo adecuado
        return UserScreenGroupsResponse.fromJson(response.data);
      } else {
        throw Exception('Error al obtener los grupos de pantallas');
      }
    } catch (e) {
      // Manejar errores de conexión o cualquier otro tipo
      throw Exception('Error de conexión: $e');
    }
  }
}
