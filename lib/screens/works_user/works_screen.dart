import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/generic_list_widget.dart';
import 'package:flutter_web_android/models/modulo_user_meetings.dart';
import 'package:flutter_web_android/screens/works_user/works_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:intl/intl.dart';

class WorksScreen extends StatelessWidget {
  const WorksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorksViewModel(),
      child: const _WorksContent(),
    );
  }
}

class _WorksContent extends StatelessWidget {
  const _WorksContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          Expanded(
            child: Consumer<WorksViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.isLoading) {
                  return const Center(child: CustomLoading());
                }

                if (viewModel.errorMessage != null) {
                  return Center(
                    child: Text(
                      viewModel.errorMessage!,
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  );
                }

                if (viewModel.filteredWorks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.work_off_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay trabajos registrados',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Los trabajos asignados aparecerán aquí',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return _buildWorksTable(context, viewModel);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<WorksViewModel>(
      builder: (context, viewModel, _) => Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar trabajo...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: viewModel.updateSearchQuery,
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () => viewModel.loadWorks(),
            icon: const Icon(Icons.refresh),
            label: const Text('Actualizar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorksTable(BuildContext context, WorksViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.work_outline, // o puedes usar Icons.assignment_outlined
                color: const Color(0xFF1E3A8A),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Mis Trabajos',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: !kIsWeb
                ? GenericListWidget<UserWork>(
                    items: viewModel.filteredWorks,
                    isLoading: viewModel.isLoading,
                    emptyMessage: 'No hay trabajos registrados',
                    emptyIcon: Icons.work_off_outlined,
                    getTitle: (trabajo) => trabajo.titulo,
                    getSubtitle: (trabajo) => '', // Dejamos el subtítulo vacío
                    getAvatarWidget: (trabajo) => CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      child: Icon(
                        Icons.article_outlined, // Icono para cada trabajo
                        color: Colors.blue.shade900,
                        size: 20,
                      ),
                    ),
                    getChips: (trabajo) => [
                      ChipInfo(
                        icon: Icons.calendar_today,
                        label:
                            'Fecha de presentación: ${DateFormat('dd/MM/yyyy').format(trabajo.fechaPresentacion)}',
                        backgroundColor: Colors.grey.shade100,
                        textColor: Colors.grey.shade700,
                      ),
                      ChipInfo(
                        icon: Icons.description,
                        label: trabajo.descripcion,
                        backgroundColor: Colors.blue.shade50,
                        textColor: Colors.blue.shade900,
                        maxWidth: MediaQuery.of(context).size.width * 0.85,
                        maxLines: 3,
                      ),
                    ],
                    actions: const [],
                  )
                : Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Scrollbar(
                        thumbVisibility: true,
                        scrollbarOrientation: ScrollbarOrientation.bottom,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width - 80,
                            ),
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(
                                  const Color(0xFF1E3A8A).withOpacity(0.1)),
                              columnSpacing: 40,
                              horizontalMargin: 24,
                              sortColumnIndex: viewModel.sortBy == 'titulo'
                                  ? 0
                                  : viewModel.sortBy == 'fecha'
                                      ? 2
                                      : null,
                              sortAscending: viewModel.sortAscending,
                              columns: [
                                DataColumn(
                                  label: Container(
                                    width: 300,
                                    child: Text(
                                      'Título',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1E3A8A),
                                      ),
                                    ),
                                  ),
                                  onSort: (_, __) =>
                                      viewModel.toggleSort('titulo'),
                                ),
                                DataColumn(
                                  label: Container(
                                    width: 400,
                                    child: Text(
                                      'Descripción',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1E3A8A),
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Container(
                                    width: 150,
                                    child: Text(
                                      'Fecha',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1E3A8A),
                                      ),
                                    ),
                                  ),
                                  onSort: (_, __) =>
                                      viewModel.toggleSort('fecha'),
                                ),
                              ],
                              rows: viewModel.filteredWorks.map((work) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 300),
                                        child: Text(
                                          work.titulo,
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 400),
                                        child: Text(
                                          work.descripcion,
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        DateFormat('dd/MM/yyyy')
                                            .format(work.fechaPresentacion),
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              '${viewModel.filteredWorks.length} registros',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
