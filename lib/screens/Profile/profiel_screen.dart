// lib/screens/Profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/blocks_usuario.dart';
import 'package:flutter_web_android/components/change_password_modal.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:flutter_web_android/components/loading_session_widget.dart';
import 'package:flutter_web_android/models/modulo_profile_usuario.dart';
import 'package:flutter_web_android/screens/Profile/profiel_screen_mobile.dart';
import 'package:flutter_web_android/screens/Profile/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..initialize(),
      child: const _ProfileContent(),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return const Center(child: CustomLoading());
        }

        return FutureBuilder<UserProfileResponse>(
          future: viewModel.futureUserProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CustomLoading());
            }

            if (snapshot.hasError) {
              return _buildErrorView(snapshot.error.toString(), () {
                viewModel.initialize();
              });
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('No se encontraron datos del usuario'),
              );
            }

            final userProfile = snapshot.data!;
            return ResponsiveBuilder(
              mobile: UserProfileMobile(
                userDetail: userProfile,
                userPhoto: viewModel.futureUserPhoto,
              ),
              desktop: _buildDesktopView(userProfile, viewModel, context),
            );
          },
        );
      },
    );
  }

  Widget _buildDesktopView(UserProfileResponse user, ProfileViewModel viewModel,
      BuildContext context) {
    return Container(
      color: const Color(0xFFF4F6F9),
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                // Header con foto y nombre
                _buildHeader(user, viewModel, context),
                const SizedBox(height: 20),

                // Información General y Grado
                _buildCard(
                  'Información General',
                  [_buildGeneralInfo(user), _buildGradeInfo(user)],
                ),
                const SizedBox(height: 20),

                // Dirección y Profesión
                _buildCard(
                  'Dirección y Profesión',
                  [_buildAddressInfo(user), _buildProfessionalInfo(user)],
                ),
                const SizedBox(height: 20),

                // Información Familiar y Adicional
                _buildCard(
                  'Información Familiar y Adicional',
                  [_buildFamilyInfo(user), _buildAdditionalInfo(user)],
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
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF1E3A8A), width: 2),
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

  Widget _buildHeader(UserProfileResponse user, ProfileViewModel viewModel,
      BuildContext context) {
    return Column(
      children: [
        HeaderInfoWidget(
          nombres: user.nombres,
          apellidoPaterno: user.apellidos_paterno,
          apellidoMaterno: user.apellidos_materno,
          userPhoto: viewModel.futureUserPhoto,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false, // Prevenir cierre accidental
              builder: (dialogContext) => ChangePasswordModal(
                onChangePassword: (newPassword) async {
                  try {
                    // Cerrar el modal de cambio de contraseña
                    Navigator.of(dialogContext).pop();

                    // Mostrar loading y proceder con el cambio
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const LoadingSessionWidget(),
                    );

                    // Cambiar contraseña y hacer logout
                    await viewModel.changePassword(newPassword, context);
                  } catch (e) {
                    // Si hay error, mostrar mensaje
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            );
          },
          icon: const Icon(Icons.lock_reset),
          label: const Text('Cambiar Contraseña'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralInfo(UserProfileResponse user) {
    return InformacionGeneralWidget(
      dni: user.dni,
      email: user.email,
      fechaNacimiento: user.fecha_nacimiento,
      celular: user.celular,
      rolNombre: user.rol_id,
      estadoUsuarioNombre: user.estado_id,
    );
  }

  Widget _buildGradeInfo(UserProfileResponse user) {
    return GradoOutWidget(
      grado: user.grados?.grado,
      abrevGrado: user.grados?.abrev_grado,
      fechaGrado: user.grados?.fecha_grado,
    );
  }

  Widget _buildAddressInfo(UserProfileResponse user) {
    return DireccionOutWidget(
      tipoVia: user.direcciones?.tipo_via,
      direccion: user.direcciones?.direccion,
      departamento: user.direcciones?.departamento,
      provincia: user.direcciones?.provincia,
      distrito: user.direcciones?.distrito,
    );
  }

  Widget _buildProfessionalInfo(UserProfileResponse user) {
    return InformacionProfesionalOutWidget(
      profesion: user.informacion_profesional?.profesion,
      especialidad: user.informacion_profesional?.especialidad,
      centroTrabajo: user.informacion_profesional?.centro_trabajo,
      direccionTrabajo: user.informacion_profesional?.direccion_trabajo,
      sueldoMensual: user.informacion_profesional?.sueldo_mensual,
    );
  }

  Widget _buildFamilyInfo(UserProfileResponse user) {
    return InformacionFamiliarOutWidget(
      nombreConyuge: user.informacion_familiar?.nombre_conyuge,
      fechaNacimientoConyuge:
          user.informacion_familiar?.fecha_nacimiento_conyuge,
      padreNombre: user.informacion_familiar?.padre_nombre,
      padreVive: user.informacion_familiar?.padre_vive,
      madreNombre: user.informacion_familiar?.madre_nombre,
      madreVive: user.informacion_familiar?.madre_vive,
    );
  }

  Widget _buildAdditionalInfo(UserProfileResponse user) {
    return InformacionAdicionalOutWidget(
      grupoSanguineo: user.informacion_adicional?.grupo_sanguineo,
      religion: user.informacion_adicional?.religion,
      presentadoLogia: user.informacion_adicional?.presentado_logia?.toString(),
      nombreLogia: user.informacion_adicional?.nombre_logia,
    );
  }

  Widget _buildErrorView(String message, VoidCallback onRetry) {
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
