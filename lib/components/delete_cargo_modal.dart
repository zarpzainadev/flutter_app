// lib/components/cargos/delete_cargo_modal.dart

import 'package:flutter/material.dart';

Future<bool?> showDeleteCargoModal(BuildContext context, String abreviatura) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Eliminar Cargo'),
        content: Text('¿Está seguro de eliminar el cargo "$abreviatura"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      );
    },
  );
}