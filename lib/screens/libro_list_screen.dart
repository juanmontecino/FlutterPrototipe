import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:diacritic/diacritic.dart';
import '../providers/libros_provider.dart';
import '../widgets/libro_card.dart';

class LibrosListScreen extends StatefulWidget {
  const LibrosListScreen({super.key});

  @override
  State<LibrosListScreen> createState() => _LibrosListScreenState();
}

class _LibrosListScreenState extends State<LibrosListScreen> {
  String _searchTerm = '';

  void _showSearchBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Buscar Libros',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar por título o autor',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchTerm.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setModalState(() {
                                  _searchTerm = '';
                                });
                                setState(() {}); // Actualizar la lista
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setModalState(() {
                        _searchTerm = value;
                      });
                      setState(() {}); // Actualizar la lista en tiempo real
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Aplicar búsqueda
                      Navigator.pop(context);
                    },
                    child: const Text('Buscar'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// **Normaliza el texto para mejorar la comparación**
  String normalizeText(String text) {
    return removeDiacritics(text) // Quitar acentos
        .replaceAll(RegExp(r'[^\w\s]'), '') // Quitar caracteres especiales
        .trim()
        .toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final librosProvider = Provider.of<LibrosProvider>(context);

    if (librosProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (librosProvider.error.isNotEmpty) {
      return Center(
        child: Text(librosProvider.error),
      );
    }

    final filteredLibros = librosProvider.libros.where((libro) {
      final tituloNormalized = normalizeText(libro['titulo']);
      final autorNormalized = normalizeText(libro['autor']);
      final searchNormalized = normalizeText(_searchTerm);

      return searchNormalized.isEmpty ||
          tituloNormalized.contains(searchNormalized) ||
          autorNormalized.contains(searchNormalized);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista De Libros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchBottomSheet,
          ),
        ],
      ),
      body: filteredLibros.isEmpty
          ? const Center(child: Text('No se encontraron libros'))
          : ListView.builder(
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
            ),
    );
  }
}
