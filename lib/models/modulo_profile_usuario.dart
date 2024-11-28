// modulo_profile_usuario.dart

import 'dart:typed_data';

class GradoOut {
  final int? id;
  final String? grado;
  final String? abrev_grado;
  final DateTime? fecha_grado;

  GradoOut({
    this.id,
    this.grado,
    this.abrev_grado,
    this.fecha_grado,
  });

  factory GradoOut.fromJson(Map<String, dynamic> json) {
    return GradoOut(
      id: json['id'] as int?,
      grado: json['grado'] as String?,
      abrev_grado: json['abrev_grado'] as String?,
      fecha_grado: json['fecha_grado'] == null
          ? null
          : DateTime.parse(json['fecha_grado'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'grado': grado,
        'abrev_grado': abrev_grado,
        'fecha_grado': fecha_grado?.toIso8601String(),
      };
}

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'profesion': profesion,
        'especialidad': especialidad,
        'centro_trabajo': centro_trabajo,
        'direccion_trabajo': direccion_trabajo,
        'sueldo_mensual': sueldo_mensual,
      };
}

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipo_via': tipo_via,
        'direccion': direccion,
        'departamento': departamento,
        'provincia': provincia,
        'distrito': distrito,
      };
}

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre_conyuge': nombre_conyuge,
        'fecha_nacimiento_conyuge': fecha_nacimiento_conyuge?.toIso8601String(),
        'padre_nombre': padre_nombre,
        'padre_vive': padre_vive,
        'madre_nombre': madre_nombre,
        'madre_vive': madre_vive,
      };
}

class DependienteOut {
  final int? id;
  final String nombres_apellidos;
  final String? parentesco;
  final DateTime? fecha_nacimiento;
  final String? sexo;
  final String? estado_civil;

  DependienteOut({
    this.id,
    required this.nombres_apellidos,
    this.parentesco,
    this.fecha_nacimiento,
    this.sexo,
    this.estado_civil,
  });

  factory DependienteOut.fromJson(Map<String, dynamic> json) {
    return DependienteOut(
      id: json['id'] as int?,
      nombres_apellidos: json['nombres_apellidos'] as String,
      parentesco: json['parentesco'] as String?,
      fecha_nacimiento: json['fecha_nacimiento'] == null
          ? null
          : DateTime.parse(json['fecha_nacimiento'] as String),
      sexo: json['sexo'] as String?,
      estado_civil: json['estado_civil'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombres_apellidos': nombres_apellidos,
        'parentesco': parentesco,
        'fecha_nacimiento': fecha_nacimiento?.toIso8601String(),
        'sexo': sexo,
        'estado_civil': estado_civil,
      };
}

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'grupo_sanguineo': grupo_sanguineo,
        'religion': religion,
        'presentado_logia': presentado_logia,
        'nombre_logia': nombre_logia,
      };
}

class UserProfileResponse {
  final int id;
  final String dni;
  final String email;
  final String nombres;
  final String apellidos_paterno;
  final String apellidos_materno;
  final DateTime fecha_nacimiento;
  final String celular;
  final int rol_id;
  final int estado_id;
  final DateTime fecha_registro;
  final String password_hash;
  final GradoOut? grados;
  final InformacionProfesionalOut? informacion_profesional;
  final DireccionOut? direcciones;
  final InformacionFamiliarOut? informacion_familiar;
  final DependienteOut? dependientes;
  final InformacionAdicionalOut? informacion_adicional;

  UserProfileResponse({
    required this.id,
    required this.dni,
    required this.email,
    required this.nombres,
    required this.apellidos_paterno,
    required this.apellidos_materno,
    required this.fecha_nacimiento,
    required this.celular,
    required this.rol_id,
    required this.estado_id,
    required this.fecha_registro,
    required this.password_hash,
    this.grados,
    this.informacion_profesional,
    this.direcciones,
    this.informacion_familiar,
    this.dependientes,
    this.informacion_adicional,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      id: json['id'] as int,
      dni: json['dni'] as String,
      email: json['email'] as String,
      nombres: json['nombres'] as String,
      apellidos_paterno: json['apellidos_paterno'] as String,
      apellidos_materno: json['apellidos_materno'] as String,
      fecha_nacimiento: DateTime.parse(json['fecha_nacimiento'] as String),
      celular: json['celular'] as String,
      rol_id: json['rol_id'] as int,
      estado_id: json['estado_id'] as int,
      fecha_registro: DateTime.parse(json['fecha_registro'] as String),
      password_hash: json['password_hash'] as String,
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'dni': dni,
        'email': email,
        'nombres': nombres,
        'apellidos_paterno': apellidos_paterno,
        'apellidos_materno': apellidos_materno,
        'fecha_nacimiento': fecha_nacimiento.toIso8601String(),
        'celular': celular,
        'rol_id': rol_id,
        'estado_id': estado_id,
        'fecha_registro': fecha_registro.toIso8601String(),
        'password_hash': password_hash,
        'grados': grados?.toJson(),
        'informacion_profesional': informacion_profesional?.toJson(),
        'direcciones': direcciones?.toJson(),
        'informacion_familiar': informacion_familiar?.toJson(),
        'dependientes': dependientes?.toJson(),
        'informacion_adicional': informacion_adicional?.toJson(),
      };
}

class UserPhotoException implements Exception {
  final String message;
  final int statusCode;

  UserPhotoException({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() => message;
}

class PhotoResponse {
  final Uint8List bytes;
  final String mimeType;

  PhotoResponse({
    required this.bytes,
    required this.mimeType,
  });
}

// Modelos para cambio de contraseña
class PasswordChangeRequest {
  final String newPassword;

  PasswordChangeRequest({required this.newPassword});

  Map<String, dynamic> toJson() => {
        'new_password': newPassword,
      };
}

class PasswordChangeResponse {
  final String message;

  PasswordChangeResponse({required this.message});

  factory PasswordChangeResponse.fromJson(Map<String, dynamic> json) {
    return PasswordChangeResponse(
      message: json['message'] as String,
    );
  }
}

class PasswordChangeException implements Exception {
  final String message;
  final int statusCode;

  PasswordChangeException({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() => message;
}
