import 'package:flutter/material.dart';

class PokemonColors {
  static final Map<String, Color> _typeColors = {
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
  };

  static Color getColorForType(String type) {
    return _typeColors[type.toLowerCase()] ?? Colors.grey;
  }
}