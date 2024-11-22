import 'package:flutter/material.dart';

class PokemonColors {
  static final Map<String, Color> _typeColors = {
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
  };

  static Color getColorForType(String type) {
    return _typeColors[type.toLowerCase()] ?? Colors.grey;
  }
}