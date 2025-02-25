import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:flutter_web_android/components/generic_list_widget.dart';
import 'package:flutter_web_android/components/report_meeting_modal.dart';
import 'package:flutter_web_android/components/table_flexible.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:intl/intl.dart';
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

Color _getStatusColor(String estado) {
  switch (estado) {
    case 'Publicada':
      return Colors.green;
    case 'Inactiva':
      return Colors.red;
    default:
      return Colors.orange;
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
                    child: !kIsWeb
                        ? GenericListWidget<MeetingListResponse>(
                            items: viewModel.meetings,
                            isLoading: viewModel.isLoading,
                            emptyMessage: 'No hay reuniones registradas',
                            emptyIcon: Icons.event_busy,
                            getTitle: (meeting) => meeting.lugar,
                            getSubtitle: (meeting) =>
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(meeting.fecha),
                            getAvatarWidget: (meeting) =>
                                _getLeadingIcon(meeting.estado),
                            getChips: (meeting) => [
                              ChipInfo(
  icon: Icons.description,
  label: (meeting.agenda['ops'] as List)
      .map((op) => op['insert'])
      .join(''), // Extrae solo el texto plano
  backgroundColor: Colors.blue.shade50,
  textColor: Colors.blue.shade900,
  maxWidth: MediaQuery.of(context).size.width * 0.7,
  maxLines: 2,
),
                              ChipInfo(
                                icon: Icons.info_outline,
                                label: meeting.estado,
                                backgroundColor: _getStatusColor(meeting.estado)
                                    .withOpacity(0.1),
                                textColor: _getStatusColor(meeting.estado),
                              ),
                            ],
                            actions: [
                              GenericAction(
  icon: Icons.edit,
  color: const Color(0xFF1E40AF),
  tooltip: 'Actualizar Reunión',
  onPressed: (meeting) => viewModel.onUpdateMeeting(
    context,
    {
      'id': meeting.id,
      'titulo': meeting.cabecera_invitacion,
      'descripcion': meeting.agenda, // Convertir el Map a string JSON
      'fecha': meeting.fecha,
      'lugar': meeting.lugar,
      'estado': meeting.estado,
    },
  ),
),
                              GenericAction(
                                icon: Icons.publish,
                                color: Colors.green,
                                tooltip: 'Publicar Reunión',
                                onPressed: (meeting) => viewModel.onPublish(
                                  context,
                                  {
                                    'id': meeting.id,
                                    'estado': meeting.estado,
                                  },
                                ),
                                isVisible: (meeting) =>
                                    meeting.estado != 'Publicada' &&
                                    meeting.estado != 'Inactiva',
                                getColor: (meeting) {
                                  switch (meeting.estado) {
                                    case 'Publicada':
                                      return Colors.grey;
                                    case 'Inactiva':
                                      return Colors.red.shade300;
                                    default:
                                      return Colors.green;
                                  }
                                },
                                getTooltip: (meeting) {
                                  switch (meeting.estado) {
                                    case 'Publicada':
                                      return 'Ya está publicada';
                                    case 'Inactiva':
                                      return 'No se puede publicar una reunión inactiva';
                                    default:
                                      return 'Publicar Reunión';
                                  }
                                },
                              ),
                              GenericAction(
                                icon: Icons.description,
                                color: Colors.orange,
                                tooltip: 'Registrar Acta',
                                onPressed: (meeting) =>
                                    viewModel.onRegisterActa(
                                  context,
                                  {
                                    'id': meeting.id,
                                    'estado': meeting.estado,
                                  },
                                ),
                              ),
                              GenericAction(
                                icon: Icons.people,
                                color: Colors.blue,
                                tooltip: 'Gestionar Asistencia',
                                onPressed: (meeting) =>
                                    viewModel.onManageAssistance(
                                  context,
                                  {
                                    'id': meeting.id,
                                    'estado': meeting.estado,
                                    'tiene_asistencia':
                                        meeting.tiene_asistencia,
                                  },
                                ),
                                getTooltip: (meeting) => meeting.estado !=
                                        'Publicada'
                                    ? 'Solo disponible para reuniones publicadas'
                                    : 'Gestionar Asistencia',
                                getColor: (meeting) =>
                                    meeting.estado != 'Publicada'
                                        ? Colors.grey
                                        : Colors.blue,
                              ),
                            ],
                          )
                        : CustomDataTable(
                            columns: viewModel.columns,
                            data: viewModel
                                .transformMeetingData(viewModel.meetings),
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

  Widget _getLeadingIcon(String estado) {
    IconData icon;
    Color backgroundColor;
    Color iconColor;

    switch (estado) {
      case 'Publicada':
        icon = Icons.event_available;
        backgroundColor = Colors.green.shade50;
        iconColor = Colors.green.shade700;
        break;
      case 'Inactiva':
        icon = Icons.event_busy;
        backgroundColor = Colors.red.shade50;
        iconColor = Colors.red.shade700;
        break;
      default: // Borrador
        icon = Icons.event_note;
        backgroundColor = Colors.orange.shade50;
        iconColor = Colors.orange.shade700;
        break;
    }

    return CircleAvatar(
      backgroundColor: backgroundColor,
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}
