import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

Future<Map<String, dynamic>?> showUploadEventModal(BuildContext context) {
  String? fileName;
  String? errorMessage;
  List<int>? fileBytes;
  String? mimeType;

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> pickFile() async {
            try {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom, // Cambiar a custom en lugar de image
                allowedExtensions: [
                  'jpg',
                  'jpeg',
                  'png'
                ], // Mantener las extensiones permitidas
              );

              if (result != null) {
                setState(() {
                  fileName = result.files.first.name;
                  fileBytes = result.files.first.bytes;
                  mimeType = 'image/${result.files.first.extension}';
                  errorMessage = null;
                });
              }
            } catch (e) {
              setState(() {
                errorMessage = 'Error al seleccionar archivo: $e';
                fileName = null;
                fileBytes = null;
              });
            }
          }

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 450, // Un poco más ancho para mejor distribución
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centrado vertical
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Centrado horizontal
                children: [
                  // Título del modal
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centrar título
                    children: [
                      Icon(
                        Icons.upload_file,
                        color: const Color(0xFF1E3A8A),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Subir Invitación',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Área de selección de archivo
                  Container(
                    padding: const EdgeInsets.all(24),
                    width: double.infinity, // Ocupar todo el ancho disponible
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF1E3A8A).withOpacity(0.1),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Centrado vertical
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          fileName ?? 'Ningún archivo seleccionado',
                          style: TextStyle(
                            color: fileName != null
                                ? Colors.grey[700]
                                : Colors.grey[500],
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: pickFile, // Aquí se conecta la función
                          icon: const Icon(Icons.add_photo_alternate),
                          label: const Text('Seleccionar Imagen'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                        if (errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            errorMessage!,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Botones de acción
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centrar botones
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: fileBytes == null
                            ? null
                            : () => Navigator.pop(context, {
                                  'fileBytes': fileBytes,
                                  'fileName': fileName,
                                  'mimeType': mimeType,
                                }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Subir'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
