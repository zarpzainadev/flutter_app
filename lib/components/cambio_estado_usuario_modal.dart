// cambio_estado_usuario_modal.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ChangeEstadoModal extends StatefulWidget {
  final String estadoActual;
  final Function(int nuevoEstadoId, String comentario, List<int> fileBytes)
      onSubmit;

  const ChangeEstadoModal({
    Key? key,
    required this.estadoActual,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<ChangeEstadoModal> createState() => _ChangeEstadoModalState();
}

class _ChangeEstadoModalState extends State<ChangeEstadoModal> {
  int? selectedEstadoId;
  String? comentario;
  String? fileName;
  List<int>? fileBytes;

  // Map de estados con sus IDs
  final Map<int, String> estados = {
    1: 'Activo',
    2: 'En sueño',
    3: 'Irradiado',
  };

  // Obtener ID del estado actual
  int getEstadoActualId() {
    return estados.entries
        .firstWhere((entry) => entry.value == widget.estadoActual)
        .key;
  }

  @override
  Widget build(BuildContext context) {
    final estadoActualId = getEstadoActualId();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cambio de Estado',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text('Estado actual: ${widget.estadoActual}'),
            const SizedBox(height: 24),
            DropdownButtonFormField<int>(
              value: selectedEstadoId,
              decoration: const InputDecoration(
                labelText: 'Nuevo Estado',
                border: OutlineInputBorder(),
              ),
              items: estados.entries
                  .where((e) => e.key != estadoActualId)
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedEstadoId = value),
            ),
            const SizedBox(height: 16),
            // Campo de comentario
            TextField(
              decoration: const InputDecoration(
                labelText: 'Comentario',
                border: OutlineInputBorder(),
                hintText: 'Ingrese un comentario sobre el cambio de estado',
              ),
              maxLines: 3,
              onChanged: (value) => setState(() => comentario = value),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Subir Documento'),
                ),
                const SizedBox(width: 8),
                if (fileName != null)
                  Expanded(
                    child: Text(
                      fileName!,
                      overflow: TextOverflow.ellipsis,
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
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _canSubmit()
                      ? () {
                          // Solo ejecutar la acción, no cerrar el modal aquí
                          widget.onSubmit(
                            selectedEstadoId!,
                            comentario ?? '',
                            fileBytes!,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Confirmar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        fileName = result.files.first.name;
        fileBytes = result.files.first.bytes;
      });
    }
  }

  bool _canSubmit() =>
      selectedEstadoId != null &&
      comentario != null &&
      comentario!.isNotEmpty &&
      fileBytes != null;
}
