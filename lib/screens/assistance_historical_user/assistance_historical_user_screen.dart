// lib/screens/assistance/assistance_historical_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/generic_list_widget.dart';
import 'package:flutter_web_android/models/modulo_user_meetings.dart';
import 'package:flutter_web_android/screens/assistance_historical_user/assistance_historical_user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';

class AssistanceHistoricalScreen extends StatelessWidget {
  const AssistanceHistoricalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AssistanceHistoricalViewModel()..initialize(),
      child: const _AssistanceHistoricalContent(),
    );
  }
}

class _AssistanceHistoricalContent extends StatelessWidget {
  const _AssistanceHistoricalContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: Consumer<AssistanceHistoricalViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.isLoading) {
                  return const Center(child: CustomLoading());
                }

                if (viewModel.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          viewModel.errorMessage!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (viewModel.asistencias.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay registros de asistencia',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Los registros de asistencia aparecerán aquí',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return _buildAssistancesList(context, viewModel);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Detectar si estamos en versión móvil
        final isMobile = constraints.maxWidth < 600;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mi Historial de Asistencias',
              style: TextStyle(
                fontSize: isMobile ? 18 : 24, // Texto más pequeño en móvil
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E3A8A),
              ),
            ),
            Consumer<AssistanceHistoricalViewModel>(
              builder: (context, viewModel, _) => IconButton(
                icon: Icon(
                  viewModel.sortAscending
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: const Color(0xFF1E3A8A),
                  size: isMobile ? 20 : 24, // Ícono más pequeño en móvil
                ),
                onPressed: () => viewModel.toggleSort(),
                tooltip: '', // Sin tooltip
                constraints: BoxConstraints.tightFor(
                  width: isMobile ? 32 : 40, // Botón más pequeño en móvil
                  height: isMobile ? 32 : 40,
                ),
                padding: EdgeInsets.zero, // Eliminar padding adicional
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAssistancesList(
      BuildContext context, AssistanceHistoricalViewModel viewModel) {
    return !kIsWeb
        ? GenericListWidget<AsistenciaUser>(
            items: viewModel.asistencias,
            isLoading: viewModel.isLoading,
            emptyMessage: 'No hay registros de asistencia',
            emptyIcon: Icons.calendar_today_outlined,
            getTitle: (asistencia) =>
                DateFormat('dd/MM/yyyy').format(asistencia.fecha),
            getSubtitle: (asistencia) => '', // Dejamos el subtítulo vacío
            getAvatarWidget: (asistencia) => CircleAvatar(
              backgroundColor:
                  _getEstadoColor(asistencia.estado).withOpacity(0.1),
              child: Icon(
                _getEstadoIcon(asistencia.estado),
                color: _getEstadoColor(asistencia.estado),
                size: 20,
              ),
            ),
            getChips: (asistencia) => [
              ChipInfo(
                icon: _getEstadoIcon(asistencia.estado),
                label: _getEstadoText(asistencia.estado),
                backgroundColor:
                    _getEstadoColor(asistencia.estado).withOpacity(0.1),
                textColor: _getEstadoColor(asistencia.estado),
              ),
            ],
            actions: const [],
          )
        : Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 48,
                ),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(
                      const Color(0xFF1E3A8A).withOpacity(0.1)),
                  columnSpacing: 40,
                  horizontalMargin: 24,
                  dataRowHeight: 60,
                  columns: [
                    DataColumn(
                      label: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Fecha',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Estado',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: viewModel.asistencias.map((asistencia) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(asistencia.fecha),
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: _buildEstadoChip(asistencia.estado),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
  }

  Widget _buildEstadoChip(EstadoAsistencia estado) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (estado) {
      case EstadoAsistencia.Asistido:
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        text = 'Asistió';
        break;
      case EstadoAsistencia.No_asistido:
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
        text = 'No Asistió';
        break;
      case EstadoAsistencia.Justificado:
        backgroundColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        text = 'Justificado';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getEstadoColor(EstadoAsistencia estado) {
    switch (estado) {
      case EstadoAsistencia.Asistido:
        return Colors.green;
      case EstadoAsistencia.No_asistido:
        return Colors.red;
      case EstadoAsistencia.Justificado:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getEstadoIcon(EstadoAsistencia estado) {
    switch (estado) {
      case EstadoAsistencia.Asistido:
        return Icons.check_circle_outline;
      case EstadoAsistencia.No_asistido:
        return Icons.cancel_outlined;
      case EstadoAsistencia.Justificado:
        return Icons.warning_amber_outlined;
      default:
        return Icons.help_outline;
    }
  }

  String _getEstadoText(EstadoAsistencia estado) {
    switch (estado) {
      case EstadoAsistencia.Asistido:
        return 'Asistió';
      case EstadoAsistencia.No_asistido:
        return 'No Asistió';
      case EstadoAsistencia.Justificado:
        return 'Justificado';
      default:
        return 'Desconocido';
    }
  }
}
