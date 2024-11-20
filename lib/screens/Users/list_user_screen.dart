import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/report_usuario_modal.dart';
import 'package:flutter_web_android/components/table_flexible.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/screens/Users/list_user_viewmodel.dart';
import 'package:provider/provider.dart';

class ListUserScreen extends StatelessWidget {
  const ListUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListUserViewModel(),
      child: Consumer<ListUserViewModel>(
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
                    Expanded(
                      child: CustomDataTable(
                        columns: viewModel.columns,
                        data: viewModel.transformUserData(viewModel.users),
                        actions: viewModel.getActions(context),
                        title: 'Usuarios',
                        primaryColor: const Color(0xFF1E3A8A),
                        headerActions: [
                          ElevatedButton.icon(
                            onPressed: () {
                              showReportUsuarioModal(
                                context,
                                (estado, formato) => viewModel.generateReport(
                                  estadoNombre: estado,
                                  formato: formato,
                                  title: "Reporte de Usuarios $estado",
                                ),
                              );
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
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () =>
                                viewModel.listUsers(forceRefresh: true),
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
                    ),
                  ],
                ),
              ),
              if (viewModel.isLoading)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
