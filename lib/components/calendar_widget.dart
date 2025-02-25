import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_web_android/models/login_model.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/models/modulo_user_meetings.dart';
import 'package:flutter_web_android/screens/calendar/calendar_viewmodel.dart';
import 'package:flutter_web_android/storage/storage_services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class CalendarWidget extends StatefulWidget {
  final List<MeetingListResponse> meetings; // Cambiar tipo
  final Function(MeetingListResponse) onMeetingTap; // Cambiar tipo
  final CalendarViewModel viewModel;

  const CalendarWidget({
    Key? key,
    required this.meetings,
    required this.onMeetingTap,
    required this.viewModel,
  }) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<List<MeetingListResponse>> _selectedEvents =
      ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null);
    _selectedDay = _focusedDay;
    _selectedEvents.value = _getEventsForDay(_selectedDay!);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  List<MeetingListResponse> _getEventsForDay(DateTime day) {
    return widget.meetings.where((meeting) {
      return isSameDay(meeting.fecha, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
  final isWeb = kIsWeb;
  final now = DateTime.now();

  // Modificar el filtro para manejar correctamente las horas
  final sortedMeetings = List<MeetingListResponse>.from(widget.meetings)
    .where((meeting) {
      if (meeting.estado != 'Publicada') return false;
      
      // Comparar fechas incluyendo la hora
      final meetingDateTime = DateTime(
        meeting.fecha.year,
        meeting.fecha.month,
        meeting.fecha.day,
        meeting.fecha.hour,
        meeting.fecha.minute,
      );
      
      final currentDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      );

      // Si la reunión es del mismo día, verificar la hora
      if (isSameDay(meeting.fecha, now)) {
        return meetingDateTime.isAfter(currentDateTime);
      }
      
      // Para otros días, mostrar solo días futuros
      return meeting.fecha.isAfter(now);
    })
    .toList()
    ..sort((a, b) {
      final diffA = a.fecha.difference(now).abs();
      final diffB = b.fecha.difference(now).abs();
      return diffA.compareTo(diffB);
    });

    // Widget de la lista de eventos
    Widget eventsList = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
          ),
          Expanded(
            child: sortedMeetings.isEmpty
                ? Center(
                    child: Text(
                      'No hay reuniones programadas',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
  controller: _scrollController,
  itemCount: sortedMeetings.length,
  itemBuilder: (context, index) {
    final meeting = sortedMeetings[index];
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
  padding: const EdgeInsets.all(8.0),
  child: Text(
    DateFormat('EEEE d MMMM, yyyy', 'es_ES')
        .format(meeting.fecha)
        .capitalize(),
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  ),
),
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: index == 0, // Esto hará que la primera reunión esté expandida
                leading: Container(
                  width: 4,
                  height: 40,
                  color: DateTime.now().isAfter(meeting.fecha)
                      ? Colors.red.shade700
                      : Colors.blue.shade700,
                ),
                title: Text(
                  meeting.cabecera_invitacion,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                                  subtitle: Text(
                                    DateFormat('HH:mm').format(meeting.fecha),
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.grey.shade200,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.calendar_today,
                                                  size: 16,
                                                  color: Colors.grey.shade700),
                                              const SizedBox(width: 8),
                                              Text(
                                                DateFormat('dd/MM/yyyy HH:mm',
                                                        'es_ES')
                                                    .format(meeting.fecha),
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on,
                                                  size: 16,
                                                  color: Colors.grey.shade700),
                                              const SizedBox(width: 8),
                                              Text(
                                                meeting.lugar,
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          
                                          const SizedBox(height: 4),
                                          Container(
  height: 100,
  child: QuillEditor(
    configurations: QuillEditorConfigurations(
      controller: QuillController(
        document: Document.fromJson(meeting.agenda['ops']), // Acceder a la lista 'ops'
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true, // Mover readOnly aquí
      ),
      padding: const EdgeInsets.all(0),
      scrollable: true,
      autoFocus: false,
      expands: false,
    ),
    focusNode: FocusNode(),
    scrollController: ScrollController(),
  ),
),
                                          if (meeting.tiene_asistencia) ...[
                                            const SizedBox(height: 16),
                                            FutureBuilder<Token?>(
                                              future: StorageService.getToken(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData)
                                                  return const SizedBox
                                                      .shrink();

                                                // Decodificar el token para obtener el rol_id
                                                final token =
                                                    snapshot.data!.accessToken;
                                                final parts = token.split('.');
                                                if (parts.length != 3)
                                                  return const SizedBox
                                                      .shrink();

                                                final payload = json.decode(
                                                  utf8.decode(base64Url.decode(
                                                      base64Url.normalize(
                                                          parts[1]))),
                                                );

                                                final rolId =
                                                    payload['rol_id'] as int;

                                                // No mostrar para roles 1 (Usuario) y 4 (Tesorero)
                                                if (rolId == 1 || rolId == 4)
                                                  return const SizedBox
                                                      .shrink();

                                                return PopupMenuButton<String>(
                                                  onSelected: (formato) async {
                                                    await widget.viewModel
                                                        .generateAttendanceReport(
                                                      formato,
                                                      reunionId: meeting.id,
                                                    );
                                                  },
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.download,
                                                          color: Color(
                                                              0xFF1E3A8A)),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        'Descargar reporte de asistencia',
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xFF1E3A8A),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  itemBuilder: (context) => [
                                                    const PopupMenuItem(
                                                      value: 'excel',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                              Icons.table_chart,
                                                              color: Color(
                                                                  0xFF1E3A8A)),
                                                          SizedBox(width: 8),
                                                          Text('Excel'),
                                                        ],
                                                      ),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: 'pdf',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .picture_as_pdf,
                                                              color: Color(
                                                                  0xFF1E3A8A)),
                                                          SizedBox(width: 8),
                                                          Text('PDF'),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );

    // Widget del calendario
    Widget calendarWidget = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      margin: const EdgeInsets.all(8),
      child: TableCalendar<MeetingListResponse>(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        locale: 'es_ES',
        eventLoader: _getEventsForDay,
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            if (events.isNotEmpty) {
              return Positioned(
                bottom: 1,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getMarkerColor(events.first.fecha),
                  ),
                ),
              );
            }
            return null;
          },
        ),
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: const TextStyle(color: Colors.red),
          holidayTextStyle: const TextStyle(color: Colors.red),
          todayDecoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 1.5),
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.blue.shade400,
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: Colors.blue.shade700,
            shape: BoxShape.circle,
          ),
          markerSize: 6,
          markersMaxCount: 4,
          canMarkersOverflow: true,
        ),
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
          formatButtonVisible: false,
          titleCentered: true,
          headerPadding: const EdgeInsets.symmetric(vertical: 12),
          leftChevronIcon: Icon(Icons.chevron_left, color: Colors.grey[600]),
          rightChevronIcon: Icon(Icons.chevron_right, color: Colors.grey[600]),
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _selectedEvents.value = _getEventsForDay(selectedDay);
          });
        },
      ),
    );

    // Retornar layout según la plataforma
    if (isWeb) {
  return Center( // Centramos el contenido
    child: Container(
      constraints: const BoxConstraints(
        maxWidth: 1200, // Limitamos el ancho máximo
        minWidth: 400, // Ancho mínimo para mantener legibilidad
      ),
      padding: const EdgeInsets.all(16),
      child: eventsList, // Mantenemos la lista de eventos
    ),
  );
} else {
  // Versión móvil sin cambios
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          height: 500,
          child: eventsList,
        ),
      ],
    ),
  );
}
  }

  Color _getMarkerColor(DateTime fecha) {
    return DateTime.now().isAfter(fecha)
        ? Colors.red.shade700
        : Colors.blue.shade700;
  }
}
