import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/components/create_edit_enlace_modal.dart';
import 'package:flutter_web_android/components/components/create_url_modal.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:flutter_web_android/models/modulo_gestion_usuario_model.dart';
import 'package:flutter_web_android/screens/enlaces/gestion_enlaces_viewmodel.dart';
import 'package:provider/provider.dart';

class GestionEnlacesScreen extends StatelessWidget {
  const GestionEnlacesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GestionEnlacesViewModel(),
      child: const _GestionEnlacesContent(),
    );
  }
}

class _GestionEnlacesContent extends StatefulWidget {
  const _GestionEnlacesContent({Key? key}) : super(key: key);

  @override
  State<_GestionEnlacesContent> createState() => _GestionEnlacesContentState();
}

class _GestionEnlacesContentState extends State<_GestionEnlacesContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GestionEnlacesViewModel>().refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Detectar si estamos en un dispositivo móvil
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gestión de Enlaces y URLs',
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A8A),
            ),
          ),
          SizedBox(height: isMobile ? 16 : 24),
          Expanded(
            child: Consumer<GestionEnlacesViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.isLoading) {
                  return const Center(child: CustomLoading());
                }

                return RefreshIndicator(
                  onRefresh: () => viewModel.refreshData(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        _buildEnlacesSection(context, viewModel, isMobile),
                        SizedBox(height: isMobile ? 16 : 32),
                        _buildUrlsSection(context, viewModel, isMobile),
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

  Widget _buildEnlacesSection(BuildContext context, GestionEnlacesViewModel viewModel, bool isMobile) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enlaces',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showCreateEnlaceDialog(context),
                icon: const Icon(Icons.add, color: Colors.white), // Icono blanco
                label: Text(isMobile ? '' : 'Nuevo Enlace'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 16,
                    vertical: isMobile ? 8 : 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (viewModel.enlaces.isEmpty)
            _buildEmptyState('No hay enlaces registrados')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.enlaces.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final enlace = viewModel.enlaces[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(Icons.link, 
                      color: Colors.blue.shade900,
                      size: isMobile ? 20 : 24,
                    ),
                  ),
                  title: Text(
                    enlace.nombre,
                    style: TextStyle(fontSize: isMobile ? 14 : 16),
                  ),
                  subtitle: Text(
                    enlace.descripcion ?? 'Sin descripción',
                    style: TextStyle(fontSize: isMobile ? 12 : 14),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    iconSize: isMobile ? 20 : 24,
                    color: const Color(0xFF1E3A8A),
                    onPressed: () => _showEditEnlaceDialog(context, enlace),
                  ),
                );
              },
            ),
        ],
      ),
    ),
  );
}

Widget _buildUrlsSection(BuildContext context, GestionEnlacesViewModel viewModel, bool isMobile) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'URLs',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showCreateUrlDialog(context, viewModel),
                icon: const Icon(Icons.add, color: Colors.white), // Icono blanco
                label: Text(isMobile ? '' : 'Nueva URL'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 16,
                    vertical: isMobile ? 8 : 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (viewModel.urls.isEmpty)
            _buildEmptyState('No hay URLs registradas')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.urls.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final url = viewModel.urls[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green.shade50,
                    child: Icon(
                      Icons.link,
                      color: Colors.green.shade900,
                      size: isMobile ? 20 : 24,
                    ),
                  ),
                  title: Text(
                    url.url,
                    style: TextStyle(fontSize: isMobile ? 14 : 16),
                  ),
                  subtitle: Text(
                    url.enlaceNombre ?? 'Sin enlace',
                    style: TextStyle(fontSize: isMobile ? 12 : 14),
                  ),
                );
              },
            ),
        ],
      ),
    ),
  );
}

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.link_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateEnlaceDialog(BuildContext context) async {
  final result = await showCreateEditEnlaceModal(context);
  if (result != null && context.mounted) {
    final viewModel = context.read<GestionEnlacesViewModel>();
    await viewModel.createEnlace(
      result['nombre']!,
      descripcion: result['descripcion'],
    );
  }
}

void _showEditEnlaceDialog(BuildContext context, EnlaceResponse enlace) async {
  final result = await showCreateEditEnlaceModal(
    context,
    enlace: enlace,
  );
  if (result != null && context.mounted) {
    final viewModel = context.read<GestionEnlacesViewModel>();
    await viewModel.updateEnlaceStatus(
      enlace.id,
      true, 
    );
  }
}

void _showCreateUrlDialog(BuildContext context, GestionEnlacesViewModel viewModel) async {
  final result = await showCreateUrlModal(
    context,
    viewModel.enlaces,
  );
  if (result != null && context.mounted) {
    await viewModel.createUrl(
      result['url'] as String,
      result['enlaceId'] as int,
    );
  }
}
}