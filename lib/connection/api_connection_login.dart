import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConnection {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: kIsWeb
          ? dotenv.env['BASE_URL_WEB'] ?? ''
          : dotenv.env['BASE_URL_ANDROID'] ?? '',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Dio getDioInstance() => _dio;

  static Future<Response> post(String path, {required dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
}
