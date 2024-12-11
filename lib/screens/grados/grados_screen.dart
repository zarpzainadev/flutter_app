// lib/screens/grados/grados_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/create_update_grado_modal.dart';
import 'package:flutter_web_android/components/generic_list_widget.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:flutter_web_android/components/table_flexible.dart';
import 'package:flutter_web_android/screens/grados/grados_viewmodel.dart';

class GradosScreen extends StatelessWidget {
  const GradosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GradosViewModel()..initialize(),
      child: Consumer<GradosViewModel>(
        builder: (context, viewModel, child) {
          return Stack(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (viewModel.errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          viewModel.errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => viewModel.loadUsuariosConGrado(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Actualizar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: !kIsWeb
                          ? GenericListWidget<UsuarioConGrado>(
                              items: viewModel.usuarios,
                              isLoading: viewModel.isLoading,
                              emptyMessage:
                                  'No hay usuarios con grados registrados',
                              emptyIcon: Icons.school_outlined,
                              getTitle: (usuario) =>
                                  '${usuario.nombres} ${usuario.apellidosPaterno}',
                              getSubtitle: (usuario) => usuario.grado,
                              getAvatarText: (usuario) =>
                                  usuario.nombres[0].toUpperCase(),
                              getChips: (usuario) => [
                                ChipInfo(
                                  icon: Icons.school,
                                  label: usuario.grado,
                                  backgroundColor: usuario.grado == 'Sin grado'
                                      ? Colors.grey[100]
                                      : Colors.blue[100],
                                  textColor: const Color(0xFF1E3A8A),
                                ),
                              ],
                              actions: [
                                GenericAction(
                                  icon: Icons.edit,
                                  color: const Color(0xFF1E3A8A),
                                  tooltip: 'Actualizar Grado',
                                  onPressed: (usuario) async {
                                    if (usuario.grado == 'Sin grado') return;
                                    await showUpdateGradoModal(
                                      context,
                                      usuario.grado,
                                      (grado, abrevGrado) async {
                                        try {
                                          final success =
                                              await viewModel.actualizarGrado(
                                            usuarioId: usuario.id,
                                            grado: grado,
                                            abrevGrado: abrevGrado,
                                          );

                                          if (success && context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Grado actualizado correctamente'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Error al actualizar grado: $e'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    );
                                  },
                                  isVisible: (usuario) =>
                                      usuario.grado != 'Sin grado',
                                  getTooltip: (usuario) => usuario.grado ==
                                          'Sin grado'
                                      ? 'No se puede actualizar sin un grado asignado'
                                      : 'Actualizar Grado',
                                ),
                                GenericAction(
                                  icon: Icons.add_circle_outline,
                                  color: Colors.green,
                                  tooltip: 'Crear Grado',
                                  onPressed: (usuario) async {
                                    if (usuario.grado != 'Sin grado') return;
                                    await showCreateGradoModal(
                                      context,
                                      usuario.id,
                                      (grado, abrevGrado) async {
                                        try {
                                          final success =
                                              await viewModel.crearGrado(
                                            usuarioId: usuario.id,
                                            grado: grado,
                                            abrevGrado: abrevGrado,
                                          );

                                          if (success && context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Grado creado correctamente'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Error al crear grado: $e'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    );
                                  },
                                  isVisible: (usuario) =>
                                      usuario.grado == 'Sin grado',
                                  getTooltip: (usuario) => usuario.grado !=
                                          'Sin grado'
                                      ? 'El usuario ya tiene un grado asignado'
                                      : 'Crear Grado',
                                ),
                              ],
                            )
                          : CustomDataTable(
                              columns: [
                                ColumnConfig(
                                  label: 'Nombres',
                                  field: 'nombres',
                                  width: 200,
                                ),
                                ColumnConfig(
                                  label: 'Apellidos',
                                  field: 'apellidos',
                                  width: 250,
                                ),
                                ColumnConfig(
                                  label: 'Grado',
                                  field: 'grado',
                                  width: 150,
                                ),
                              ],
                              data: viewModel.usuarios
                                  .map((usuario) => {
                                        'nombres': usuario.nombres,
                                        'apellidos':
                                            '${usuario.apellidosPaterno} ${usuario.apellidosMaterno}',
                                        'grado': usuario.grado,
                                        'id': usuario.id,
                                      })
                                  .toList(),
                              actions: [
                                TableAction(
                                  icon: Icons.edit,
                                  color: const Color(0xFF1E3A8A),
                                  tooltip: 'Actualizar Grado',
                                  onPressed: (row) async {
                                    // Solo permitir actualizar si tiene un grado
                                    if (row['grado'] == 'Sin grado') {
                                      return null;
                                    }
                                    await showUpdateGradoModal(
                                      context,
                                      row['grado'],
                                      (grado, abrevGrado) async {
                                        try {
                                          final success =
                                              await viewModel.actualizarGrado(
                                            usuarioId: row['id'],
                                            grado: grado,
                                            abrevGrado: abrevGrado,
                                          );

                                          if (success && context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Grado actualizado correctamente'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Error al actualizar grado: $e'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    );
                                  },
                                  getTooltip: (row) {
                                    if (row['grado'] == 'Sin grado') {
                                      return 'No se puede actualizar sin un grado asignado';
                                    }
                                    return 'Actualizar Grado';
                                  },
                                  getColor: (row) {
                                    if (row['grado'] == 'Sin grado') {
                                      return Colors.grey;
                                    }
                                    return const Color(0xFF1E3A8A);
                                  },
                                ),
                                TableAction(
                                  icon: Icons.add_circle_outline,
                                  color: Colors.green,
                                  tooltip: 'Crear Grado',
                                  onPressed: (row) async {
                                    // Solo permitir crear si no tiene grado
                                    if (row['grado'] != 'Sin grado') {
                                      return null;
                                    }
                                    await showCreateGradoModal(
                                      context,
                                      row['id'],
                                      (grado, abrevGrado) async {
                                        try {
                                          final success =
                                              await viewModel.crearGrado(
                                            usuarioId: row['id'],
                                            grado: grado,
                                            abrevGrado: abrevGrado,
                                          );

                                          if (success && context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Grado creado correctamente'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Error al crear grado: $e'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    );
                                  },
                                  getTooltip: (row) {
                                    if (row['grado'] != 'Sin grado') {
                                      return 'El usuario ya tiene un grado asignado';
                                    }
                                    return 'Crear Grado';
                                  },
                                  getColor: (row) {
                                    if (row['grado'] != 'Sin grado') {
                                      return Colors.grey;
                                    }
                                    return Colors.green;
                                  },
                                ),
                              ],
                              title: 'Gestión de Grados',
                              primaryColor: const Color(0xFF1E3A8A),
                            ),
                    ),
                  ],
                ),
              ),
              if (viewModel.isLoading)
                Container(
                  color: Colors.white.withOpacity(0.8),
                  child: const CustomLoading(),
                ),
            ],
          );
        },
      ),
    );
  }
}
