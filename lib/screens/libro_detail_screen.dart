import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/libros_provider.dart';
import '../widgets/libros_cover_image.dart';

class LibroDetailScreen extends StatelessWidget {
  const LibroDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final libroId = ModalRoute.of(context)!.settings.arguments as String;
    final Future<Map<String, dynamic>?> libroFuture = Provider.of<LibrosProvider>(context).getLibroById(libroId);


    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>?>(
          future: libroFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return Text(snapshot.data!['title']);
            }
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: libroFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          } else {
            final libro = snapshot.data!;
            return SingleChildScrollView(
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
                      libro['title'],
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      libro['author'],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      libro['description'],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
