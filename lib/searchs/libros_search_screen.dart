import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/libros_provider.dart';
import '../widgets/libro_card.dart';
import 'package:diacritic/diacritic.dart';

class BuscarLibrosScreen extends StatefulWidget {
  const BuscarLibrosScreen({super.key});

  @override
  State<BuscarLibrosScreen> createState() => _BuscarLibrosScreenState();
}

class _BuscarLibrosScreenState extends State<BuscarLibrosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  // Normaliza el texto para búsqueda sin acentos ni caracteres especiales
  String normalizeText(String text) {
    return removeDiacritics(text)
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim()
        .toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Libros'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por título o autor',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchTerm.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchTerm = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
            ),
          ),
          Expanded(
            child: Consumer<LibrosProvider>(
              builder: (context, librosProvider, child) {
                if (librosProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (librosProvider.error.isNotEmpty) {
                  return Center(child: Text(librosProvider.error));
                }

                final filteredLibros = librosProvider.libros.where((libro) {
                  final tituloNormalized = normalizeText(libro['titulo']);
                  final autorNormalized = normalizeText(libro['autor']);
                  final searchNormalized = normalizeText(_searchTerm);

                  return searchNormalized.isEmpty ||
                      tituloNormalized.contains(searchNormalized) ||
                      autorNormalized.contains(searchNormalized);
                }).toList();

                if (filteredLibros.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.book_outlined, size: 100, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _searchTerm.isNotEmpty
                              ? 'Libro no encontrado: "${_searchTerm}"'
                              : 'No se encontraron libros',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Intenta con otro término de búsqueda.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[500],
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
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
                          arguments: libro,
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
