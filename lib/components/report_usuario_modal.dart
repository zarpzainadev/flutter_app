// report_usuario_modal.dart
import 'package:flutter/material.dart';

class ReportUsuarioModal extends StatefulWidget {
  final Function(String estado, String formato) onGenerate;

  const ReportUsuarioModal({
    Key? key,
    required this.onGenerate,
  }) : super(key: key);

  @override
  _ReportUsuarioModalState createState() => _ReportUsuarioModalState();
}

class _ReportUsuarioModalState extends State<ReportUsuarioModal> {
  String selectedEstado = 'Activo';
  String selectedFormato = 'excel';

  final estados = ['Activo', 'En sueño', 'Irradiado'];
  final formatos = ['excel', 'pdf'];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive width
          double width =
              constraints.maxWidth > 600 ? 500 : constraints.maxWidth * 0.9;

          return Container(
            width: width,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Generar Reporte',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  value: selectedEstado,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(),
                  ),
                  items: estados.map((estado) {
                    return DropdownMenuItem(
                      value: estado,
                      child: Text(estado),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedEstado = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedFormato,
                  decoration: const InputDecoration(
                    labelText: 'Formato',
                    border: OutlineInputBorder(),
                  ),
                  items: formatos.map((formato) {
                    return DropdownMenuItem(
                      value: formato,
                      child: Text(formato.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFormato = value!;
                    });
                  },
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
                        widget.onGenerate(selectedEstado, selectedFormato);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Generar'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Función para mostrar el modal
void showReportUsuarioModal(
    BuildContext context, Function(String, String) onGenerate) {
  showDialog(
    context: context,
    builder: (context) => ReportUsuarioModal(onGenerate: onGenerate),
  );
}
