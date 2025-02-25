import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:flutter_web_android/components/report_usuario_modal.dart';
import 'package:flutter_web_android/components/table_flexible.dart';
import 'package:flutter_web_android/components/user_list_widget.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/screens/Users/list_user_viewmodel.dart';
import 'package:provider/provider.dart';

class ListUserScreen extends StatelessWidget {
  const ListUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListUserViewModel()..initialize(),
      child: Consumer<ListUserViewModel>(
        builder: (context, viewModel, child) {
          return Material(
            child: Stack(
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
                      const SizedBox(height: 16),
                      Expanded(
                        child: !kIsWeb
                            ? UserListWidget(
                                users: viewModel.users,
                                isLoading: viewModel.isLoading,
                                onUserTap: (user) => viewModel.onViewDetails(
                                  context,
                                  {'id': user.id},
                                ),
                                actions: [
                                  UserAction(
                                    icon: Icons.visibility,
                                    color: const Color(0xFF6B7280),
                                    tooltip: 'Ver Detalles',
                                    onPressed: (user) =>
                                        viewModel.onViewDetails(
                                      context,
                                      {'id': user.id},
                                    ),
                                  ),
                                  UserAction(
                                    icon: Icons.edit,
                                    color: const Color(0xFF1E40AF),
                                    tooltip: 'Editar',
                                    onPressed: (user) => viewModel.onEdit(
                                      context,
                                      {'id': user.id},
                                    ),
                                  ),
                                  UserAction(
                                    icon: Icons.loop,
                                    color: Colors.orange,
                                    tooltip: 'Cambiar Estado',
                                    onPressed: (user) =>
                                        viewModel.showChangeEstadoModal(
                                      context,
                                      {
                                        'id': user.id,
                                        'estado_usuario_nombre':
                                            user.estado_usuario_nombre,
                                      },
                                    ),
                                  ),
                                  UserAction(
    icon: Icons.password,
    color: Colors.purple,
    tooltip: 'Cambiar Contraseña',
    onPressed: (user) => viewModel.showChangePasswordModal(
      context,
      {'id': user.id},
    ),
  ),
                                ],
                              )
                            : CustomDataTable(
                                columns: viewModel.columns,
                                data: viewModel
                                    .transformUserData(viewModel.users),
                                actions: viewModel.getActions(context),
                                title: 'Usuarios',
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
            ),
          );
        },
      ),
    );
  }
}
