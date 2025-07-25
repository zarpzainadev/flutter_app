import 'package:json_annotation/json_annotation.dart';

part 'modulo_gestion_usuario_model.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String dni;
  final String email;
  final String nombres;
  final String apellidos_paterno;
  final String apellidos_materno;
  final DateTime fecha_nacimiento;
  final String celular;
  final String rol_nombre;
  final String estado_usuario_nombre;
  final DateTime fecha_registro;

  User({
    required this.id,
    required this.dni,
    required this.email,
    required this.nombres,
    required this.apellidos_paterno,
    required this.apellidos_materno,
    required this.fecha_nacimiento,
    required this.celular,
    required this.rol_nombre,
    required this.estado_usuario_nombre,
    required this.fecha_registro,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

//modulos de detalles de usuario
@JsonSerializable()
class GradoOut {
  final int? id;
  final int? id_grado;
  final DateTime? fecha_grado;
  final String? estado;
  final DateTime? fecha;
  final String? nombre_grado;  // Cambiado de grado a nombre_grado

  GradoOut({
    this.id,
    this.id_grado,
    this.fecha_grado,
    this.estado,
    this.fecha,
    this.nombre_grado,
  });

  factory GradoOut.fromJson(Map<String, dynamic> json) => _$GradoOutFromJson(json);
  Map<String, dynamic> toJson() => _$GradoOutToJson(this);
}

@JsonSerializable()
class InformacionProfesionalOut {
  final int? id;
  final String? profesion;
  final String? especialidad;
  final String? centro_trabajo;
  final String? direccion_trabajo;
  final double? sueldo_mensual;

  InformacionProfesionalOut({
    this.id,
    this.profesion,
    this.especialidad,
    this.centro_trabajo,
    this.direccion_trabajo,
    this.sueldo_mensual,
  });

  factory InformacionProfesionalOut.fromJson(Map<String, dynamic> json) {
    return InformacionProfesionalOut(
      id: json['id'] as int?,
      profesion: json['profesion'] as String?,
      especialidad: json['especialidad'] as String?,
      centro_trabajo: json['centro_trabajo'] as String?,
      direccion_trabajo: json['direccion_trabajo'] as String?,
      sueldo_mensual: (json['sueldo_mensual'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => _$InformacionProfesionalOutToJson(this);
}

@JsonSerializable()
class DireccionOut {
  final int? id;
  final String? tipo_via;
  final String? direccion;
  final String? departamento;
  final String? provincia;
  final String? distrito;

  DireccionOut({
    this.id,
    this.tipo_via,
    this.direccion,
    this.departamento,
    this.provincia,
    this.distrito,
  });

  factory DireccionOut.fromJson(Map<String, dynamic> json) {
    return DireccionOut(
      id: json['id'] as int?,
      tipo_via: json['tipo_via'] as String?,
      direccion: json['direccion'] as String?,
      departamento: json['departamento'] as String?,
      provincia: json['provincia'] as String?,
      distrito: json['distrito'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$DireccionOutToJson(this);
}

@JsonSerializable()
class InformacionFamiliarOut {
  final int? id;
  final String? nombre_conyuge;
  final DateTime? fecha_nacimiento_conyuge;
  final String? padre_nombre;
  final bool? padre_vive;
  final String? madre_nombre;
  final bool? madre_vive;

  InformacionFamiliarOut({
    this.id,
    this.nombre_conyuge,
    this.fecha_nacimiento_conyuge,
    this.padre_nombre,
    this.padre_vive,
    this.madre_nombre,
    this.madre_vive,
  });

  factory InformacionFamiliarOut.fromJson(Map<String, dynamic> json) {
    return InformacionFamiliarOut(
      id: json['id'] as int?,
      nombre_conyuge: json['nombre_conyuge'] as String?,
      fecha_nacimiento_conyuge: json['fecha_nacimiento_conyuge'] == null
          ? null
          : DateTime.parse(json['fecha_nacimiento_conyuge'] as String),
      padre_nombre: json['padre_nombre'] as String?,
      padre_vive: json['padre_vive'] as bool?,
      madre_nombre: json['madre_nombre'] as String?,
      madre_vive: json['madre_vive'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => _$InformacionFamiliarOutToJson(this);
}

@JsonSerializable()
class DependienteOut {
  final int? id;
  final String? nombres_apellidos;
  final String? parentesco;
  final DateTime? fecha_nacimiento;
  final String? sexo;
  final String? estado_civil;

  DependienteOut({
    this.id,
    this.nombres_apellidos,
    this.parentesco,
    this.fecha_nacimiento,
    this.sexo,
    this.estado_civil,
  });

  factory DependienteOut.fromJson(Map<String, dynamic> json) {
    return DependienteOut(
      id: json['id'] as int?,
      nombres_apellidos: json['nombres_apellidos'] as String?,
      parentesco: json['parentesco'] as String?,
      fecha_nacimiento: json['fecha_nacimiento'] == null
          ? null
          : DateTime.parse(json['fecha_nacimiento'] as String),
      sexo: json['sexo'] as String?,
      estado_civil: json['estado_civil'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$DependienteOutToJson(this);
}

@JsonSerializable()
class InformacionAdicionalOut {
  final int? id;
  final String? grupo_sanguineo;
  final String? religion;
  final bool? presentado_logia;
  final String? nombre_logia;

  InformacionAdicionalOut({
    this.id,
    this.grupo_sanguineo,
    this.religion,
    this.presentado_logia,
    this.nombre_logia,
  });

  factory InformacionAdicionalOut.fromJson(Map<String, dynamic> json) {
    return InformacionAdicionalOut(
      id: json['id'] as int?,
      grupo_sanguineo: json['grupo_sanguineo'] as String?,
      religion: json['religion'] as String?,
      presentado_logia: json['presentado_logia'] as bool?,
      nombre_logia: json['nombre_logia'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$InformacionAdicionalOutToJson(this);
}

@JsonSerializable()
class UserDetail {
  final int id;
  final String dni;
  final String email;
  final String nombres;
  final String apellidos_paterno;
  final String apellidos_materno;
  final DateTime fecha_nacimiento;
  final String celular;
  final String rol_nombre;
  final String estado_usuario_nombre;
  final DateTime fecha_registro;
  final String password_hash;
  final int rol_id;
  final int estado_id;
  final GradoOut? grados;
  final InformacionProfesionalOut? informacion_profesional;
  final DireccionOut? direcciones;
  final InformacionFamiliarOut? informacion_familiar;
  final DependienteOut? dependientes;
  final InformacionAdicionalOut? informacion_adicional;

  UserDetail({
    required this.id,
    required this.dni,
    required this.email,
    required this.nombres,
    required this.apellidos_paterno,
    required this.apellidos_materno,
    required this.fecha_nacimiento,
    required this.celular,
    required this.rol_nombre,
    required this.estado_usuario_nombre,
    required this.fecha_registro,
    required this.password_hash,
    required this.rol_id,
    required this.estado_id,
    this.grados,
    this.informacion_profesional,
    this.direcciones,
    this.informacion_familiar,
    this.dependientes,
    this.informacion_adicional,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['id']?.toInt() ?? 0,
      dni: json['dni']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      nombres: json['nombres']?.toString() ?? '',
      apellidos_paterno: json['apellidos_paterno']?.toString() ?? '',
      apellidos_materno: json['apellidos_materno']?.toString() ?? '',
      fecha_nacimiento: json['fecha_nacimiento'] == null
          ? DateTime.now()
          : DateTime.parse(json['fecha_nacimiento'].toString()),
      celular: json['celular']?.toString() ?? '',
      rol_nombre: json['rol_nombre']?.toString() ?? '',
      estado_usuario_nombre: json['estado_usuario_nombre']?.toString() ?? '',
      fecha_registro: json['fecha_registro'] == null
          ? DateTime.now()
          : DateTime.parse(json['fecha_registro'].toString()),
      password_hash: json['password_hash']?.toString() ?? '',
      rol_id: json['rol_id']?.toInt() ?? 0,
      estado_id: json['estado_id']?.toInt() ?? 0,
      grados: json['grados'] == null
          ? null
          : GradoOut.fromJson(json['grados'] as Map<String, dynamic>),
      informacion_profesional: json['informacion_profesional'] == null
          ? null
          : InformacionProfesionalOut.fromJson(
              json['informacion_profesional'] as Map<String, dynamic>),
      direcciones: json['direcciones'] == null
          ? null
          : DireccionOut.fromJson(json['direcciones'] as Map<String, dynamic>),
      informacion_familiar: json['informacion_familiar'] == null
          ? null
          : InformacionFamiliarOut.fromJson(
              json['informacion_familiar'] as Map<String, dynamic>),
      dependientes: json['dependientes'] == null
          ? null
          : DependienteOut.fromJson(
              json['dependientes'] as Map<String, dynamic>),
      informacion_adicional: json['informacion_adicional'] == null
          ? null
          : InformacionAdicionalOut.fromJson(
              json['informacion_adicional'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => _$UserDetailToJson(this);
}

//modulo de documentos adjuntos al usuario
@JsonSerializable()
class Documento {
  final int id;
  final String nombre;
  final String tipo;
  final DateTime fecha_subida;

  Documento({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.fecha_subida,
  });

  factory Documento.fromJson(Map<String, dynamic> json) =>
      _$DocumentoFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentoToJson(this);
}

@JsonSerializable()
class ListaDocumentosResponse {
  final List<Documento> documentos;

  ListaDocumentosResponse({required this.documentos});

  factory ListaDocumentosResponse.fromJson(Map<String, dynamic> json) =>
      _$ListaDocumentosResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ListaDocumentosResponseToJson(this);
}

//modelos de creacion de usuario
@JsonSerializable()
class UsuarioCreate {
  final String dni;
  final String email;
  final String password;
  final String nombres;
  final String apellidos_paterno;
  final String apellidos_materno;
  final DateTime fecha_nacimiento;
  final String? celular;
  final int rol_id;
  final int estado_id;
  final String? profesion;
  final String? especialidad;
  final String? centro_trabajo;
  final String? direccion_trabajo;
  final double? sueldo_mensual;
  final String? tipo_via;
  final String? direccion;
  final String? departamento;
  final String? provincia;
  final String? distrito;
  final String? nombre_conyuge;
  final DateTime? fecha_nacimiento_conyuge;
  final String? padre_nombre;
  final bool? padre_vive;
  final String? madre_nombre;
  final bool? madre_vive;
  final String? grupo_sanguineo;
  final String? religion;
  final bool? presentado_logia;
  final String? nombre_logia;
  final String nombres_apellidos;
  final String? parentesco;
  final DateTime? fecha_nacimiento1;
  final String? sexo;
  final String? estado_civil;
  final int? id_organizacion;

  UsuarioCreate({
    required this.dni,
    required this.email,
    required this.password,
    required this.nombres,
    required this.apellidos_paterno,
    required this.apellidos_materno,
    required this.fecha_nacimiento,
    this.celular,
    required this.rol_id,
    required this.estado_id,
    this.profesion,
    this.especialidad,
    this.centro_trabajo,
    this.direccion_trabajo,
    this.sueldo_mensual,
    this.tipo_via,
    this.direccion,
    this.departamento,
    this.provincia,
    this.distrito,
    this.nombre_conyuge,
    this.fecha_nacimiento_conyuge,
    this.padre_nombre,
    this.padre_vive,
    this.madre_nombre,
    this.madre_vive,
    this.grupo_sanguineo,
    this.religion,
    this.presentado_logia,
    this.nombre_logia,
    required this.nombres_apellidos,
    this.parentesco,
    this.fecha_nacimiento1,
    this.sexo,
    this.estado_civil,
    this.id_organizacion,
  });

  factory UsuarioCreate.fromJson(Map<String, dynamic> json) =>
      _$UsuarioCreateFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioCreateToJson(this);
}

@JsonSerializable()
class UsuarioResponse {
  final int id;
  final String mensaje;

  UsuarioResponse({
    required this.id,
    this.mensaje = "Usuario registrado exitosamente",
  });

  factory UsuarioResponse.fromJson(Map<String, dynamic> json) =>
      _$UsuarioResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioResponseToJson(this);
}

//modelos de respuesta para la subida de foto
@JsonSerializable()
class FotoResponse {
  final String mensaje;

  FotoResponse({this.mensaje = "Foto subida exitosamente"});

  factory FotoResponse.fromJson(Map<String, dynamic> json) =>
      _$FotoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FotoResponseToJson(this);
}

//modelos de respuesta para la subida del docuemnto
@JsonSerializable()
class DocumentoResponse {
  final int id;
  final String mensaje;

  DocumentoResponse({
    required this.id,
    this.mensaje = "Documento subido exitosamente",
  });

  factory DocumentoResponse.fromJson(Map<String, dynamic> json) =>
      _$DocumentoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DocumentoResponseToJson(this);
}

//modelos de cambios de estado de usuario
@JsonSerializable()
class CambioEstadoBase {
  final int usuario_id;
  final int estado_nuevo_id;
  final String? comentario;

  CambioEstadoBase({
    required this.usuario_id,
    required this.estado_nuevo_id,
    this.comentario,
  });

  factory CambioEstadoBase.fromJson(Map<String, dynamic> json) =>
      _$CambioEstadoBaseFromJson(json);
  Map<String, dynamic> toJson() => _$CambioEstadoBaseToJson(this);
}

@JsonSerializable()
class CambioEstadoCreate extends CambioEstadoBase {
  CambioEstadoCreate({
    required int usuario_id,
    required int estado_nuevo_id,
    String? comentario,
  }) : super(
          usuario_id: usuario_id,
          estado_nuevo_id: estado_nuevo_id,
          comentario: comentario,
        );

  factory CambioEstadoCreate.fromJson(Map<String, dynamic> json) =>
      _$CambioEstadoCreateFromJson(json);
  Map<String, dynamic> toJson() => _$CambioEstadoCreateToJson(this);
}

@JsonSerializable()
class CambioEstadoResponse extends CambioEstadoBase {
  final int id;
  final DateTime fecha_cambio;
  final int estado_anterior_id;
  final int admin_id;

  CambioEstadoResponse({
    required this.id,
    required this.fecha_cambio,
    required this.estado_anterior_id,
    required this.admin_id,
    required int usuario_id,
    required int estado_nuevo_id,
    String? comentario,
  }) : super(
          usuario_id: usuario_id,
          estado_nuevo_id: estado_nuevo_id,
          comentario: comentario,
        );

  factory CambioEstadoResponse.fromJson(Map<String, dynamic> json) =>
      _$CambioEstadoResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CambioEstadoResponseToJson(this);
}

//modelos de la actualizacion de datos de usuario
@JsonSerializable()
class UsuarioUpdate {
  final String? dni;
  final String? email;
  final String? password;
  final String? nombres;
  final String? apellidos_paterno;
  final String? apellidos_materno;
  final DateTime? fecha_nacimiento;
  final String? celular;
  final int? rol_id;
  final String? profesion;
  final String? especialidad;
  final String? centro_trabajo;
  final String? direccion_trabajo;
  final double? sueldo_mensual;
  final String? tipo_via;
  final String? direccion;
  final String? departamento;
  final String? provincia;
  final String? distrito;
  final String? nombre_conyuge;
  final DateTime? fecha_nacimiento_conyuge;
  final String? padre_nombre;
  final bool? padre_vive;
  final String? madre_nombre;
  final bool? madre_vive;
  final String? grupo_sanguineo;
  final String? religion;
  final bool? presentado_logia;
  final String? nombre_logia;
  final String? nombres_apellidos;
  final String? parentesco;
  final DateTime? fecha_nacimiento1;
  final String? sexo;
  final String? estado_civil;

  UsuarioUpdate({
    this.dni,
    this.email,
    this.password,
    this.nombres,
    this.apellidos_paterno,
    this.apellidos_materno,
    this.fecha_nacimiento,
    this.celular,
    this.rol_id,
    this.profesion,
    this.especialidad,
    this.centro_trabajo,
    this.direccion_trabajo,
    this.sueldo_mensual,
    this.tipo_via,
    this.direccion,
    this.departamento,
    this.provincia,
    this.distrito,
    this.nombre_conyuge,
    this.fecha_nacimiento_conyuge,
    this.padre_nombre,
    this.padre_vive,
    this.madre_nombre,
    this.madre_vive,
    this.grupo_sanguineo,
    this.religion,
    this.presentado_logia,
    this.nombre_logia,
    this.nombres_apellidos,
    this.parentesco,
    this.fecha_nacimiento1,
    this.sexo,
    this.estado_civil,
  });

  factory UsuarioUpdate.fromJson(Map<String, dynamic> json) =>
      _$UsuarioUpdateFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioUpdateToJson(this);
}

//modelos de respuesta de generar reporte de usuario por estado
@JsonSerializable()
class ReportTemplate {
  final String title;

  ReportTemplate({required this.title});

  factory ReportTemplate.fromJson(Map<String, dynamic> json) =>
      _$ReportTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$ReportTemplateToJson(this);
}

@JsonSerializable()
class ReportRequest {
  final String estado_nombre;
  final String formato;
  final ReportTemplate template;

  ReportRequest({
    required this.estado_nombre,
    required this.formato,
    required this.template,
  });

  factory ReportRequest.fromJson(Map<String, dynamic> json) =>
      _$ReportRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ReportRequestToJson(this);
}

//modelos de error derespuesta de documento asociado a usuario
@JsonSerializable()
class DocumentError {
  final String detail;

  DocumentError({required this.detail});

  factory DocumentError.fromJson(Map<String, dynamic> json) {
    return DocumentError(
        detail: json['detail'] as String? ?? 'Error desconocido');
  }

  Map<String, dynamic> toJson() => {'detail': detail};
}

//modelos de respuesta de modulo de gestion de reuniones

class MeetingCreate {
  final DateTime fecha;
  final String lugar;
  final Map<String, dynamic> agenda;
  final String cabecera_invitacion; 

  MeetingCreate({
    required this.fecha,
    required this.lugar,
    required this.agenda,
    required this.cabecera_invitacion, 
  });

  Map<String, dynamic> toJson() => {
        'fecha': fecha.toIso8601String(),
        'lugar': lugar,
        'agenda': agenda,
        'cabecera_invitacion': cabecera_invitacion,
      };
}

class MeetingUpdate {
  final DateTime? fecha;
  final String? lugar;
  final Map<String, dynamic>? agenda;
  final String? estado;
  final String? cabecera_invitacion;

  MeetingUpdate({
    this.fecha,
    this.lugar,
    this.agenda,
    this.estado,
    this.cabecera_invitacion,
  });

  Map<String, dynamic> toJson() => {
    if (fecha != null) 'fecha': fecha!.toIso8601String(),
    if (lugar != null) 'lugar': lugar,
    if (agenda != null) 'agenda': agenda,
    if (estado != null) 'estado': estado,
    if (cabecera_invitacion != null) 'cabecera_invitacion': cabecera_invitacion,
  };
}

class MeetingResponse {
  final int id;
  final DateTime fecha;
  final String lugar;
  final Map<String, dynamic> agenda; // Cambiar de String a Map
  final String estado;
  final int creador_id;
  final String cabecera_invitacion;

  MeetingResponse({
    required this.id,
    required this.fecha,
    required this.lugar,
    required this.agenda,
    required this.estado,
    required this.creador_id,
    required this.cabecera_invitacion,
  });

  factory MeetingResponse.fromJson(Map<String, dynamic> json) {
    return MeetingResponse(
      id: json['id'] as int,
      fecha: DateTime.parse(json['fecha'] as String),
      lugar: json['lugar'] as String,
      agenda: json['agenda'] as Map<String, dynamic>, // Cambiar aquí también
      estado: json['estado'] as String,
      creador_id: json['creador_id'] as int,
      cabecera_invitacion: json['cabecera_invitacion'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fecha': fecha.toIso8601String(),
    'lugar': lugar,
    'agenda': agenda,
    'estado': estado,
    'creador_id': creador_id,
    'cabecera_invitacion': cabecera_invitacion,
  };
}

class MeetingListResponse {
  final int id;
  final DateTime fecha;
  final String lugar;
  final Map<String, dynamic> agenda;
  final String estado;
  final int creador_id;
  final bool tiene_asistencia;
  final String cabecera_invitacion;

  MeetingListResponse({
    required this.id,
    required this.fecha,
    required this.lugar,
    required this.agenda,
    required this.estado,
    required this.creador_id,
    required this.tiene_asistencia,
    required this.cabecera_invitacion,
  });

  factory MeetingListResponse.fromJson(Map<String, dynamic> json) {
    return MeetingListResponse(
      id: json['id'] as int,
      fecha: DateTime.parse(json['fecha'] as String),
      lugar: json['lugar'] as String,
      agenda: json['agenda'] as Map<String, dynamic>, 
      estado: json['estado'] as String,
      creador_id: json['creador_id'] as int,
      tiene_asistencia: json['tiene_asistencia'] as bool? ?? false,
      cabecera_invitacion: json['cabecera_invitacion'] as String? ?? '',
    );
  }

  bool get publicada => estado == 'Publicada';
}

// Lista de trabajos con datos del usuario
class TrabajoListResponse {
  final int id;
  final int usuarioId;
  final int reunionId;
  final String titulo;
  final String descripcion;
  final DateTime fechaPresentacion;
  final String estado;
  final String nombreUsuario;

  TrabajoListResponse({
    required this.id,
    required this.usuarioId,
    required this.reunionId,
    required this.titulo,
    required this.descripcion,
    required this.fechaPresentacion,
    required this.estado,
    required this.nombreUsuario,
  });

  factory TrabajoListResponse.fromJson(Map<String, dynamic> json) {
    return TrabajoListResponse(
      id: json['id'] as int,
      usuarioId: json['usuario_id'] as int,
      reunionId: json['reunion_id'] as int,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      fechaPresentacion: DateTime.parse(json['fecha_presentacion']),
      estado: json['estado'] as String,
      nombreUsuario: json['nombre_usuario'] as String,
    );
  }
}

// Error específico para listado de trabajos
class TrabajoListError implements Exception {
  final String message;
  final int? statusCode;

  TrabajoListError(this.message, {this.statusCode});

  @override
  String toString() => message;
}

//modelos de respuesta de ruta de crear acta
class ActaResponse {
  final int id;
  final int reunionId;
  final DateTime fechaSubida;
  final String estado;

  ActaResponse({
    required this.id,
    required this.reunionId,
    required this.fechaSubida,
    required this.estado,
  });

  factory ActaResponse.fromJson(Map<String, dynamic> json) {
    return ActaResponse(
      id: json['id'] as int,
      reunionId: json['reunion_id'] as int,
      fechaSubida: DateTime.parse(json['fecha_subida']),
      estado: json['estado'] as String,
    );
  }
}

class ActaError implements Exception {
  final String message;
  final int? statusCode;

  ActaError(this.message, {this.statusCode});

  @override
  String toString() => message;
}

//modelo de respuesta de ruta de subir el acta
class ContenidoActaResponse {
  final int id;
  final int actaId;
  final String tipoMime;

  ContenidoActaResponse({
    required this.id,
    required this.actaId,
    required this.tipoMime,
  });

  factory ContenidoActaResponse.fromJson(Map<String, dynamic> json) {
    return ContenidoActaResponse(
      id: json['id'] as int,
      actaId: json['acta_id'] as int,
      tipoMime: json['tipo_mime'] as String,
    );
  }
}

// Modelo de error
class ContenidoActaError implements Exception {
  final String message;
  final int? statusCode;

  ContenidoActaError(this.message, {this.statusCode});

  @override
  String toString() => message;
}

//modelo de erro de la ruta para descargar el acta
// Modelo de error específico para descarga
class DownloadActaError implements Exception {
  final String message;
  final int? statusCode;

  DownloadActaError(this.message, {this.statusCode});

  @override
  String toString() => message;
}

//modelo de respuesta de ruta de crear trabajo
class TrabajoResponse {
  final int id;
  final int usuarioId;
  final int reunionId;
  final String titulo;
  final String descripcion;
  final DateTime fechaPresentacion;
  final String estado;

  TrabajoResponse({
    required this.id,
    required this.usuarioId,
    required this.reunionId,
    required this.titulo,
    required this.descripcion,
    required this.fechaPresentacion,
    required this.estado,
  });

  factory TrabajoResponse.fromJson(Map<String, dynamic> json) {
    return TrabajoResponse(
      id: json['id'] as int,
      usuarioId: json['usuario_id'] as int,
      reunionId: json['reunion_id'] as int,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      fechaPresentacion: DateTime.parse(json['fecha_presentacion']),
      estado: json['estado'] as String,
    );
  }
}

// Modelo de error
class TrabajoError implements Exception {
  final String message;
  final int? statusCode;

  TrabajoError(this.message, {this.statusCode});

  @override
  String toString() => message;
}

//modelo de respuesta de actualizar trabajo

class TrabajoUpdateRequest {
  final String? titulo;
  final String? descripcion;
  final String? estado;
  final DateTime? fechaPresentacion;

  TrabajoUpdateRequest({
    this.titulo,
    this.descripcion,
    this.estado,
    this.fechaPresentacion,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (titulo != null) data['titulo'] = titulo;
    if (descripcion != null) data['descripcion'] = descripcion;
    if (estado != null) data['estado'] = estado;
    if (fechaPresentacion != null) {
      data['fecha_presentacion'] =
          fechaPresentacion!.toIso8601String().split('T')[0];
    }
    return data;
  }
}

// Modelo de error específico
class TrabajoUpdateError implements Exception {
  final String message;
  final int? statusCode;

  TrabajoUpdateError(this.message, {this.statusCode});

  @override
  String toString() => message;
}

// Modelo de error para reportes
class ReportError implements Exception {
  final String message;
  final int? statusCode;

  ReportError(this.message, {this.statusCode});

  @override
  String toString() => message;
}

//modelos de rutas de asistencia
class UsuarioAsistenciaModel {
  final int id;
  final String nombres;
  final String apellidosPaterno;
  final String apellidosMaterno;

  UsuarioAsistenciaModel({
    required this.id,
    required this.nombres,
    required this.apellidosPaterno,
    required this.apellidosMaterno,
  });

  factory UsuarioAsistenciaModel.fromJson(Map<String, dynamic> json) {
    return UsuarioAsistenciaModel(
      id: json['id'] ?? 0,
      nombres: json['nombres'] ?? '',
      apellidosPaterno: json['apellidos_paterno'] ?? '',
      apellidosMaterno: json['apellidos_materno'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombres': nombres,
        'apellidos_paterno': apellidosPaterno,
        'apellidos_materno': apellidosMaterno,
      };
}

enum EstadoAsistencia { Asistido, No_asistido, Justificado }

class AsistenciaCreate {
  final int usuarioId;
  final EstadoAsistencia estado;

  AsistenciaCreate({
    required this.usuarioId,
    required this.estado,
  });

  Map<String, dynamic> toJson() => {
        'usuario_id': usuarioId,
        'estado': estado.toString().split('.').last,
      };
}

class AsistenciaMasiva {
  final int reunionId;
  final List<AsistenciaCreate> asistencias;
  final DateTime fecha;

  AsistenciaMasiva({
    required this.reunionId,
    required this.asistencias,
    required this.fecha,
  });

  Map<String, dynamic> toJson() => {
        'reunion_id': reunionId,
        'asistencias': asistencias.map((a) => a.toJson()).toList(),
        'fecha': fecha.toIso8601String().split('T').first,
      };
}

class AsistenciaResponse {
  final int id;
  final int usuarioId;
  final EstadoAsistencia estado;
  final DateTime fecha;
  final UsuarioAsistenciaModel usuario;

  AsistenciaResponse({
    required this.id,
    required this.usuarioId,
    required this.estado,
    required this.fecha,
    required this.usuario,
  });

  factory AsistenciaResponse.fromJson(Map<String, dynamic> json) {
    return AsistenciaResponse(
      id: json['id'],
      usuarioId: json['usuario_id'],
      estado: EstadoAsistencia.values.firstWhere(
        (e) => e.toString().split('.').last == json['estado'],
      ),
      fecha: DateTime.parse(json['fecha']),
      usuario: UsuarioAsistenciaModel.fromJson(json['usuario']),
    );
  }
}

// modelo para actualización individual
class AsistenciaUpdateItem {
  final int usuarioId;
  final EstadoAsistencia estado;

  AsistenciaUpdateItem({
    required this.usuarioId,
    required this.estado,
  });

  Map<String, dynamic> toJson() => {
        'usuario_id': usuarioId,
        'estado': estado.toString().split('.').last,
      };
}

// modelo para actualización masiva
class AsistenciaUpdateMasiva {
  final int reunionId;
  final List<AsistenciaUpdateItem> asistencias;

  AsistenciaUpdateMasiva({
    required this.reunionId,
    required this.asistencias,
  });

  Map<String, dynamic> toJson() => {
        'reunion_id': reunionId,
        'asistencias': asistencias.map((a) => a.toJson()).toList(),
      };
}

class UsuarioConGrado {
  final int id;
  final String nombres;
  final String apellidosPaterno;
  final String apellidosMaterno;
  final String grado;

  UsuarioConGrado({
    required this.id,
    required this.nombres,
    required this.apellidosPaterno,
    required this.apellidosMaterno,
    this.grado = "Sin grado",
  });

  factory UsuarioConGrado.fromJson(Map<String, dynamic> json) {
    return UsuarioConGrado(
      id: json['id'] as int,
      nombres: json['nombres'] as String,
      apellidosPaterno: json['apellidos_paterno'] as String,
      apellidosMaterno: json['apellidos_materno'] as String,
      grado: json['grado'] as String? ?? "Sin grado",
    );
  }
}

// Modelo de error específico
class UsuariosGradoError implements Exception {
  final String message;
  final int? statusCode;

  UsuariosGradoError(this.message, {this.statusCode});

  @override
  String toString() => message;
}

enum TipoGrado {
  Aprendiz,
  Companero, // Sin ñ en el enum (no podemos usar ñ en identificadores)
  Maestro;

  String get display {
    switch (this) {
      case TipoGrado.Aprendiz:
        return 'Aprendiz';
      case TipoGrado.Companero:
        return 'Compañero'; // Con ñ para mostrar
      case TipoGrado.Maestro:
        return 'Maestro';
    }
  }

  // Nuevo método para convertir a string para el backend
  String toBackendString() {
    switch (this) {
      case TipoGrado.Aprendiz:
        return 'Aprendiz';
      case TipoGrado.Companero:
        return 'Compañero'; // Con ñ para el backend
      case TipoGrado.Maestro:
        return 'Maestro';
    }
  }
}

class GradoCreate {
  final int usuario_id;
  final int id_grado;
  final String estado;

  GradoCreate({
    required this.usuario_id,
    required this.id_grado,
    this.estado = 'Activo',
  });

  Map<String, dynamic> toJson() => {
    'usuario_id': usuario_id,
    'id_grado': id_grado,
    'estado': estado,
  };
}

class GradoError implements Exception {
  final String message;
  final int? statusCode;

  GradoError(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class GradoUpdate {
  final int id_grado;
  final String? estado;

  GradoUpdate({
    required this.id_grado,
    this.estado,
  });

  Map<String, dynamic> toJson() => {
    'id_grado': id_grado,
    if (estado != null) 'estado': estado,
  };
}

// Agregamos también el enum para estado de grado
enum EstadoGrado {
  Activo,
  Inactivo;

  String get display {
    switch (this) {
      case EstadoGrado.Activo:
        return 'Activo';
      case EstadoGrado.Inactivo:
        return 'Inactivo';
    }
  }
}

class FotoInvitacionResponse {
  final int id;
  final String fotoTipoMime;
  final DateTime fechaSubida;

  FotoInvitacionResponse({
    required this.id,
    required this.fotoTipoMime,
    required this.fechaSubida,
  });

  factory FotoInvitacionResponse.fromJson(Map<String, dynamic> json) {
    return FotoInvitacionResponse(
      id: json['id'] as int,
      fotoTipoMime: json['foto_tipo_mime'] as String,
      fechaSubida: DateTime.parse(json['fecha_subida'] as String),
    );
  }
}

// Modelo de error para foto de invitación
class FotoInvitacionError implements Exception {
  final String message;
  final int? statusCode;

  FotoInvitacionError(this.message, {this.statusCode});

  @override
  String toString() => message;
}


class NewOrganizacionResponse {
  final String descripcion;
  final String numero;
  final String grupo;  // Cambio aquí: ahora es String en lugar de NewGrupoTipo

  NewOrganizacionResponse({
    required this.descripcion,
    required this.numero,
    required this.grupo,
  });

  factory NewOrganizacionResponse.fromJson(Map<String, dynamic> json) {
    return NewOrganizacionResponse(
      descripcion: json['descripcion'] as String,
      numero: json['numero'] as String,
      grupo: json['grupo'] as String,  // Cambio aquí
    );
  }

  Map<String, dynamic> toJson() => {
    'descripcion': descripcion,
    'numero': numero,
    'grupo': grupo,
  };
}

class NewGrupoTipo {
  final String nombre;

  NewGrupoTipo({required this.nombre});

  factory NewGrupoTipo.fromJson(Map<String, dynamic> json) {
    return NewGrupoTipo(
      nombre: json['nombre'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'nombre': nombre};
}
class NewOrganizacionError implements Exception {
  final String message;
  final int? statusCode;

  NewOrganizacionError(this.message, {this.statusCode});

  @override
  String toString() => message;
}


class PasswordUpdateRequest {
  final String password;

  PasswordUpdateRequest({required this.password});

  Map<String, dynamic> toJson() => {
    'password': password,
  };
}

class PasswordUpdateResponse {
  final String message;

  PasswordUpdateResponse({
    required this.message,
  });

  factory PasswordUpdateResponse.fromJson(Map<String, dynamic> json) {
    return PasswordUpdateResponse(
      message: json['message'] as String,
    );
  }
}

class PasswordUpdateError implements Exception {
  final String message;
  final int? statusCode;

  PasswordUpdateError(this.message, {this.statusCode});

  @override
  String toString() => message;
}


// Modelo para listar actas por reunión
class ActaDetailResponse {
  final int id;
  final int reunionId;
  final DateTime fechaSubida;
  final String estado;

  ActaDetailResponse({
    required this.id,
    required this.reunionId,
    required this.fechaSubida,
    required this.estado,
  });

  factory ActaDetailResponse.fromJson(Map<String, dynamic> json) {
    return ActaDetailResponse(
      id: json['id'] as int,
      reunionId: json['reunion_id'] as int,
      fechaSubida: DateTime.parse(json['fecha_subida']),
      estado: json['estado'] as String,
    );
  }
}

// Modelo para respuesta de eliminación de acta
class DeleteActaResponse {
  final String message;

  DeleteActaResponse({required this.message});

  factory DeleteActaResponse.fromJson(Map<String, dynamic> json) {
    return DeleteActaResponse(
      message: json['message'] as String,
    );
  }
}


class EnlaceBase {
  final String nombre;
  final String? descripcion;

  EnlaceBase({
    required this.nombre,
    this.descripcion,
  });

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    if (descripcion != null) 'descripcion': descripcion,
  };
}

class EnlaceCreate extends EnlaceBase {
  EnlaceCreate({
    required String nombre,
    String? descripcion,
  }) : super(nombre: nombre, descripcion: descripcion);
}

class EnlaceUpdate {
  final String? nombre;
  final String? descripcion;
  final bool? estado;

  EnlaceUpdate({
    this.nombre,
    this.descripcion,
    this.estado,
  });

  Map<String, dynamic> toJson() => {
    if (nombre != null) 'nombre': nombre,
    if (descripcion != null) 'descripcion': descripcion,
    if (estado != null) 'estado': estado,
  };
}

class EnlaceResponse extends EnlaceBase {
  final int id;
  final bool estado;

  EnlaceResponse({
    required this.id,
    required String nombre,
    String? descripcion,
    required this.estado,
  }) : super(nombre: nombre, descripcion: descripcion);

  factory EnlaceResponse.fromJson(Map<String, dynamic> json) {
    return EnlaceResponse(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      estado: json['estado'] as bool,
    );
  }
}

// Modelos para URLs
class URLBase {
  final String url;
  final int enlaceId;

  URLBase({
    required this.url,
    required this.enlaceId,
  });

  Map<String, dynamic> toJson() => {
    'url': url,
    'enlace_id': enlaceId,
  };
}

class URLCreate extends URLBase {
  URLCreate({
    required String url,
    required int enlaceId,
  }) : super(url: url, enlaceId: enlaceId);
}

class URLUpdate {
  final String? url;
  final bool? estado;

  URLUpdate({
    this.url,
    this.estado,
  });

  Map<String, dynamic> toJson() => {
    if (url != null) 'url': url,
    if (estado != null) 'estado': estado,
  };
}

class URLResponse extends URLBase {
  final int id;
  final DateTime fechaCreacion;
  final bool estado;

  URLResponse({
    required this.id,
    required String url,
    required int enlaceId,
    required this.fechaCreacion,
    required this.estado,
  }) : super(url: url, enlaceId: enlaceId);

  factory URLResponse.fromJson(Map<String, dynamic> json) {
    return URLResponse(
      id: json['id'] as int,
      url: json['url'] as String,
      enlaceId: json['enlace_id'] as int,
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      estado: json['estado'] as bool,
    );
  }
}

class URLListResponse extends URLBase {
  final int id;
  final String enlaceNombre;
  final DateTime fechaCreacion;
  final bool estado;

  URLListResponse({
    required this.id,
    required String url,
    required int enlaceId,
    required this.enlaceNombre,
    required this.fechaCreacion,
    required this.estado,
  }) : super(url: url, enlaceId: enlaceId);

  factory URLListResponse.fromJson(Map<String, dynamic> json) {
    return URLListResponse(
      id: json['id'] as int,
      url: json['url'] as String,
      enlaceId: json['enlace_id'] as int,
      enlaceNombre: json['enlace_nombre'] as String,
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      estado: json['estado'] as bool,
    );
  }
}


class ContenidoTrabajoResponse {
  final int id;
  final int trabajoId;
  final String nombreArchivo;
  final String tipoMime;
  final DateTime fechaSubida;

  ContenidoTrabajoResponse({
    required this.id,
    required this.trabajoId,
    required this.nombreArchivo,
    required this.tipoMime,
    required this.fechaSubida,
  });

  factory ContenidoTrabajoResponse.fromJson(Map<String, dynamic> json) {
    return ContenidoTrabajoResponse(
      id: json['id'] as int,
      trabajoId: json['trabajo_id'] as int,
      nombreArchivo: json['nombre_archivo'] as String,
      tipoMime: json['tipo_mime'] as String,
      fechaSubida: DateTime.parse(json['fecha_subida']),
    );
  }
}

// Modelo de error específico
class ContenidoTrabajoError implements Exception {
  final String message;
  final int? statusCode;

  ContenidoTrabajoError(this.message, {this.statusCode});

  @override
  String toString() => message;
}


// Cargo models
class CargoBase {
  final int idOrganizacion;
  final int idUsuario; 
  final String abreviatura;
  final String cargoNombre; 

  CargoBase({
    required this.idOrganizacion,
    required this.idUsuario,
    required this.abreviatura,
    required this.cargoNombre, 
  });

  Map<String, dynamic> toJson() => {
    'id_organizacion': idOrganizacion,
    'id_usuario': idUsuario,
    'abreviatura': abreviatura,
    'cargo_nombre': cargoNombre, 
  };
}

class CargoCreate extends CargoBase {
  CargoCreate({
    required int idOrganizacion,
    required int idUsuario,
    required String abreviatura,
    required String cargoNombre, 
  }) : super(
    idOrganizacion: idOrganizacion, 
    idUsuario: idUsuario,
    abreviatura: abreviatura,
    cargoNombre: cargoNombre, 
  );
}

class CargoUpdate {
  final int? idOrganizacion;
  final int? idUsuario;
  final String? abreviatura;
  final String? cargoNombre;

  CargoUpdate({
    this.idOrganizacion,
    this.idUsuario,
    this.abreviatura,
    this.cargoNombre, 
  });

  Map<String, dynamic> toJson() => {
    if (idOrganizacion != null) 'id_organizacion': idOrganizacion,
    if (idUsuario != null) 'id_usuario': idUsuario,
    if (abreviatura != null) 'abreviatura': abreviatura,
    if (cargoNombre != null) 'cargo_nombre': cargoNombre, 
  };
}

class CargoResponse {
  final int id;
  final int idOrganizacion;
  final int idUsuario;
  final String abreviatura;
  final String cargoNombre; 
  final String nombreUsuario;
  final String nombreOrganizacion;

  CargoResponse({
    required this.id,
    required this.idOrganizacion,
    required this.idUsuario,
    required this.abreviatura,
    required this.cargoNombre, 
    required this.nombreUsuario,
    required this.nombreOrganizacion,
  });

  factory CargoResponse.fromJson(Map<String, dynamic> json) {
    return CargoResponse(
      id: json['id'],
      idOrganizacion: json['id_organizacion'],
      idUsuario: json['id_usuario'],
      abreviatura: json['abreviatura'],
      cargoNombre: json['cargo_nombre'], 
      nombreUsuario: json['nombre_usuario'],
      nombreOrganizacion: json['nombre_organizacion'],
    );
  }
}

class CargoDetailResponse {
  final String cargoNombre;
  final String abreviatura; 
  final int idUsuario;
  final String usuarioNombre;
  final String usuarioEmail;
  final String usuarioCelular;

  CargoDetailResponse({
    required this.cargoNombre,
    required this.abreviatura,
    required this.idUsuario,
    required this.usuarioNombre,
    required this.usuarioEmail,
    required this.usuarioCelular,
  });

  factory CargoDetailResponse.fromJson(Map<String, dynamic> json) {
    return CargoDetailResponse(
      cargoNombre: json['cargo_nombre'] as String,
      abreviatura: json['abreviatura'] as String,
      idUsuario: json['id_usuario'] as int, // Añadido al fromJson
      usuarioNombre: json['usuario_nombre'] as String,
      usuarioEmail: json['usuario_email'] as String,
      usuarioCelular: json['usuario_celular'] as String,
    );
  }
}

// Modelo de error específico
class CargoDetailError implements Exception {
  final String message;
  final int? statusCode;

  CargoDetailError(this.message, {this.statusCode});

  @override
  String toString() => message;
}



class UsuarioBasicInfo {
  final int id;
  final String nombres;
  final String apellidosPaterno;
  final String apellidosMaterno;

  UsuarioBasicInfo({
    required this.id,
    required this.nombres,
    required this.apellidosPaterno,
    required this.apellidosMaterno,
  });

  factory UsuarioBasicInfo.fromJson(Map<String, dynamic> json) {
    return UsuarioBasicInfo(
      id: json['id'] as int,
      nombres: json['nombres'] as String,
      apellidosPaterno: json['apellidos_paterno'] as String,
      apellidosMaterno: json['apellidos_materno'] as String,
    );
  }
}

// Agregar con los otros modelos
class GradoSimpleResponse {
  final int id;
  final String nombre;

  GradoSimpleResponse({
    required this.id,
    required this.nombre,
  });

  factory GradoSimpleResponse.fromJson(Map<String, dynamic> json) {
    return GradoSimpleResponse(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
    );
  }
}