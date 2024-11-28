// lib/screens/Profile/widgets/user_profile_mobile_widget.dart

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_web_android/models/modulo_profile_usuario.dart';
import 'package:intl/intl.dart';

class UserProfileMobile extends StatelessWidget {
  final UserProfileResponse userDetail;
  final Future<Uint8List>? userPhoto;

  const UserProfileMobile({
    Key? key,
    required this.userDetail,
    this.userPhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header con gradiente y foto
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1E3A8A),
                  const Color(0xFF1E3A8A).withOpacity(0.8),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildProfilePhoto(),
                    const SizedBox(height: 16),
                    Text(
                      '${userDetail.nombres}\n${userDetail.apellidos_paterno} ${userDetail.apellidos_materno}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Contenido
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildInfoCard('Información General', [
                  _buildInfoItem('DNI', userDetail.dni),
                  _buildInfoItem('Email', userDetail.email),
                  _buildInfoItem('Celular', userDetail.celular),
                  _buildInfoItem(
                    'Fecha de Nacimiento',
                    DateFormat('dd/MM/yyyy')
                        .format(userDetail.fecha_nacimiento),
                  ),
                ]),
                const SizedBox(height: 16),
                if (userDetail.grados != null)
                  _buildInfoCard('Grado', [
                    _buildInfoItem('Grado', userDetail.grados?.grado ?? 'N/A'),
                    _buildInfoItem(
                        'Abreviatura', userDetail.grados?.abrev_grado ?? 'N/A'),
                    if (userDetail.grados?.fecha_grado != null)
                      _buildInfoItem(
                        'Fecha de Grado',
                        DateFormat('dd/MM/yyyy')
                            .format(userDetail.grados!.fecha_grado!),
                      ),
                  ]),
                const SizedBox(height: 16),
                if (userDetail.direcciones != null)
                  _buildInfoCard('Dirección', [
                    _buildInfoItem('Tipo de Vía',
                        userDetail.direcciones?.tipo_via ?? 'N/A'),
                    _buildInfoItem('Dirección',
                        userDetail.direcciones?.direccion ?? 'N/A'),
                    _buildInfoItem('Departamento',
                        userDetail.direcciones?.departamento ?? 'N/A'),
                    _buildInfoItem('Provincia',
                        userDetail.direcciones?.provincia ?? 'N/A'),
                    _buildInfoItem(
                        'Distrito', userDetail.direcciones?.distrito ?? 'N/A'),
                  ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePhoto() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: ClipOval(
        child: userPhoto == null
            ? const Icon(Icons.person, size: 60, color: Colors.white)
            : FutureBuilder<Uint8List>(
                future: userPhoto,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Icon(Icons.person,
                        size: 60, color: Colors.white);
                  }
                  return Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  );
                },
              ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
