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
  Future<List<MeetingListResponse>> listMeetings(
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
        return data.map((json) => MeetingListResponse.fromJson(json)).toList();
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

  // Listar todos los trabajos
  Future<List<TrabajoListResponse>> listTrabajos(
    String token, {
    int skip = 0,
    int limit = 100,
  }) async {
    try {
      final response = await _dio.get(
        '/meeting/trabajos/',
        queryParameters: {
          'skip': skip,
          'limit': limit,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => TrabajoListResponse.fromJson(json)).toList();
      }

      throw TrabajoListError(
        response.data['detail'] ?? 'Error al listar trabajos',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw TrabajoListError('Error de red: ${e.message}');
    }
  }

  Future<List<ContenidoTrabajoResponse>> uploadArchivosTrabajoMultiple(
  String token,
  int trabajoId,
  List<Map<String, dynamic>> files,
) async {
  try {
    final formData = FormData();
    
    // Agregar cada archivo al FormData
    for (var fileInfo in files) {
      formData.files.add(
        MapEntry(
          'files',
          MultipartFile.fromBytes(
            fileInfo['bytes'] as List<int>,
            filename: fileInfo['name'] as String,
            contentType: MediaType.parse(fileInfo['mimeType'] as String),
          ),
        ),
      );
    }

    final response = await _dio.post(
      '/meeting/trabajos/$trabajoId/archivos/',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = response.data;
      return data
          .map((json) => ContenidoTrabajoResponse.fromJson(json))
          .toList();
    }

    if (response.statusCode == 404) {
      throw ContenidoTrabajoError(
        'Trabajo no encontrado',
        statusCode: 404,
      );
    }

    throw ContenidoTrabajoError(
      response.data['detail'] ?? 'Error al subir archivos',
      statusCode: response.statusCode,
    );
  } on DioException catch (e) {
    debugPrint('DioException en uploadArchivosTrabajoMultiple: ${e.message}');
    throw ContenidoTrabajoError('Error de red: ${e.message}');
  } catch (e) {
    debugPrint('Error inesperado en uploadArchivosTrabajoMultiple: $e');
    throw ContenidoTrabajoError('Error inesperado: $e');
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
    String token, {
    int? userId,
    String? startDate,
    String? endDate,
    int? reunionId,
    String formato = 'excel',
  }) async {
    try {
      final response = await _dio.get(
        '/meeting/reportes/asistencia',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
          validateStatus: (status) => status! < 500,
        ),
        queryParameters: {
          if (userId != null) 'user_id': userId,
          if (startDate != null) 'start_date': startDate,
          if (endDate != null) 'end_date': endDate,
          if (reunionId != null) 'reunion_id': reunionId,
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

  //ruta para obtener usuarios activos
  Future<List<UsuarioAsistenciaModel>> getUsuariosActivos(String token) async {
    try {
      final response = await _dio.get(
        '/attendance/usuarios-activos/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => UsuarioAsistenciaModel.fromJson(json))
            .toList();
      }

      throw Exception(
        response.data['detail'] ?? 'Error al obtener usuarios activos',
      );
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

//ruta para registrar asistecia
  Future<List<AsistenciaResponse>> registrarAsistencias(
    String token,
    AsistenciaMasiva asistencias,
  ) async {
    try {
      final response = await _dio.post(
        '/attendance/registrar/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
        data: asistencias.toJson(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => AsistenciaResponse.fromJson(json)).toList();
      }

      throw Exception(
        response.data['detail'] ?? 'Error al registrar asistencias',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(
            e.response?.data['detail'] ?? 'Error al registrar asistencias');
      }
      throw Exception('Error de red: ${e.message}');
    }
  }

  //ruta para obtener asistencias por reunion
  Future<List<AsistenciaResponse>> obtenerAsistenciasReunion(
    String token,
    int reunionId,
  ) async {
    try {
      final response = await _dio.get(
        '/attendance/reunion/$reunionId/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => AsistenciaResponse.fromJson(json)).toList();
      }

      if (response.statusCode == 404) {
        throw Exception(
            'No se encontraron registros de asistencia para esta reunión');
      }

      throw Exception(
        response.data['detail'] ?? 'Error al obtener asistencias de la reunión',
      );
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    }
  }

  // ruta para obtener asistencias por reunion
  Future<List<AsistenciaResponse>> actualizarAsistencias(
    String token,
    AsistenciaUpdateMasiva asistencias,
  ) async {
    try {
      final response = await _dio.patch(
        '/attendance/actualizar/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
        data: asistencias.toJson(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => AsistenciaResponse.fromJson(json)).toList();
      }

      if (response.statusCode == 404) {
        throw Exception(
            'No se encontraron registros de asistencia para actualizar');
      }

      throw Exception(
        response.data['detail'] ?? 'Error al actualizar asistencias',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(
          e.response?.data['detail'] ?? 'Error al actualizar asistencias',
        );
      }
      throw Exception('Error de red: ${e.message}');
    }
  }

  Future<List<UsuarioConGrado>> getUsuariosConGrado(String token) async {
    try {
      final response = await _dio.get(
        '/complementary/usuarios-grados/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => UsuarioConGrado.fromJson(json)).toList();
      }

      if (response.statusCode == 404) {
        throw UsuariosGradoError(
          'No se encontraron usuarios con grados',
          statusCode: 404,
        );
      }

      throw UsuariosGradoError(
        response.data['detail'] ?? 'Error al obtener usuarios con grados',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw UsuariosGradoError(
          'No autorizado - Token inválido o expirado',
          statusCode: 401,
        );
      }
      throw UsuariosGradoError(
        'Error de red: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<void> createGrado(String token, GradoCreate grado) async {
    try {
      final response = await _dio.post(
        '/complementary/create_grade/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
        data: grado.toJson(),
      );

      if (response.statusCode == 201) {
        return;
      }

      if (response.statusCode == 400) {
        throw GradoError(
          response.data['detail'] ?? 'Error al crear el grado',
          statusCode: 400,
        );
      }

      throw GradoError(
        'Error al crear el grado',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw GradoError(
          'No autorizado - Token inválido o expirado',
          statusCode: 401,
        );
      }
      throw GradoError(
        'Error de red: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<GradoOut> updateGrado(
    String token,
    int usuarioId,
    GradoUpdate update,
  ) async {
    try {
      final response = await _dio.put(
        '/complementary/update_grade/$usuarioId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) => status! < 500,
        ),
        data: update.toJson(),
      );

      if (response.statusCode == 200) {
        return GradoOut.fromJson(response.data);
      }

      if (response.statusCode == 404) {
        throw GradoError(
          'Grado no encontrado',
          statusCode: 404,
        );
      }

      throw GradoError(
        response.data['detail'] ?? 'Error al actualizar el grado',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw GradoError(
          'No autorizado - Token inválido o expirado',
          statusCode: 401,
        );
      }
      throw GradoError(
        'Error de red: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<FotoInvitacionResponse> uploadFotoInvitacion(
    String token,
    Uint8List fileBytes,
    String fileName,
    String mimeType,
  ) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await _dio.post(
        '/meeting/meetings/foto-invitacion/',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        return FotoInvitacionResponse.fromJson(response.data);
      }

      throw FotoInvitacionError(
        response.data['detail'] ?? 'Error al subir la foto de invitación',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw FotoInvitacionError(
          'No autorizado - Token inválido o expirado',
          statusCode: 401,
        );
      }
      throw FotoInvitacionError(
        'Error de red: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    }
  }

// Future para obtener la última foto de invitación
  Future<Uint8List> getUltimaFotoInvitacion() async {
    try {
      final response = await _dio.get(
        '/meeting/meetings/ultima-foto-invitacion/',
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      }

      if (response.statusCode == 404) {
        throw FotoInvitacionError(
          'No hay fotos de invitación disponibles',
          statusCode: 404,
        );
      }

      throw FotoInvitacionError(
        'Error al obtener la foto de invitación',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw FotoInvitacionError(
        'Error de red: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    }
  }


  Future<List<NewOrganizacionResponse>> listOrganizations(String token) async {
  try {
    final response = await _dio.get(
      '/user/organizations',
      options: Options(
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode == 200) {
      // Agrega logs para depuración
      debugPrint('Response data: ${response.data}');
      
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) {
        try {
          return NewOrganizacionResponse.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          debugPrint('Error parsing organization: $e');
          debugPrint('JSON data: $json');
          rethrow;
        }
      }).toList();
    }

    throw NewOrganizacionError(
      response.data['detail'] ?? 'Error al listar organizaciones',
      statusCode: response.statusCode,
    );
  } on DioException catch (e) {
    debugPrint('Error DioException: ${e.message}');
    debugPrint('Response: ${e.response?.data}');
    throw NewOrganizacionError('Error de red: ${e.message}');
  }
}

Future<PasswordUpdateResponse> updateUserPassword(
  String token,
  int userId,
  String newPassword,
) async {
  try {
    final response = await _dio.patch(
      '/user/users/$userId/password',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
      data: PasswordUpdateRequest(password: newPassword).toJson(),
    );

    if (response.statusCode == 200) {
      return PasswordUpdateResponse.fromJson(response.data);
    }

    if (response.statusCode == 404) {
      throw PasswordUpdateError(
        'Usuario no encontrado',
        statusCode: 404,
      );
    }

    throw PasswordUpdateError(
      response.data['detail'] ?? 'Error al actualizar la contraseña',
      statusCode: response.statusCode,
    );
  } on DioException catch (e) {
    debugPrint('Error DioException: ${e.message}');
    debugPrint('Response: ${e.response?.data}');
    throw PasswordUpdateError('Error de red: ${e.message}');
  }
}


// Future para obtener actas por reunión
Future<List<ActaDetailResponse>> getActasByReunion(String token, int reunionId) async {
  try {
    final response = await _dio.get(
      '/meeting/actas/reunion/$reunionId',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => ActaDetailResponse.fromJson(json)).toList();
    }

    if (response.statusCode == 404) {
      throw ActaError(
        'No se encontraron actas para esta reunión',
        statusCode: 404,
      );
    }

    throw ActaError(
      'Error del servidor: ${response.statusCode}',
      statusCode: response.statusCode,
    );
  } on DioException catch (e) {
    debugPrint('DioException en getActasByReunion: ${e.message}');
    throw ActaError('Error de red: ${e.message}');
  }
}

// Future para eliminar acta
Future<DeleteActaResponse> deleteActa(String token, int actaId) async {
  try {
    final response = await _dio.delete(
      '/meeting/actas/$actaId',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode == 200) {
      return DeleteActaResponse.fromJson(response.data);
    }

    if (response.statusCode == 404) {
      throw ActaError(
        'Acta no encontrada',
        statusCode: 404,
      );
    }

    throw ActaError(
      'Error del servidor: ${response.statusCode}',
      statusCode: response.statusCode,
    );
  } on DioException catch (e) {
    debugPrint('DioException en deleteActa: ${e.message}');
    throw ActaError('Error de red: ${e.message}');
  }
}


Future<EnlaceResponse> createEnlace(String token, EnlaceCreate enlace) async {
  try {
    final response = await _dio.post(
      '/url/enlaces/',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
      data: enlace.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return EnlaceResponse.fromJson(response.data);
    }

    throw Exception(
      response.data['detail'] ?? 'Error al crear enlace',
    );
  } on DioException catch (e) {
    debugPrint('Error al crear enlace: ${e.message}');
    throw Exception('Error de red: ${e.message}');
  }
}

Future<List<EnlaceResponse>> getEnlaces(String token, {int skip = 0, int limit = 100}) async {
  try {
    final response = await _dio.get(
      '/url/enlaces/',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => EnlaceResponse.fromJson(json)).toList();
    }

    throw Exception(
      response.data['detail'] ?? 'Error al obtener enlaces',
    );
  } on DioException catch (e) {
    debugPrint('Error al obtener enlaces: ${e.message}');
    throw Exception('Error de red: ${e.message}');
  }
}

Future<EnlaceResponse> updateEnlace(
    String token, int enlaceId, EnlaceUpdate enlace) async {
  try {
    final response = await _dio.put(
      '/url/enlaces/$enlaceId',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
      data: enlace.toJson(),
    );

    if (response.statusCode == 200) {
      return EnlaceResponse.fromJson(response.data);
    }

    throw Exception(
      response.data['detail'] ?? 'Error al actualizar enlace',
    );
  } on DioException catch (e) {
    debugPrint('Error al actualizar enlace: ${e.message}');
    throw Exception('Error de red: ${e.message}');
  }
}

Future<bool> deleteEnlace(String token, int enlaceId) async {
  try {
    final response = await _dio.delete(
      '/url/enlaces/$enlaceId',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception(
      response.data['detail'] ?? 'Error al eliminar enlace',
    );
  } on DioException catch (e) {
    debugPrint('Error al eliminar enlace: ${e.message}');
    throw Exception('Error de red: ${e.message}');
  }
}

// URLs
Future<URLResponse> createURL(String token, URLCreate url) async {
  try {
    final response = await _dio.post(
      '/url/urls/',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
      data: url.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return URLResponse.fromJson(response.data);
    }

    throw Exception(
      response.data['detail'] ?? 'Error al crear URL',
    );
  } on DioException catch (e) {
    debugPrint('Error al crear URL: ${e.message}');
    throw Exception('Error de red: ${e.message}');
  }
}

Future<URLResponse> updateURL(String token, int urlId, URLUpdate url) async {
  try {
    final response = await _dio.put(
      '/url/urls/$urlId',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
      data: url.toJson(),
    );

    if (response.statusCode == 200) {
      return URLResponse.fromJson(response.data);
    }

    throw Exception(
      response.data['detail'] ?? 'Error al actualizar URL',
    );
  } on DioException catch (e) {
    debugPrint('Error al actualizar URL: ${e.message}');
    throw Exception('Error de red: ${e.message}');
  }
}

Future<List<URLListResponse>> getUrls(String token, {int skip = 0, int limit = 100}) async {
  try {
    debugPrint('Obteniendo URLs...'); // Log para debug
    final response = await _dio.get(
      '/url/urlsList/', // Esta es la ruta correcta que mencionas
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
    );

    debugPrint('Response status: ${response.statusCode}'); // Log para debug
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      debugPrint('URLs recibidas: ${data.length}'); // Log para debug
      return data.map((json) => URLListResponse.fromJson(json)).toList();
    }

    throw Exception(
      response.data['detail'] ?? 'Error al obtener URLs',
    );
  } on DioException catch (e) {
    debugPrint('Error al obtener URLs: ${e.message}');
    throw Exception('Error de red: ${e.message}');
  }
}


// List all cargos
Future<List<CargoResponse>> listCargos(String token, {int skip = 0, int limit = 100}) async {
  try {
    final response = await _dio.get(
      '/meeting/cargos/',
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => CargoResponse.fromJson(json)).toList();
    }

    throw Exception(response.data['detail'] ?? 'Error al listar cargos');
  } catch (e) {
    throw Exception('Error de conexión: $e');
  }
}

// Create new cargo
Future<CargoResponse> createCargo(String token, CargoCreate cargo) async {
  try {
    final response = await _dio.post(
      '/meeting/cargos/',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
      data: cargo.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CargoResponse.fromJson(response.data);
    }

    throw Exception(response.data['detail'] ?? 'Error al crear cargo');
  } catch (e) {
    throw Exception('Error de conexión: $e');
  }
}

// Update cargo
Future<CargoResponse> updateCargo(String token, int cargoId, CargoUpdate cargo) async {
  try {
    final response = await _dio.put(
      '/meeting/cargos/$cargoId',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
      data: cargo.toJson(),
    );

    if (response.statusCode == 200) {
      return CargoResponse.fromJson(response.data);
    }

    throw Exception(response.data['detail'] ?? 'Error al actualizar cargo');
  } catch (e) {
    throw Exception('Error de conexión: $e');
  }
}

// Delete cargo
Future<bool> deleteCargo(String token, int cargoId) async {
  try {
    final response = await _dio.delete(
      '/meeting/cargos/$cargoId',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception(response.data['detail'] ?? 'Error al eliminar cargo');
  } catch (e) {
    throw Exception('Error de conexión: $e'); 
  }
}

Future<List<CargoDetailResponse>> getCargoDetails(String token) async {
  try {
    final response = await _dio.get(
      '/meeting/cargos/usuarios/detail',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => CargoDetailResponse.fromJson(json)).toList();
    }

    if (response.statusCode == 404) {
      throw CargoDetailError(
        'No se encontraron detalles de cargos',
        statusCode: 404
      );
    }

    if (response.statusCode == 401) {
      throw CargoDetailError(
        'No autorizado para ver los detalles de cargos',
        statusCode: 401
      );
    }

    throw CargoDetailError(
      response.data['detail'] ?? 'Error al obtener detalles de cargos',
      statusCode: response.statusCode
    );
  } on DioException catch (e) {
    debugPrint('DioException en getCargoDetails: ${e.message}');
    throw CargoDetailError('Error de red: ${e.message}');
  } catch (e) {
    debugPrint('Error inesperado en getCargoDetails: $e');
    throw CargoDetailError('Error inesperado: $e');
  }
}

Future<List<UsuarioBasicInfo>> getUsuariosBasicInfo(String token) async {
  try {
    final response = await _dio.get(
      '/complementary/usuarios/basic-info',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => UsuarioBasicInfo.fromJson(json)).toList();
    }

    throw Exception(
      response.data['detail'] ?? 'Error al obtener información básica de usuarios'
    );
  } on DioException catch (e) {
    debugPrint('Error al obtener información básica de usuarios: ${e.message}');
    throw Exception('Error de red: ${e.message}');
  }
}

Future<List<GradoSimpleResponse>> getGradosOrganizacion(String token, String nombreOrganizacion) async {
  try {
    final response = await _dio.get(
      '/meeting/organizacion/grados/$nombreOrganizacion',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => GradoSimpleResponse.fromJson(json)).toList();
    }

    throw Exception(
      response.data['detail'] ?? 'Error al obtener grados de la organización'
    );
  } on DioException catch (e) {
    debugPrint('Error al obtener grados de la organización: ${e.message}');
    throw Exception('Error de red: ${e.message}');
  }
}

}
