import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/blocks_usuario_register.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'user_register_viewmodel.dart';

class UserRegisterScreen extends StatelessWidget {
  const UserRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserRegisterViewModel(),
      child: const _UserRegisterContent(),
    );
  }
}

class _UserRegisterContent extends StatelessWidget {
  const _UserRegisterContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const UserRegisterForm();
  }
}

class UserRegisterForm extends StatefulWidget {
  const UserRegisterForm({Key? key}) : super(key: key);

  @override
  State<UserRegisterForm> createState() => _UserRegisterFormState();
}

class _UserRegisterFormState extends State<UserRegisterForm> {
  Map<String, String?> _errors = {};

  bool _validateFields() {
    _errors.clear();
    bool isValid = true;
    try {
      // Validar campos obligatorios
      debugPrint('Validando información general...');
      if (_nombresController.text.isEmpty) {
        _errors['nombres'] = 'El nombre es requerido';
        isValid = false;
        debugPrint('Error: nombres vacío');
      }

      if (_apellidoPaternoController.text.isEmpty) {
        _errors['apellidoPaterno'] = 'El apellido paterno es requerido';
        isValid = false;
        debugPrint('Error: apellido paterno vacío');
      }

      if (_dniController.text.isEmpty) {
        _errors['dni'] = 'El DNI es requerido';
        isValid = false;
        debugPrint('Error: DNI vacío');
      } else if (_dniController.text.length != 8) {
        _errors['dni'] = 'El DNI debe tener 8 dígitos';
        isValid = false;
        debugPrint('Error: DNI inválido');
      }

      if (_emailController.text.isEmpty) {
        _errors['email'] = 'El email es requerido';
        isValid = false;
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
          .hasMatch(_emailController.text)) {
        _errors['email'] = 'Email inválido';
        isValid = false;
      }

      if (_passwordController.text.isEmpty) {
        _errors['password'] = 'La contraseña es requerida';
        isValid = false;
      } else if (_passwordController.text.length < 6) {
        _errors['password'] = 'La contraseña debe tener al menos 6 caracteres';
        isValid = false;
      }

      if (_celularController.text.isEmpty) {
        _errors['celular'] = 'El celular es requerido';
        isValid = false;
      } else if (_celularController.text.length != 9) {
        _errors['celular'] = 'El celular debe tener 9 dígitos';
        isValid = false;
      }

      if (_fechaNacimiento == null) {
        _errors['fechaNacimiento'] = 'La fecha de nacimiento es requerida';
        isValid = false;
        debugPrint('Error: fecha nacimiento null');
      }

      if (_rolSeleccionado == null) {
        _errors['rol'] = 'El rol es requerido';
        isValid = false;
        debugPrint('Error: rol null');
      }

      if (_estadoSeleccionado == null) {
        _errors['estado'] = 'El estado es requerido';
        isValid = false;
        debugPrint('Error: estado null');
      }

      if (_organizacionSeleccionada == null) {
        _errors['organizacion'] = 'La organización es requerida';
        isValid = false;
        debugPrint('Error: organización null');
      }

      setState(() {}); // Actualizar UI para mostrar errores
      return isValid;
    } catch (e) {
      debugPrint('Error durante la validación: $e');
      return false;
    }
  }

  // Información General
  final _nombresController = TextEditingController();
  final _apellidoPaternoController = TextEditingController();
  final _apellidoMaternoController = TextEditingController();
  final _dniController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _celularController = TextEditingController();

  // Información Profesional
  final _profesionController = TextEditingController();
  final _especialidadController = TextEditingController();
  final _centroTrabajoController = TextEditingController();
  final _direccionTrabajoController = TextEditingController();
  final _sueldoMensualController = TextEditingController();

  // Dirección
  final _tipoViaController = TextEditingController();
  final _direccionController = TextEditingController();
  final _departamentoController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _distritoController = TextEditingController();

  // Información Familiar
  final _nombreConyugeController = TextEditingController();
  final _padreNombreController = TextEditingController();
  final _madreNombreController = TextEditingController();

