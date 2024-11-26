import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:flutter_web_android/screens/Users/user_details/user_detail_viewmodel.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:flutter_web_android/components/blocks_usuario.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';

// Constantes centralizadas
class UserDetailConstants {
  static const String noInfo = 'Sin información';
  static const double spacing = 24.0;
}

class UserDetailScreen extends StatefulWidget {
  final int userId;
  const UserDetailScreen(
      {Key? key, required this.userId, required Null Function() onBack})
      : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late final UserDetailViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = UserDetailViewModel();
    _loadData();
  }

  Future<void> _loadData() async {
    await viewModel.initialize(widget.userId);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: viewModel,
        child: _UserDetailBody(userId: widget.userId), // Pasar userId
      ),
    );
  }
}

class _UserDetailBody extends StatelessWidget {
  final int userId; // Agregar userId

  const _UserDetailBody({required this.userId}); // Constructor actualizado

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetailViewModel>(
      builder: (context, model, _) {
        if (model.isLoading) {
          return Container(
            color: Colors.white.withOpacity(0.8),
            child: const CustomLoading(),
          );
        }

        if (model.errorMessage != null) {
          return _ErrorView(
            message: model.errorMessage!,
            onRetry: () => context
                .read<UserDetailViewModel>()
                .initialize(userId), // Pasar userId
          );
        }

        return _UserDetailContent(model: model, userId: userId); // Pasar userId
      },
    );
  }
}

class _UserDetailContent extends StatelessWidget {
  final UserDetailViewModel model;
  final int userId; // Agregar userId

  const _UserDetailContent({
    required this.model,
    required this.userId, // Agregar al constructor
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserDetail>(
      future: model.futureUserDetail,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _ErrorView(
            message: snapshot.error.toString(),
            onRetry: () => model.initialize(userId), // Pasar userId
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text('No se encontraron datos del usuario'),
          );
        }

        return _UserDetailView(
          userDetail: snapshot.data!,
          model: model,
        );
      },
    );
  }
}

class _UserDetailView extends StatelessWidget {
  final UserDetail userDetail;
  final UserDetailViewModel model;

