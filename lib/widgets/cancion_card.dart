import 'package:flutter/material.dart';

class CancionCard extends StatelessWidget {
  final Map<String, dynamic> song;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;
  final double? width;
  final bool showDetails;

  const CancionCard({
    super.key,
    required this.song,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onTap,
    this.width,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Image.network(
                  song['imageUrl'],
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: onToggleFavorite,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song['titulo'],
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song['artista'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (showDetails) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Género: ${song['genero']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Duración: ${song['duracion']}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            TextButton(
              onPressed: onTap,
              child: const Text('Ver detalles'),
            ),
          ],
        ),
      ),
    );
  }
}