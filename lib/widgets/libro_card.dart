// libro_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/libros_cover_image.dart';
import '../providers/libros_provider.dart';

class LibroCard extends StatelessWidget {
  final Map<String, dynamic> libro;
  final VoidCallback onTap;

  const LibroCard({
    super.key,
    required this.libro,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LibrosProvider>(
      builder: (context, librosProvider, child) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LibroCoverImage(
                    imageUrl: libro['urlImagen'],
                    onTap: onTap,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          libro['titulo'],
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          libro['autor'],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: libro['leido'] ?? false,
                        onChanged: (bool? newValue) {
                          librosProvider.marcarLibroComoLeido(
                            libro['id'], 
                            newValue ?? false
                          );
                        },
                      ),
                      Text(
                        'Leído',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}