import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConnection {
  static Dio getDioInstance({bool isMultipart = false}) {
    final options = BaseOptions(
      baseUrl: kIsWeb
          ? dotenv.env['BASE_URL_WEB_USER'] ?? ''
          : dotenv.env['BASE_URL_ANDROID_USER'] ?? '',
      headers: {
        'Content-Type':
            isMultipart ? 'multipart/form-data' : 'application/json',
      },
    );

    final dio = Dio(options);
    return dio;
  }

  static Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    final dio = getDioInstance();
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> post(String path, {required dynamic data}) async {
    final dio = getDioInstance();
    try {
      return await dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> put(String path, {required dynamic data}) async {
    final dio = getDioInstance();
    try {
      return await dio.put(path, data: data);
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> delete(String path,
      {Map<String, dynamic>? queryParameters}) async {
    final dio = getDioInstance();
    try {
      return await dio.delete(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> patch(String path, {required dynamic data}) async {
    final dio = getDioInstance();
    try {
      return await dio.patch(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
}
