// To parse this JSON data, do
//
//     final pokemon = pokemonFromJson(jsonString);

import 'dart:convert';

Pokemon pokemonFromJson(String str) => Pokemon.fromJson(json.decode(str));

String pokemonToJson(Pokemon data) => json.encode(data.toJson());

class Pokemon {
    int height;
    int id;
    String name;
    List<Type> types;
    int weight;
    String imageUrl;
    Species species;

    Pokemon({
        required this.height,
        required this.id,
        required this.name,
        required this.types,
        required this.weight,
        required this.imageUrl,
        required this.species,
    });

    factory Pokemon.fromJson(Map<String, dynamic> json) => Pokemon(
        height: json["height"],
        id: json["id"],
        name: json["name"],
        types: List<Type>.from(json["types"].map((x) => Type.fromJson(x))),
        weight: json["weight"],
        imageUrl: json["imageUrl"],
        species: Species.fromJson(json["species"]),
    );

    Map<String, dynamic> toJson() => {
        "height": height,
        "id": id,
        "name": name,
        "types": List<dynamic>.from(types.map((x) => x.toJson())),
        "weight": weight,
        "imageUrl": imageUrl,
        "species": species
    };
}
class Species {
    String name;
    String url;

    Species({
        required this.name,
        required this.url,
    });

    factory Species.fromJson(Map<String, dynamic> json) => Species(
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
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