  // Información Adicional
  final _grupoSanguineoController = TextEditingController();
  final _religionController = TextEditingController();
  final _nombreLogiaController = TextEditingController();

  // Dependientes
  final _dependienteNombresApellidosController = TextEditingController();
  final _dependienteParentescoController = TextEditingController();
  DateTime? _dependienteFechaNacimiento;
  String? _dependienteSexo;
  String? _dependienteEstadoCivil;

  // Estados
  DateTime? _fechaNacimiento;
  DateTime? _fechaNacimientoConyuge;
  int? _rolSeleccionado;
  int? _estadoSeleccionado;
  int? _organizacionSeleccionada;
  bool _padreVive = false;
  bool _madreVive = false;
  bool _presentadoLogia = false;
  Uint8List? _selectedImage;
  List<String> _uploadedFiles = [];
  Uint8List? _documentoBytes;

  @override
  void dispose() {
    // Dispose todos los controllers
    // Controladores de Información General
    _nombresController.dispose();
    _apellidoPaternoController.dispose();
    _apellidoMaternoController.dispose();
    _dniController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _celularController.dispose();

    // Controladores de Información Profesional
    _profesionController.dispose();
    _especialidadController.dispose();
    _centroTrabajoController.dispose();
    _direccionTrabajoController.dispose();
    _sueldoMensualController.dispose();

    // Controladores de Dirección
    _tipoViaController.dispose();
    _direccionController.dispose();
    _departamentoController.dispose();
    _provinciaController.dispose();
    _distritoController.dispose();

    // Controladores de Información Familiar
    _nombreConyugeController.dispose();
    _padreNombreController.dispose();
    _madreNombreController.dispose();

    // Controladores de Información Adicional
    _grupoSanguineoController.dispose();
    _religionController.dispose();
    _nombreLogiaController.dispose();

    // Controladores de Dependientes
    _dependienteNombresApellidosController.dispose();
    _dependienteParentescoController.dispose();

    super.dispose();
  }

