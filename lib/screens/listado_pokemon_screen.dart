import 'package:flutter/material.dart';
import 'package:flutter_guide_2024/mocks/pokemon_mock.dart';
import 'package:flutter_guide_2024/mocks/pokemon_mock_data.dart';
import 'package:flutter_guide_2024/utils/pokemon_colors_utils.dart';

class ListadoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pokemon'),
      ),
      body: ListView.builder(
        itemCount: pokemonMockData.length,
        itemBuilder: (context, index) {
          final Pokemon pokemon = pokemonMockData[index];
          Color backgroundColor = PokemonColors.getColorForType(pokemon.types.first.type.name); 

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            color: backgroundColor, 
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