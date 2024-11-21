import 'package:flutter/material.dart';
import 'package:flutter_guide_2024/mocks/pokemon_mock.dart';

class PokemonDetailScreen extends StatefulWidget {
  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  // Mapa que asocia tipos de Pokémon con colores
  final Map<String, Color> typeColors = {
    'fire': Colors.red,
    'water': Colors.blue,
    'grass': Colors.green,
    'electric': Colors.yellow,
    'bug': Colors.greenAccent,
    'normal': Colors.brown,
    'fighting': Colors.purple,
    'psychic': Colors.pink,
    'ghost': Colors.deepPurple,
    'dragon': Colors.deepOrange,
    // Agregar más tipos si es necesario
  };

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ancho y alto de la pantalla
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    // Obtenemos el Pokémon desde la ruta
    final Pokemon pokemon =
        ModalRoute.of(context)!.settings.arguments as Pokemon;

    // Obtenemos el color basado en el primer tipo del Pokémon
    Color backgroundColor =
        typeColors[pokemon.types.first.type.name.toLowerCase()] ?? Colors.grey;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Positioned(
              top: 40,
              left: 1,
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),

            //TEXTO TITULO
            Positioned(
              top: 90,
              left: 20,
              child: Text(pokemon.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
            ),

            //TIPO DE POKEMON
            Positioned(
              top: 140,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  (pokemon.types).map((type) => type.type.name).join(", "), 
                  style: TextStyle(color: Colors.white, fontSize: 15), 
                  textAlign: TextAlign.left,
                ),
              ),
            ),

            //POKEBALL DETALLE
            Positioned(
              top: height * 0.18,
              right: -30,
              child: Image.asset(
                'images/pokeball.png',
                height: 200,
                fit: BoxFit.fitHeight,
              ),
            ),

            Positioned(
              bottom: 0,
              child: Container(
                width: width,
                height: height * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: width * 0.3,
                              child: Text('Name', style: TextStyle(color: Colors.blueGrey, fontSize: 17)),
                            ),
                            Container(
                              child: Text(pokemon.name, style: TextStyle(color: Colors.black, fontSize: 17)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: width * 0.3,
                              child: Text('Height', style: TextStyle(color: Colors.blueGrey, fontSize: 17)),
                            ),
                            Container(
                              child: Text('${pokemon.height / 10} m', style: TextStyle(color: Colors.black, fontSize: 17)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: width * 0.3,
                              child: Text('Weight', style: TextStyle(color: Colors.blueGrey, fontSize: 17)),
                            ),
                            Container(
                              child: Text('${pokemon.weight / 10} kg', style: TextStyle(color: Colors.black, fontSize: 17)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: width * 0.3,
                              child: Text('Types', style: TextStyle(color: Colors.blueGrey, fontSize: 17)),
                            ),
                            Container(
                              child: Text(
                                pokemon.types.map((type) => type.type.name).join(", "),
                                style: TextStyle(color: Colors.black, fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: width * 0.3,
                              child: Text('Species', style: TextStyle(color: Colors.blueGrey, fontSize: 17)),
                            ),
                            Container(
                              child: Text(pokemon.species.name, style: TextStyle(color: Colors.black, fontSize: 17)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: width * 0.3,
                              child: Text('ID', style: TextStyle(color: Colors.blueGrey, fontSize: 17)),
                            ),
                            Container(
                              child: Text(pokemon.id.toString(), style: TextStyle(color: Colors.black, fontSize: 17)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),


            //IMAGEN POKEMON
            Positioned(
                top: 50, 
                left: (width / 2) - 150,
                child: Image.network(
                  pokemon.imageUrl,
                  height: 300, 
                  fit: BoxFit.fitHeight,
                ),
              ),
          ],
        ));
  }
}