  void _resetForm() {
    setState(() {
      // Limpiar campos de texto
      _nombresController.clear();
      _apellidoPaternoController.clear();
      _apellidoMaternoController.clear();
      _dniController.clear();
      _emailController.clear();
      _passwordController.clear();
      _celularController.clear();
      _profesionController.clear();
      _especialidadController.clear();
      _centroTrabajoController.clear();
      _direccionTrabajoController.clear();
      _sueldoMensualController.clear();
      _tipoViaController.clear();
      _direccionController.clear();
      _departamentoController.clear();
      _provinciaController.clear();
      _distritoController.clear();
      _nombreConyugeController.clear();
      _padreNombreController.clear();
      _madreNombreController.clear();
      _grupoSanguineoController.clear();
      _religionController.clear();
      _nombreLogiaController.clear();
      _dependienteNombresApellidosController.clear();
      _dependienteParentescoController.clear();

      // Resetear fechas
      _fechaNacimiento = null;
      _fechaNacimientoConyuge = null;
      _dependienteFechaNacimiento = null;

      // Resetear selecciones
      _rolSeleccionado = null;
      _estadoSeleccionado = null;
      _organizacionSeleccionada = null;
      _dependienteSexo = null;
      _dependienteEstadoCivil = null;

      // Resetear booleanos
      _padreVive = false;
      _madreVive = false;
      _presentadoLogia = false;

      // Limpiar imagen y documentos
      _selectedImage = null;
      _documentoBytes = null;
      _uploadedFiles = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    final viewModel = context.watch<UserRegisterViewModel>();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header siempre a ancho completo
                HeaderInfoRegisterWidget(
                  nombresController: _nombresController,
                  apellidoPaternoController: _apellidoPaternoController,
                  apellidoMaternoController: _apellidoMaternoController,
                  onPhotoTap: _handlePhotoUpload,
                  onPhotoRemove: _handlePhotoRemove,
                  selectedImage: _selectedImage,
                ),
                const SizedBox(height: 24),
                // Contenido en dos columnas
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Columna izquierda
                    Expanded(
                      child: Column(
                        children: [
                          InformacionGeneralRegisterWidget(
                            dniController: _dniController,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            celularController: _celularController,
                            fechaNacimiento: _fechaNacimiento,
                            rolSeleccionado: _rolSeleccionado,
                            estadoSeleccionado: _estadoSeleccionado,
                            onFechaNacimientoChanged: (date) {
                              setState(() => _fechaNacimiento = date);
                            },
                            onRolChanged: (rol) {
                              setState(() => _rolSeleccionado = rol);
                            },
                            onEstadoChanged: (estado) {
                              setState(() => _estadoSeleccionado = estado);
                            },
                            organizacionSeleccionada: _organizacionSeleccionada,
                            // Agregar errores
                            dniError: _errors['dni'],
                            emailError: _errors['email'],
                            passwordError: _errors['password'],
                            celularError: _errors['celular'],
                            fechaNacimientoError: _errors['fechaNacimiento'],
                            rolError: _errors['rol'],
                            estadoError: _errors['estado'],
                            onOrganizacionChanged: (org) {
                              setState(() => _organizacionSeleccionada = org);
                            },
                            organizacionError: _errors['organizacion'],
                          ),
                          const SizedBox(height: 24),
                          InformacionProfesionalRegisterWidget(
                            profesionController: _profesionController,
                            especialidadController: _especialidadController,
                            centroTrabajoController: _centroTrabajoController,
                            direccionTrabajoController:
                                _direccionTrabajoController,
                            sueldoMensualController: _sueldoMensualController,
                          ),
                          const SizedBox(height: 24),
                          DireccionRegisterWidget(
                            tipoViaController: _tipoViaController,
                            direccionController: _direccionController,
                            departamentoController: _departamentoController,
                            provinciaController: _provinciaController,
                            distritoController: _distritoController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Columna derecha
                    Expanded(
                      child: Column(
                        children: [
                          InformacionFamiliarRegisterWidget(
                            nombreConyugeController: _nombreConyugeController,
                            fechaNacimientoConyuge: _fechaNacimientoConyuge,
                            padreNombreController: _padreNombreController,
                            padreVive: _padreVive,
                            madreNombreController: _madreNombreController,
                            madreVive: _madreVive,
                            onFechaNacimientoConyugeChanged: (date) {
                              setState(() => _fechaNacimientoConyuge = date);
                            },
                            onPadreViveChanged: (value) {
                              setState(() => _padreVive = value);
                            },
                            onMadreViveChanged: (value) {
                              setState(() => _madreVive = value);
                            },
                          ),
                          const SizedBox(height: 24),
                          InformacionAdicionalRegisterWidget(
                            grupoSanguineoController: _grupoSanguineoController,
                            religionController: _religionController,
                            presentadoLogia: _presentadoLogia,
                            nombreLogiaController: _nombreLogiaController,
                            onPresentadoLogiaChanged: (value) {
                              setState(() => _presentadoLogia = value);
                            },
                          ),
                          const SizedBox(height: 24),
                          DependienteRegisterWidget(
                            nombresApellidosController:
                                _dependienteNombresApellidosController,
                            parentescoController:
                                _dependienteParentescoController,
                            fechaNacimiento: _dependienteFechaNacimiento,
                            sexoSeleccionado: _dependienteSexo,
                            estadoCivilSeleccionado: _dependienteEstadoCivil,
                            onFechaNacimientoChanged: (date) {
                              setState(
                                  () => _dependienteFechaNacimiento = date);
                            },
                            onSexoChanged: (sexo) {
                              setState(() => _dependienteSexo = sexo);
                            },
                            onEstadoCivilChanged: (estado) {
                              setState(() => _dependienteEstadoCivil = estado);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Documentos a ancho completo
                DocumentUploadWidget(
                  uploadedFiles: _uploadedFiles,
                  onUploadTap: _handleDocumentUpload,
                  onDeleteTap: _handleDocumentDelete,
                ),
                const SizedBox(height: 24),
                if (viewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                // Botón centrado y con mejor estilo
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: viewModel.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Registrar Usuario',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handlePhotoUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _selectedImage = result.files.first.bytes;
      });
    }
  }

  Future<void> _handleDocumentUpload() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null) {
        final file = result.files.first;
        if (file.bytes != null) {
          // Verificar el tamaño del archivo
          if (file.bytes!.length > 10 * 1024 * 1024) {
            // 10MB límite
            throw Exception('El archivo es demasiado grande. Máximo 10MB.');
          }

          setState(() {
            _documentoBytes = file.bytes;
            _uploadedFiles = [file.name];
          });
          debugPrint('Documento seleccionado: ${file.name}');
          debugPrint('Tamaño: ${file.bytes!.length} bytes');
          debugPrint('Tipo: ${file.extension}');
        } else {
          throw Exception('No se pudo leer el archivo');
        }
      }
    } catch (e) {
      debugPrint('Error al seleccionar documento: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al seleccionar documento: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handlePhotoRemove() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _handleDocumentDelete(int index) {
    setState(() {
      _uploadedFiles.removeAt(index);
      _documentoBytes = null;
    });
  }

  Future<void> _handleSubmit() async {
    try {
      // Primer breakpoint aquí
      debugPrint('Iniciando submit...');
      if (!_validateFields()) {
        debugPrint('Validación fallida, deteniendo submit');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, complete todos los campos requeridos'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      debugPrint('Validación exitosa, continuando...');
      final viewModel = context.read<UserRegisterViewModel>();
      print('Creando objeto UsuarioCreate...');
      final usuario = UsuarioCreate(
        dni: _dniController.text,
        email: _emailController.text,
        password: _passwordController.text,
        nombres: _nombresController.text,
        apellidos_paterno: _apellidoPaternoController.text,
        apellidos_materno: _apellidoMaternoController.text,
        fecha_nacimiento: _fechaNacimiento!,
        celular: _celularController.text,
        rol_id: _rolSeleccionado!,
        estado_id: _estadoSeleccionado!,
        profesion: _profesionController.text,
        especialidad: _especialidadController.text,
        centro_trabajo: _centroTrabajoController.text,
        direccion_trabajo: _direccionTrabajoController.text,
        sueldo_mensual:
            (int.tryParse(_sueldoMensualController.text) ?? 0).toDouble(),
        tipo_via: _tipoViaController.text,
        direccion: _direccionController.text,
        departamento: _departamentoController.text,
        provincia: _provinciaController.text,
        distrito: _distritoController.text,
        nombre_conyuge: _nombreConyugeController.text,
        fecha_nacimiento_conyuge: _fechaNacimientoConyuge,
        padre_nombre: _padreNombreController.text,
        padre_vive: _padreVive,
        madre_nombre: _madreNombreController.text,
        madre_vive: _madreVive,
        grupo_sanguineo: _grupoSanguineoController.text,
        religion: _religionController.text,
        presentado_logia: _presentadoLogia,
        nombre_logia: _nombreLogiaController.text,
        id_organizacion: _organizacionSeleccionada!,
        nombres_apellidos: _dependienteNombresApellidosController.text,
        parentesco: _dependienteParentescoController.text,
        fecha_nacimiento1: _dependienteFechaNacimiento,
        sexo: _dependienteSexo,
        estado_civil: _dependienteEstadoCivil,
      );

      final success = await viewModel.registerUsuarioCompleto(
        usuario: usuario,
        fotoBytes: _selectedImage,
        fotoNombre: 'foto_perfil.jpg',
        fotoMimeType: 'image/jpeg',
        documentoBytes: _documentoBytes,
        nombres: _nombresController.text,
        apellidos: _apellidoPaternoController.text,
      );

      if (success && mounted) {
        await _mostrarDialogoExito();
        _resetForm();
      }
    } catch (e) {
      print('Error en _handleSubmit: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al registrar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _mostrarDialogoExito() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Text('¡Registro Exitoso!'),
            ],
          ),
          content: const Text(
            'El usuario ha sido registrado correctamente.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
