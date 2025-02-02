import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/libros_provider.dart';
import '../widgets/libros_cover_image.dart';

class LibroDetailScreen extends StatelessWidget {
  const LibroDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final libroId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Libro'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: Provider.of<LibrosProvider>(context, listen: false).getLibroById(libroId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return _buildErrorScreen(context);
          }

          final libro = snapshot.data!;
          return _buildBookDetail(context, libro);
        },
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
