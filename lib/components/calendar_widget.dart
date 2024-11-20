import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_user_meetings.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final List<MeetingModel> meetings;
  final Function(MeetingModel) onMeetingTap;

  CalendarWidget({required this.meetings, required this.onMeetingTap});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  OverlayEntry? _overlayEntry;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  List<MeetingModel> _getEventsForDay(DateTime day) {
    debugPrint('Buscando reuniones para el día: ${day.toString()}');
    final events = widget.meetings.where((meeting) {
      final esMismoDia = meeting.fecha.year == day.year &&
          meeting.fecha.month == day.month &&
          meeting.fecha.day == day.day;

      if (esMismoDia) {
        debugPrint(
            'Encontrada reunión para el día ${day.toString()}: ID=${meeting.id}');
      }
      return esMismoDia;
    }).toList();

    debugPrint('Total de reuniones encontradas para el día: ${events.length}');
    return events;
  }

  void _showEventDetails(
      BuildContext context, Offset position, MeetingModel meeting) {
    _overlayEntry?.remove();

    final size = MediaQuery.of(context).size;
    final overlayWidth = 250.0;

    // Ajustar posición para que no se salga de la pantalla
    double left = position.dx - (overlayWidth / 2);
    double top = position.dy + 20;

    // Ajustes para mantener el overlay dentro de la pantalla
    if (left < 0) left = 10;
    if (left + overlayWidth > size.width) left = size.width - overlayWidth - 10;
    if (top + 200 > size.height) top = position.dy - 220;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Background gesture detector
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
                setState(() {
                  _selectedDay = null;
                });
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Overlay content
          Positioned(
            left: left,
            top: top,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: GestureDetector(
                onTap: () {}, // Prevent tap from reaching background
                child: Container(
                  width: overlayWidth,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF1E3A8A).withOpacity(0.1)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy', 'es_ES').format(meeting.fecha),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: Color(0xFF1E3A8A)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(meeting.lugar)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.description,
                              size: 16, color: Color(0xFF1E3A8A)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(meeting.agenda)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final calendarWidth = kIsWeb ? screenWidth * 0.9 : screenWidth * 0.95;
    final calendarHeight = kIsWeb ? screenHeight * 0.8 : screenHeight * 0.7;

    return Container(
      color: const Color(0xFFF0F2F5),
      padding: EdgeInsets.all(kIsWeb ? 32 : 8),
      child: Center(
        child: Container(
          width: calendarWidth,
          height: calendarHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: TableCalendar<MeetingModel>(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            locale: 'es_ES',
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekHeight: 40,
            rowHeight: 52,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 24,
                color: Color(0xFF1E3A8A),
                fontWeight: FontWeight.bold,
              ),
              headerPadding: EdgeInsets.symmetric(vertical: 20),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: Color(0xFF1E3A8A),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              weekendStyle: TextStyle(
                color: Color(0xFF1E3A8A),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              isTodayHighlighted: true,
              defaultTextStyle: TextStyle(
                fontSize: kIsWeb ? 24 : 16,
                fontWeight: FontWeight.w500,
              ),
              weekendTextStyle: TextStyle(
                color: const Color(0xFF1E3A8A),
                fontSize: kIsWeb ? 24 : 16,
                fontWeight: FontWeight.w500,
              ),
              holidayTextStyle: TextStyle(
                color: const Color(0xFF1E3A8A),
                fontSize: kIsWeb ? 24 : 16,
              ),
              todayDecoration: BoxDecoration(
                color: const Color(0xFF1E3A8A).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Color(0xFF1E3A8A),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF1E3A8A),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: Colors.white,
                fontSize: kIsWeb ? 20 : 16,
              ),
              cellPadding: EdgeInsets.all(12),
              cellMargin: EdgeInsets.all(6),
            ),
            selectedDayPredicate: (day) {
              final hasEvents = _getEventsForDay(day).isNotEmpty;
              return _selectedDay != null &&
                  isSameDay(_selectedDay!, day) &&
                  hasEvents;
            },
            onDaySelected: (selectedDay, focusedDay) {
              final events = _getEventsForDay(selectedDay);
              if (events.isNotEmpty) {
                setState(() {
                  _focusedDay = focusedDay;
                  _selectedDay = selectedDay;
                });

                // Obtener la posición del día seleccionado
                final RenderBox? box = context.findRenderObject() as RenderBox?;
                if (box != null) {
                  final position = box.localToGlobal(Offset.zero);
                  _showEventDetails(
                    context,
                    position + Offset(box.size.width / 2, box.size.height / 2),
                    events.first,
                  );
                }
              } else {
                setState(() {
                  _selectedDay = null;
                });
                _overlayEntry?.remove();
                _overlayEntry = null;
              }
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final hasEvents = _getEventsForDay(day).isNotEmpty;
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: hasEvents
                      ? BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF1E3A8A),
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        )
                      : null,
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
