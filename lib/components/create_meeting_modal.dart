import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';

Future<Map<String, dynamic>?> showCreateMeetingModal(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final lugarController = TextEditingController();
  final agendaController = QuillController(
    document: Document(), 
    selection: const TextSelection.collapsed(offset: 0),
    readOnly: false,
  );

  DateTime selectedDateTime = DateTime.now().copyWith(hour: 9, minute: 0);
  TimeOfDay selectedTime = TimeOfDay(hour: 9, minute: 0);
  final dateTimeNotifier = ValueNotifier<DateTime>(selectedDateTime);
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crear Nueva Reunión',
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
                        controller: tituloController,
                        decoration: InputDecoration(
                          labelText: 'Título',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese un título';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            QuillToolbar.simple(
                              configurations: QuillSimpleToolbarConfigurations(
                                controller: agendaController,
                                showFontFamily: false,
                                showSearchButton: false,
                                showRedo: false,
                                showUndo: false,
                                multiRowsDisplay: false,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: QuillEditor(
                                  configurations: QuillEditorConfigurations(
                                    controller: agendaController,
                                    
                                    padding: const EdgeInsets.all(0),
                                    scrollable: true,
                                    autoFocus: false,
                                    expands: false,
                                    placeholder: 'Escribe la agenda aquí...',
                                  ),
                                  focusNode: FocusNode(),
                                  scrollController: ScrollController(),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el lugar';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ValueListenableBuilder<DateTime>(
                        valueListenable: dateTimeNotifier,
                        builder: (context, dateTime, _) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fecha y hora seleccionada:',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy HH:mm').format(dateTime),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDateTime,
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
                                  selectedDateTime = DateTime(
                                    picked.year,
                                    picked.month,
                                    picked.day,
                                    selectedTime.hour,
                                    selectedTime.minute,
                                  );
                                  dateTimeNotifier.value = selectedDateTime;
                                }
                              },
                              icon: const Icon(Icons.calendar_today),
                              label: const Text('Seleccionar Fecha'),
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
                                final TimeOfDay? picked = await showTimePicker(
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
                                  selectedTime = picked;
                                  selectedDateTime = DateTime(
                                    selectedDateTime.year,
                                    selectedDateTime.month,
                                    selectedDateTime.day,
                                    picked.hour,
                                    picked.minute,
                                  );
                                  dateTimeNotifier.value = selectedDateTime;
                                }
                              },
                              icon: const Icon(Icons.access_time),
                              label: const Text('Seleccionar Hora'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
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
      final agendaData = agendaController.document.toDelta().toJson();
      debugPrint('=== DEBUG CREATE MEETING ===');
      debugPrint('Contenido del editor (raw):');
      debugPrint(jsonEncode(agendaData));
      
      final data = {
        'titulo': tituloController.text,
        'agenda': {
          'ops': agendaData
        },
        'lugar': lugarController.text,
        'fecha': selectedDateTime.toIso8601String(), // Convertir a ISO8601
      };
      
      debugPrint('Datos completos a enviar desde modal:');
      debugPrint(jsonEncode(data));
      
      Navigator.pop(context, data);
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),
  child: const Text('Crear'),
),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}