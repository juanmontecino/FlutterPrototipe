import 'package:flutter/material.dart';
import 'package:flutter_guide_2024/mocks/pokemon_mock.dart';
import 'package:flutter_guide_2024/mocks/pokemon_mock_data.dart';

class ListadoScreen extends StatelessWidget {
  // Mapa que asocia tipos de Pokémon con colores
  final Map<String, Color> typeColors = {
    'fire': const Color.fromARGB(167, 248, 84, 73),
    'water': const Color.fromARGB(126, 106, 184, 248),
    'grass': const Color.fromARGB(155, 108, 196, 49),
    'electric': Colors.yellow,
    'bug': Colors.greenAccent,
    'normal': Colors.brown,
    'fighting': Colors.purple,
    'psychic': Colors.pink,
    'ghost': Colors.deepPurple,
    'dragon': Colors.deepOrange,
    // Puedes agregar más tipos si es necesario
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pokémon'),
      ),
      body: ListView.builder(
        itemCount: pokemonMockData.length,
        itemBuilder: (context, index) {
          final Pokemon pokemon = pokemonMockData[index];

          // Obtener el color basado en el primer tipo del Pokémon
          Color backgroundColor = typeColors[pokemon.types.first.type.name.toLowerCase()] ?? Colors.grey;

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            color: backgroundColor, // Aplicamos el color de fondo según el tipo
            child: ListTile(
              leading: Image.network(
                pokemon.imageUrl,
                width: 50,
                height: 50,
              ),
              title: Text(
                pokemon.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Tipos: ${pokemon.types.map((t) => t.type.name).join(", ")}"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
              onTap: () {
                final Pokemon pokemon = pokemonMockData[index];
                print(pokemon.name); // Verifica que el Pokémon correcto se pasa
                Navigator.pushNamed(
                  context, 'pokemon_detail',
                  arguments: pokemon
                );
              },
            ),
          );
        },
      ),
    );
  }
}
