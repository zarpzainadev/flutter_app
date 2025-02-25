// lib/screens/cuadro/cuadro_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'cuadro_viewmodel.dart';

class CuadroScreen extends StatelessWidget {
  const CuadroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CuadroViewModel(),
      child: const _CuadroContent(),
    );
  }
}

class _CuadroContent extends StatelessWidget {
  const _CuadroContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cuadro de Oficiales',
                style: TextStyle(
                  fontSize: isMobile ? 20 : 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<CuadroViewModel>().refreshCargos(),
                color: const Color(0xFF1E3A8A),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Consumer<CuadroViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.isLoading) {
                  return const Center(child: CustomLoading());
                }

                if (viewModel.error != null) {
                  return _buildError(viewModel.error!);
                }

                if (viewModel.cargos.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: viewModel.refreshCargos,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.builder(
                        padding: EdgeInsets.all(isMobile ? 8 : 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _getCrossAxisCount(constraints.maxWidth),
                          childAspectRatio: isMobile ? 2.5 : 1.8,
                          crossAxisSpacing: isMobile ? 8 : 20,
                          mainAxisSpacing: isMobile ? 8 : 20,
                        ),
                        itemCount: viewModel.cargos.length,
                        itemBuilder: (context, index) {
                          final cargo = viewModel.cargos[index];
                          return _buildCargoCard(context, cargo, isMobile);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(double width) {
    if (width > 1200) return 3;
    if (width > 800) return 2;
    return 1;
  }

  Widget _buildCargoCard(BuildContext context, CargoDetailResponse cargo, bool isMobile) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Consumer<CuadroViewModel>(
                    builder: (context, viewModel, _) {
                      return FutureBuilder<Uint8List>(
                        future: viewModel.getUserPhoto(cargo.idUsuario),
                        builder: (context, snapshot) {
                          return CircleAvatar(
                            radius: isMobile ? 24 : 32,
                            backgroundColor: Colors.blue.shade100,
                            backgroundImage: snapshot.hasData && snapshot.data!.isNotEmpty
                                ? MemoryImage(snapshot.data!)
                                : null,
                            child: (!snapshot.hasData || snapshot.data!.isEmpty)
                                ? Icon(
                                    Icons.person,
                                    size: isMobile ? 24 : 32,
                                    color: const Color(0xFF1E3A8A),
                                  )
                                : null,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cargo.cargoNombre,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                        Text(
                          cargo.abreviatura,
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cargo.usuarioNombre,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    _buildContactInfo(
                      Icons.phone,
                      cargo.usuarioCelular,
                      isMobile,
                    ),
                    const SizedBox(height: 8),
                    _buildContactInfo(
                      Icons.email,
                      cargo.usuarioEmail,
                      isMobile,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text, bool isMobile) {
    return Row(
      children: [
        Icon(
          icon,
          size: isMobile ? 16 : 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            error,
            style: TextStyle(color: Colors.red[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay oficiales asignados',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}