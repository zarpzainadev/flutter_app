// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

Future<void> handleWebDownload(
    List<int> bytes, String estadoNombre, String formato) async {
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', 'reporte_usuarios_$estadoNombre.$formato')
    ..click();
  html.Url.revokeObjectUrl(url);
}

Future<void> handleMobileDownload(
    List<int> bytes, String estadoNombre, String formato) async {
  throw UnsupportedError('Mobile download not supported on web');
}

// helpers para web descarg de documento asociado al usuario
Future<void> handleDocumentDownload(
    List<int> bytes, String nombre, String formato) async {
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', '$nombre.$formato')
    ..click();
  html.Url.revokeObjectUrl(url);
}

Future<void> handleMobileDocumentDownload(
    List<int> bytes, String nombre, String formato) async {
  throw UnsupportedError('Mobile download not supported on web');
}
