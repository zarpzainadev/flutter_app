import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/create_trabajo_modal.dart';
import 'package:flutter_web_android/components/update_trabajo_modal.dart';
import 'package:intl/intl.dart';
import 'package:flutter_web_android/components/table_flexible.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_android/screens/works/work_list_viewmodel.dart';

class WorkListScreen extends StatelessWidget {
  const WorkListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkViewModel()..listTrabajos(),
      child: Consumer<WorkViewModel>(
        builder: (context, viewModel, _) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => CreateTrabajoModal(
                            onCreate: (data) {
                              Navigator.pop(context);
                            },
                            viewModel: viewModel,
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Nuevo Trabajo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Funcionalidad pendiente
                      },
                      icon: const Icon(Icons.description),
                      label: const Text('Generar Reporte'),
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
                const SizedBox(height: 20),
                Expanded(
                  child: Stack(
                    children: [
                      CustomDataTable(
                        columns: const [
                          ColumnConfig(
                            label: 'Título',
                            field: 'titulo',
                            width: 200,
                          ),
                          ColumnConfig(
                            label: 'Descripción',
                            field: 'descripcion',
                            width: 300,
                          ),
                          ColumnConfig(
                            label: 'Fecha de Presentación',
                            field: 'fecha_presentacion',
                            width: 150,
                          ),
                          ColumnConfig(
                            // Nueva columna
                            label: 'Estado',
                            field: 'estado',
                            width: 100,
                          ),
                        ],
                        data: viewModel.trabajos
                            .map((trabajo) => {
                                  'id': trabajo.id,
                                  'titulo': trabajo.titulo,
                                  'descripcion': trabajo.descripcion,
                                  'fecha_presentacion': DateFormat('dd/MM/yyyy')
                                      .format(trabajo.fechaPresentacion),
                                  'estado':
                                      trabajo.estado, // Agregamos el estado
                                })
                            .toList(),
                        actions: [
                          TableAction(
                            icon: Icons.edit,
                            color: const Color(0xFF1E3A8A),
                            tooltip: 'Editar',
                            onPressed: (row) {
                              showDialog(
                                context: context,
                                builder: (context) => UpdateTrabajoModal(
                                  trabajo: row,
                                  onUpdate: (updatedData) async {
                                    await viewModel.updateTrabajo(
                                      trabajoId: row['id'],
                                      titulo: updatedData['titulo'],
                                      descripcion: updatedData['descripcion'],
                                      estado: updatedData['estado'],
                                      fechaPresentacion:
                                          updatedData['fecha_presentacion'],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                        title: 'Trabajos',
                        primaryColor: const Color(0xFF1E3A8A),
                      ),
                      if (viewModel.isLoading)
                        Container(
                          color: Colors.white.withOpacity(0.8),
                          child: const CustomLoading(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
