import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/modal.dart';

class ProductsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Productos',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: DataTable(
                  columnSpacing: 24.0,
                  columns: [
                    DataColumn(label: Text('Nombre de producto')),
                    DataColumn(label: Text('Tipo')),
                    DataColumn(label: Text('Localización')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('Snowboarding 206')),
                      DataCell(Text('Viaje abierto')),
                      DataCell(Text('Baqueira Beret')),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.download),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(Icons.upload),
                              onPressed: () => _showUploadModal(context),
                            ),
                          ],
                        ),
                      ),
                    ]),
                    // Add more rows as needed
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showUploadModal(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // Permite cerrar el modal haciendo clic fuera
    builder: (BuildContext context) => UploadModal(
      onFileSelected: (String filePath) {
        print('Archivo seleccionado: $filePath');
        // Implementa la lógica de selección de archivo
      },
      onUpload: () {
        print('Iniciando carga...');
        // Implementa la lógica de carga
        Navigator.of(context).pop(); // Cierra el modal después de cargar
      },
    ),
  );
}
