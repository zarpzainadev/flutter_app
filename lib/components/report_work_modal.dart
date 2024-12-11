import 'package:flutter/material.dart';

class ReportWorkModal extends StatefulWidget {
  final Function(String formato) onGenerate;

  const ReportWorkModal({
    Key? key,
    required this.onGenerate,
  }) : super(key: key);

  @override
  _ReportWorkModalState createState() => _ReportWorkModalState();
}

class _ReportWorkModalState extends State<ReportWorkModal> {
  String selectedFormato = 'excel';
  final formatos = ['excel', 'pdf'];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generar Reporte de Trabajos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
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
                    widget.onGenerate(selectedFormato);
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
      ),
    );
  }
}

// Función auxiliar para mostrar el modal
void showReportWorkModal(BuildContext context, Function(String) onGenerate) {
  showDialog(
    context: context,
    builder: (context) => ReportWorkModal(onGenerate: onGenerate),
  );
}
