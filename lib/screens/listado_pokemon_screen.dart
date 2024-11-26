import 'package:flutter/material.dart';
import 'package:flutter_guide_2024/utils/pokemon_colors_utils.dart';
import 'package:flutter_guide_2024/providers/pokemon_provider.dart';
import 'package:flutter_guide_2024/widgets/pokemon/pokemon_search.dart';
import 'package:provider/provider.dart';
import 'package:flutter_guide_2024/models/pokemon_model.dart';

class ListadoScreen extends StatefulWidget {
  @override
  _ListadoScreenState createState() => _ListadoScreenState();
}

class _ListadoScreenState extends State<ListadoScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PokemonProvider>(context, listen: false);
    provider.getPokemons(); // Carga inicial de Pokémon

    // Configura scroll infinito
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !provider.isLoading) {
        provider.getPokemons(); // Carga más Pokémon al llegar al final
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pokémon'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PokemonSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: provider.isLoading && provider.listPokemons.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: provider.listPokemons.length + 1,
              itemBuilder: (context, index) {
                if (index == provider.listPokemons.length) {
                  return provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink();
                }

                final Pokemon pokemon = provider.listPokemons[index];
                Color backgroundColor =
                    PokemonColors.getColorForType(pokemon.types.first.type.name);

                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  color: backgroundColor,
                  child: ListTile(
                    leading: Image.network(
                      pokemon.sprites.frontDefault,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(
                      pokemon.name.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Tipos: ${pokemon.types.map((t) => t.type.name).join(", ")}",
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        'pokemon_detail',
                        arguments: pokemon, // Pasa el Pokémon seleccionado
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}