import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/screens/Users/user_details/user_detail_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserBlockStyles {
  static const pagePadding = EdgeInsets.all(32.0);
  static const sectionSpacing = 24.0;
  static const fieldSpacing = 16.0;

  static const labelStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF555555),
    fontWeight: FontWeight.w500,
  );

  static const valueStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF2D3748),
  );

  static final inputDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(6),
    border: Border.all(color: Color(0xFFE2E8F0)),
  );

  static const sectionTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2D3748),
  );
  static final inputDecorationEditable = BoxDecoration(
    color: const Color(0xFFF8F9FC),
    borderRadius: BorderRadius.circular(4),
    border: Border.all(color: const Color(0xFFCED4DA)),
  );
}

class GradoOutWidget extends StatelessWidget {
  final String? grado;
  final String? abrevGrado;
  final DateTime? fechaGrado;
  final String? estado;

  const GradoOutWidget({
    Key? key,
    this.grado,
    this.abrevGrado,
    this.fechaGrado,
    this.estado,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildInfoBlock(
      context,
      'Información de Grado',
      [
        _buildTextField('Grado', grado ?? 'N/A'),
        _buildTextField('Abreviatura', abrevGrado ?? 'N/A'),
        _buildTextField(
            'Fecha',
            fechaGrado != null
                ? DateFormat('yyyy-MM-dd').format(fechaGrado!)
                : 'N/A'),
        _buildTextField('Estado', estado ?? 'N/A'),
      ],
    );
  }
}

class InformacionProfesionalOutWidget extends StatelessWidget {
  final String? profesion;
  final String? especialidad;
  final String? centroTrabajo;
  final String? direccionTrabajo;
  final double? sueldoMensual;

  const InformacionProfesionalOutWidget({
    Key? key,
    this.profesion,
    this.especialidad,
    this.centroTrabajo,
    this.direccionTrabajo,
    this.sueldoMensual,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildInfoBlock(
      context,
      'Información Profesional',
      [
        _buildTextField('Profesión', profesion ?? 'N/A'),
        _buildTextField('Especialidad', especialidad ?? 'N/A'),
        _buildTextField('Centro de Trabajo', centroTrabajo ?? 'N/A'),
        _buildTextField('Dirección de Trabajo', direccionTrabajo ?? 'N/A'),
        _buildTextField('Sueldo Mensual', sueldoMensual?.toString() ?? 'N/A'),
      ],
    );
  }
}

class DireccionOutWidget extends StatelessWidget {
  final String? tipoVia;
  final String? direccion;
  final String? departamento;
  final String? provincia;
  final String? distrito;

  const DireccionOutWidget({
    Key? key,
    this.tipoVia,
    this.direccion,
    this.departamento,
    this.provincia,
    this.distrito,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildInfoBlock(
      context,
      'Dirección',
      [
        _buildTextField('Tipo de Vía', tipoVia ?? 'N/A'),
        _buildTextField('Dirección', direccion ?? 'N/A'),
        _buildTextField('Departamento', departamento ?? 'N/A'),
        _buildTextField('Provincia', provincia ?? 'N/A'),
        _buildTextField('Distrito', distrito ?? 'N/A'),
      ],
    );
  }
}

class InformacionFamiliarOutWidget extends StatelessWidget {
  final String? nombreConyuge;
  final DateTime? fechaNacimientoConyuge;
  final String? padreNombre;
  final bool? padreVive;
  final String? madreNombre;
  final bool? madreVive;

  const InformacionFamiliarOutWidget({
    Key? key,
    this.nombreConyuge,
    this.fechaNacimientoConyuge,
    this.padreNombre,
    this.padreVive,
    this.madreNombre,
    this.madreVive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildInfoBlock(
      context,
      'Información Familiar',
      [
        _buildTextField('Nombre del Cónyuge', nombreConyuge ?? 'N/A'),
        _buildDateField(
          'Fecha de Nacimiento del Cónyuge',
          fechaNacimientoConyuge != null
              ? DateFormat('yyyy-MM-dd').format(fechaNacimientoConyuge!)
              : 'N/A',
        ),
        _buildTextField('Nombre del Padre', padreNombre ?? 'N/A'),
        _buildTextField('¿Padre Vive?', padreVive == true ? 'Sí' : 'No'),
        _buildTextField('Nombre de la Madre', madreNombre ?? 'N/A'),
        _buildTextField('¿Madre Vive?', madreVive == true ? 'Sí' : 'No'),
      ],
    );
  }
}

class DependienteOutWidget extends StatelessWidget {
  final String? nombresApellidos;
  final String? parentesco;
  final DateTime? fechaNacimiento;
  final String? sexo;
  final String? estadoCivil;

