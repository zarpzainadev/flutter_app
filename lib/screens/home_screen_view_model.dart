import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_web_android/models/login_model.dart';
import 'package:flutter_web_android/screens/login_screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final _dio = Dio();

  Future<void> logout(BuildContext context) async {
    try {
      // Obtener el refresh token desde SharedPreferences
      final token = await TokenHelper.getToken();
      print(
          '2. Token obtenido: ${token != null ? "Token existe" : "Token es null"}');
      if (token == null) {
        throw Exception('No hay sesión activa para cerrar.');
      }

      // Hacer la solicitud de cierre de sesión
      final response = await _dio.post(
        '/auth/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${token.accessToken}',
          },
        ),
      );

      // Parsear la respuesta
      final logoutResponse = LogoutResponse.fromJson(response.data);

      // Eliminar el token de SharedPreferences
      await TokenHelper.deleteToken();

      // Navegar a la pantalla de inicio de sesión
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );

      // Notificar a los widgets observadores
      notifyListeners();
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('No hay sesión activa para cerrar.');
      }
      throw Exception('Error al cerrar sesión: ${e.message}');
    } catch (e) {
      // Manejar otros errores
      rethrow;
    }
  }
}

// Clase auxiliar para manejar el token
class TokenHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<Token?> getToken() async {
    if (_prefs == null) await init();

    try {
      final tokenJson = _prefs!.getString('token');
      if (tokenJson == null) return null;

      final tokenMap = json.decode(tokenJson);
      return Token.fromJson(tokenMap);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  static Future<bool> deleteToken() async {
    if (_prefs == null) await init();
    return await _prefs!.remove('token');
  }
}

class Token {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  Token({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
    );
  }
}
