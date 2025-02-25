// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modulo_gestion_usuario_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      dni: json['dni'] as String,
      email: json['email'] as String,
      nombres: json['nombres'] as String,
      apellidos_paterno: json['apellidos_paterno'] as String,
      apellidos_materno: json['apellidos_materno'] as String,
      fecha_nacimiento: DateTime.parse(json['fecha_nacimiento'] as String),
      celular: json['celular'] as String,
      rol_nombre: json['rol_nombre'] as String,
      estado_usuario_nombre: json['estado_usuario_nombre'] as String,
      fecha_registro: DateTime.parse(json['fecha_registro'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'dni': instance.dni,
      'email': instance.email,
      'nombres': instance.nombres,
      'apellidos_paterno': instance.apellidos_paterno,
      'apellidos_materno': instance.apellidos_materno,
      'fecha_nacimiento': instance.fecha_nacimiento.toIso8601String(),
      'celular': instance.celular,
      'rol_nombre': instance.rol_nombre,
      'estado_usuario_nombre': instance.estado_usuario_nombre,
      'fecha_registro': instance.fecha_registro.toIso8601String(),
    };

GradoOut _$GradoOutFromJson(Map<String, dynamic> json) => GradoOut(
      id: (json['id'] as num?)?.toInt(),
      id_grado: (json['id_grado'] as num?)?.toInt(),
      fecha_grado: json['fecha_grado'] == null
          ? null
          : DateTime.parse(json['fecha_grado'] as String),
      estado: json['estado'] as String?,
      fecha: json['fecha'] == null
          ? null
          : DateTime.parse(json['fecha'] as String),
      nombre_grado: json['nombre_grado'] as String?,
    );

Map<String, dynamic> _$GradoOutToJson(GradoOut instance) => <String, dynamic>{
      'id': instance.id,
      'id_grado': instance.id_grado,
      'fecha_grado': instance.fecha_grado?.toIso8601String(),
      'estado': instance.estado,
      'fecha': instance.fecha?.toIso8601String(),
      'nombre_grado': instance.nombre_grado,
    };

InformacionProfesionalOut _$InformacionProfesionalOutFromJson(
        Map<String, dynamic> json) =>
    InformacionProfesionalOut(
      id: (json['id'] as num?)?.toInt(),
      profesion: json['profesion'] as String?,
      especialidad: json['especialidad'] as String?,
      centro_trabajo: json['centro_trabajo'] as String?,
      direccion_trabajo: json['direccion_trabajo'] as String?,
      sueldo_mensual: (json['sueldo_mensual'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$InformacionProfesionalOutToJson(
        InformacionProfesionalOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profesion': instance.profesion,
      'especialidad': instance.especialidad,
      'centro_trabajo': instance.centro_trabajo,
      'direccion_trabajo': instance.direccion_trabajo,
      'sueldo_mensual': instance.sueldo_mensual,
    };

DireccionOut _$DireccionOutFromJson(Map<String, dynamic> json) => DireccionOut(
      id: (json['id'] as num?)?.toInt(),
      tipo_via: json['tipo_via'] as String?,
      direccion: json['direccion'] as String?,
      departamento: json['departamento'] as String?,
      provincia: json['provincia'] as String?,
      distrito: json['distrito'] as String?,
    );

Map<String, dynamic> _$DireccionOutToJson(DireccionOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tipo_via': instance.tipo_via,
      'direccion': instance.direccion,
      'departamento': instance.departamento,
      'provincia': instance.provincia,
      'distrito': instance.distrito,
    };

InformacionFamiliarOut _$InformacionFamiliarOutFromJson(
        Map<String, dynamic> json) =>
    InformacionFamiliarOut(
      id: (json['id'] as num?)?.toInt(),
      nombre_conyuge: json['nombre_conyuge'] as String?,
      fecha_nacimiento_conyuge: json['fecha_nacimiento_conyuge'] == null
          ? null
          : DateTime.parse(json['fecha_nacimiento_conyuge'] as String),
      padre_nombre: json['padre_nombre'] as String?,
      padre_vive: json['padre_vive'] as bool?,
      madre_nombre: json['madre_nombre'] as String?,
      madre_vive: json['madre_vive'] as bool?,
    );

Map<String, dynamic> _$InformacionFamiliarOutToJson(
        InformacionFamiliarOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre_conyuge': instance.nombre_conyuge,
      'fecha_nacimiento_conyuge':
          instance.fecha_nacimiento_conyuge?.toIso8601String(),
      'padre_nombre': instance.padre_nombre,
      'padre_vive': instance.padre_vive,
      'madre_nombre': instance.madre_nombre,
      'madre_vive': instance.madre_vive,
    };

DependienteOut _$DependienteOutFromJson(Map<String, dynamic> json) =>
    DependienteOut(
      id: (json['id'] as num?)?.toInt(),
      nombres_apellidos: json['nombres_apellidos'] as String?,
      parentesco: json['parentesco'] as String?,
      fecha_nacimiento: json['fecha_nacimiento'] == null
          ? null
          : DateTime.parse(json['fecha_nacimiento'] as String),
      sexo: json['sexo'] as String?,
      estado_civil: json['estado_civil'] as String?,
    );

Map<String, dynamic> _$DependienteOutToJson(DependienteOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombres_apellidos': instance.nombres_apellidos,
      'parentesco': instance.parentesco,
      'fecha_nacimiento': instance.fecha_nacimiento?.toIso8601String(),
      'sexo': instance.sexo,
      'estado_civil': instance.estado_civil,
    };

InformacionAdicionalOut _$InformacionAdicionalOutFromJson(
        Map<String, dynamic> json) =>
    InformacionAdicionalOut(
      id: (json['id'] as num?)?.toInt(),
      grupo_sanguineo: json['grupo_sanguineo'] as String?,
      religion: json['religion'] as String?,
      presentado_logia: json['presentado_logia'] as bool?,
      nombre_logia: json['nombre_logia'] as String?,
    );

Map<String, dynamic> _$InformacionAdicionalOutToJson(
        InformacionAdicionalOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'grupo_sanguineo': instance.grupo_sanguineo,
      'religion': instance.religion,
      'presentado_logia': instance.presentado_logia,
      'nombre_logia': instance.nombre_logia,
    };

UserDetail _$UserDetailFromJson(Map<String, dynamic> json) => UserDetail(
      id: (json['id'] as num).toInt(),
      dni: json['dni'] as String,
      email: json['email'] as String,
      nombres: json['nombres'] as String,
      apellidos_paterno: json['apellidos_paterno'] as String,
      apellidos_materno: json['apellidos_materno'] as String,
      fecha_nacimiento: DateTime.parse(json['fecha_nacimiento'] as String),
      celular: json['celular'] as String,
      rol_nombre: json['rol_nombre'] as String,
      estado_usuario_nombre: json['estado_usuario_nombre'] as String,
      fecha_registro: DateTime.parse(json['fecha_registro'] as String),
      password_hash: json['password_hash'] as String,
      rol_id: (json['rol_id'] as num).toInt(),
      estado_id: (json['estado_id'] as num).toInt(),
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

Map<String, dynamic> _$UserDetailToJson(UserDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dni': instance.dni,
      'email': instance.email,
      'nombres': instance.nombres,
      'apellidos_paterno': instance.apellidos_paterno,
      'apellidos_materno': instance.apellidos_materno,
      'fecha_nacimiento': instance.fecha_nacimiento.toIso8601String(),
      'celular': instance.celular,
      'rol_nombre': instance.rol_nombre,
      'estado_usuario_nombre': instance.estado_usuario_nombre,
      'fecha_registro': instance.fecha_registro.toIso8601String(),
      'password_hash': instance.password_hash,
      'rol_id': instance.rol_id,
      'estado_id': instance.estado_id,
      'grados': instance.grados,
      'informacion_profesional': instance.informacion_profesional,
      'direcciones': instance.direcciones,
      'informacion_familiar': instance.informacion_familiar,
      'dependientes': instance.dependientes,
      'informacion_adicional': instance.informacion_adicional,
    };

Documento _$DocumentoFromJson(Map<String, dynamic> json) => Documento(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
      tipo: json['tipo'] as String,
      fecha_subida: DateTime.parse(json['fecha_subida'] as String),
    );

Map<String, dynamic> _$DocumentoToJson(Documento instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'tipo': instance.tipo,
      'fecha_subida': instance.fecha_subida.toIso8601String(),
    };

ListaDocumentosResponse _$ListaDocumentosResponseFromJson(
        Map<String, dynamic> json) =>
    ListaDocumentosResponse(
      documentos: (json['documentos'] as List<dynamic>)
          .map((e) => Documento.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListaDocumentosResponseToJson(
        ListaDocumentosResponse instance) =>
    <String, dynamic>{
      'documentos': instance.documentos,
    };

UsuarioCreate _$UsuarioCreateFromJson(Map<String, dynamic> json) =>
    UsuarioCreate(
      dni: json['dni'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      nombres: json['nombres'] as String,
      apellidos_paterno: json['apellidos_paterno'] as String,
      apellidos_materno: json['apellidos_materno'] as String,
      fecha_nacimiento: DateTime.parse(json['fecha_nacimiento'] as String),
      celular: json['celular'] as String?,
      rol_id: (json['rol_id'] as num).toInt(),
      estado_id: (json['estado_id'] as num).toInt(),
      profesion: json['profesion'] as String?,
      especialidad: json['especialidad'] as String?,
      centro_trabajo: json['centro_trabajo'] as String?,
      direccion_trabajo: json['direccion_trabajo'] as String?,
      sueldo_mensual: (json['sueldo_mensual'] as num?)?.toDouble(),
      tipo_via: json['tipo_via'] as String?,
      direccion: json['direccion'] as String?,
      departamento: json['departamento'] as String?,
      provincia: json['provincia'] as String?,
      distrito: json['distrito'] as String?,
      nombre_conyuge: json['nombre_conyuge'] as String?,
      fecha_nacimiento_conyuge: json['fecha_nacimiento_conyuge'] == null
          ? null
          : DateTime.parse(json['fecha_nacimiento_conyuge'] as String),
      padre_nombre: json['padre_nombre'] as String?,
      padre_vive: json['padre_vive'] as bool?,
      madre_nombre: json['madre_nombre'] as String?,
      madre_vive: json['madre_vive'] as bool?,
      grupo_sanguineo: json['grupo_sanguineo'] as String?,
      religion: json['religion'] as String?,
      presentado_logia: json['presentado_logia'] as bool?,
      nombre_logia: json['nombre_logia'] as String?,
      nombres_apellidos: json['nombres_apellidos'] as String,
      parentesco: json['parentesco'] as String?,
      fecha_nacimiento1: json['fecha_nacimiento1'] == null
          ? null
          : DateTime.parse(json['fecha_nacimiento1'] as String),
      sexo: json['sexo'] as String?,
      estado_civil: json['estado_civil'] as String?,
      id_organizacion: (json['id_organizacion'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UsuarioCreateToJson(UsuarioCreate instance) =>
    <String, dynamic>{
      'dni': instance.dni,
      'email': instance.email,
      'password': instance.password,
      'nombres': instance.nombres,
      'apellidos_paterno': instance.apellidos_paterno,
      'apellidos_materno': instance.apellidos_materno,
      'fecha_nacimiento': instance.fecha_nacimiento.toIso8601String(),
      'celular': instance.celular,
      'rol_id': instance.rol_id,
      'estado_id': instance.estado_id,
      'profesion': instance.profesion,
      'especialidad': instance.especialidad,
      'centro_trabajo': instance.centro_trabajo,
      'direccion_trabajo': instance.direccion_trabajo,
      'sueldo_mensual': instance.sueldo_mensual,
      'tipo_via': instance.tipo_via,
      'direccion': instance.direccion,
      'departamento': instance.departamento,
      'provincia': instance.provincia,
      'distrito': instance.distrito,
      'nombre_conyuge': instance.nombre_conyuge,
      'fecha_nacimiento_conyuge':
          instance.fecha_nacimiento_conyuge?.toIso8601String(),
      'padre_nombre': instance.padre_nombre,
      'padre_vive': instance.padre_vive,
      'madre_nombre': instance.madre_nombre,
      'madre_vive': instance.madre_vive,
      'grupo_sanguineo': instance.grupo_sanguineo,
      'religion': instance.religion,
      'presentado_logia': instance.presentado_logia,
      'nombre_logia': instance.nombre_logia,
      'nombres_apellidos': instance.nombres_apellidos,
      'parentesco': instance.parentesco,
      'fecha_nacimiento1': instance.fecha_nacimiento1?.toIso8601String(),
      'sexo': instance.sexo,
      'estado_civil': instance.estado_civil,
      'id_organizacion': instance.id_organizacion,
    };

UsuarioResponse _$UsuarioResponseFromJson(Map<String, dynamic> json) =>
    UsuarioResponse(
      id: (json['id'] as num).toInt(),
      mensaje: json['mensaje'] as String? ?? "Usuario registrado exitosamente",
    );

Map<String, dynamic> _$UsuarioResponseToJson(UsuarioResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mensaje': instance.mensaje,
    };

FotoResponse _$FotoResponseFromJson(Map<String, dynamic> json) => FotoResponse(
      mensaje: json['mensaje'] as String? ?? "Foto subida exitosamente",
    );

Map<String, dynamic> _$FotoResponseToJson(FotoResponse instance) =>
    <String, dynamic>{
      'mensaje': instance.mensaje,
    };

DocumentoResponse _$DocumentoResponseFromJson(Map<String, dynamic> json) =>
    DocumentoResponse(
      id: (json['id'] as num).toInt(),
      mensaje: json['mensaje'] as String? ?? "Documento subido exitosamente",
    );

Map<String, dynamic> _$DocumentoResponseToJson(DocumentoResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mensaje': instance.mensaje,
    };

CambioEstadoBase _$CambioEstadoBaseFromJson(Map<String, dynamic> json) =>
    CambioEstadoBase(
      usuario_id: (json['usuario_id'] as num).toInt(),
      estado_nuevo_id: (json['estado_nuevo_id'] as num).toInt(),
      comentario: json['comentario'] as String?,
    );

Map<String, dynamic> _$CambioEstadoBaseToJson(CambioEstadoBase instance) =>
    <String, dynamic>{
      'usuario_id': instance.usuario_id,
      'estado_nuevo_id': instance.estado_nuevo_id,
      'comentario': instance.comentario,
    };

CambioEstadoCreate _$CambioEstadoCreateFromJson(Map<String, dynamic> json) =>
    CambioEstadoCreate(
      usuario_id: (json['usuario_id'] as num).toInt(),
      estado_nuevo_id: (json['estado_nuevo_id'] as num).toInt(),
      comentario: json['comentario'] as String?,
    );

Map<String, dynamic> _$CambioEstadoCreateToJson(CambioEstadoCreate instance) =>
    <String, dynamic>{
      'usuario_id': instance.usuario_id,
      'estado_nuevo_id': instance.estado_nuevo_id,
      'comentario': instance.comentario,
    };

CambioEstadoResponse _$CambioEstadoResponseFromJson(
        Map<String, dynamic> json) =>
    CambioEstadoResponse(
      id: (json['id'] as num).toInt(),
      fecha_cambio: DateTime.parse(json['fecha_cambio'] as String),
      estado_anterior_id: (json['estado_anterior_id'] as num).toInt(),
      admin_id: (json['admin_id'] as num).toInt(),
      usuario_id: (json['usuario_id'] as num).toInt(),
      estado_nuevo_id: (json['estado_nuevo_id'] as num).toInt(),
      comentario: json['comentario'] as String?,
    );

Map<String, dynamic> _$CambioEstadoResponseToJson(
        CambioEstadoResponse instance) =>
    <String, dynamic>{
      'usuario_id': instance.usuario_id,
      'estado_nuevo_id': instance.estado_nuevo_id,
      'comentario': instance.comentario,
      'id': instance.id,
      'fecha_cambio': instance.fecha_cambio.toIso8601String(),
      'estado_anterior_id': instance.estado_anterior_id,
      'admin_id': instance.admin_id,
    };

UsuarioUpdate _$UsuarioUpdateFromJson(Map<String, dynamic> json) =>
    UsuarioUpdate(
      dni: json['dni'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      nombres: json['nombres'] as String?,
      apellidos_paterno: json['apellidos_paterno'] as String?,
      apellidos_materno: json['apellidos_materno'] as String?,
      fecha_nacimiento: json['fecha_nacimiento'] == null
          ? null
          : DateTime.parse(json['fecha_nacimiento'] as String),
      celular: json['celular'] as String?,
      rol_id: (json['rol_id'] as num?)?.toInt(),
      profesion: json['profesion'] as String?,
      especialidad: json['especialidad'] as String?,
      centro_trabajo: json['centro_trabajo'] as String?,
      direccion_trabajo: json['direccion_trabajo'] as String?,
      sueldo_mensual: (json['sueldo_mensual'] as num?)?.toDouble(),
      tipo_via: json['tipo_via'] as String?,
      direccion: json['direccion'] as String?,
      departamento: json['departamento'] as String?,
      provincia: json['provincia'] as String?,
      distrito: json['distrito'] as String?,
      nombre_conyuge: json['nombre_conyuge'] as String?,
      fecha_nacimiento_conyuge: json['fecha_nacimiento_conyuge'] == null
          ? null
          : DateTime.parse(json['fecha_nacimiento_conyuge'] as String),
      padre_nombre: json['padre_nombre'] as String?,
      padre_vive: json['padre_vive'] as bool?,
      madre_nombre: json['madre_nombre'] as String?,
      madre_vive: json['madre_vive'] as bool?,
      grupo_sanguineo: json['grupo_sanguineo'] as String?,
      religion: json['religion'] as String?,
      presentado_logia: json['presentado_logia'] as bool?,
      nombre_logia: json['nombre_logia'] as String?,
      nombres_apellidos: json['nombres_apellidos'] as String?,
      parentesco: json['parentesco'] as String?,
      fecha_nacimiento1: json['fecha_nacimiento1'] == null
          ? null
          : DateTime.parse(json['fecha_nacimiento1'] as String),
      sexo: json['sexo'] as String?,
      estado_civil: json['estado_civil'] as String?,
    );

Map<String, dynamic> _$UsuarioUpdateToJson(UsuarioUpdate instance) =>
    <String, dynamic>{
      'dni': instance.dni,
      'email': instance.email,
      'password': instance.password,
      'nombres': instance.nombres,
      'apellidos_paterno': instance.apellidos_paterno,
      'apellidos_materno': instance.apellidos_materno,
      'fecha_nacimiento': instance.fecha_nacimiento?.toIso8601String(),
      'celular': instance.celular,
      'rol_id': instance.rol_id,
      'profesion': instance.profesion,
      'especialidad': instance.especialidad,
      'centro_trabajo': instance.centro_trabajo,
      'direccion_trabajo': instance.direccion_trabajo,
      'sueldo_mensual': instance.sueldo_mensual,
      'tipo_via': instance.tipo_via,
      'direccion': instance.direccion,
      'departamento': instance.departamento,
      'provincia': instance.provincia,
      'distrito': instance.distrito,
      'nombre_conyuge': instance.nombre_conyuge,
      'fecha_nacimiento_conyuge':
          instance.fecha_nacimiento_conyuge?.toIso8601String(),
      'padre_nombre': instance.padre_nombre,
      'padre_vive': instance.padre_vive,
      'madre_nombre': instance.madre_nombre,
      'madre_vive': instance.madre_vive,
      'grupo_sanguineo': instance.grupo_sanguineo,
      'religion': instance.religion,
      'presentado_logia': instance.presentado_logia,
      'nombre_logia': instance.nombre_logia,
      'nombres_apellidos': instance.nombres_apellidos,
      'parentesco': instance.parentesco,
      'fecha_nacimiento1': instance.fecha_nacimiento1?.toIso8601String(),
      'sexo': instance.sexo,
      'estado_civil': instance.estado_civil,
    };

ReportTemplate _$ReportTemplateFromJson(Map<String, dynamic> json) =>
    ReportTemplate(
      title: json['title'] as String,
    );

Map<String, dynamic> _$ReportTemplateToJson(ReportTemplate instance) =>
    <String, dynamic>{
      'title': instance.title,
    };

ReportRequest _$ReportRequestFromJson(Map<String, dynamic> json) =>
    ReportRequest(
      estado_nombre: json['estado_nombre'] as String,
      formato: json['formato'] as String,
      template:
          ReportTemplate.fromJson(json['template'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReportRequestToJson(ReportRequest instance) =>
    <String, dynamic>{
      'estado_nombre': instance.estado_nombre,
      'formato': instance.formato,
      'template': instance.template,
    };

DocumentError _$DocumentErrorFromJson(Map<String, dynamic> json) =>
    DocumentError(
      detail: json['detail'] as String,
    );

Map<String, dynamic> _$DocumentErrorToJson(DocumentError instance) =>
    <String, dynamic>{
      'detail': instance.detail,
    };
