import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/libros_provider.dart';
import '../widgets/libro_card.dart';

class LibrosSearchScreen extends StatefulWidget {
  const LibrosSearchScreen({super.key});

  @override
  State<LibrosSearchScreen> createState() => _LibrosSearchScreenState();
}

class _LibrosSearchScreenState extends State<LibrosSearchScreen> {
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar libros'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar libros...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<LibrosProvider>(
              builder: (context, librosProvider, child) {
                final filteredLibros = librosProvider.searchLibros(_searchTerm);

                if (_searchTerm.isNotEmpty && filteredLibros.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron resultados'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredLibros.length,
                  itemBuilder: (context, index) {
                    final libro = filteredLibros[index];
                    return LibroCard(
                      libro: libro,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          'libro_detail',
                          arguments: libro['id'],
                        );
                      },
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
}