  const _UserDetailView({
    required this.userDetail,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return Container(
        color: Colors.white,
        child: UserProfileMobileWidget(
          userDetail: userDetail,
          userPhoto: model.futureUserPhoto,
        ),
      );
    }
    return Container(
      color: const Color(0xFFF4F6F9), // Fondo gris claro
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                // Header con foto y nombre
                _HeaderInfo(
                  userDetail: userDetail,
                  model: model,
                ),
                const SizedBox(height: 20),

                // Cards de información
                _buildCard(
                  'Información General',
                  [_buildGeneralInfo(), _buildGradeInfo()],
                ),
                const SizedBox(height: 20),
                _buildCard(
                  'Dirección y Profesión',
                  [_buildAddressInfo(), _buildProfessionalInfo()],
                ),
                const SizedBox(height: 20),
                _buildCard(
                  'Información Familiar y Adicional',
                  [_buildFamilyInfo(), _buildAdditionalInfo()],
                ),
                const SizedBox(height: 20),
                // Documentos
                if (model.documentsList?.documentos.isNotEmpty ?? false)
                  _buildCard(
                    'Documentos',
                    [
                      DocumentsTableWidget(
                        documentos: model.documentsList,
                        userDetail: userDetail,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título con borde inferior azul
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF007BFF),
                  width: 2,
                ),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Contenido
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children
                .map((child) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: child,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralInfo() => InformacionGeneralWidget(
        dni: userDetail.dni,
        email: userDetail.email,
        fechaNacimiento: userDetail.fecha_nacimiento,
        celular: userDetail.celular,
        rolNombre: userDetail.rol_id,
        estadoUsuarioNombre: userDetail.estado_id,
      );

  Widget _buildGradeInfo() => GradoOutWidget(
        grado: userDetail.grados?.grado ?? UserDetailConstants.noInfo,
        abrevGrado:
            userDetail.grados?.abrev_grado ?? UserDetailConstants.noInfo,
        fechaGrado: userDetail.grados?.fecha_grado,
        estado: userDetail.grados?.estado ?? UserDetailConstants.noInfo,
      );

  Widget _buildAddressInfo() => DireccionOutWidget(
        tipoVia: userDetail.direcciones?.tipo_via ?? UserDetailConstants.noInfo,
        direccion:
            userDetail.direcciones?.direccion ?? UserDetailConstants.noInfo,
        departamento:
            userDetail.direcciones?.departamento ?? UserDetailConstants.noInfo,
        provincia:
            userDetail.direcciones?.provincia ?? UserDetailConstants.noInfo,
        distrito:
            userDetail.direcciones?.distrito ?? UserDetailConstants.noInfo,
      );

  Widget _buildProfessionalInfo() => InformacionProfesionalOutWidget(
        profesion: userDetail.informacion_profesional?.profesion ??
            UserDetailConstants.noInfo,
        especialidad: userDetail.informacion_profesional?.especialidad ??
            UserDetailConstants.noInfo,
        centroTrabajo: userDetail.informacion_profesional?.centro_trabajo ??
            UserDetailConstants.noInfo,
        direccionTrabajo:
            userDetail.informacion_profesional?.direccion_trabajo ??
                UserDetailConstants.noInfo,
        sueldoMensual: userDetail.informacion_profesional?.sueldo_mensual,
      );

  Widget _buildFamilyInfo() => InformacionFamiliarOutWidget(
        nombreConyuge: userDetail.informacion_familiar?.nombre_conyuge ??
            UserDetailConstants.noInfo,
        fechaNacimientoConyuge:
            userDetail.informacion_familiar?.fecha_nacimiento_conyuge,
        padreNombre: userDetail.informacion_familiar?.padre_nombre ??
            UserDetailConstants.noInfo,
        padreVive: userDetail.informacion_familiar?.padre_vive ?? false,
        madreNombre: userDetail.informacion_familiar?.madre_nombre ??
            UserDetailConstants.noInfo,
        madreVive: userDetail.informacion_familiar?.madre_vive ?? false,
      );

  Widget _buildAdditionalInfo() => InformacionAdicionalOutWidget(
        grupoSanguineo: userDetail.informacion_adicional?.grupo_sanguineo ??
            UserDetailConstants.noInfo,
        religion: userDetail.informacion_adicional?.religion ??
            UserDetailConstants.noInfo,
        presentadoLogia:
            userDetail.informacion_adicional?.presentado_logia?.toString() ??
                UserDetailConstants.noInfo,
        nombreLogia: userDetail.informacion_adicional?.nombre_logia ??
            UserDetailConstants.noInfo,
      );
}

class _InformationRow extends StatelessWidget {
  final List<Widget> children;

  const _InformationRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .map((child) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: child,
                ),
              ))
          .toList(),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

class _HeaderInfo extends StatelessWidget {
  final UserDetail userDetail;
  final UserDetailViewModel model;

  const _HeaderInfo({
    required this.userDetail,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildUserPhoto(),
          const SizedBox(width: 24),
          Expanded(child: _buildUserInfo()),
        ],
      ),
    );
  }

  Widget _buildUserPhoto() {
    return FutureBuilder<Uint8List>(
      future: model.futureUserPhoto,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildDefaultPhoto();
        }

        return snapshot.hasData
            ? CircleAvatar(
                radius: 50,
                backgroundImage: MemoryImage(snapshot.data!),
              )
            : _buildDefaultPhoto();
      },
    );
  }

  Widget _buildDefaultPhoto() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, size: 50, color: Colors.grey),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${userDetail.nombres} ${userDetail.apellidos_paterno} ${userDetail.apellidos_materno}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'DNI: ${userDetail.dni}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Email: ${userDetail.email}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
