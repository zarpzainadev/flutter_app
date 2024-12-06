// lib/components/update_trabajo_modal.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateTrabajoModal extends StatefulWidget {
  final Map<String, dynamic> trabajo;
  final Function(Map<String, dynamic>) onUpdate;

  const UpdateTrabajoModal({
    Key? key,
    required this.trabajo,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<UpdateTrabajoModal> createState() => _UpdateTrabajoModalState();
}

class _UpdateTrabajoModalState extends State<UpdateTrabajoModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  late DateTime _fechaPresentacion;
  String _estado = 'Activo';

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.trabajo['titulo']);
    _descripcionController =
        TextEditingController(text: widget.trabajo['descripcion']);
    _fechaPresentacion =
        DateFormat('dd/MM/yyyy').parse(widget.trabajo['fecha_presentacion']);
    _estado = widget.trabajo['estado'] ?? 'Activo';
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Actualizar Trabajo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una descripción';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _estado,
                          decoration: const InputDecoration(
                            labelText: 'Estado',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Activo', 'Inactivo'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _estado = newValue;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _fechaPresentacion,
                              // Permitir fechas desde hace 10 años
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 3650)),
                              // Permitir fechas hasta 10 años en el futuro
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 3650)),
                            );
                            if (picked != null) {
                              setState(() {
                                _fechaPresentacion = picked;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Fecha de Presentación',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              DateFormat('dd/MM/yyyy')
                                  .format(_fechaPresentacion),
                            ),
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
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.onUpdate({
                              'titulo': _tituloController.text,
                              'descripcion': _descripcionController.text,
                              'estado': _estado,
                              'fecha_presentacion': _fechaPresentacion,
                            });
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Actualizar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
