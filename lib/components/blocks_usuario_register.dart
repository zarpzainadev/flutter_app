import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/blocks_usuario.dart';
import 'package:intl/intl.dart';

// Reutilizar UserBlockStyles de blocks_usuario.dart

mixin InfoBlockBuilder {
  Widget _buildInfoBlock(String title, List<Widget> children) {
    return Container(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
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

class HeaderInfoRegisterWidget extends StatelessWidget {
  final TextEditingController nombresController;
  final TextEditingController apellidoPaternoController;
  final TextEditingController apellidoMaternoController;
  final Function() onPhotoTap;
  final Function()? onPhotoRemove;
  final Uint8List? selectedImage;

  const HeaderInfoRegisterWidget({
    Key? key,
    required this.nombresController,
    required this.apellidoPaternoController,
    required this.apellidoMaternoController,
    required this.onPhotoTap,
    this.onPhotoRemove,
    this.selectedImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Wrap(
              spacing: UserBlockStyles.fieldSpacing,
              runSpacing: UserBlockStyles.fieldSpacing,
              children: [
                _buildInputField('Nombres', nombresController),
                _buildInputField('Apellido Paterno', apellidoPaternoController),
                _buildInputField('Apellido Materno', apellidoMaternoController),
              ],
            ),
          ),
          const SizedBox(width: 24),
          _buildPhotoUploader(),
        ],
      ),
    );
  }

  Widget _buildPhotoUploader() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          if (selectedImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                selectedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            )
          else
            InkWell(
              onTap: onPhotoTap,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Agregar foto'),
                  ],
                ),
              ),
            ),
          if (selectedImage != null)
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 16,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close, size: 16, color: Colors.white),
                  onPressed: onPhotoRemove,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class InformacionGeneralRegisterWidget extends StatelessWidget
    with InfoBlockBuilder {
  final TextEditingController dniController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController celularController;
  final DateTime? fechaNacimiento;
  final int? rolSeleccionado;
  final int? estadoSeleccionado;
  final Function(DateTime) onFechaNacimientoChanged;
  final Function(int?) onRolChanged;
  final Function(int?) onEstadoChanged;
  // Agregar campos de error
  final String? dniError;
  final String? emailError;
  final String? passwordError;
  final String? celularError;
  final String? fechaNacimientoError;
  final String? rolError;
  final String? estadoError;

  final int? organizacionSeleccionada;
  final Function(int?) onOrganizacionChanged;
  final String? organizacionError;

  const InformacionGeneralRegisterWidget({
    Key? key,
    required this.dniController,
    required this.emailController,
    required this.passwordController,
    required this.celularController,
    required this.fechaNacimiento,
    required this.rolSeleccionado,
    required this.estadoSeleccionado,
    required this.onFechaNacimientoChanged,
    required this.onRolChanged,
    required this.onEstadoChanged,
    this.dniError,
    this.emailError,
    this.passwordError,
    this.celularError,
    this.fechaNacimientoError,
    this.rolError,
    this.estadoError,
    required this.organizacionSeleccionada,
    required this.onOrganizacionChanged,
    this.organizacionError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildInfoBlock(
      'Información General',
      [
        _buildInputField('DNI', dniController),
        _buildInputField('Email', emailController),
        _buildInputField('Contraseña', passwordController, isPassword: true),
        _buildDatePickerField(
          'Fecha de Nacimiento',
          fechaNacimiento,
          onFechaNacimientoChanged,
          context,
        ),
        _buildInputField('Celular', celularController),
        _buildDropdownField('Rol', rolSeleccionado, _getRoles(), onRolChanged),
        _buildDropdownField(
            'Estado', estadoSeleccionado, _getEstados(), onEstadoChanged),
        _buildDropdownField(
          'Organización',
          organizacionSeleccionada,
          _getOrganizaciones(),
          onOrganizacionChanged,
          errorText: organizacionError,
        ),
      ],
    );
  }
}

// Agregar después de InformacionGeneralRegisterWidget

class GradoRegisterWidget extends StatelessWidget with InfoBlockBuilder {
  final TextEditingController gradoController;
  final TextEditingController abrevGradoController;
  final DateTime? fechaGrado;
  final TextEditingController estadoController;
  final Function(DateTime) onFechaGradoChanged;

  const GradoRegisterWidget({
    Key? key,
    required this.gradoController,
    required this.abrevGradoController,
    required this.fechaGrado,
    required this.estadoController,
    required this.onFechaGradoChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildInfoBlock(
      'Información de Grado',
      [
        _buildInputField('Grado', gradoController),
        _buildInputField('Abreviatura', abrevGradoController),
        _buildDatePickerField(
            'Fecha', fechaGrado, onFechaGradoChanged, context),
        _buildInputField('Estado', estadoController),
      ],
    );
  }
}

class InformacionProfesionalRegisterWidget extends StatelessWidget
    with InfoBlockBuilder {
  final TextEditingController profesionController;
  final TextEditingController especialidadController;
  final TextEditingController centroTrabajoController;
  final TextEditingController direccionTrabajoController;
  final TextEditingController sueldoMensualController;

  const InformacionProfesionalRegisterWidget({
    Key? key,
    required this.profesionController,
    required this.especialidadController,
    required this.centroTrabajoController,
    required this.direccionTrabajoController,
    required this.sueldoMensualController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildInfoBlock(
      'Información Profesional',
      [
        _buildInputField('Profesión', profesionController),
        _buildInputField('Especialidad', especialidadController),
        _buildInputField('Centro de Trabajo', centroTrabajoController),
        _buildInputField('Dirección de Trabajo', direccionTrabajoController),
        _buildInputField('Sueldo Mensual', sueldoMensualController),
      ],
    );
  }
}

class DireccionRegisterWidget extends StatelessWidget with InfoBlockBuilder {
  final TextEditingController tipoViaController;
  final TextEditingController direccionController;
  final TextEditingController departamentoController;
  final TextEditingController provinciaController;
  final TextEditingController distritoController;

  const DireccionRegisterWidget({
    Key? key,
    required this.tipoViaController,
    required this.direccionController,
    required this.departamentoController,
    required this.provinciaController,
    required this.distritoController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildInfoBlock(
      'Dirección',
      [
        _buildInputField('Tipo de Vía', tipoViaController),
        _buildInputField('Dirección', direccionController),
        _buildInputField('Departamento', departamentoController),
        _buildInputField('Provincia', provinciaController),
        _buildInputField('Distrito', distritoController),
      ],
    );
  }
}

class InformacionFamiliarRegisterWidget extends StatelessWidget
    with InfoBlockBuilder {
  final TextEditingController nombreConyugeController;
  final DateTime? fechaNacimientoConyuge;
  final TextEditingController padreNombreController;
  final bool padreVive;
  final TextEditingController madreNombreController;
  final bool madreVive;
  final Function(DateTime) onFechaNacimientoConyugeChanged;
  final Function(bool) onPadreViveChanged;
  final Function(bool) onMadreViveChanged;

  const InformacionFamiliarRegisterWidget({
    Key? key,
    required this.nombreConyugeController,
    required this.fechaNacimientoConyuge,
    required this.padreNombreController,
    required this.padreVive,
    required this.madreNombreController,
    required this.madreVive,
    required this.onFechaNacimientoConyugeChanged,
    required this.onPadreViveChanged,
    required this.onMadreViveChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildInfoBlock(
      'Información Familiar',
      [
        _buildInputField('Nombre del Cónyuge', nombreConyugeController),
        _buildDatePickerField('Fecha de Nacimiento del Cónyuge',
            fechaNacimientoConyuge, onFechaNacimientoConyugeChanged, context),
        _buildInputField('Nombre del Padre', padreNombreController),
        _buildSwitchField('¿Padre Vive?', padreVive, onPadreViveChanged),
        _buildInputField('Nombre de la Madre', madreNombreController),
        _buildSwitchField('¿Madre Vive?', madreVive, onMadreViveChanged),
      ],
    );
  }
}

class DependienteRegisterWidget extends StatelessWidget with InfoBlockBuilder {
  final TextEditingController nombresApellidosController;
  final TextEditingController parentescoController;
  final DateTime? fechaNacimiento;
  final String? sexoSeleccionado;
  final String? estadoCivilSeleccionado;
  final Function(DateTime) onFechaNacimientoChanged;
  final Function(String?) onSexoChanged;
  final Function(String?) onEstadoCivilChanged;

  const DependienteRegisterWidget({
    Key? key,
    required this.nombresApellidosController,
    required this.parentescoController,
    required this.fechaNacimiento,
    required this.sexoSeleccionado,
    required this.estadoCivilSeleccionado,
    required this.onFechaNacimientoChanged,
    required this.onSexoChanged,
    required this.onEstadoCivilChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildInfoBlock(
      'Dependientes',
      [
        _buildInputField('Nombres y Apellidos', nombresApellidosController),
        _buildInputField('Parentesco', parentescoController),
        _buildDatePickerField('Fecha de Nacimiento', fechaNacimiento,
            onFechaNacimientoChanged, context),
        _buildDropdownField(
            'Sexo',
            sexoSeleccionado,
            [
              const DropdownMenuItem(value: 'M', child: Text('Masculino')),
              const DropdownMenuItem(value: 'F', child: Text('Femenino')),
            ],
            onSexoChanged),
        _buildDropdownField(
            'Estado Civil',
            estadoCivilSeleccionado,
            [
              const DropdownMenuItem(value: 'S', child: Text('Soltero')),
              const DropdownMenuItem(value: 'C', child: Text('Casado')),
              const DropdownMenuItem(value: 'D', child: Text('Divorciado')),
              const DropdownMenuItem(value: 'V', child: Text('Viudo')),
            ],
            onEstadoCivilChanged),
      ],
    );
  }
}

class InformacionAdicionalRegisterWidget extends StatelessWidget
    with InfoBlockBuilder {
  final TextEditingController grupoSanguineoController;
  final TextEditingController religionController;
  final bool presentadoLogia;
  final TextEditingController nombreLogiaController;
  final Function(bool) onPresentadoLogiaChanged;

  const InformacionAdicionalRegisterWidget({
    Key? key,
    required this.grupoSanguineoController,
    required this.religionController,
    required this.presentadoLogia,
    required this.nombreLogiaController,
    required this.onPresentadoLogiaChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildInfoBlock(
      'Información Adicional',
      [
        _buildInputField('Grupo Sanguíneo', grupoSanguineoController),
        _buildInputField('Religión', religionController),
        _buildSwitchField(
            '¿Presentado en Logia?', presentadoLogia, onPresentadoLogiaChanged),
        _buildInputField('Nombre de Logia', nombreLogiaController),
      ],
    );
  }
}

// Agregar widget para switch field
Widget _buildSwitchField(String label, bool value, Function(bool) onChanged) {
  return Container(
    width: 300,
    margin: const EdgeInsets.only(bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: UserBlockStyles.labelStyle),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    ),
  );
}
// Agregar widgets similares para los demás bloques...

// Mejorar DocumentUploadWidget
class DocumentUploadWidget extends StatelessWidget with InfoBlockBuilder {
  final List<String> uploadedFiles;
  final Function() onUploadTap;
  final Function(int) onDeleteTap;

  const DocumentUploadWidget({
    Key? key,
    required this.uploadedFiles,
    required this.onUploadTap,
    required this.onDeleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Documentos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              ElevatedButton.icon(
                onPressed: onUploadTap,
                icon: const Icon(Icons.upload_file),
                label: const Text('Subir documento'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
          if (uploadedFiles.isNotEmpty) ...[
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: uploadedFiles.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.file_present),
                    title: Text(uploadedFiles[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDeleteTap(index),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class RegisterStyles {
  static const cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8)),
    boxShadow: [
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );

  static const sectionPadding = EdgeInsets.all(24);
  static const sectionSpacing = SizedBox(height: 24);
}
// Helpers y widgets compartidos

Widget _buildInputField(String label, TextEditingController controller,
    {bool isPassword = false}) {
  return Container(
    width: 300,
    margin: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: UserBlockStyles.labelStyle),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDatePickerField(String label, DateTime? value,
    Function(DateTime) onChanged, BuildContext context) {
  return Container(
    width: 300,
    margin: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: UserBlockStyles.labelStyle),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            final fecha = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (fecha != null) {
              onChanged(fecha);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: UserBlockStyles.inputDecoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value != null
                      ? DateFormat('yyyy-MM-dd').format(value)
                      : 'Seleccionar fecha',
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDropdownField<T>(String label, T? value,
    List<DropdownMenuItem<T>> items, Function(T?) onChanged,
    {String? errorText}) {
  return Container(
    width: 300,
    margin: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: UserBlockStyles.labelStyle),
        const SizedBox(height: 4),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ),
      ],
    ),
  );
}

List<DropdownMenuItem<int>> _getRoles() {
  return const [
    DropdownMenuItem(value: 1, child: Text('Usuario')),
    DropdownMenuItem(value: 2, child: Text('Administrador')),
    DropdownMenuItem(value: 3, child: Text('Secretario')),
    DropdownMenuItem(value: 4, child: Text('Tesorero')),
  ];
}

List<DropdownMenuItem<int>> _getEstados() {
  return const [
    DropdownMenuItem(value: 1, child: Text('Activo')),
    DropdownMenuItem(value: 2, child: Text('En sueño')),
    DropdownMenuItem(value: 3, child: Text('Irradiado')),
  ];
}

List<DropdownMenuItem<int>> _getOrganizaciones() {
  return const [
    DropdownMenuItem(
        value: 1, child: Text('Francisco de Paula Gonzales Vigil')),
    DropdownMenuItem(value: 2, child: Text('Real Arco')),
  ];
}
