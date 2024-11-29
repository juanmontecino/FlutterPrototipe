import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/libros_provider.dart';
import '../widgets/libro_card.dart';

class LibrosListScreen extends StatefulWidget {
  const LibrosListScreen({super.key});

  @override
  State<LibrosListScreen> createState() => _LibrosListScreenState();
}

class _LibrosListScreenState extends State<LibrosListScreen> {
  String _searchTerm = '';
  String _selectedGenre = 'Todos';
  final List<String> _genres = [
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setModalState(() {
                        _searchTerm = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Filtrar por Género',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Wrap(
                    spacing: 8,
                    children: _genres.map((genre) {
                      return ChoiceChip(
                        label: Text(genre),
                        selected: _selectedGenre == genre,
                        onSelected: (selected) {
                          setModalState(() {
                            _selectedGenre = selected ? genre : 'Todos';
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<LibrosProvider>(context, listen: false).cargarLibros(
                        tema: _selectedGenre == 'Todos' ? 'ficcion' : _selectedGenre
                      );
                      setState(() {});
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
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista De Libros'),
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
          final filteredLibros = librosProvider.libros.where((libro) {
            bool matchesSearch = _searchTerm.isEmpty || 
              libro['titulo'].toLowerCase().contains(_searchTerm.toLowerCase()) ||
              libro['autor'].toLowerCase().contains(_searchTerm.toLowerCase());
            
            bool matchesGenre = _selectedGenre == 'Todos' || libro['genero'] == _selectedGenre;
            
            return matchesSearch && matchesGenre;
          }).toList();

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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Libros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            _showSearchBottomSheet();
          }
        },
      ),
    );
  }
}