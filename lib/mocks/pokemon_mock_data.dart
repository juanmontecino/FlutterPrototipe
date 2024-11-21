import 'pokemon_mock.dart';

final List<Pokemon> pokemonMockData = [
  Pokemon(
    height: 7, // En decímetros
    id: 1,
    name: "Bulbasaur",
    types: [
      Type(slot: 1, type: Species(name: "Grass", url: "")),
      Type(slot: 2, type: Species(name: "Poison", url: "")),
    ],
    weight: 69, // En hectogramos
    imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
    species: Species(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon-species/1/"),
  ),
  Pokemon(
    height: 6,
    id: 4,
    name: "Charmander",
    types: [
      Type(slot: 1, type: Species(name: "Fire", url: "")),
    ],
    weight: 85,
    imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png",
    species: Species(name: "charmander", url: "https://pokeapi.co/api/v2/pokemon-species/4/"),
  ),
  Pokemon(
    height: 5,
    id: 7,
    name: "Squirtle",
    types: [
      Type(slot: 1, type: Species(name: "Water", url: "")),
    ],
    weight: 90,
    imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png",
    species: Species(name: "squirtle", url: "https://pokeapi.co/api/v2/pokemon-species/7/"),
  ),
];
