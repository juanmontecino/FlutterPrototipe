import 'package:flutter/material.dart';
import 'package:flutter_guide_2024/mocks/pokemon_mock.dart';
import 'package:flutter_guide_2024/utils/pokemon_colors_utils.dart';
import 'package:flutter_guide_2024/widgets/pokemon/pokemon_details_view.dart';
import 'package:flutter_guide_2024/widgets/pokemon/pokemon_form_view.dart';

class PokemonDetailScreen extends StatefulWidget {
  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Pokemon pokemon = ModalRoute.of(context)!.settings.arguments as Pokemon;

    List<Widget> _widgetOptions = <Widget>[
      PokemonDetailsView(pokemon: pokemon),
      PokemonFormView(pokemon: pokemon),
    ];

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.catching_pokemon),
            label: 'Detalles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Notas del Entrenador',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: PokemonColors.getColorForType(pokemon.types.first.type.name),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}