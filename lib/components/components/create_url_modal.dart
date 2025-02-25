import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';

Future<Map<String, dynamic>?> showCreateUrlModal(
  BuildContext context,
  List<EnlaceResponse> enlaces,
) {
  final formKey = GlobalKey<FormState>();
  final urlController = TextEditingController();
  EnlaceResponse? selectedEnlace;

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
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Crear Nueva URL',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<EnlaceResponse>(
                      value: selectedEnlace,
                      decoration: const InputDecoration(
                        labelText: 'Enlace',
                        border: OutlineInputBorder(),
                      ),
                      items: enlaces.map((enlace) {
                        return DropdownMenuItem(
                          value: enlace,
                          child: Text(enlace.nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedEnlace = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor seleccione un enlace';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: urlController,
                      decoration: const InputDecoration(
                        labelText: 'URL',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una URL';
                        }
                        if (!Uri.parse(value).isAbsolute) {
                          return 'Por favor ingrese una URL válida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(context, {
                                'url': urlController.text,
                                'enlaceId': selectedEnlace!.id,
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
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
    },
  );
}