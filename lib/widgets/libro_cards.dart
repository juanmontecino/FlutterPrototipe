import 'package:flutter/material.dart';
import '../models/libro.dart';
import '../screens/libro_screen.dart';

class LibroCard extends StatelessWidget {
  final Libro libro;

  const LibroCard({super.key, required this.libro});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LibroScreen(libro: libro)),
        );
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (libro.imagenPortada != null)
                Image.network(libro.imagenPortada!, width: 80, height: 120),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(libro.titulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(libro.autores?.join(', ') ?? '', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}