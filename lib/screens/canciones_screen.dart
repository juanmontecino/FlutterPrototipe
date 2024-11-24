import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/canciones_provider.dart';
import './canciones_detail_screen.dart';

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

class _ListaCancionesView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: canciones.length,
      itemBuilder: (context, index) {
        final cancion = canciones[index];
        final esFavorito = favoritos.contains(cancion);
        return ListTile(
          leading: Image.network(cancion['imageUrl']),
          title: Text(cancion['titulo']),
          subtitle: Text('${cancion['artista']} • ${cancion['genero']}'),
          trailing: IconButton(
            icon: Icon(
              esFavorito ? Icons.favorite : Icons.favorite_border,
              color: esFavorito ? Colors.red : null,
            ),
            onPressed: () => onToggleFavorito(cancion),
          ),
          onTap: () => onTapCancion(cancion),
        );
      },
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
        return ListTile(
          leading: Image.network(cancion['imageUrl']),
          title: Text(cancion['titulo']),
          subtitle: Text('${cancion['artista']} • ${cancion['genero']}'),
          trailing: IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () => onToggleFavorito(cancion),
          ),
          onTap: () => onTapCancion(cancion),
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
    final generos = canciones.map((cancion) => cancion['genero']).toSet().toList();

    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          'Filtrar por género:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              FilterChip(
                label: const Text('Todos'),
                selected: generoSeleccionado == null,
                onSelected: (_) => onGeneroSeleccionado(null),
              ),
              ...generos.map(
                (genero) => FilterChip(
                  label: Text(genero),
                  selected: genero == generoSeleccionado,
                  onSelected: (_) => onGeneroSeleccionado(genero),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: cancionesFiltradas.length,
            itemBuilder: (context, index) {
              final cancion = cancionesFiltradas[index];
              final esFavorito = favoritos.contains(cancion);
              return ListTile(
                leading: Image.network(cancion['imageUrl']),
                title: Text(cancion['titulo']),
                subtitle: Text('${cancion['artista']} • ${cancion['genero']}'),
                trailing: IconButton(
                  icon: Icon(
                    esFavorito ? Icons.favorite : Icons.favorite_border,
                    color: esFavorito ? Colors.red : null,
                  ),
                  onPressed: () => onToggleFavorito(cancion),
                ),
                onTap: () => onTapCancion(cancion),
              );
            },
          ),
        ),
      ],
    );
  }
}