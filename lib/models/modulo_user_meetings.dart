import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';

class Meeting {
  final DateTime fecha;
  final String lugar;
  final String agenda;
  final String estado;
  final int id;

  Meeting({
    required this.fecha,
    required this.lugar,
    required this.agenda,
    required this.estado,
    required this.id,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      fecha: DateTime.parse(json['fecha']),
      lugar: json['lugar'],
      agenda: json['agenda'],
      estado: json['estado'],
      id: json['id'],
    );
  }
}

class MeetingModel {
  // Renamed from Meeting
  final int id;
  final DateTime fecha;
  final String lugar;
  final String agenda;
  final String estado;

  MeetingModel({
    // Update constructor
    required this.id,
    required this.fecha,
    required this.lugar,
    required this.agenda,
    required this.estado,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) => MeetingModel(
        id: json['id'],
        fecha: DateTime.parse(json['fecha']),
        lugar: json['lugar'],
        agenda: json['agenda'],
        estado: json['estado'],
      );
}

//modulo de respuesa Erro en reuniones
class ApiErrorResponse {
  final String detail;

  ApiErrorResponse({required this.detail});

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      detail: json['detail'] ?? 'Error desconocido',
    );
  }
}

class AsistenciaUser {
  final int id;
  final int reunionId;
  final int usuarioId;
  final EstadoAsistencia estado;
  final DateTime fecha;

  AsistenciaUser({
    required this.id,
    required this.reunionId,
    required this.usuarioId,
    required this.estado,
    required this.fecha,
  });

  factory AsistenciaUser.fromJson(Map<String, dynamic> json) {
    return AsistenciaUser(
      id: json['id'] as int,
      reunionId: json['reunion_id'] as int,
      usuarioId: json['usuario_id'] as int,
      estado: EstadoAsistencia.values.firstWhere(
        (e) => e.toString().split('.').last == json['estado'],
      ),
      fecha: DateTime.parse(json['fecha']),
    );
  }
}

// Modelo de error específico
class AsistenciaUserError implements Exception {
  final String message;
  final int? statusCode;

  AsistenciaUserError(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class UserWork {
  final int id;
  final int usuarioId;
  final int reunionId;
  final String titulo;
  final String descripcion;
  final DateTime fechaPresentacion;

  UserWork({
    required this.id,
    required this.usuarioId,
    required this.reunionId,
    required this.titulo,
    required this.descripcion,
    required this.fechaPresentacion,
  });

  factory UserWork.fromJson(Map<String, dynamic> json) {
    return UserWork(
      id: json['id'] as int,
      usuarioId: json['usuario_id'] as int,
      reunionId: json['reunion_id'] as int,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      fechaPresentacion: DateTime.parse(json['fecha_presentacion']),
    );
  }
}

// Modelo de error específico
class UserWorkError implements Exception {
  final String message;
  final int? statusCode;

  UserWorkError(this.message, {this.statusCode});

  @override
  String toString() => message;
}
