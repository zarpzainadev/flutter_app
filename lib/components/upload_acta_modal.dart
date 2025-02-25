// upload_acta_modal.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/screens/meetings/list_meeting_viewmodel.dart';
import 'package:intl/intl.dart';

Future<Map<String, dynamic>?> showUploadActaModal(BuildContext context, int reunionId, ListMeetingViewModel viewModel) {
  String? fileName;
  String? errorMessage;
  List<int>? fileBytes;
  List<ActaDetailResponse> actas = [];
  bool isLoading = true; 

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          // Función para cargar las actas
          Future<void> loadActas() async {
            try {
              setState(() => isLoading = true);
              actas = await viewModel.getActasByMeeting(reunionId);
            } catch (e) {
              if (context.mounted) {
                setState(() => errorMessage = e.toString());
              }
            } finally {
              if (context.mounted) {
                setState(() => isLoading = false);
              }
            }
          }

          // Función para eliminar acta
          Future<void> deleteActa(int actaId) async {
            try {
              final success = await viewModel.deleteActa(actaId);
              if (success) {
                setState(() {
                  actas.removeWhere((acta) => acta.id == actaId);
                });
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Acta eliminada exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            } catch (e) {
              if (context.mounted) {
                setState(() => errorMessage = e.toString());
              }
            }
          }

          // Función para seleccionar archivo
          Future<void> pickFile() async {
            try {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
              );

              if (result != null) {
                setState(() {
                  fileName = result.files.first.name;
                  fileBytes = result.files.first.bytes;
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

          // Cargar actas al abrir el modal
          if (isLoading) {
            loadActas();
          }

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 600,
              constraints: const BoxConstraints(maxHeight: 700),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E3A8A),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.description,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Gestión de Actas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sección de Actas Existentes
                            if (isLoading) ...[
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ] else if (actas.isEmpty) ...[
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.grey[400]),
                                    const SizedBox(width: 12),
                                    Text(
                                      'No se encontraron actas para esta reunión',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                            ] else ...[
                              const Text(
                                'Actas Existentes',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3A8A),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: actas.length,
                                itemBuilder: (context, index) {
                                  final acta = actas[index];
                                  return Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                                      title: Text('Acta ${acta.id}'),
                                      subtitle: Text('Subido el: ${DateFormat('dd/MM/yyyy').format(acta.fechaSubida)}'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.visibility),
                                            onPressed: () {
                                              // Implementar vista de PDF
                                            },
                                            tooltip: 'Ver Acta',
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: const Text('Confirmar eliminación'),
                                                  content: const Text('¿Está seguro de eliminar esta acta?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: const Text('Cancelar'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        deleteActa(acta.id);
                                                      },
                                                      child: const Text(
                                                        'Eliminar',
                                                        style: TextStyle(color: Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            tooltip: 'Eliminar Acta',
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const Divider(height: 32),
                            ],

                            // Sección de Subir Nueva Acta
                            const Text(
                              'Subir Nueva Acta',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A8A),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          fileName != null ? Icons.picture_as_pdf : Icons.upload_file,
                                          color: fileName != null ? Colors.red : Colors.grey[400],
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                fileName ?? 'Ningún archivo seleccionado',
                                                style: TextStyle(
                                                  color: fileName != null ? Colors.black87 : Colors.grey[600],
                                                  fontSize: 16,
                                                ),
                                              ),
                                              if (fileName != null)
                                                Text(
                                                  'Listo para subir',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: pickFile,
                                          icon: const Icon(Icons.file_upload),
                                          label: Text(fileName != null ? 'Cambiar' : 'Seleccionar'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF1E3A8A),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (errorMessage != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          errorMessage!,
                                          style: TextStyle(color: Colors.red[700], fontSize: 12),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Actions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border(
                        top: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: Row(
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
                          onPressed: fileName != null && fileBytes != null
                              ? () => Navigator.pop(context, {
                                    'fileName': fileName,
                                    'file': fileBytes,
                                  })
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Subir Acta'),
                        ),
                      ],
                    ),
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