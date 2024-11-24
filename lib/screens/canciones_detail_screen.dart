import 'package:flutter/material.dart';
import '../widgets/cancion_card.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CancionCard(
                song: cancion,
                isFavorite: esFavorita,
                onToggleFavorite: () {
                  setState(() {
                    esFavorita = !esFavorita;
                    onToggleFavorito();
                  });
                },
                onTap: () {}, // No necesitamos navegación aquí
                showDetails: true,
                width: double.infinity,
              ),
              const SizedBox(height: 16),
              // Información adicional que quieras mostrar
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información adicional',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text('Duración: ${cancion['duracion']}'),
                      Text('Álbum: ${cancion['album'] ?? 'No disponible'}'),
                      Text('Año: ${cancion['año'] ?? 'No disponible'}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}