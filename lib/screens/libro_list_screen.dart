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
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      Provider.of<LibrosProvider>(context, listen: false).cargarLibros();
      _initialized = true;
    }
  }

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
                                setState(() {});
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
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
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
        title: const Text('Lista De Libros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchBottomSheet,
          ),
          // Añadimos un botón de recarga
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<LibrosProvider>(context, listen: false).cargarLibros();
            },
          ),
        ],
      ),
      body: Consumer<LibrosProvider>(
        builder: (context, librosProvider, child) {
          if (librosProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (librosProvider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar los libros',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      librosProvider.error,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      librosProvider.cargarLibros();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
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

          if (filteredLibros.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.book_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchTerm.isNotEmpty
                        ? 'No se encontraron libros que coincidan con "$_searchTerm"'
                        : 'No hay libros disponibles',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (_searchTerm.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _searchTerm = '';
                        });
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('Limpiar búsqueda'),
                    ),
                  ],
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
    );
  }
}