  const DependienteOutWidget({
    Key? key,
    this.nombresApellidos,
    this.parentesco,
    this.fechaNacimiento,
    this.sexo,
    this.estadoCivil,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildInfoBlock(
      context,
      'Dependientes',
      [
        _buildTextField('Nombres y Apellidos', nombresApellidos ?? 'N/A'),
        _buildTextField('Parentesco', parentesco ?? 'N/A'),
        _buildDateField(
          'Fecha de Nacimiento',
          fechaNacimiento != null
              ? DateFormat('yyyy-MM-dd').format(fechaNacimiento!)
              : 'N/A',
        ),
        _buildTextField(
            'Sexo',
            sexo == 'M'
                ? 'Masculino'
                : sexo == 'F'
                    ? 'Femenino'
                    : 'N/A'),
        _buildTextField('Estado Civil', estadoCivil ?? 'N/A'),
      ],
    );
  }
}

Widget _buildDateField(String label, String value) {
  return Container(
    width: 300,
    margin: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: UserBlockStyles.labelStyle),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: UserBlockStyles.inputDecoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: UserBlockStyles.valueStyle),
              Icon(
                Icons.calendar_today,
                size: 20,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class InformacionAdicionalOutWidget extends StatelessWidget {
  final String? grupoSanguineo;
  final String? religion;
  final String? presentadoLogia;
  final String? nombreLogia;

  const InformacionAdicionalOutWidget({
    Key? key,
    this.grupoSanguineo,
    this.religion,
    this.presentadoLogia,
    this.nombreLogia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildInfoBlock(
      context,
      'Información Adicional',
      [
        _buildTextField('Grupo Sanguíneo', grupoSanguineo ?? 'N/A'),
        _buildTextField('Religión', religion ?? 'N/A'),
        _buildTextField(
            '¿Presentado en Logia?', presentadoLogia == true ? 'No' : 'Si'),
        _buildTextField('Nombre de Logia', nombreLogia ?? 'N/A'),
      ],
    );
  }
}

Widget _buildInfoBlock(
    BuildContext context, String title, List<Widget> children) {
  return Container(
    margin: EdgeInsets.zero, // Eliminar margin bottom
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(title, style: UserBlockStyles.sectionTitleStyle),
        ),
        Wrap(
          spacing: UserBlockStyles.fieldSpacing,
          runSpacing: UserBlockStyles.fieldSpacing,
          children: children,
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
}

Widget _buildTextField(String label, String value) {
  return Container(
    width: 300,
    margin: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: UserBlockStyles.labelStyle),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: UserBlockStyles.inputDecoration,
          child: Text(value, style: UserBlockStyles.valueStyle),
        ),
      ],
    ),
  );
}

// Agregar estos widgets a blocks_usuario.dart

class HeaderInfoWidget extends StatelessWidget {
  final String nombres;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final Future<Uint8List>? userPhoto;

  const HeaderInfoWidget(
      {Key? key,
      required this.nombres,
      required this.apellidoPaterno,
      required this.apellidoMaterno,
      this.userPhoto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Wrap(
                spacing: UserBlockStyles.fieldSpacing,
                runSpacing: UserBlockStyles.fieldSpacing,
                children: [
                  SizedBox(
                    width: 300,
                    child: _buildTextField('Nombres', nombres),
                  ),
                  SizedBox(
                    width: 300,
                    child: _buildTextField('Apellido Paterno', apellidoPaterno),
                  ),
                  SizedBox(
                    width: 300,
                    child: _buildTextField('Apellido Materno', apellidoMaterno),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            _buildPhotoBox(),
          ],
        ),
        const SizedBox(height: UserBlockStyles.sectionSpacing),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),
        const SizedBox(height: UserBlockStyles.sectionSpacing),
      ],
    );
  }

  Widget _buildPhotoBox() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
      ),
      child: userPhoto == null || userPhoto == Uint8List(0)
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 32,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sin foto',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : FutureBuilder<Uint8List>(
              future: userPhoto,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, color: Colors.grey),
                        Text('Sin foto', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
    );
  }
}

class InformacionGeneralWidget extends StatelessWidget {
  final String dni;
  final String email;
  final DateTime fechaNacimiento;
  final String celular;
  final int rolNombre;
  final int estadoUsuarioNombre;

  const InformacionGeneralWidget({
    Key? key,
    required this.dni,
    required this.email,
    required this.fechaNacimiento,
    required this.celular,
    required this.rolNombre,
    required this.estadoUsuarioNombre,
  }) : super(key: key);

  String getRolText(int rol) {
    switch (rol) {
      case 1:
        return "Usuario";
      case 2:
        return "Administrador";
      case 3:
        return "Secretario";
      case 4:
        return "Tesorero";
      default:
        return "No definido";
    }
  }

  String getEstadoText(int estado) {
    switch (estado) {
      case 1:
        return "Activo";
      case 2:
        return "En sueño";
      case 3:
        return "Irradiado";
      default:
        return "No definido";
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildInfoBlock(
      context,
      'Información General',
      [
        _buildTextField('DNI', dni),
        _buildTextField('Email', email),
        _buildDateField(
          'Fecha de Nacimiento',
          DateFormat('yyyy-MM-dd').format(fechaNacimiento),
        ),
        _buildTextField('Celular', celular),
        _buildTextField('Rol', getRolText(rolNombre)),
        _buildTextField('Estado', getEstadoText(estadoUsuarioNombre)),
      ],
    );
  }
}

class DocumentsTableWidget extends StatelessWidget {
  final ListaDocumentosResponse? documentos;
  final UserDetail userDetail;

