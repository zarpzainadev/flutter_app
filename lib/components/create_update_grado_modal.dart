// lib/components/create_update_grado_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_android/screens/grados/grados_viewmodel.dart';

class CreateGradoModal extends StatefulWidget {
  final Function(int idGrado, String estado) onConfirm;
  final int usuarioId;

  const CreateGradoModal({
    Key? key,
    required this.onConfirm,
    required this.usuarioId,
  }) : super(key: key);

  @override
  State<CreateGradoModal> createState() => _CreateGradoModalState();
}

class _CreateGradoModalState extends State<CreateGradoModal> {
  GradoSimpleResponse? selectedGrado;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        child: Consumer<GradosViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Crear Grado',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 24),
                if (viewModel.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (viewModel.gradosOrganizacion.isEmpty)
                  const Text('No hay grados disponibles')
                else
                  DropdownButtonFormField<GradoSimpleResponse>(
                    value: selectedGrado,
                    decoration: const InputDecoration(
                      labelText: 'Grado',
                      border: OutlineInputBorder(),
                    ),
                    items: viewModel.gradosOrganizacion.map((grado) {
                      return DropdownMenuItem(
                        value: grado,
                        child: Text(grado.nombre),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedGrado = value),
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor seleccione un grado';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: selectedGrado == null
                          ? null
                          : () {
                              widget.onConfirm(
                                selectedGrado!.id,
                                'Activo',
                              );
                              Navigator.pop(context);
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
            );
          },
        ),
      ),
    );
  }
}

class UpdateGradoModal extends StatefulWidget {
  final Function(int idGrado, String estado) onConfirm;
  final String gradoActual;

  const UpdateGradoModal({
    Key? key,
    required this.onConfirm,
    required this.gradoActual,
  }) : super(key: key);

  @override
  State<UpdateGradoModal> createState() => _UpdateGradoModalState();
}

class _UpdateGradoModalState extends State<UpdateGradoModal> {
  GradoSimpleResponse? selectedGrado;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        child: Consumer<GradosViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Actualizar Grado',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Grado actual: ${widget.gradoActual}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                if (viewModel.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (viewModel.gradosOrganizacion.isEmpty)
                  const Text('No hay grados disponibles')
                else
                  DropdownButtonFormField<GradoSimpleResponse>(
                    value: selectedGrado,
                    decoration: const InputDecoration(
                      labelText: 'Nuevo Grado',
                      border: OutlineInputBorder(),
                    ),
                    items: viewModel.gradosOrganizacion.map((grado) {
                      return DropdownMenuItem(
                        value: grado,
                        child: Text(grado.nombre),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedGrado = value),
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor seleccione un grado';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: selectedGrado == null
                          ? null
                          : () {
                              widget.onConfirm(
                                selectedGrado!.id,
                                'Activo',
                              );
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Actualizar'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Funciones helper para mostrar los modales
Future<void> showCreateGradoModal(
  BuildContext context,
  int usuarioId,
  Function(int idGrado, String estado) onConfirm,
) {
  // Obtener el ViewModel existente
  final viewModel = Provider.of<GradosViewModel>(context, listen: false);
  
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) => ChangeNotifierProvider.value( // Cambiado aquí
      value: viewModel,
      child: CreateGradoModal(
        usuarioId: usuarioId,
        onConfirm: onConfirm,
      ),
    ),
  );
}

Future<void> showUpdateGradoModal(
  BuildContext context,
  String gradoActual,
  Function(int idGrado, String estado) onConfirm,
) {
  // Obtener el ViewModel existente
  final viewModel = Provider.of<GradosViewModel>(context, listen: false);
  
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) => ChangeNotifierProvider.value( // Cambiado aquí
      value: viewModel,
      child: UpdateGradoModal(
        gradoActual: gradoActual,
        onConfirm: onConfirm,
      ),
    ),
  );
}