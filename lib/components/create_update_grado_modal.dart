// lib/components/create_update_grado_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';

// Mapa de abreviaciones
const Map<TipoGrado, String> _abreviaciones = {
  TipoGrado.Aprendiz: ':.A',
  TipoGrado.Companero: ':.C',
  TipoGrado.Maestro: ':.M',
};

// Modal para crear grado
class CreateGradoModal extends StatefulWidget {
  final Function(TipoGrado grado, String abrevGrado) onConfirm;
  final int usuarioId;

  const CreateGradoModal({
    Key? key,
    required this.onConfirm,
    required this.usuarioId,
  }) : super(key: key);

  @override
  State<CreateGradoModal> createState() => _CreateGradoModalState();
}

class _CreateGradoModalState extends State<CreateGradoModal> {
  TipoGrado? selectedGrado;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crear Grado',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<TipoGrado>(
              value: selectedGrado,
              decoration: const InputDecoration(
                labelText: 'Grado',
                border: OutlineInputBorder(),
              ),
              items: TipoGrado.values.map((grado) {
                return DropdownMenuItem(
                  value: grado,
                  child: Text(grado.display),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedGrado = value),
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
                  onPressed: selectedGrado == null
                      ? null
                      : () {
                          widget.onConfirm(
                            selectedGrado!,
                            _abreviaciones[selectedGrado]!,
                          );
                          Navigator.pop(context);
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
    );
  }
}

// Modal para actualizar grado
class UpdateGradoModal extends StatefulWidget {
  final Function(TipoGrado grado, String abrevGrado) onConfirm;
  final String gradoActual;

  const UpdateGradoModal({
    Key? key,
    required this.onConfirm,
    required this.gradoActual,
  }) : super(key: key);

  @override
  State<UpdateGradoModal> createState() => _UpdateGradoModalState();
}

class _UpdateGradoModalState extends State<UpdateGradoModal> {
  TipoGrado? selectedGrado;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Actualizar Grado',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Grado actual: ${widget.gradoActual}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<TipoGrado>(
              value: selectedGrado,
              decoration: const InputDecoration(
                labelText: 'Nuevo Grado',
                border: OutlineInputBorder(),
              ),
              items: TipoGrado.values.map((grado) {
                return DropdownMenuItem(
                  value: grado,
                  child: Text(grado.display),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedGrado = value),
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
                  onPressed: selectedGrado == null
                      ? null
                      : () {
                          widget.onConfirm(
                            selectedGrado!,
                            _abreviaciones[selectedGrado]!,
                          );
                          Navigator.pop(context);
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
    );
  }
}

// Funciones helper para mostrar los modales
Future<void> showCreateGradoModal(
  BuildContext context,
  int usuarioId,
  Function(TipoGrado grado, String abrevGrado) onConfirm,
) {
  return showDialog(
    context: context,
    builder: (context) => CreateGradoModal(
      usuarioId: usuarioId,
      onConfirm: onConfirm,
    ),
  );
}

Future<void> showUpdateGradoModal(
  BuildContext context,
  String gradoActual,
  Function(TipoGrado grado, String abrevGrado) onConfirm,
) {
  return showDialog(
    context: context,
    builder: (context) => UpdateGradoModal(
      gradoActual: gradoActual,
      onConfirm: onConfirm,
    ),
  );
}
