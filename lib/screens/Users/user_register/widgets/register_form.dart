import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/blocks_usuario.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/screens/Users/user_register/user_register_viewmodel.dart';
import 'package:flutter_web_android/screens/Users/user_register/utils/register_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // Controllers
  final Map<String, TextEditingController> _controllers = {
    'nombres': TextEditingController(),
    'apellidoPaterno': TextEditingController(),
    'apellidoMaterno': TextEditingController(),
    'dni': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
    'celular': TextEditingController(),
    'profesion': TextEditingController(),
    'especialidad': TextEditingController(),
    'centroTrabajo': TextEditingController(),
    'direccionTrabajo': TextEditingController(),
    'sueldoMensual': TextEditingController(),
    'tipoVia': TextEditingController(),
    'direccion': TextEditingController(),
    'departamento': TextEditingController(),
    'provincia': TextEditingController(),
    'distrito': TextEditingController(),
    'nombreConyuge': TextEditingController(),
    'padreNombre': TextEditingController(),
    'madreNombre': TextEditingController(),
    'grupoSanguineo': TextEditingController(),
    'religion': TextEditingController(),
    'nombreLogia': TextEditingController(),
    'parentesco': TextEditingController(),
    'sexo': TextEditingController(),
    'estadoCivil': TextEditingController(),
    'nombres_apellidos': TextEditingController(),
  };

  // Estados
  DateTime? _fechaNacimiento;
  DateTime? _fechaNacimientoConyuge;
  DateTime? _fechaNacimiento1;
  int? _rolSeleccionado;
  int? _estadoSeleccionado;
  int? _organizacionSeleccionada;
  bool _padreVive = false;
  bool _madreVive = false;
  bool _presentadoLogia = false;
  Uint8List? _selectedImage;
  List<String> _uploadedFiles = [];
  Uint8List? _documentoBytes;
  Map<String, String?> _errors = {};
  String? _sexoSeleccionado;

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _handleSubmit() async {
    final errors = RegisterValidators.validateFields(
      nombres: _controllers['nombres']!.text,
      apellidoPaterno: _controllers['apellidoPaterno']!.text,
      dni: _controllers['dni']!.text,
      email: _controllers['email']!.text,
      password: _controllers['password']!.text,
      celular: _controllers['celular']!.text,
      fechaNacimiento: _fechaNacimiento,
      rolSeleccionado: _rolSeleccionado,
      estadoSeleccionado: _estadoSeleccionado,
      organizacionSeleccionada: _organizacionSeleccionada,
    );

    // Si hay errores, actualizar estado y detener
    if (errors.isNotEmpty) {
      setState(() => _errors = errors);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete todos los campos requeridos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final viewModel = context.read<UserRegisterViewModel>();

      final usuario = UsuarioCreate(
        dni: _controllers['dni']!.text,
        email: _controllers['email']!.text,
        password: _controllers['password']!.text,
        nombres: _controllers['nombres']!.text,
        apellidos_paterno: _controllers['apellidoPaterno']!.text,
        apellidos_materno: _controllers['apellidoMaterno']!.text,
        fecha_nacimiento: _fechaNacimiento!,
        celular: _controllers['celular']!.text,
        rol_id: _rolSeleccionado!,
        estado_id: _estadoSeleccionado!,
        profesion: _controllers['profesion']!.text,
        especialidad: _controllers['especialidad']!.text,
        centro_trabajo: _controllers['centroTrabajo']!.text,
        direccion_trabajo: _controllers['direccionTrabajo']!.text,
        sueldo_mensual: double.tryParse(_controllers['sueldoMensual']!.text),
        tipo_via: _controllers['tipoVia']!.text,
        direccion: _controllers['direccion']!.text,
        departamento: _controllers['departamento']!.text,
        provincia: _controllers['provincia']!.text,
        distrito: _controllers['distrito']!.text,
        nombre_conyuge: _controllers['nombreConyuge']!.text,
        fecha_nacimiento_conyuge: _fechaNacimientoConyuge,
        padre_nombre: _controllers['padreNombre']!.text,
        padre_vive: _padreVive,
        madre_nombre: _controllers['madreNombre']!.text,
        madre_vive: _madreVive,
        grupo_sanguineo: _controllers['grupoSanguineo']!.text,
        religion: _controllers['religion']!.text,
        presentado_logia: _presentadoLogia,
        nombre_logia:
            _presentadoLogia ? _controllers['nombreLogia']!.text : null,
        nombres_apellidos: _controllers['nombres_apellidos']!.text,
        parentesco: _controllers['parentesco']!.text,
        fecha_nacimiento1: _fechaNacimiento1,
        sexo: _sexoSeleccionado,
        estado_civil: _controllers['estadoCivil']!.text,
        id_organizacion: _organizacionSeleccionada,
      );

      final success = await viewModel.registerUsuarioCompleto(
        usuario: usuario,
        fotoBytes: _selectedImage,
        documentoBytes: _documentoBytes,
        nombres: _controllers['nombres']!.text,
        apellidos: _controllers['apellidoPaterno']!.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado correctamente')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _handlePhotoUpload() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _selectedImage = result.files.first.bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  void _handleDocumentUpload() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _documentoBytes = result.files.first.bytes;
          _uploadedFiles.add(result.files.first.name);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar documento: $e')),
      );
    }
  }

  void _handleDocumentDelete(int index) {
    setState(() {
      _uploadedFiles.removeAt(index);
      if (_uploadedFiles.isEmpty) {
        _documentoBytes = null;
      }
    });
  }

  void _initializeControllers() {
    // Inicializar controllers
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
                  children: [_buildHeaderSection()],
                ),
                const SizedBox(height: 20),

                // Información General
                BaseBlockWidget(
                  title: 'Información General',
                  children: [_buildGeneralSection()],
                ),
                const SizedBox(height: 20),

                // Información Profesional y Dirección
                BaseBlockWidget(
                  title: 'Información Profesional y Dirección',
                  children: [
                    _buildProfessionalSection(),
                    _buildAddressSection(),
                  ],
                ),
                const SizedBox(height: 20),

                // Información Familiar y Adicional
                BaseBlockWidget(
                  title: 'Información Familiar y Adicional',
                  children: [
                    _buildFamilySection(),
                    _buildAdditionalSection(),
                  ],
                ),
                const SizedBox(height: 20),

                // Dependientes
                BaseBlockWidget(
                  title: 'Dependientes',
                  children: [_buildDependientesSection()],
                ),
                const SizedBox(height: 20),

                // Documentos
                BaseBlockWidget(
                  title: 'Documentos',
                  children: [_buildDocumentsSection()],
                ),
                const SizedBox(height: 24),

                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        // Foto
        GestureDetector(
          onTap: _handlePhotoUpload,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
              color: const Color(0xFFF8FAFC),
            ),
            child: _selectedImage != null
                ? CircleAvatar(
                    backgroundImage: MemoryImage(_selectedImage!),
                    radius: 60,
                  )
                : const Icon(Icons.add_a_photo,
                    size: 40, color: Color(0xFF64748B)),
          ),
        ),
        if (_selectedImage != null)
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 20),
              onPressed: () => setState(() => _selectedImage = null),
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(
                minWidth: 30,
                minHeight: 30,
              ),
            ),
          ),
        const SizedBox(height: 16),

        // Campos de texto
        _buildTextField('Nombres', _controllers['nombres']!, isRequired: true),
        _buildTextField('Apellido Paterno', _controllers['apellidoPaterno']!,
            isRequired: true),
        _buildTextField('Apellido Materno', _controllers['apellidoMaterno']!,
            isRequired: true),
      ],
    );
  }

  Widget _buildGeneralSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildTextField('DNI', _controllers['dni']!, isRequired: true),
              _buildTextField('Email', _controllers['email']!,
                  isRequired: true),
              _buildTextField('Contraseña', _controllers['password']!,
                  isPassword: true, isRequired: true),
              _buildTextField('Celular', _controllers['celular']!,
                  isRequired: true),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              _buildDateSelector(
                'Fecha de Nacimiento',
                _fechaNacimiento,
                isRequired: true,
                (date) => setState(() => _fechaNacimiento = date),
              ),
              _buildDropdown(
                'Rol',
                _rolSeleccionado,
                _getRoles(),
                isRequired: true,
                (value) => setState(() => _rolSeleccionado = value),
              ),
              _buildDropdown(
                'Estado',
                _estadoSeleccionado,
                _getEstados(),
                isRequired: true,
                (value) => setState(() => _estadoSeleccionado = value),
              ),
              _buildDropdown(
                'Organización',
                _organizacionSeleccionada,
                _getOrganizaciones(),
                isRequired: true,
                (value) => setState(() => _organizacionSeleccionada = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<int>> _getRoles() => [
        const DropdownMenuItem(value: 1, child: Text('Usuario')),
        const DropdownMenuItem(value: 2, child: Text('Administrador')),
        const DropdownMenuItem(value: 3, child: Text('Secretario')),
        const DropdownMenuItem(value: 4, child: Text('Tesorero')),
      ];

  List<DropdownMenuItem<int>> _getEstados() => [
        const DropdownMenuItem(value: 1, child: Text('Activo')),
        const DropdownMenuItem(value: 2, child: Text('En sueño')),
        const DropdownMenuItem(value: 3, child: Text('Irradiado')),
      ];

  List<DropdownMenuItem<int>> _getOrganizaciones() => [
        const DropdownMenuItem(
            value: 1, child: Text('Francisco de Paula Gonzales Vigil')),
        const DropdownMenuItem(value: 2, child: Text('Real Arco')),
      ];

  List<DropdownMenuItem<String>> _getSexoOptions() => [
        const DropdownMenuItem(value: 'M', child: Text('Masculino')),
        const DropdownMenuItem(value: 'F', child: Text('Femenino')),
      ];

  Widget _buildDateSelector(
      String label, DateTime? value, Function(DateTime?) onChanged,
      {bool isRequired = false}) {
    return Container(
      width: double.infinity,
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
          if (isRequired)
            const Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FC),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFCED4DA)),
            ),
            child: ListTile(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: value ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                onChanged(date);
              },
              title: Text(
                value != null
                    ? DateFormat('dd/MM/yyyy').format(value)
                    : 'Seleccionar fecha',
                style: const TextStyle(fontSize: 14),
              ),
              trailing: const Icon(Icons.calendar_today),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>(
    String label,
    T? value,
    List<DropdownMenuItem<T>> items,
    Function(T?) onChanged, {
    bool isRequired = false, // Nuevo parámetro
    String? errorText,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // Nuevo Row para label y asterisco
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFCED4DA)),
            ),
            child: DropdownButtonFormField<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: InputBorder.none,
                errorText: errorText,
              ),
              isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildTextField('Profesión', _controllers['profesion']!),
              _buildTextField(
                  'Centro de Trabajo', _controllers['centroTrabajo']!),
              _buildTextField(
                'Sueldo Mensual',
                _controllers['sueldoMensual']!,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              _buildTextField('Especialidad', _controllers['especialidad']!),
              _buildTextField(
                  'Dirección de Trabajo', _controllers['direccionTrabajo']!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildTextField('Tipo de Vía', _controllers['tipoVia']!),
              _buildTextField('Dirección', _controllers['direccion']!),
              _buildTextField('Departamento', _controllers['departamento']!),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              _buildTextField('Provincia', _controllers['provincia']!),
              _buildTextField('Distrito', _controllers['distrito']!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFamilySection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildTextField(
                  'Nombre del Cónyuge', _controllers['nombreConyuge']!),
              _buildDateSelector(
                'Fecha de Nacimiento Cónyuge',
                _fechaNacimientoConyuge,
                (date) => setState(() => _fechaNacimientoConyuge = date),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              _buildTextField('Nombre del Padre', _controllers['padreNombre']!),
              SwitchListTile(
                title: const Text('¿Padre vive?'),
                value: _padreVive,
                onChanged: (value) => setState(() => _padreVive = value),
              ),
              _buildTextField(
                  'Nombre de la Madre', _controllers['madreNombre']!),
              SwitchListTile(
                title: const Text('¿Madre vive?'),
                value: _madreVive,
                onChanged: (value) => setState(() => _madreVive = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalSection() {
    return Column(
      children: [
        _buildTextField('Grupo Sanguíneo', _controllers['grupoSanguineo']!),
        _buildTextField('Religión', _controllers['religion']!),
        SwitchListTile(
          title: const Text('¿Presentado en Logia?'),
          value: _presentadoLogia,
          onChanged: (value) => setState(() => _presentadoLogia = value),
        ),
        if (_presentadoLogia)
          _buildTextField('Nombre de la Logia', _controllers['nombreLogia']!),
      ],
    );
  }

  Widget _buildDependientesSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildTextField('Nombres y Apellidos del Dependiente',
                  _controllers['nombres_apellidos']!),
              _buildTextField('Parentesco', _controllers['parentesco']!),
              _buildDateSelector(
                'Fecha de Nacimiento',
                _fechaNacimiento1,
                (date) => setState(() => _fechaNacimiento1 = date),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              _buildDropdown(
                'Sexo',
                _sexoSeleccionado,
                _getSexoOptions(),
                (value) => setState(() => _sexoSeleccionado = value),
              ),
              _buildTextField('Estado Civil', _controllers['estadoCivil']!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: _handleDocumentUpload,
          icon: const Icon(Icons.upload_file),
          label: const Text('Subir Documento'),
        ),
        if (_uploadedFiles.isNotEmpty) ...[
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _uploadedFiles.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.file_present),
                title: Text(_uploadedFiles[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _handleDocumentDelete(index),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  //boton de registrar usuario
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: const Color(0xFF007BFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Registrar Usuario',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Agregar este método en _RegisterFormState
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    TextInputType? keyboardType,
    String? errorText,
    bool isRequired = false,
  }) {
    return Container(
      width: double.infinity,
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
          if (isRequired)
            const Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8), // Bordes más redondeados
              border: Border.all(color: const Color(0xFFCED4DA)),
            ),
            child: TextFormField(
              controller: controller,
              obscureText: isPassword,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                errorText: errorText,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                border: InputBorder.none,
                fillColor: Colors.white,
                filled: true,
                // Agregar bordes redondeados al campo de texto
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
