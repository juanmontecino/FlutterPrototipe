// To parse this JSON data, do
//
//     final pokemon = pokemonFromJson(jsonString);

import 'dart:convert';

Pokemon pokemonFromJson(String str) => Pokemon.fromJson(json.decode(str));

String pokemonToJson(Pokemon data) => json.encode(data.toJson());

class Pokemon {
  int id;
  String name;
  Sprites sprites;
  List<Type> types;
  List<Stat> stats;
  int height;
  int weight;

  Pokemon({
    required this.id,
    required this.name,
    required this.sprites,
    required this.types,
    required this.stats,
    required this.height,
    required this.weight,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Desconocido',
      height: json['height'] ?? 1,
      weight: json['weight'] ?? 1,
      sprites: Sprites.fromJson(json['sprites'] ?? {}),
      types: (json['types'] as List?)?.map((e) => Type.fromJson(e)).toList() ?? [],
      stats: (json['stats'] as List?)?.map((e) => Stat.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sprites": sprites.toJson(),
        "types": List<dynamic>.from(types.map((x) => x.toJson())),
        "stats": List<dynamic>.from(stats.map((x) => x.toJson())),
        "height": height,
        "weight": weight,
      };
}

class Sprites {
  String frontDefault;

  Sprites({
    required this.frontDefault,
  });

  factory Sprites.fromJson(Map<String, dynamic> json) => Sprites(
        frontDefault: json["front_default"],
      );

  Map<String, dynamic> toJson() => {
        "front_default": frontDefault,
      };
}

class Type {
  int slot;
  Species type;

  Type({
    required this.slot,
    required this.type,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        slot: json["slot"],
        type: Species.fromJson(json["type"]),
      );

  Map<String, dynamic> toJson() => {
        "slot": slot,
        "type": type.toJson(),
      };
}

class Stat {
  int baseStat;
  String name;

  Stat({
    required this.baseStat,
    required this.name,
  });

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
        baseStat: json["base_stat"],
        name: json["stat"]["name"],
      );

  Map<String, dynamic> toJson() => {
        "base_stat": baseStat,
        "name": name,
      };
}

class Species {
  String name;

  Species({
    required this.name,
  });

  factory Species.fromJson(Map<String, dynamic> json) => Species(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
