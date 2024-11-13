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
}
