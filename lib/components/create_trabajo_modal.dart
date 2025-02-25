// lib/components/create_trabajo_modal.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/screens/works/work_list_viewmodel.dart';
import 'package:intl/intl.dart';

class CreateTrabajoModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onCreate;
  final WorkViewModel viewModel; // Agregar viewModel

  const CreateTrabajoModal({
    Key? key,
    required this.onCreate,
    required this.viewModel, // Requerido
  }) : super(key: key);

  @override
  State<CreateTrabajoModal> createState() => _CreateTrabajoModalState();
}

class _CreateTrabajoModalState extends State<CreateTrabajoModal> {
  int? selectedUsuarioId;
  int? selectedReunionId;
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  DateTime _fechaPresentacion = DateTime.now();
  bool _isInitialized = false;
  List<Map<String, dynamic>> selectedFiles = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // Usar addPostFrameCallback para evitar setState durante el build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    if (!_isInitialized) {
      await widget.viewModel.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          for (var file in result.files) {
            if (file.bytes != null) {
              selectedFiles.add({
                'name': file.name,
                'bytes': file.bytes!,
                'mimeType': 'application/pdf',
              });
            }
          }
          errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error al seleccionar archivos: $e';
      });
    }
  }

  // Agregar este método para eliminar un archivo
  void _removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Crear Nuevo Trabajo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 24),
                // Búsqueda de Usuario
                Autocomplete<UsuarioConGrado>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return widget.viewModel.usuariosActivos;
                    }
                    return widget.viewModel.usuariosActivos.where((usuario) {
                      final nombre = widget.viewModel
                          .formatUserName(usuario)
                          .toLowerCase();
                      return nombre
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  displayStringForOption: (usuario) =>
                      widget.viewModel.formatUserName(usuario),
                  onSelected: (usuario) {
                    setState(() {
                      selectedUsuarioId = usuario.id;
                    });
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxWidth: 300, maxHeight: 200),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final option = options.elementAt(index);
                              return ListTile(
                                title: Text(
                                    widget.viewModel.formatUserName(option)),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Buscar Usuario',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione un usuario';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Búsqueda de Reunión
                Autocomplete<MeetingListResponse>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return widget.viewModel.reunionesPublicadas;
                    }
                    return widget.viewModel.reunionesPublicadas
                        .where((reunion) {
                      final descripcion =
                          widget.viewModel.formatMeeting(reunion).toLowerCase();
                      return descripcion
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  displayStringForOption: (reunion) =>
                      widget.viewModel.formatMeeting(reunion),
                  onSelected: (reunion) {
                    setState(() {
                      selectedReunionId = reunion.id;
                    });
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxWidth: 300, maxHeight: 200),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final option = options.elementAt(index);
                              return ListTile(
                                title: Text(
                                    widget.viewModel.formatMeeting(option)),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Buscar Reunión',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione una reunión';
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una descripción';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _fechaPresentacion,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() {
                        _fechaPresentacion = picked;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Presentación',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(_fechaPresentacion),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
_buildFileList(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
    if (_formKey.currentState!.validate()) {
      if (selectedUsuarioId == null || selectedReunionId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor seleccione usuario y reunión'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Cerrar el modal inmediatamente
      Navigator.pop(context);

      // Realizar la creación en segundo plano
      final success = await widget.viewModel.createTrabajo(
        reunionId: selectedReunionId!,
        usuarioId: selectedUsuarioId!,
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
        fechaPresentacion: _fechaPresentacion,
      );

      // Si la creación fue exitosa y hay archivos, subirlos
      if (success && selectedFiles.isNotEmpty) {
        await widget.viewModel.uploadTrabajoFiles(
          selectedFiles: selectedFiles,
        );
      }
    }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Crear'),
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

  Widget _buildFileList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Archivos PDF',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          itemCount: selectedFiles.length,
          itemBuilder: (context, index) {
            final file = selectedFiles[index];
            return ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text(file['name']),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _removeFile(index),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _pickFiles,
          icon: const Icon(Icons.upload_file),
          label: const Text('Agregar PDFs'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
          ),
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              errorMessage!,
              style: TextStyle(color: Colors.red[700], fontSize: 12),
            ),
          ),
      ],
    );
  }
}

