// buscar_libros_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/libros_provider.dart';
import '../widgets/libro_card.dart';

class BuscarLibrosScreen extends StatefulWidget {
  const BuscarLibrosScreen({super.key});

  @override
  State<BuscarLibrosScreen> createState() => _BuscarLibrosScreenState();
}

class _BuscarLibrosScreenState extends State<BuscarLibrosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  String _selectedGenre = 'Todos';
  bool? _libroLeido;

  final List<String> generos = [
    'Todos', 
    'Distopía', 
    'Realismo mágico', 
    'Fábula', 
    'Drama', 
    'Romance', 
    'Tragedia', 
    'Aventura', 
    'Histórica', 
    'Ficción contemporánea'
  ];

  void _mostrarFiltrosBottomSheet() {
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
                    'Filtros de Búsqueda',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Estado de Lectura',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<bool?>(
                          title: const Text('Todos'),
                          value: null,
                          groupValue: _libroLeido,
                          onChanged: (value) {
                            setModalState(() {
                              _libroLeido = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('Leídos'),
                          value: true,
                          groupValue: _libroLeido,
                          onChanged: (value) {
                            setModalState(() {
                              _libroLeido = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          title: const Text('No Leídos'),
                          value: false,
                          groupValue: _libroLeido,
                          onChanged: (value) {
                            setModalState(() {
                               _libroLeido = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _searchTerm = _searchController.text;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Aplicar Filtros'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Libros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _mostrarFiltrosBottomSheet,
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
              child: Text(librosProvider.error),
            );
          }

          // Filtrar libros
          final filteredLibros = librosProvider.filtrarLibros(
            searchTerm: _searchTerm,
            genero: _selectedGenre,
            leido: _libroLeido,
          );

          // Verificar si no se encontraron libros
          if (filteredLibros.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.book_outlined, 
                    size: 100, 
                    color: Colors.grey
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchTerm.isNotEmpty 
                      ? 'Libro no encontrado: "${_searchTerm}"' 
                      : 'No se encontraron libros',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600]
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Intenta con otro término de búsqueda o ajusta los filtros',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500]
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
                    arguments: libro['id'],
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