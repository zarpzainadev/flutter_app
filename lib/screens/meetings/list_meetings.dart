import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:flutter_web_android/components/report_meeting_modal.dart';
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
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen =
                          MediaQuery.of(context).size.width < 600;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ElevatedButton(
                                onPressed: () =>
                                    viewModel.onCreateMeeting(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E3A8A),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 8 : 16,
                                    vertical: isSmallScreen ? 8 : 12,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.add, size: 20),
                                    if (!isSmallScreen) ...[
                                      const SizedBox(width: 8),
                                      const Text('Crear Reunión'),
                                    ],
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    viewModel.listMeetings(forceRefresh: true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E3A8A),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 8 : 16,
                                    vertical: isSmallScreen ? 8 : 12,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.refresh, size: 20),
                                    if (!isSmallScreen) ...[
                                      const SizedBox(width: 8),
                                      const Text('Actualizar'),
                                    ],
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => showReportMeetingModal(
                                  context,
                                  (formato) =>
                                      viewModel.generateMeetingsReport(formato),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E3A8A),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 8 : 16,
                                    vertical: isSmallScreen ? 8 : 12,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.download, size: 20),
                                    if (!isSmallScreen) ...[
                                      const SizedBox(width: 8),
                                      const Text('Descargar Reporte'),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: CustomDataTable(
                      columns: viewModel.columns,
                      data: viewModel.transformMeetingData(viewModel.meetings),
                      actions: viewModel.getActions(context),
                      title: 'Reuniones',
                      primaryColor: const Color(0xFF1E3A8A),
                    ),
                  ),
                ],
              ),
            ),
            if (viewModel.isLoading) const CustomLoading(),
          ],
        );
      },
    );
  }
}
