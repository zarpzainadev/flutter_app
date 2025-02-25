import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';

Future<Map<String, dynamic>?> showCreateCargoModal(
  BuildContext context,
  List<UsuarioBasicInfo> usuarios,
) {
  final formKey = GlobalKey<FormState>();
  final abreviaturaController = TextEditingController();
  final cargoNombreController = TextEditingController();
  UsuarioBasicInfo? selectedUser;

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
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Crear Nuevo Cargo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
  controller: cargoNombreController,
  decoration: const InputDecoration(
    labelText: 'Nombre del Cargo',
    border: OutlineInputBorder(),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el nombre del cargo';
    }
    return null;
  },
),
const SizedBox(height: 16),
                TextFormField(
                  controller: abreviaturaController,
                  decoration: const InputDecoration(
                    labelText: 'Abreviatura',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una abreviatura';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<UsuarioBasicInfo>(
  decoration: const InputDecoration(
    labelText: 'Usuario',
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), 
    isDense: true, 
  ),
  validator: (value) {
    if (value == null) {
      return 'Por favor seleccione un usuario';
    }
    return null;
  },
  items: usuarios.map((usuario) {
    return DropdownMenuItem(
      value: usuario,
      child: Text(
        '${usuario.nombres} ${usuario.apellidosPaterno}',
        style: const TextStyle(fontSize: 14),
      ),
    );
  }).toList(),
  onChanged: (value) {
    selectedUser = value;
  },
  isExpanded: true, 
  menuMaxHeight: 250, 
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
                        if (formKey.currentState!.validate() && selectedUser != null) {
                          Navigator.pop(context, {
                            'abreviatura': abreviaturaController.text,
                            'cargo_nombre': cargoNombreController.text,
                            'id_usuario': selectedUser!.id,
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
}