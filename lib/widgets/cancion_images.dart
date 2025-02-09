import 'package:flutter/material.dart';

class CancionSwiper extends StatelessWidget {
  final List<Map<String, dynamic>> songs;
  final Function(Map<String, dynamic>) onSongSelected;
  final List<Map<String, dynamic>> favorites;
  final Function(Map<String, dynamic>) onToggleFavorite;

  const CancionSwiper({
    super.key,
    required this.songs,
    required this.onSongSelected,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: songs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final song = songs[index];
        final isFavorite = favorites.contains(song);
        
        return Card(
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                song['imageUrl'] ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.music_note),
                  );
                },
              ),
            ),
            title: Text(
              song['titulo'] ?? 'Sin título',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(song['artista'] ?? 'Artista desconocido'),
                Text(song['album'] ?? 'Álbum desconocido'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () => onToggleFavorite(song),
            ),
            onTap: () => onSongSelected(song),
          ),
        );
      },
    );
  }
}