import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/create_trabajo_modal.dart';
import 'package:flutter_web_android/components/generic_list_widget.dart';
import 'package:flutter_web_android/components/report_work_modal.dart';
import 'package:flutter_web_android/components/update_trabajo_modal.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
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
                      label: Text(
                        'Nuevo Trabajo',
                        // Ocultar texto en móvil
                        style: TextStyle(
                          fontSize: !kIsWeb ? 0 : 14,
                          height: !kIsWeb ? 0 : 1,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: !kIsWeb ? 12 : 16,
                          vertical: !kIsWeb ? 12 : 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => showReportWorkModal(
                        context,
                        (formato) => viewModel.generateWorksReport(formato),
                      ),
                      icon: const Icon(Icons.description),
                      label: Text(
                        'Generar Reporte',
                        // Ocultar texto en móvil
                        style: TextStyle(
                          fontSize: !kIsWeb ? 0 : 14,
                          height: !kIsWeb ? 0 : 1,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: !kIsWeb ? 12 : 16,
                          vertical: !kIsWeb ? 12 : 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: !kIsWeb
                      ? GenericListWidget<TrabajoListResponse>(
                          items: viewModel.trabajos,
                          isLoading: viewModel.isLoading,
                          emptyMessage: 'No hay trabajos registrados',
                          emptyIcon: Icons.work_off,
                          getTitle: (trabajo) => trabajo.titulo,
                          getSubtitle: (trabajo) => trabajo.estado,
                          getAvatarWidget: (trabajo) => CircleAvatar(
                            backgroundColor: _getStatusColor(trabajo.estado)
                                .withOpacity(0.1),
                            child: Icon(
                              _getStatusIcon(trabajo.estado),
                              color: _getStatusColor(trabajo.estado),
                              size: 20,
                            ),
                          ),
                          getChips: (trabajo) => [
                            ChipInfo(
                              icon: Icons.description,
                              label: trabajo.descripcion,
                              backgroundColor: Colors.blue.shade50,
                              textColor: Colors.blue.shade900,
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                              maxLines: 2,
                            ),
                            ChipInfo(
                              icon: Icons.calendar_today,
                              label: DateFormat('dd/MM/yyyy')
                                  .format(trabajo.fechaPresentacion),
                              backgroundColor: Colors.grey.shade100,
                              textColor: Colors.grey.shade700,
                            ),
                            ChipInfo(
                              icon: Icons.person,
                              label: trabajo.nombreUsuario,
                              backgroundColor: Colors.blue.shade50,
                              textColor: Colors.blue.shade900,
                            ),
                          ],
                          actions: [
                            GenericAction(
                              icon: Icons.edit,
                              color: const Color(0xFF1E3A8A),
                              tooltip: 'Editar',
                              onPressed: (trabajo) {
                                showDialog(
                                  context: context,
                                  builder: (context) => UpdateTrabajoModal(
                                    trabajo: {
                                      'id': trabajo.id,
                                      'titulo': trabajo.titulo,
                                      'descripcion': trabajo.descripcion,
                                      'estado': trabajo.estado,
                                      'fecha_presentacion':
                                          DateFormat('dd/MM/yyyy').format(
                                              trabajo.fechaPresentacion),
                                    },
                                    onUpdate: (updatedData) async {
                                      await viewModel.updateTrabajo(
                                        trabajoId: trabajo.id,
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
                        )
                      : CustomDataTable(
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
                                    'fecha_presentacion':
                                        DateFormat('dd/MM/yyyy')
                                            .format(trabajo.fechaPresentacion),
                                    'estado': trabajo.estado,
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
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'activo':
        return Colors.green;
      case 'inactivo':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String estado) {
    switch (estado.toLowerCase()) {
      case 'activo':
        return Icons.check_circle;
      case 'inactivo':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}
