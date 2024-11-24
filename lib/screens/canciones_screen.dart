import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/canciones_provider.dart';
import '../widgets/cancion_card.dart';
import '../widgets/cancion_images.dart';
import '../widgets/cancion_filtro.dart';

class ListaCancionesScreen extends StatefulWidget {
  @override
  _ListaCancionesScreenState createState() => _ListaCancionesScreenState();
}

class _ListaCancionesScreenState extends State<ListaCancionesScreen> {
  int _paginaSeleccionada = 0;
  String? _generoSeleccionado;
  final List<Map<String, dynamic>> _favoritos = [];

  void _toggleFavorito(Map<String, dynamic> cancion) {
    setState(() {
      if (_favoritos.contains(cancion)) {
        _favoritos.remove(cancion);
      } else {
        _favoritos.add(cancion);
      }
    });
  }

  void _navegarADetalle(BuildContext context, Map<String, dynamic> cancion) {
    Navigator.pushNamed(
      context,
      'canciones_detalle',
      arguments: {
        ...cancion,
        'esFavorito': _favoritos.contains(cancion),
        'onToggleFavorito': () => _toggleFavorito(cancion),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CancionesProvider>(context);
    final canciones = provider.canciones;

    final cancionesFiltradas = _generoSeleccionado == null
        ? canciones
        : canciones
            .where((cancion) => cancion['genero'] == _generoSeleccionado)
            .toList();

    final List<Widget> _paginas = [
      _ListaCancionesView(
        canciones: cancionesFiltradas,
        onToggleFavorito: _toggleFavorito,
        favoritos: _favoritos,
        onTapCancion: (cancion) => _navegarADetalle(context, cancion),
      ),
      _FavoritosView(
        favoritos: _favoritos,
        onToggleFavorito: _toggleFavorito,
        onTapCancion: (cancion) => _navegarADetalle(context, cancion),
      ),
      _FiltroGeneroView(
        canciones: canciones,
        cancionesFiltradas: cancionesFiltradas,
        generoSeleccionado: _generoSeleccionado,
        onGeneroSeleccionado: (genero) {
          setState(() {
            _generoSeleccionado = genero;
          });
        },
        onToggleFavorito: _toggleFavorito,
        favoritos: _favoritos,
        onTapCancion: (cancion) => _navegarADetalle(context, cancion),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Canciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.refrescarCanciones();
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error.isNotEmpty
              ? Center(child: Text(provider.error))
              : _paginas[_paginaSeleccionada],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaSeleccionada,
        onTap: (index) {
          setState(() {
            _paginaSeleccionada = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Canciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_list),
            label: 'Filtrar',
          ),
        ],
      ),
    );
  }
}

class _ListaCancionesView extends StatefulWidget {
  final List<Map<String, dynamic>> canciones;
  final Function(Map<String, dynamic>) onToggleFavorito;
  final Function(Map<String, dynamic>) onTapCancion;
  final List<Map<String, dynamic>> favoritos;

  const _ListaCancionesView({
    required this.canciones,
    required this.onToggleFavorito,
    required this.onTapCancion,
    required this.favoritos,
  });

  @override
  _ListaCancionesViewState createState() => _ListaCancionesViewState();
}

class _ListaCancionesViewState extends State<_ListaCancionesView> {
  String searchTerm = '';

  List<Map<String, dynamic>> get filteredCanciones {
    if (searchTerm.isEmpty) {
      return widget.canciones;
    }
    return widget.canciones.where((cancion) {
      final title = cancion['titulo']?.toString().toLowerCase() ?? '';
      final artist = cancion['artista']?.toString().toLowerCase() ?? '';
      final searchLower = searchTerm.toLowerCase();
      return title.contains(searchLower) || artist.contains(searchLower);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Agregamos el SongSwiper para las canciones destacadas
        if (widget.canciones.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Destacadas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 350,
            child: CancionSwiper(
              songs: widget.canciones.take(5).toList(),
              onSongSelected: widget.onTapCancion,
              favorites: widget.favoritos,
              onToggleFavorite: widget.onToggleFavorito,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar canción...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
            ),
          ),
        ],
        Expanded(
          child: ListView.builder(
            itemCount: filteredCanciones.length,
            itemBuilder: (context, index) {
              final cancion = filteredCanciones[index];
              return CancionCard(
                song: cancion,
                isFavorite: widget.favoritos.contains(cancion),
                onToggleFavorite: () => widget.onToggleFavorito(cancion),
                onTap: () => widget.onTapCancion(cancion),
                showDetails: false,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FavoritosView extends StatelessWidget {
  final List<Map<String, dynamic>> favoritos;
  final Function(Map<String, dynamic>) onToggleFavorito;
  final Function(Map<String, dynamic>) onTapCancion;

  const _FavoritosView({
    required this.favoritos,
    required this.onToggleFavorito,
    required this.onTapCancion,
  });

  @override
  Widget build(BuildContext context) {
    if (favoritos.isEmpty) {
      return const Center(
        child: Text('No hay favoritos.'),
      );
    }

    return ListView.builder(
      itemCount: favoritos.length,
      itemBuilder: (context, index) {
        final cancion = favoritos[index];
        return CancionCard(
          song: cancion,
          isFavorite: true,
          onToggleFavorite: () => onToggleFavorito(cancion),
          onTap: () => onTapCancion(cancion),
          showDetails: true,
        );
      },
    );
  }
}

class _FiltroGeneroView extends StatelessWidget {
  final List<Map<String, dynamic>> canciones;
  final List<Map<String, dynamic>> cancionesFiltradas;
  final String? generoSeleccionado;
  final Function(String?) onGeneroSeleccionado;
  final Function(Map<String, dynamic>) onToggleFavorito;
  final List<Map<String, dynamic>> favoritos;
  final Function(Map<String, dynamic>) onTapCancion;

  const _FiltroGeneroView({
    required this.canciones,
    required this.cancionesFiltradas,
    required this.generoSeleccionado,
    required this.onGeneroSeleccionado,
    required this.onToggleFavorito,
    required this.favoritos,
    required this.onTapCancion,
  });

  @override
  Widget build(BuildContext context) {
    final generos = canciones.map((cancion) => cancion['genero'] as String).toSet().toList();

    return Column(
      children: [
        const SizedBox(height: 16),
        FiltroGenero(
          genres: generos,
          selectedGenre: generoSeleccionado,
          onGenreSelected: onGeneroSeleccionado,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: cancionesFiltradas.length,
            itemBuilder: (context, index) {
              final cancion = cancionesFiltradas[index];
              return CancionCard(
                song: cancion,
                isFavorite: favoritos.contains(cancion),
                onToggleFavorite: () => onToggleFavorito(cancion),
                onTap: () => onTapCancion(cancion),
                showDetails: true,
              );
            },
          ),
        ),
      ],
    );
  }
}