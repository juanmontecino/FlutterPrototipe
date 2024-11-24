import 'package:flutter/material.dart';

class DetalleCancionScreen extends StatefulWidget {
  const DetalleCancionScreen({Key? key}) : super(key: key);

  @override
  _DetalleCancionScreenState createState() => _DetalleCancionScreenState();
}

class _DetalleCancionScreenState extends State<DetalleCancionScreen> {
  late bool esFavorita;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      setState(() {
        esFavorita = args['esFavorito'] ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final cancion = args;
    final onToggleFavorito = args['onToggleFavorito'] as Function;

    return Scaffold(
      appBar: AppBar(
        title: Text(cancion['titulo']),
        actions: [
          IconButton(
            icon: Icon(
              esFavorita ? Icons.favorite : Icons.favorite_border,
              color: esFavorita ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                esFavorita = !esFavorita;
                onToggleFavorito();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(cancion['imageUrl']),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                cancion['titulo'],
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SwitchListTile(
              value: esFavorita,
              onChanged: (valor) {
                setState(() {
                  esFavorita = valor;
                  onToggleFavorito();
                });
              },
              title: const Text('Favorita'),
            ),
            const SizedBox(height: 16),
            Text('Artista: ${cancion['artista']}'),
            Text('Género: ${cancion['genero']}'),
            Text('Duración: ${cancion['duracion']}'),
          ],
        ),
      ),
    );
  }
}