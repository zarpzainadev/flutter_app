import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/calendar_widget.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:flutter_web_android/components/upload_event_modal.dart';
import 'package:flutter_web_android/models/login_model.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/screens/calendar/calendar_viewmodel.dart';
import 'package:flutter_web_android/storage/storage_services.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatelessWidget {
  final List<MeetingListResponse> meetings;
  final Function(MeetingListResponse) onMeetingTap;
  const CalendarScreen({
    Key? key,
    required this.meetings,
    required this.onMeetingTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarViewModel()..initialize(),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Calendario de Reuniones',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Expanded(
              child: Consumer<CalendarViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return Container(
                      color: Colors.white.withOpacity(0.8),
                      child: const CustomLoading(),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: CalendarWidget(
                          meetings: viewModel.getMeetings,
                          onMeetingTap: (meeting) {
                            debugPrint(
                                'Reunión seleccionada: ID=${meeting.id}');
                          },
                          viewModel: viewModel,
                        ),
                      ),
                      
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
