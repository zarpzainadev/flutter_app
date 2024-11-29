import 'package:flutter/material.dart';
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(
              label: const Text('Título'),
              onSort: (_, __) => viewModel.toggleSort('titulo'),
            ),
            const DataColumn(
              label: Text('Descripción'),
            ),
            DataColumn(
              label: const Text('Fecha'),
              onSort: (_, __) => viewModel.toggleSort('fecha'),
            ),
          ],
          rows: viewModel.filteredWorks.map((work) {
            return DataRow(
              cells: [
                DataCell(Text(work.titulo)),
                DataCell(Text(work.descripcion)),
                DataCell(
                  Text(DateFormat('dd/MM/yyyy').format(work.fechaPresentacion)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
