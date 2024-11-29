// lib/screens/assistance/assistance_historical_screen.dart
import 'package:flutter/material.dart';
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
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        mainAxisExtent: 120,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: viewModel.asistencias.length,
      itemBuilder: (context, index) {
        final asistencia = viewModel.asistencias[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('dd MMMM yyyy', 'es_ES').format(asistencia.fecha),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                _buildEstadoChip(asistencia.estado),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEstadoChip(EstadoAsistencia estado) {
    Color color;
    String text;

    switch (estado) {
      case EstadoAsistencia.Asistido:
        color = Colors.green;
        text = 'Asistió';
        break;
      case EstadoAsistencia.No_asistido:
        color = Colors.red;
        text = 'No Asistió';
        break;
      case EstadoAsistencia.Justificado:
        color = Colors.orange;
        text = 'Justificado';
        break;
    }

    return Chip(
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color,
    );
  }
}
