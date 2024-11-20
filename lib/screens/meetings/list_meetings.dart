// list_meetings.dart
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/table_flexible.dart';
import 'package:provider/provider.dart';
import 'list_meeting_viewmodel.dart';

class ListMeetings extends StatelessWidget {
  const ListMeetings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListMeetingViewModel(),
      child: Consumer<ListMeetingViewModel>(
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
                        data:
                            viewModel.transformMeetingData(viewModel.meetings),
                        actions: viewModel.getActions(context),
                        title: 'Reuniones',
                        primaryColor: const Color(0xFF1E3A8A),
                        onCreateNew: () => viewModel.onCreateMeeting(context),
                        headerActions: [
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
