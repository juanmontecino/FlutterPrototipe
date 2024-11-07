import 'package:flutter/material.dart';
import '../models/libro.dart';

class LibroScreen extends StatelessWidget {
  final Libro libro;

  const LibroScreen({super.key, required this.libro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(libro.titulo),
      ),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (libro.imagenPortada != null)
                Image.network(libro.imagenPortada!, width: 100, height: 150),
              const SizedBox(height: 16),
              Text(libro.titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(libro.autores?.join(', ') ?? '', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Text(libro.descripcion ?? '', style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}