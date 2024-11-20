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
