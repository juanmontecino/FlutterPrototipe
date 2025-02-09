import 'package:flutter/material.dart';

class LibroDetailScreen extends StatelessWidget {
  const LibroDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> libro =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(libro['titulo']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  libro['urlImagen'],
                  height: 300,
                  width: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 150);
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                libro['titulo'],
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Autor: ${libro['autor']}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                libro['descripcion'],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 100, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Libro no encontrado',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.red),
          ),
          const SizedBox(height: 8),
          Text(
            'El libro solicitado no existe en la biblioteca.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookDetail(BuildContext context, Map<String, dynamic> libro) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: LibroCoverImage(
              imageUrl: libro['urlImagen'],
              height: 300,
              width: 200,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            libro['titulo'],
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            libro['autor'],
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Text(
            libro['descripcion'],
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
