import 'package:flutter/material.dart';
import 'package:flutter_web_android/screens/Users/user_details/user_detail_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_android/components/blocks_usuario.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';

class UserDetailScreen extends StatelessWidget {
  final int userId;

  const UserDetailScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserDetailViewModel()..initialize(userId),
      child: Consumer<UserDetailViewModel>(
        builder: (context, viewModel, child) {
          return FutureBuilder<UserDetail>(
            future: viewModel.futureUserDetail,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No se encontraron detalles'));
              }

              final userDetail = snapshot.data!;
              return Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: UserDetailsLayout(
                    children: [
                      // Header
                      HeaderInfoWidget(
                        nombres: userDetail.nombres,
                        apellidoPaterno: userDetail.apellidos_paterno,
                        apellidoMaterno: userDetail.apellidos_materno,
                        userPhoto: viewModel.futureUserPhoto,
                      ),
                      // Primera fila: Información General y Grado
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        children: [
                          Flexible(
                            flex: 1,
                            child: InformacionGeneralWidget(
                              dni: userDetail.dni,
                              email: userDetail.email,
                              fechaNacimiento: userDetail.fecha_nacimiento,
                              celular: userDetail.celular,
                              rolNombre: userDetail.rol_id,
                              estadoUsuarioNombre: userDetail.estado_id,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: GradoOutWidget(
                              grado:
                                  userDetail.grados?.grado ?? 'Sin información',
                              abrevGrado: userDetail.grados?.abrev_grado ??
                                  'Sin información',
                              fechaGrado: userDetail.grados?.fecha_grado,
                              estado: userDetail.grados?.estado ??
                                  'Sin información',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Segunda fila: Dirección e Información Profesional
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        children: [
                          Flexible(
                            flex: 1,
                            child: DireccionOutWidget(
                              tipoVia: userDetail.direcciones?.tipo_via ??
                                  'Sin información',
                              direccion: userDetail.direcciones?.direccion ??
                                  'Sin información',
                              departamento:
                                  userDetail.direcciones?.departamento ??
                                      'Sin información',
                              provincia: userDetail.direcciones?.provincia ??
                                  'Sin información',
                              distrito: userDetail.direcciones?.distrito ??
                                  'Sin información',
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: InformacionProfesionalOutWidget(
                              profesion: userDetail
                                      .informacion_profesional?.profesion ??
                                  'Sin información',
                              especialidad: userDetail
                                      .informacion_profesional?.especialidad ??
                                  'Sin información',
                              centroTrabajo: userDetail.informacion_profesional
                                      ?.centro_trabajo ??
                                  'Sin información',
                              direccionTrabajo: userDetail
                                      .informacion_profesional
                                      ?.direccion_trabajo ??
                                  'Sin información',
                              sueldoMensual: userDetail
                                  .informacion_profesional?.sueldo_mensual,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Tercera fila: Información Familiar y Adicional
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        children: [
                          Flexible(
                            flex: 1,
                            child: InformacionFamiliarOutWidget(
                              nombreConyuge: userDetail
                                      .informacion_familiar?.nombre_conyuge ??
                                  'Sin información',
                              fechaNacimientoConyuge: userDetail
                                  .informacion_familiar
                                  ?.fecha_nacimiento_conyuge,
                              padreNombre: userDetail
                                      .informacion_familiar?.padre_nombre ??
                                  'Sin información',
                              padreVive:
                                  userDetail.informacion_familiar?.padre_vive ??
                                      false,
                              madreNombre: userDetail
                                      .informacion_familiar?.madre_nombre ??
                                  'Sin información',
                              madreVive:
                                  userDetail.informacion_familiar?.madre_vive ??
                                      false,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: InformacionAdicionalOutWidget(
                              grupoSanguineo: userDetail
                                      .informacion_adicional?.grupo_sanguineo ??
                                  'Sin información',
                              religion:
                                  userDetail.informacion_adicional?.religion ??
                                      'Sin información',
                              presentadoLogia: userDetail
                                      .informacion_adicional?.presentado_logia
                                      ?.toString() ??
                                  'Sin información',
                              nombreLogia: userDetail
                                      .informacion_adicional?.nombre_logia ??
                                  'Sin información',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Tabla de documentos
                      DocumentsTableWidget(
                        documentos: viewModel.documentsList,
                        userDetail: snapshot.data!, // Pasar el userDetail
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoBox() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          style: BorderStyle.solid,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              color: Colors.grey,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              'FOTOGRAFÍA',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
