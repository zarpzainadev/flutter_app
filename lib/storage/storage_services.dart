import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_model.dart';

class StorageService {
  static const String tokenKey = 'auth_token';

  // Instancia de SharedPreferences
  static SharedPreferences? _prefs;

  // Inicializar SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // En storage_services.dart

static Future<void> saveOrganizacionDescripcion(String descripcion) async {
  if (_prefs == null) await init();
  await _prefs!.setString('organizacion_descripcion', descripcion);
}

static Future<String?> getOrganizacionDescripcion() async {
  if (_prefs == null) await init();
  return _prefs!.getString('organizacion_descripcion');
}

  // Guardar el token
  static Future<bool> saveToken(Token token) async {
    if (_prefs == null) await init();

    try {
      // Convertimos el token a JSON string
      final tokenJson = json.encode(token.toJson());
      // Guardamos el string
      final result = await _prefs!.setString(tokenKey, tokenJson);
      return result;
    } catch (e) {
      print('Error saving token: $e');
      return false;
    }
  }

  // Obtener el token
  static Future<Token?> getToken() async {
    if (_prefs == null) await init();

    try {
      final tokenJson = _prefs!.getString(tokenKey);
      if (tokenJson == null) return null;

      // Convertimos el JSON string de vuelta a un objeto Token
      final tokenMap = json.decode(tokenJson);
      return Token.fromJson(tokenMap);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  // Verificar si hay un token guardado
  static Future<bool> hasToken() async {
    if (_prefs == null) await init();
    return _prefs!.containsKey(tokenKey);
  }

  // Eliminar el token (útil para logout)
  static Future<bool> deleteToken() async {
    if (_prefs == null) await init();
    return await _prefs!.remove(tokenKey);
  }

  // Método para limpiar todo el almacenamiento
  static Future<bool> clearAll() async {
    if (_prefs == null) await init();
    return await _prefs!.clear();
  }

  // Método para verificar si el token JWT ha expirado
  static bool isTokenExpired(String token) {
    try {
      // Decodificar el token JWT (segunda parte)
      final parts = token.split('.');
      if (parts.length != 3) return true;

      // Decodificar payload
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );

      // Verificar campo exp
      if (!payload.containsKey('exp')) return true;

      final exp = payload['exp'];
      final expDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expDate);
    } catch (e) {
      print('Error verificando expiración del token: $e');
      return true; // Si hay error, consideramos que expiró
    }
  }

  

}
