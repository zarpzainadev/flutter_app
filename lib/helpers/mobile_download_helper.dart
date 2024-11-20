import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> handleMobileDownload(
    List<int> bytes, String estadoNombre, String formato) async {
  try {
    print('Verificando permisos...'); // Debug

    // Verificar permisos actuales
    var storageStatus = await Permission.storage.status;
    var manageStatus = await Permission.manageExternalStorage.status;

    // Si no están otorgados, solicitarlos
    if (!storageStatus.isGranted || !manageStatus.isGranted) {
      print('Solicitando permisos...'); // Debug

      final statuses = await [
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();

      if (!statuses.values.every((status) => status.isGranted)) {
        print('Permisos no otorgados. Abriendo configuración...'); // Debug
        await openAppSettings();
        throw Exception(
            'Por favor, otorga los permisos de almacenamiento en la configuración');
      }
    }

    print('Permisos otorgados. Buscando directorio...'); // Debug

    // Intentar diferentes directorios
    Directory? directory;

    // Primero intentar directorio de descargas
    try {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    } catch (e) {
      print(
          'No se pudo acceder a Downloads, intentando alternativa...'); // Debug

      // Si falla, intentar con getExternalStorageDirectory
      directory = await getExternalStorageDirectory();

      if (directory == null) {
        throw Exception(
            'No se pudo acceder a ningún directorio de almacenamiento');
      }
    }

    String fileName = 'reporte_usuarios_$estadoNombre.$formato';
    String filePath = '${directory.path}/$fileName';

    print('Directorio encontrado. Guardando en: $filePath'); // Debug

    try {
      File file = File(filePath);
      await file.writeAsBytes(bytes);
      print('¡Archivo guardado exitosamente en $filePath!'); // Debug
    } catch (e) {
      throw Exception('Error al escribir el archivo: $e');
    }
  } catch (e) {
    print('Error en el proceso de descarga: $e'); // Debug
    rethrow;
  }
}

Future<void> handleWebDownload(
    List<int> bytes, String estadoNombre, String formato) async {
  throw UnsupportedError('Web download not supported on mobile');
}

Future<void> handleDocumentDownload(
    List<int> bytes, String nombre, String formato) async {
  try {
    var storageStatus = await Permission.storage.status;
    var manageStatus = await Permission.manageExternalStorage.status;

    if (!storageStatus.isGranted || !manageStatus.isGranted) {
      final statuses = await [
        Permission.storage,
        Permission.manageExternalStorage,
      ].request();

      if (!statuses.values.every((status) => status.isGranted)) {
        await openAppSettings();
        throw Exception('Se requieren permisos de almacenamiento');
      }
    }

    Directory? directory;
    try {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    } catch (e) {
      directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('No se pudo acceder al almacenamiento');
      }
    }

    String fileName = '$nombre.$formato';
    String filePath = '${directory.path}/$fileName';

    File file = File(filePath);
    await file.writeAsBytes(bytes);
  } catch (e) {
    rethrow;
  }
}

Future<void> handleWebDocumentDownload(
    List<int> bytes, String nombre, String formato) async {
  throw UnsupportedError('Web download not supported on mobile');
}
