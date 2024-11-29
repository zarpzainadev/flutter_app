import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/blocks_usuario.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:intl/intl.dart';

class EditForm extends StatefulWidget {
  final UserDetail? initialData;
  final Function(Map<String, dynamic>) onSave;

  const EditForm({
    Key? key,
    required this.initialData,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _changedFields = {};
  DateTime? _fechaNacimiento;
  DateTime? _fechaNacimientoConyuge;
  int? _rolSeleccionado;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Campos generales
    _controllers['nombres'] =
        TextEditingController(text: widget.initialData?.nombres ?? 'Sin datos');
    _controllers['apellidosPaterno'] = TextEditingController(
        text: widget.initialData?.apellidos_paterno ?? 'Sin datos');
    _controllers['apellidosMaterno'] = TextEditingController(
        text: widget.initialData?.apellidos_materno ?? 'Sin datos');
    _controllers['dni'] =
        TextEditingController(text: widget.initialData?.dni ?? 'Sin datos');
    _controllers['email'] =
        TextEditingController(text: widget.initialData?.email ?? 'Sin datos');
    _controllers['celular'] =
        TextEditingController(text: widget.initialData?.celular ?? 'Sin datos');

    // Campos profesionales
    _controllers['profesion'] = TextEditingController(
        text: widget.initialData?.informacion_profesional?.profesion ??
            'Sin datos');
    _controllers['especialidad'] = TextEditingController(
        text: widget.initialData?.informacion_profesional?.especialidad ??
            'Sin datos');
    _controllers['centroTrabajo'] = TextEditingController(
        text: widget.initialData?.informacion_profesional?.centro_trabajo ??
            'Sin datos');
    _controllers['direccionTrabajo'] = TextEditingController(
        text: widget.initialData?.informacion_profesional?.direccion_trabajo ??
            'Sin datos');
    _controllers['sueldoMensual'] = TextEditingController(
        text: widget.initialData?.informacion_profesional?.sueldo_mensual
                ?.toString() ??
            'Sin datos');

    // Agregar en _initializeControllers:

// Campos de dirección
    _controllers['tipoVia'] = TextEditingController(
        text: widget.initialData?.direcciones?.tipo_via ?? 'Sin datos');
    _controllers['direccion'] = TextEditingController(
        text: widget.initialData?.direcciones?.direccion ?? 'Sin datos');
    _controllers['departamento'] = TextEditingController(
        text: widget.initialData?.direcciones?.departamento ?? 'Sin datos');
    _controllers['provincia'] = TextEditingController(
        text: widget.initialData?.direcciones?.provincia ?? 'Sin datos');
    _controllers['distrito'] = TextEditingController(
        text: widget.initialData?.direcciones?.distrito ?? 'Sin datos');

// Campos familiares
    _controllers['nombreConyuge'] = TextEditingController(
        text: widget.initialData?.informacion_familiar?.nombre_conyuge ??
            'Sin datos');
    _controllers['padreNombre'] = TextEditingController(
        text: widget.initialData?.informacion_familiar?.padre_nombre ??
            'Sin datos');
    _controllers['madreNombre'] = TextEditingController(
        text: widget.initialData?.informacion_familiar?.madre_nombre ??
            'Sin datos');

// Campos adicionales
    _controllers['grupoSanguineo'] = TextEditingController(
        text: widget.initialData?.informacion_adicional?.grupo_sanguineo ??
            'Sin datos');
    _controllers['religion'] = TextEditingController(
        text:
            widget.initialData?.informacion_adicional?.religion ?? 'Sin datos');
    _controllers['nombreLogia'] = TextEditingController(
        text: widget.initialData?.informacion_adicional?.nombre_logia ??
            'Sin datos');

    // Inicializar fechas
    _fechaNacimiento = widget.initialData?.fecha_nacimiento;
    _fechaNacimientoConyuge =
        widget.initialData?.informacion_familiar?.fecha_nacimiento_conyuge;
    _rolSeleccionado = widget.initialData?.rol_id;

    // Agregar listeners para detectar cambios
    _controllers.forEach((key, controller) {
      controller.addListener(() {
        if (controller.text != widget.initialData?.toJson()[key]) {
          _changedFields[key] = controller.text;
        }
      });
    });
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _handleSubmit() {
    // Solo enviar campos modificados
    if (_changedFields.isNotEmpty) {
      widget.onSave(_changedFields);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F6F9),
      child: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                // Información Personal
                BaseBlockWidget(
                  title: 'Información Personal',
                  children: [_buildPersonalInfo()],
                ),
                const SizedBox(height: 20),

                // Información Profesional
                BaseBlockWidget(
                  title: 'Información Profesional',
                  children: [_buildProfessionalInfo()],
                ),
                const SizedBox(height: 20),

                // Dirección
                BaseBlockWidget(
                  title: 'Dirección',
                  children: [_buildAddressInfo()],
                ),
                const SizedBox(height: 20),

                // Información Familiar
                BaseBlockWidget(
                  title: 'Información Familiar',
                  children: [_buildFamilyInfo()],
                ),
                const SizedBox(height: 20),

                // Información Adicional
                BaseBlockWidget(
                  title: 'Información Adicional',
                  children: [_buildAdditionalInfo()],
                ),
                const SizedBox(height: 20),

                // Botón guardar
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Continuación de edit_form.dart

  Widget _buildPersonalInfo() {
    return Column(
      children: [
        TextFormField(
          controller: _controllers['nombres'],
          decoration: _buildInputDecoration('Nombres'),
          onChanged: (value) => _changedFields['nombres'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['apellidosPaterno'],
          decoration: _buildInputDecoration('Apellido Paterno'),
          onChanged: (value) => _changedFields['apellidosPaterno'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['apellidosMaterno'],
          decoration: _buildInputDecoration('Apellido Materno'),
          onChanged: (value) => _changedFields['apellidosMaterno'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['dni'],
          decoration: _buildInputDecoration('DNI'),
          onChanged: (value) => _changedFields['dni'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['email'],
          decoration: _buildInputDecoration('Email'),
          onChanged: (value) => _changedFields['email'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['celular'],
          decoration: _buildInputDecoration('Celular'),
          onChanged: (value) => _changedFields['celular'] = value,
        ),
      ],
    );
  }

  Widget _buildProfessionalInfo() {
    return Column(
      children: [
        TextFormField(
          controller: _controllers['profesion'],
          decoration: _buildInputDecoration('Profesión'),
          onChanged: (value) => _changedFields['profesion'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['especialidad'],
          decoration: _buildInputDecoration('Especialidad'),
          onChanged: (value) => _changedFields['especialidad'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['centroTrabajo'],
          decoration: _buildInputDecoration('Centro de Trabajo'),
          onChanged: (value) => _changedFields['centroTrabajo'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['direccionTrabajo'],
          decoration: _buildInputDecoration('Dirección de Trabajo'),
          onChanged: (value) => _changedFields['direccionTrabajo'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['sueldoMensual'],
          decoration: _buildInputDecoration('Sueldo Mensual'),
          keyboardType: TextInputType.number,
          onChanged: (value) => _changedFields['sueldoMensual'] = value,
        ),
      ],
    );
  }

  Widget _buildAddressInfo() {
    return Column(
      children: [
        TextFormField(
          controller: _controllers['tipoVia'],
          decoration: _buildInputDecoration('Tipo de Vía'),
          onChanged: (value) => _changedFields['tipoVia'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['direccion'],
          decoration: _buildInputDecoration('Dirección'),
          onChanged: (value) => _changedFields['direccion'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['departamento'],
          decoration: _buildInputDecoration('Departamento'),
          onChanged: (value) => _changedFields['departamento'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['provincia'],
          decoration: _buildInputDecoration('Provincia'),
          onChanged: (value) => _changedFields['provincia'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['distrito'],
          decoration: _buildInputDecoration('Distrito'),
          onChanged: (value) => _changedFields['distrito'] = value,
        ),
      ],
    );
  }

  Widget _buildFamilyInfo() {
    return Column(
      children: [
        TextFormField(
          controller: _controllers['nombreConyuge'],
          decoration: _buildInputDecoration('Nombre del Cónyuge'),
          onChanged: (value) => _changedFields['nombreConyuge'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['padreNombre'],
          decoration: _buildInputDecoration('Nombre del Padre'),
          onChanged: (value) => _changedFields['padreNombre'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['madreNombre'],
          decoration: _buildInputDecoration('Nombre de la Madre'),
          onChanged: (value) => _changedFields['madreNombre'] = value,
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      children: [
        TextFormField(
          controller: _controllers['grupoSanguineo'],
          decoration: _buildInputDecoration('Grupo Sanguíneo'),
          onChanged: (value) => _changedFields['grupoSanguineo'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['religion'],
          decoration: _buildInputDecoration('Religión'),
          onChanged: (value) => _changedFields['religion'] = value,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controllers['nombreLogia'],
          decoration: _buildInputDecoration('Nombre de Logia'),
          onChanged: (value) => _changedFields['nombreLogia'] = value,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E3A8A),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Guardar Cambios',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
      ),
    );
  }
}
