import 'package:flutter/material.dart';
import 'package:flutter_guide_2024/models/pokemon_model.dart';
import 'package:flutter_guide_2024/utils/pokemon_colors_utils.dart';


class PokemonDetailsView extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailsView({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Color backgroundColor =
        PokemonColors.getColorForType(pokemon.types.first.type.name);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          _buildBackButton(context),
          _buildPokemonName(),
          _buildPokemonType(),
          _buildDetailsContainer(width, height, context),
          _buildPokemonImage(width),
          _buildPokeballBack(height)
        ],
      ),
    );
  }

  //POKEBALL DETALLE
  Widget _buildPokeballBack(double height) {
    return Positioned(
      top: height * 0.18,
      right: -30,
      child: Image.asset(
        'images/pokeball.png',
        height: 200,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 20,
      left: 1,
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildPokemonName() {
    return Positioned(
      top: 70,
      left: 20,
      child: Text(
        pokemon.name,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _buildPokemonType() {
    return Positioned(
      top: 120,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Text(
          pokemon.types.map((type) => type.type.name).join(", "),
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

Widget _buildDetailsContainer(double width, double height, BuildContext context) {
  final theme = Theme.of(context);

  return Positioned(
    bottom: 0,
    child: Container(
      width: width,
      height: height * 0.6,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        color: theme.scaffoldBackgroundColor, 
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            _buildDetailRow('Nombre', pokemon.name, width, context),
            _buildDetailRow('Altura', '${pokemon.height / 10} m', width, context),
            _buildDetailRow('Peso', '${pokemon.weight / 10} kg', width, context),
            _buildDetailRow(
              'Tipo',
              pokemon.types.map((type) => type.type.name).join(", "),
              width,
              context
            ),
            _buildDetailRow('Especie', pokemon.types.map((type) => type.type.name).join(", "), width, context),
            _buildDetailRow(
              'Numero en Pokedex(ID)', 
              pokemon.id.toString(), 
              width,
              context
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildPokemonImage(double width) {
    return Positioned(
      top: 50,
      left: (width / 2) - 150,
      child: Image.network(
        pokemon.sprites.frontDefault,
        height: 300,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, double width, BuildContext context) {
    return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinea verticalmente al inicio
        children: [
          Container(
            width: width * 0.4,
            child: Text(label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 20),
          Container(
            child: Text(value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
