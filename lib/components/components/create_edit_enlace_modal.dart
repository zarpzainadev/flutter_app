import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';

Future<Map<String, String>?> showCreateEditEnlaceModal(
  BuildContext context, {
  EnlaceResponse? enlace, // null si es creación, objeto si es edición
}) {
  final formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController(text: enlace?.nombre);
  final descripcionController = TextEditingController(text: enlace?.descripcion);

  return showDialog<Map<String, String>>(
    context: context,
    builder: (BuildContext context) {
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
                Text(
                  enlace == null ? 'Crear Enlace' : 'Editar Enlace',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
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
                            'nombre': nombreController.text,
                            'descripcion': descripcionController.text,
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(enlace == null ? 'Crear' : 'Actualizar'),
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