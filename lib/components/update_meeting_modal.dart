// create_meeting_modal.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<Map<String, dynamic>?> showUpdateMeetingModal(
    BuildContext context, Map<String, dynamic> meeting) {
  final formKey = GlobalKey<FormState>();
  final agendaController = TextEditingController(text: meeting['descripcion']);
  final lugarController = TextEditingController(text: meeting['lugar']);

  // Manejo mejorado de fechas
  DateTime selectedDate;
  try {
    selectedDate = DateTime.parse(meeting['fecha']);
  } catch (e) {
    try {
      final parts = meeting['fecha'].split('/');
      selectedDate = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (e) {
      selectedDate = DateTime.now();
      debugPrint('Error al analizar la fecha: ${meeting['fecha']}');
    }
  }

  String selectedEstado = 'Borrador';
  final primaryColor = const Color(0xFF1E3A8A);

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
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
                        labelText: 'Agenda de la reunión',
                        hintText: 'Ingrese la agenda',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                      maxLines: 3,
                      validator: (value) => value?.isEmpty ?? true
                          ? 'La agenda es requerida'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: lugarController,
                      decoration: InputDecoration(
                        labelText: 'Lugar de la reunión',
                        hintText: 'Ingrese el lugar',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'El lugar es requerido'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedEstado,
                      decoration: InputDecoration(
                        labelText: 'Estado de la reunión',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                      items: ['Borrador', 'Inactiva'].map((String estado) {
                        return DropdownMenuItem<String>(
                          value: estado,
                          child: Text(estado),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          selectedEstado = newValue;
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(selectedDate)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
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
                          selectedDate = picked;
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Cambiar Fecha'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(context, {
                          'id': meeting['id'],
                          'agenda': agendaController.text,
                          'lugar': lugarController.text,
                          'fecha': selectedDate,
                          'estado': selectedEstado,
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Actualizar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
