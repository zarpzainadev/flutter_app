// create_meeting_modal.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// En update_meeting_modal.dart

// En update_meeting_modal.dart

Future<Map<String, dynamic>?> showUpdateMeetingModal(
    BuildContext context, Map<String, dynamic> meeting) {
  final formKey = GlobalKey<FormState>();
  final agendaController = TextEditingController(text: meeting['descripcion']);
  final lugarController = TextEditingController(text: meeting['lugar']);

  DateTime selectedDateTime;
  try {
    if (meeting['fecha'] is String) {
      final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
      selectedDateTime = formatter.parse(meeting['fecha']);
    } else {
      selectedDateTime = DateTime.now();
    }
  } catch (e) {
    selectedDateTime = DateTime.now();
    debugPrint('Error al analizar la fecha/hora: ${meeting['fecha']} - $e');
  }

  TimeOfDay selectedTime = TimeOfDay(
    hour: selectedDateTime.hour,
    minute: selectedDateTime.minute,
  );

  String selectedEstado = meeting['estado'];
  final primaryColor = const Color(0xFF1E3A8A);

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Actualizar Reunión',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: agendaController,
                            decoration: InputDecoration(
                              labelText: 'Agenda',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: primaryColor, width: 2),
                              ),
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese la agenda';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: lugarController,
                            decoration: InputDecoration(
                              labelText: 'Lugar',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: primaryColor, width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el lugar';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: selectedEstado,
                            decoration: InputDecoration(
                              labelText: 'Estado',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: primaryColor, width: 2),
                              ),
                            ),
                            items: ['Borrador', 'Publicada', 'Inactiva']
                                .map((String estado) {
                              return DropdownMenuItem<String>(
                                value: estado,
                                child: Text(estado),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedEstado = newValue;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Fecha y hora seleccionada:',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${DateFormat('dd/MM/yyyy').format(selectedDateTime)} ${selectedTime.format(context)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final now = DateTime.now();
                                    final DateTime? picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate:
                                          selectedDateTime.isBefore(now)
                                              ? now
                                              : selectedDateTime,
                                      firstDate: now,
                                      lastDate: DateTime(2101),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: primaryColor,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        selectedDateTime = DateTime(
                                          picked.year,
                                          picked.month,
                                          picked.day,
                                          selectedTime.hour,
                                          selectedTime.minute,
                                        );
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_today),
                                  label: const Text('Cambiar Fecha'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    final TimeOfDay? picked =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: selectedTime,
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: primaryColor,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (picked != null) {
                                      setState(() {
                                        selectedTime = picked;
                                        selectedDateTime = DateTime(
                                          selectedDateTime.year,
                                          selectedDateTime.month,
                                          selectedDateTime.day,
                                          picked.hour,
                                          picked.minute,
                                        );
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.access_time),
                                  label: const Text('Cambiar Hora'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Cancelar',
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    Navigator.pop(context, {
                                      'id': meeting['id'],
                                      'agenda': agendaController.text,
                                      'lugar': lugarController.text,
                                      'fecha': selectedDateTime,
                                      'estado': selectedEstado,
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text('Actualizar'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
