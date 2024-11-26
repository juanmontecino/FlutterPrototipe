import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/libros_provider.dart';
import '../widgets/libros_cover_image.dart';

class LibroDetailScreen extends StatelessWidget {
  const LibroDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final libroId = ModalRoute.of(context)!.settings.arguments as String;
    final libro = Provider.of<LibrosProvider>(context).getLibroById(libroId);

    if (libro == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Libro no encontrado'),
        ),
      );
    }

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
}