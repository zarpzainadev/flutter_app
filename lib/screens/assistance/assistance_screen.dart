// assistance_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/screens/home_screen.dart';
import 'package:flutter_web_android/screens/meetings/list_meetings.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/screens/assistance/assistance_viewmodel.dart';

class AssistanceScreen extends StatelessWidget {
  final String title;
  final bool isEditing;
  final int? reunionId;

  const AssistanceScreen({
    Key? key,
    this.title = 'Registro de Asistencia',
    this.isEditing = false,
    this.reunionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Detectar si es móvil
    final isMobile = !kIsWeb;

    return ChangeNotifierProvider(
      create: (_) => AssistanceViewModel()..cargarUsuariosActivos(),
      child: Scaffold(
        backgroundColor: Colors.white,
        // Usar AppBar solo en móvil con estilo modificado
        appBar: isMobile
            ? AppBar(
                title: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: Colors.white, // Fondo blanco
                elevation: 0, // Sin sombra
                automaticallyImplyLeading: false, // Quita la flecha de retorno
              )
            : null,
        body: _AssistanceContent(
          title: title,
          isEditing: isEditing,
          reunionId: reunionId,
          isMobile: isMobile,
        ),
      ),
    );
  }
}

class _AssistanceContent extends StatelessWidget {
  final String title;
  final bool isEditing;
  final int? reunionId;
  final bool isMobile;

  const _AssistanceContent({
    Key? key,
    required this.title,
    required this.isEditing,
    required this.isMobile,
    this.reunionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mostrar título solo si no es móvil (web)
          if (!isMobile) _buildHeader(context),
          if (!isMobile) const SizedBox(height: 20),

          Expanded(
            child: Consumer<AssistanceViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.isLoading) {
                  return const Center(child: CustomLoading());
                }

                if (viewModel.errorMessage != null) {
                  return _buildErrorMessage(viewModel.errorMessage!);
                }

                return _buildAssistanceList(context, viewModel);
              },
            ),
          ),
          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF1E3A8A),
                fontWeight: FontWeight.bold,
              ),
        ),
        if (!isEditing)
          ElevatedButton.icon(
            onPressed: () {
              final viewModel = context.read<AssistanceViewModel>();
              viewModel.cargarUsuariosActivos();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Actualizar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
            ),
          ),
      ],
    );
  }

  Widget _buildAssistanceList(
      BuildContext context, AssistanceViewModel viewModel) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Text(
                    'N°',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Nombre Completo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Estado de Asistencia',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.usuariosActivos.length,
              itemBuilder: (context, index) {
                final usuario = viewModel.usuariosActivos[index];
                final estadoActual = viewModel.estadosAsistencia[usuario.id] ??
                    EstadoAsistencia.No_asistido;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade100,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${usuario.nombres} ${usuario.apellidosPaterno} ${usuario.apellidosMaterno}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              _buildRadioOption(
                                'Asistió',
                                EstadoAsistencia.Asistido,
                                estadoActual,
                                (value) => viewModel.cambiarEstadoAsistencia(
                                  usuario.id,
                                  value as EstadoAsistencia,
                                ),
                              ),
                              _buildRadioOption(
                                'Faltó',
                                EstadoAsistencia.No_asistido,
                                estadoActual,
                                (value) => viewModel.cambiarEstadoAsistencia(
                                  usuario.id,
                                  value as EstadoAsistencia,
                                ),
                              ),
                              _buildRadioOption(
                                'Justificado',
                                EstadoAsistencia.Justificado,
                                estadoActual,
                                (value) => viewModel.cambiarEstadoAsistencia(
                                  usuario.id,
                                  value as EstadoAsistencia,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(
    String label,
    EstadoAsistencia value,
    EstadoAsistencia groupValue,
    Function(Object?) onChanged,
  ) {
    return Expanded(
      child: Row(
        children: [
          Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.grey.shade400,
            ),
            child: Radio<EstadoAsistencia>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: const Color(0xFF1E3A8A),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle get _headerStyle => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      );

  Widget _buildAsistenciaButton(
    String text,
    bool isSelected,
    VoidCallback onPressed,
    Color color,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : Colors.grey.shade200,
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text, style: TextStyle(fontSize: 12)),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              // Encontrar el HomeScreenState y cambiar a ListMeetings
              if (context.findAncestorStateOfType<HomeScreenState>() != null) {
                context
                    .findAncestorStateOfType<HomeScreenState>()
                    ?.changeScreen(
                      const ListMeetings(),
                    );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black87,
            ),
            child: const Text('Cancelar'),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () => _handleSave(context),
            icon: const Icon(Icons.save),
            label: const Text('Guardar Asistencias'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  Color _getEstadoColor(EstadoAsistencia estado) {
    switch (estado) {
      case EstadoAsistencia.Asistido:
        return Colors.green;
      case EstadoAsistencia.Justificado:
        return Colors.orange;
      case EstadoAsistencia.No_asistido:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getEstadoText(EstadoAsistencia estado) {
    switch (estado) {
      case EstadoAsistencia.Asistido:
        return 'Asistió';
      case EstadoAsistencia.No_asistido:
        return 'Faltó';
      case EstadoAsistencia.Justificado:
        return 'Justificado';
      default:
        return 'No registrado';
    }
  }

  Future<void> _handleSave(BuildContext context) async {
    final viewModel = context.read<AssistanceViewModel>();

    if (!viewModel.hayAsistenciasPendientes()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay cambios para guardar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    viewModel.prepararAsistencias();
    final success = await viewModel.registrarAsistencias(
      reunionId: reunionId ?? 0,
      fecha: DateTime.now(),
    );

    if (success && context.mounted) {
      // Mostrar modal de éxito
      showDialog(
        context: context,
        barrierDismissible: false, // El usuario debe usar el botón para cerrar
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 30),
                SizedBox(width: 8),
                Text('¡Éxito!'),
              ],
            ),
            content: Text('Las asistencias fueron registradas correctamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra solo el modal
                  // Recargar los usuarios activos para refrescar la vista
                  viewModel.cargarUsuariosActivos();
                },
                child: Text(
                  'Aceptar',
                  style: TextStyle(color: const Color(0xFF1E3A8A)),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
