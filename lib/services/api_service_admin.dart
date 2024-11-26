import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/connection/api_connection_admin.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:http_parser/http_parser.dart';

class ApiServiceAdmin {
  final Dio _dio = ApiConnection.getDioInstance();

  Future<List<User>> listUsers(String token,
      {String? status, String? role}) async {
    try {
      final response = await _dio.get(
        '/user/admin/users',
        queryParameters: {
          if (status != null) 'status': status,
          if (role != null) 'role': role,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception('Error al listar usuarios');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  //metodo para obtener los detalles de un usuario
  Future<UserDetail> getUserDetails(String token, int userId) async {
    try {
      print('Enviando solicitud a la API para obtener detalles del usuario...');
      final response = await _dio.get(
        '/user/usuario/detalles/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Respuesta de la API: ${response.data}');
        return UserDetail.fromJson(response.data);
      } else {
        print('Error al obtener detalles del usuario: ${response.statusCode}');
        throw Exception('Error al obtener los detalles del usuario');
      }
    } catch (e) {
      print('Error de conexión: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Uint8List> getUserPhoto(String token, int userId) async {
    try {
      final response = await _dio.get(
        '/user/usuario/$userId/foto/stream',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      } else {
        throw Exception('Error al obtener la foto del usuario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para obtener documentos asociados a un usuario por ID
  Future<ListaDocumentosResponse> getUserDocuments(
      String token, int userId) async {
    try {
      final response = await _dio.get(
        '/user/usuarios/documentos/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ListaDocumentosResponse.fromJson(response.data);
      } else {
        throw Exception('Error al obtener los documentos del usuario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para descargar un documento asociado por ID
  Future<Uint8List> downloadDocument(
      String token, int documentoId, String nombre) async {
    try {
      final response = await _dio.get(
        '/user/documentos/$documentoId/download',
        queryParameters: {
          'nombre': nombre,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      } else {
        throw Exception('Error al descargar el documento');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método para crear un nuevo usuario
  Future<UsuarioResponse> createUsuario(
      String token, UsuarioCreate usuario) async {
    try {
      debugPrint('URL: /user/usuarios/');
      debugPrint('Token: $token');
      debugPrint('Request body: ${usuario.toJson()}');

      final response = await _dio.post(
        '/user/usuarios/',
        data: usuario.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      // Cambiar a 200 ya que es el código que devuelve
      if (response.statusCode == 200) {
        final usuarioResponse = UsuarioResponse.fromJson(response.data);
        debugPrint('ID del usuario creado: ${usuarioResponse.id}');
        return UsuarioResponse.fromJson(response.data);
      } else {
        throw Exception('Error al crear el usuario: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('DioError: ${e.message}');
      debugPrint('DioError response: ${e.response?.data}');
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      debugPrint('Error general: $e');
      throw Exception('Error al crear el usuario: $e');
    }
  }

  Future<FotoResponse> uploadUserPhoto(
    String token,
    int usuarioId,
    Uint8List fileBytes,
    String fileName,
    String mimeType,
  ) async {
    try {
      debugPrint('Iniciando carga de foto para usuario $usuarioId');
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      debugPrint('Enviando foto...');
      final response = await _dio.post(
        '/user/usuarios/$usuarioId/foto',
        data: formData,
        // Remover Content-Type header, Dio lo maneja automáticamente
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('Respuesta foto: ${response.data}');
      return FotoResponse.fromJson(response.data);
    } catch (e) {
      debugPrint('Error en uploadUserPhoto: $e');
      throw e;
    }
  }

  Future<DocumentoResponse> uploadUserDocument(
    String token,
    int usuarioId,
    String nombre,
    String tipo,
    Uint8List fileBytes,
    String fileName,
    String mimeType,
  ) async {
    try {
      // Asegurarse de que el mime type sea correcto
      final contentType = MediaType.parse(mimeType);

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: contentType,
        ),
        'nombre': nombre,
        'tipo': tipo,
      });

      debugPrint('Enviando documento:');
      debugPrint('URL: /user/usuarios/$usuarioId/documentos');
      debugPrint('Content-Type: $mimeType');
      debugPrint('Filename: $fileName');
      debugPrint('Tamaño: ${fileBytes.length} bytes');

      final response = await _dio.post(
        '/user/usuarios/$usuarioId/documentos',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 422) {
        debugPrint('Error 422: ${response.data}');
        throw Exception('Error al procesar el documento: ${response.data}');
      }

      if (response.statusCode != 200) {
        throw Exception('Error ${response.statusCode}: ${response.data}');
      }

      return DocumentoResponse.fromJson(response.data);
    } catch (e) {
      debugPrint('Error en uploadUserDocument: $e');
      rethrow;
    }
  }

  //metodo para cambiar el estado de un usuario
  Future<CambioEstadoResponse> cambiarEstadoUsuario(
      String token, CambioEstadoCreate cambio) async {
    try {
      final response = await _dio.put(
        '/user/usuarios/cambio_estado',
        data: cambio.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return CambioEstadoResponse.fromJson(response.data);
      } else {
        throw Exception('Error al cambiar el estado del usuario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  //metodo para subir un documento de cambio de estado
  Future<String> subirDocumentosCambioEstado(
      String token, int cambioId, List<MultipartFile> files) async {
    try {
      final formData = FormData.fromMap({
        'files': files,
      });

      final response = await _dio.post(
        '/user/cambios-estado/$cambioId/documentos',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw Exception('Error al subir los documentos del cambio de estado');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  //metodo para actualizar un usuario
  Future<UsuarioResponse> updateUser(
      String token, int userId, UsuarioUpdate userData) async {
    try {
      final response = await _dio.patch(
        '/user/users/$userId',
        data: userData.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return UsuarioResponse.fromJson(response.data);
      } else {
        throw Exception('Error al actualizar el usuario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  //metodo para obtener el reporte de usuarios por estado
  Future<Uint8List> generateUserReport(
      String token, ReportRequest request) async {
    try {
      print('Iniciando generación de reporte...'); // Debug log
      print('Request data: ${request.toJson()}'); // Debug log

      final response = await _dio.post(
        '/user/reportes/usuarios',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.bytes,
        ),
      );

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response headers: ${response.headers}'); // Debug log

      if (response.statusCode == 200) {
        print('Reporte generado exitosamente'); // Debug log
        if (response.data is! List<int>) {
          print(
              'Tipo de respuesta inesperado: ${response.data.runtimeType}'); // Debug log
          throw Exception('Respuesta inválida del servidor');
        }
        return Uint8List.fromList(response.data);
      } else {
        print('Error: status code ${response.statusCode}'); // Debug log
        throw Exception('Error al generar el reporte de usuarios');
      }
    } catch (e) {
      print('Error en generateUserReport: $e'); // Debug log
      throw Exception('Error de conexión: $e');
    }
  }

  // Crear reunión
  Future<MeetingResponse> createMeeting(
      String token, MeetingCreate meeting) async {
    try {
      debugPrint('Datos a enviar: ${meeting.toJson()}'); // Debug log

      final response = await _dio.post(
        '/meeting/meetings/',
        data: meeting.toJson(), // Solo envía fecha, lugar y agenda
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MeetingResponse.fromJson(response.data);
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error en createMeeting: $e');
      rethrow;
    }
  }

  // Actualizar reunión
  Future<MeetingResponse> updateMeeting(
    String token,
    int meetingId,
    MeetingUpdate meeting,
  ) async {
    try {
      final response = await _dio.put(
        '/meeting/meetings/$meetingId',
        data: meeting.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return MeetingResponse.fromJson(response.data);
      } else {
        throw Exception('Error al actualizar la reunión');
      }
    } catch (e) {
      debugPrint('Error en updateMeeting: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Publicar reunión
  Future<MeetingResponse> publishMeeting(String token, int meetingId) async {
    try {
      final response = await _dio.post(
        '/meeting/meetings/$meetingId/publish',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return MeetingResponse.fromJson(response.data);
      } else {
        throw Exception('Error al publicar la reunión');
      }
    } catch (e) {
      debugPrint('Error en publishMeeting: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  // Listar reuniones con paginación
  Future<List<MeetingResponse>> listMeetings(
    String token, {
    int skip = 0,
    int limit = 100,
  }) async {
    try {
      debugPrint(
          'Iniciando listMeetings con token: ${token.substring(0, 20)}...'); // Log seguro

      final response = await _dio.get(
        '/meeting/meetings/list_meetings',
        queryParameters: {
          'skip': skip,
          'limit': limit,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) =>
              status! < 500, // Acepta códigos 4xx para manejarlos
        ),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data type: ${response.data.runtimeType}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data == null) {
          return []; // Retorna lista vacía si no hay datos
        }

        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => MeetingResponse.fromJson(json)).toList();
      } else {
        throw Exception(
            'Error del servidor: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      debugPrint('DioException en listMeetings: ${e.message}');
      debugPrint('DioException response: ${e.response?.data}');
      throw Exception('Error de red: ${e.message}');
    } catch (e) {
      debugPrint('Error inesperado en listMeetings: $e');
      throw Exception('Error inesperado: $e');
    }
  }

  //Crear acta
  Future<ActaResponse> createActa(String token, int reunionId) async {
    try {
      final response = await _dio.post(
        '/meeting/actas/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
        data: {
          'reunion_id': reunionId,
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ActaResponse.fromJson(response.data);
      }

      if (response.statusCode == 404) {
        throw ActaError('Reunión no encontrada', statusCode: 404);
      }

      throw ActaError(
        'Error del servidor: ${response.statusCode} - ${response.data}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      debugPrint('DioException en createActa: ${e.message}');
      throw ActaError('Error de red: ${e.message}');
    } catch (e) {
      debugPrint('Error inesperado en createActa: $e');
      throw ActaError('Error inesperado: $e');
    }
  }

  //subir contenido de acta
  Future<ContenidoActaResponse> uploadContenidoActa(
    String token,
    int actaId,
    List<int> fileBytes,
    String fileName,
  ) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: MediaType('application', 'pdf'),
        ),
      });

      final response = await _dio.post(
        '/meeting/actas/$actaId/contenido',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ContenidoActaResponse.fromJson(response.data);
      }

      if (response.statusCode == 404) {
        throw ContenidoActaError('Acta no encontrada', statusCode: 404);
      }

      if (response.statusCode == 400) {
        throw ContenidoActaError('El archivo debe ser un PDF', statusCode: 400);
      }

      throw ContenidoActaError(
        'Error del servidor: ${response.statusCode} - ${response.data}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      debugPrint('DioException en uploadContenidoActa: ${e.message}');
      throw ContenidoActaError('Error de red: ${e.message}');
    } catch (e) {
      debugPrint('Error inesperado en uploadContenidoActa: $e');
      throw ContenidoActaError('Error inesperado: $e');
    }
  }

  //ruta para descargar el contenido de un acta
  Future<(List<int>, String)> downloadActa(String token, int actaId) async {
    try {
      final response = await _dio.get(
        '/meeting/meetings/minutes/$actaId/download',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          responseType: ResponseType.bytes,
          validateStatus: (status) => status! < 500,
        ),
      );

      debugPrint('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final contentDisposition =
            response.headers.value('content-disposition');
        final fileName = contentDisposition != null
            ? RegExp(r'filename="([^"]*)"')
                .firstMatch(contentDisposition)
                ?.group(1)
            : 'acta.pdf';

        return (response.data as List<int>, fileName ?? 'acta.pdf');
      }

      if (response.statusCode == 404) {
        throw DownloadActaError(
          'Acta no encontrada o sin contenido',
          statusCode: 404,
        );
      }

      if (response.statusCode == 403) {
        throw DownloadActaError(
          'No tiene permisos para descargar esta acta',
          statusCode: 403,
        );
      }

      throw DownloadActaError(
        'Error del servidor: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      debugPrint('DioException en downloadActa: ${e.message}');
      throw DownloadActaError('Error de red: ${e.message}');
    } catch (e) {
      debugPrint('Error inesperado en downloadActa: $e');
      throw DownloadActaError('Error inesperado: $e');
    }
  }

  //ruta para crear trabajo
  Future<TrabajoResponse> createTrabajo(
    String token,
    int reunionId,
    int usuarioId,
    String titulo,
    String descripcion,
    DateTime fechaPresentacion,
  ) async {
    try {
      final response = await _dio.post(
        '/meeting/create/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
        data: {
          'reunion_id': reunionId,
          'usuario_id': usuarioId,
          'titulo': titulo,
          'descripcion': descripcion,
          'fecha_presentacion':
              fechaPresentacion.toIso8601String().split('T')[0],
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return TrabajoResponse.fromJson(response.data);
      }

      if (response.statusCode == 404) {
        throw TrabajoError('Reunión o usuario no encontrado', statusCode: 404);
      }

      throw TrabajoError(
        'Error del servidor: ${response.statusCode} - ${response.data}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      debugPrint('DioException en createTrabajo: ${e.message}');
      throw TrabajoError('Error de red: ${e.message}');
    } catch (e) {
      debugPrint('Error inesperado en createTrabajo: $e');
      throw TrabajoError('Error inesperado: $e');
    }
  }

  // ruta para actualizar trabajo
  Future<TrabajoResponse> updateTrabajo(
    String token,
    int trabajoId,
    TrabajoUpdateRequest update,
  ) async {
    try {
      final response = await _dio.put(
        '/meeting/update/$trabajoId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
        data: update.toJson(),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return TrabajoResponse.fromJson(response.data);
      }

      if (response.statusCode == 404) {
        throw TrabajoUpdateError(
          'Trabajo no encontrado',
          statusCode: 404,
        );
      }

      if (response.statusCode == 403) {
        throw TrabajoUpdateError(
          'No tiene permisos para actualizar este trabajo',
          statusCode: 403,
        );
      }

      throw TrabajoUpdateError(
        'Error del servidor: ${response.statusCode} - ${response.data}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      debugPrint('DioException en updateTrabajo: ${e.message}');
      throw TrabajoUpdateError('Error de red: ${e.message}');
    } catch (e) {
      debugPrint('Error inesperado en updateTrabajo: $e');
      throw TrabajoUpdateError('Error inesperado: $e');
    }
  }

  // metodo para listar trabajos por id
  Future<TrabajoResponse> getTrabajo(String token, int trabajoId) async {
    try {
      final response = await _dio.get(
        '/meeting/$trabajoId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return TrabajoResponse.fromJson(response.data);
      }

      if (response.statusCode == 404) {
        throw TrabajoError(
          'Trabajo no encontrado',
          statusCode: 404,
        );
      }

      throw TrabajoError(
        'Error del servidor: ${response.statusCode} - ${response.data}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      debugPrint('DioException en getTrabajo: ${e.message}');
      throw TrabajoError('Error de red: ${e.message}');
    } catch (e) {
      debugPrint('Error inesperado en getTrabajo: $e');
      throw TrabajoError('Error inesperado: $e');
    }
  }

  // 1. Reporte de reuniones
  Future<List<int>> generateMeetingsReport(String token, String formato) async {
    try {
      final response = await _dio.get(
        '/meeting/reportes/reuniones',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
          validateStatus: (status) => status! < 500,
        ),
        queryParameters: {'formato': formato},
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      throw ReportError(
        response.data['detail'] ?? 'Error al generar reporte',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ReportError('Error de red: ${e.message}');
    }
  }

// 2. Reporte de trabajos
  Future<List<int>> generateWorksReport(String token, String formato) async {
    try {
      final response = await _dio.get(
        '/meeting/reportes/trabajos',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
          validateStatus: (status) => status! < 500,
        ),
        queryParameters: {'formato': formato},
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      throw ReportError(
        response.data['detail'] ?? 'Error al generar reporte',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ReportError('Error de red: ${e.message}');
    }
  }

// 3. Reporte de actas
  Future<List<int>> generateMinutesReport(String token, String formato) async {
    try {
      final response = await _dio.get(
        '/meeting/reportes/actas',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
          validateStatus: (status) => status! < 500,
        ),
        queryParameters: {'formato': formato},
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      throw ReportError(
        response.data['detail'] ?? 'Error al generar reporte',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ReportError('Error de red: ${e.message}');
    }
  }

// 4. Reporte de asistencia
  Future<List<int>> generateAttendanceReport(
    String token,
    int userId,
    String startDate,
    String endDate,
    String formato,
  ) async {
    try {
      final response = await _dio.get(
        '/meeting/reportes/asistencia',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
          validateStatus: (status) => status! < 500,
        ),
        queryParameters: {
          'user_id': userId,
          'start_date': startDate,
          'end_date': endDate,
          'formato': formato,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      throw ReportError(
        response.data['detail'] ?? 'Error al generar reporte',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw ReportError('Error de red: ${e.message}');
    }
  }
}
