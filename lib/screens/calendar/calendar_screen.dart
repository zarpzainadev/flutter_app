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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FutureBuilder<Token?>(
                          future: StorageService.getToken(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return const SizedBox.shrink();

                            // Decodificar el token para obtener el rol_id
                            final token = snapshot.data!.accessToken;
                            final parts = token.split('.');
                            if (parts.length != 3)
                              return const SizedBox.shrink();

                            final payload = json.decode(
                              utf8.decode(base64Url
                                  .decode(base64Url.normalize(parts[1]))),
                            );

                            final rolId = payload['rol_id'] as int;

                            // Solo mostrar para roles 2 (Admin) y 3 (Secretario)
                            if (rolId != 2 && rolId != 3)
                              return const SizedBox.shrink();

                            return Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final result =
                                      await showUploadEventModal(context);
                                  if (result != null) {
                                    final success =
                                        await viewModel.uploadFotoInvitacion(
                                      result['fileBytes'],
                                      result['fileName'],
                                      result['mimeType'],
                                    );
                                    if (success && context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Imagen subida correctamente'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.upload),
                                label: const Text('Subir Invitación'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E3A8A),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            );
                          },
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
