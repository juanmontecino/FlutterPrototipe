import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_guide_2024/providers/pokemon_provider.dart';
import 'package:flutter_guide_2024/models/pokemon_model.dart';
import 'package:flutter_guide_2024/utils/pokemon_colors_utils.dart';

class PokemonSearchDelegate extends SearchDelegate<Pokemon?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context, listen: false);
    final searchId = int.tryParse(query);

    if (searchId == null) {
      return const Center(
        child: Text('Por favor ingresa un número válido'),
      );
    }

    return FutureBuilder<Pokemon?>(
      future: provider.searchPokemonById(searchId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final pokemon = snapshot.data;
        if (pokemon == null) {
          return const Center(
            child: Text('Pokémon no encontrado'),
          );
        }
        final backgroundColor = PokemonColors.getColorForType(
            pokemon.types.isNotEmpty ? pokemon.types.first.type.name : 'normal');

        final imageUrl = pokemon.sprites.frontDefault ??
            'https://via.placeholder.com/150';

        return ListTile(
          tileColor: backgroundColor,
          leading: Image.network(imageUrl),
          title: Text(
            pokemon.name.toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            "Tipos: ${pokemon.types.map((t) => t.type.name).join(", ")}",
            style: const TextStyle(color: Colors.white70),
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              'pokemon_detail',
              arguments: pokemon,
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Busca un Pokémon por su número de Pokédex'),
    );
  }
}