import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_user_meetings.dart';
import 'package:flutter_web_android/screens/calendar/calendar_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final List<MeetingModel> meetings;
  final Function(MeetingModel) onMeetingTap;
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
  final ValueNotifier<List<MeetingModel>> _selectedEvents = ValueNotifier([]);

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

  List<MeetingModel> _getEventsForDay(DateTime day) {
    return widget.meetings.where((meeting) {
      return isSameDay(meeting.fecha, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Detectar si estamos en web
    final isWeb = kIsWeb;

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
            child: ListView.builder(
              controller: _scrollController,
              itemCount: 365,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final events = _getEventsForDay(date);

                if (events.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DateFormat('EEEE d MMMM, yyyy', 'es_ES').format(date),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      ...events.map((event) => Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                leading: Container(
                                  width: 4,
                                  height: 40,
                                  color: Colors.blue.shade700,
                                ),
                                title: Text(
                                  event.lugar,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat('HH:mm').format(event.fecha),
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
                                                  .format(event.fecha),
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
                                              event.lugar,
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Agenda:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          event.agenda,
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onExpansionChanged: (isExpanded) {
                                  if (isExpanded) {
                                    widget.onMeetingTap(event);
                                  }
                                },
                              ),
                            ),
                          )),
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
      child: TableCalendar<MeetingModel>(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        locale: 'es_ES',
        eventLoader: _getEventsForDay,
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
      return Row(
        children: [
          Expanded(flex: 3, child: eventsList),
          Expanded(flex: 7, child: calendarWidget),
        ],
      );
    } else {
      // En móvil, solo mostrar la lista de eventos
      return eventsList;
    }
  }
}