  const DocumentsTableWidget({
    Key? key,
    this.documentos,
    required this.userDetail,
  }) : super(key: key);

  String _getFileExtension(String tipo) {
    // Map de tipos de archivo comunes
    final extensiones = {
      'pdf': '.pdf',
      'excel': '.xlsx',
    };

    // Convertir a minúsculas y buscar en el map
    final extension = extensiones[tipo.toLowerCase()];

    // Retornar extensión encontrada o vacío si no existe
    return extension ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (documentos?.documentos == null || documentos!.documentos.isEmpty) {
      return const Center(child: Text('No hay documentos disponibles'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        horizontalMargin: 20,
        columnSpacing: 60,
        columns: const [
          DataColumn(
            label: Text(
              'Nombre',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Fecha',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Acciones',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: documentos!.documentos
            .map((doc) => DataRow(
                  cells: [
                    DataCell(Text(doc.nombre +
                        _getFileExtension(doc.tipo))), // Aquí se usa el método
                    DataCell(Text(
                        DateFormat('dd/MM/yyyy').format(doc.fecha_subida))),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.download, color: Colors.blue),
                        onPressed: () {
                          final viewModel = context.read<UserDetailViewModel>();
                          final nombreArchivo =
                              'documento_${userDetail.nombres}_${userDetail.apellidos_paterno}'; // Aquí también
                          viewModel.downloadDocument(doc.id, nombreArchivo);
                        },
                      ),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

class UserDetailsLayout extends StatelessWidget {
  final List<Widget> children;

  const UserDetailsLayout({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;
        final isTablet =
            constraints.maxWidth > 600 && constraints.maxWidth <= 1024;

        return Scrollbar(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop
                    ? 32.0
                    : isTablet
                        ? 24.0
                        : 16.0,
                vertical: 20.0,
              ),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop
                        ? 900
                        : isTablet
                            ? 700
                            : 500,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class UserProfileMobileWidget extends StatelessWidget {
  final UserDetail userDetail;
  final Future<Uint8List>? userPhoto;

  const UserProfileMobileWidget({
    Key? key,
    required this.userDetail,
    this.userPhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
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
                    _buildPhoto(),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: _buildInfoSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoto() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: FutureBuilder<Uint8List>(
        future: userPhoto,
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 60, color: Colors.white70),
            );
          }
          return CircleAvatar(
            radius: 60,
            backgroundImage: MemoryImage(snapshot.data!),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection() {
    final infoWidget = InformacionGeneralWidget(
      dni: userDetail.dni,
      email: userDetail.email,
      fechaNacimiento: userDetail.fecha_nacimiento,
      celular: userDetail.celular,
      rolNombre: userDetail.rol_id,
      estadoUsuarioNombre: userDetail.estado_id,
    );

    final items = [
      {'icon': Icons.badge, 'label': 'DNI', 'value': userDetail.dni},
      {'icon': Icons.email, 'label': 'Email', 'value': userDetail.email},
      {
        'icon': Icons.calendar_today,
        'label': 'Fecha de Nacimiento',
        'value': DateFormat('dd/MM/yyyy').format(userDetail.fecha_nacimiento)
      },
      {'icon': Icons.phone, 'label': 'Celular', 'value': userDetail.celular},
      {
        'icon': Icons.work,
        'label': 'Rol',
        'value': infoWidget.getRolText(userDetail.rol_id)
      },
      {
        'icon': Icons.info,
        'label': 'Estado',
        'value': infoWidget.getEstadoText(userDetail.estado_id)
      },
    ];

    return Column(
      children: items
          .map((item) => _buildInfoItem(
                item['label']! as String,
                item['value']! as String,
                icon: item['icon'] as IconData,
              ))
          .toList(),
    );
  }

  Widget _buildInfoItem(String label, String value, {required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1E3A8A),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;
  final double breakpoint;

  const ResponsiveBuilder({
    required this.mobile,
    required this.desktop,
    this.breakpoint = 600,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxWidth < breakpoint ? mobile : desktop;
    });
  }
}

class EditableInfoBlock extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isMobile;

  const EditableInfoBlock({
    required this.title,
    required this.children,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: UserBlockStyles.sectionTitleStyle),
          const SizedBox(height: 16),
          if (isMobile)
            Column(children: children)
          else
            Wrap(
              spacing: UserBlockStyles.fieldSpacing,
              runSpacing: UserBlockStyles.fieldSpacing,
              children: children,
            ),
        ],
      ),
    );
  }
}

class BaseBlockWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isEditable;

  const BaseBlockWidget({
    required this.title,
    required this.children,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            style: UserBlockStyles.sectionTitleStyle,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: UserBlockStyles.fieldSpacing,
          runSpacing: UserBlockStyles.fieldSpacing,
          children: children,
        ),
      ],
    );
  }
}
