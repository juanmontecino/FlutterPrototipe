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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de libros'),
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

          return Column(
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
                child: RefreshIndicator(
                  onRefresh: librosProvider.refrescarLibros,
                  child: ListView.builder(
                    itemCount: _searchTerm.isEmpty
                        ? librosProvider.libros.length
                        : librosProvider.searchLibros(_searchTerm).length,
                    itemBuilder: (context, index) {
                      final libro = _searchTerm.isEmpty
                          ? librosProvider.libros[index]
                          : librosProvider.searchLibros(_searchTerm)[index];
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
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}