// lib/screens/Users/user_edit/user_edit_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/services/api_service_admin.dart';
import 'package:flutter_web_android/storage/storage_services.dart';

class UserEditViewModel extends ChangeNotifier {
  final ApiServiceAdmin _apiService;

  // Estados
  bool isLoading = false;
  String? errorMessage;
  bool _disposed = false;

  // Datos del usuario actual
  UserDetail? currentUser;
  int? userId;

  UserEditViewModel({ApiServiceAdmin? apiService})
      : _apiService = apiService ?? ApiServiceAdmin();

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  // Inicializar con los datos del usuario
  Future<void> initialize(int userId) async {
    try {
      this.userId = userId;
      isLoading = true;
      errorMessage = null;
      _safeNotifyListeners();

      final token = await _getToken();
      // Cargar los detalles del usuario
      currentUser = await _apiService.getUserDetails(token, userId);
    } catch (e) {
      errorMessage = 'Error al cargar datos del usuario: $e';
      debugPrint(errorMessage);
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  // Actualizar usuario
  Future<bool> updateUser({
    required String dni,
    required String email,
    required String nombres,
    required String apellidosPaterno,
    required String apellidosMaterno,
    required DateTime fechaNacimiento,
    String? celular,
    required int rolId,
    String? profesion,
    String? especialidad,
    String? centroTrabajo,
    String? direccionTrabajo,
    double? sueldoMensual,
    String? tipoVia,
    String? direccion,
    String? departamento,
    String? provincia,
    String? distrito,
    String? nombreConyuge,
    DateTime? fechaNacimientoConyuge,
    String? padreNombre,
    bool? padreVive,
    String? madreNombre,
    bool? madreVive,
    String? grupoSanguineo,
    String? religion,
    bool? presentadoLogia,
    String? nombreLogia,
  }) async {
    try {
      if (userId == null) {
        throw Exception('ID de usuario no inicializado');
      }

      isLoading = true;
      errorMessage = null;
      _safeNotifyListeners();

      final token = await _getToken();

      final userData = UsuarioUpdate(
        dni: dni,
        email: email,
        nombres: nombres,
        apellidos_paterno: apellidosPaterno,
        apellidos_materno: apellidosMaterno,
        fecha_nacimiento: fechaNacimiento,
        celular: celular,
        rol_id: rolId,
        profesion: profesion,
        especialidad: especialidad,
        centro_trabajo: centroTrabajo,
        direccion_trabajo: direccionTrabajo,
        sueldo_mensual: sueldoMensual,
        tipo_via: tipoVia,
        direccion: direccion,
        departamento: departamento,
        provincia: provincia,
        distrito: distrito,
        nombre_conyuge: nombreConyuge,
        fecha_nacimiento_conyuge: fechaNacimientoConyuge,
        padre_nombre: padreNombre,
        padre_vive: padreVive,
        madre_nombre: madreNombre,
        madre_vive: madreVive,
        grupo_sanguineo: grupoSanguineo,
        religion: religion,
        presentado_logia: presentadoLogia,
        nombre_logia: nombreLogia,
      );

      await _apiService.updateUser(token, userId!, userData);

      // Recargar datos después de actualizar
      await initialize(userId!);
      return true;
    } catch (e) {
      errorMessage = 'Error al actualizar usuario: $e';
      debugPrint(errorMessage);
      return false;
    } finally {
      isLoading = false;
      _safeNotifyListeners();
    }
  }

  Future<String> _getToken() async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('Token no disponible');
    return token.accessToken;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<bool> handleUpdateUser(Map<String, dynamic> changes) async {
    try {
      return await updateUser(
        dni: changes['dni'] ?? currentUser?.dni ?? '',
        email: changes['email'] ?? currentUser?.email ?? '',
        nombres: changes['nombres'] ?? currentUser?.nombres ?? '',
        apellidosPaterno:
            changes['apellidosPaterno'] ?? currentUser?.apellidos_paterno ?? '',
        apellidosMaterno:
            changes['apellidosMaterno'] ?? currentUser?.apellidos_materno ?? '',
        fechaNacimiento: currentUser?.fecha_nacimiento ?? DateTime.now(),
        celular: changes['celular'],
        rolId: currentUser?.rol_id ?? 1,
        profesion: changes['profesion'],
        especialidad: changes['especialidad'],
        centroTrabajo: changes['centroTrabajo'],
        direccionTrabajo: changes['direccionTrabajo'],
        sueldoMensual: double.tryParse(changes['sueldoMensual'] ?? ''),
        tipoVia: changes['tipoVia'],
        direccion: changes['direccion'],
        departamento: changes['departamento'],
        provincia: changes['provincia'],
        distrito: changes['distrito'],
        nombreConyuge: changes['nombreConyuge'],
        fechaNacimientoConyuge: changes['fechaNacimientoConyuge'],
        padreNombre: changes['padreNombre'],
        padreVive: changes['padreVive'],
        madreNombre: changes['madreNombre'],
        madreVive: changes['madreVive'],
        grupoSanguineo: changes['grupoSanguineo'],
        religion: changes['religion'],
        presentadoLogia: changes['presentadoLogia'],
        nombreLogia: changes['nombreLogia'],
      );
    } catch (e) {
      errorMessage = 'Error al actualizar usuario: $e';
      _safeNotifyListeners();
      return false;
    }
  }
}
