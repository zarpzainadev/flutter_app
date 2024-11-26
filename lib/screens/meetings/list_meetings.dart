import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:flutter_web_android/components/table_flexible.dart';
import 'package:provider/provider.dart';
import 'list_meeting_viewmodel.dart';

class ListMeetings extends StatelessWidget {
  const ListMeetings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListMeetingViewModel(),
      child: _ListMeetingsContent(),
    );
  }
}

class _ListMeetingsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ListMeetingViewModel>(
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
                      data: viewModel.transformMeetingData(viewModel.meetings),
                      actions: viewModel.getActions(context),
                      title: 'Reuniones',
                      primaryColor: const Color(0xFF1E3A8A),
                      onCreateNew: () => viewModel.onCreateMeeting(context),
                      headerActions: [
                        ElevatedButton.icon(
                          onPressed: () => viewModel.onCreateMeeting(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Crear Reunión'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8), // Espaciado entre botones
                        ElevatedButton.icon(
                          onPressed: () =>
                              viewModel.listMeetings(forceRefresh: true),
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
                color: Colors.white
                    .withOpacity(0.8), // Fondo más claro y profesional
                child: const CustomLoading(), // Nuestro nuevo loader
              ),
          ],
        );
      },
    );
  }
}
