// lib/screens/resources/resources_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'resources_viewmodel.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResourcesViewModel(),
      child: const _ResourcesContent(),
    );
  }
}

class _ResourcesContent extends StatelessWidget {
  const _ResourcesContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recursos y Enlaces',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Consumer<ResourcesViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.isLoading) {
                  return const Center(child: CustomLoading());
                }

                if (viewModel.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, 
                          size: 48, 
                          color: Colors.red[300]
                        ),
                        const SizedBox(height: 16),
                        Text(
                          viewModel.error!,
                          style: TextStyle(color: Colors.red[700]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: viewModel.refreshUrls,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (viewModel.urls.isEmpty) {
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
                          'No hay recursos disponibles',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = 
                        viewModel.getGridCrossAxisCount(constraints.maxWidth);
                    final spacing = 
                        viewModel.getGridSpacing(constraints.maxWidth);

                    return RefreshIndicator(
                      onRefresh: viewModel.refreshUrls,
                      child: GridView.builder(
                        padding: EdgeInsets.all(spacing),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: spacing,
                          mainAxisSpacing: spacing,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: viewModel.urls.length,
                        itemBuilder: (context, index) {
                          final url = viewModel.urls[index];
                          return _buildResourceCard(
                            title: url.enlaceNombre ?? 'Sin nombre',
                            url: url.url,
                            viewModel: viewModel,
                            context: context,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard({
    required String title,
    required String url,
    required ResourcesViewModel viewModel,
    required BuildContext context,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => viewModel.openUrl(url, context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.blue.shade100,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.link,
                  size: 32,
                  color: Colors.blue.shade800,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}