import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_guide_2024/models/pokemon_model.dart';

class PokemonProvider extends ChangeNotifier {
  List<Pokemon> listPokemons = [];
  int currentPage = 0; 
  bool isLoading = false;
  Pokemon? searchedPokemon;
  String? searchError;

  PokemonProvider() {
    print('PokemonProvider constructor');
    getPokemons(); 
  }

Future<void> getPokemons([int limit = 10]) async {
  if (isLoading) return; 

  try {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse(
        'https://pokeapi.co/api/v2/pokemon?offset=${currentPage * limit}&limit=$limit');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;

      // Obtener detalles en paralelo
      final detailFutures = results.map((item) => http.get(Uri.parse(item['url'])));
      final detailResponses = await Future.wait(detailFutures);

      for (var detailResponse in detailResponses) {
        if (detailResponse.statusCode == 200) {
          final detailData = json.decode(detailResponse.body);
          final pokemon = Pokemon.fromJson(detailData);
          listPokemons.add(pokemon);
        }
      }

      currentPage++;
    } else {
      print('Error en el servicio: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al realizar el request: $e');
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


  /// Busca un Pokémon por su ID
  Future<Pokemon?> searchPokemonById(int id) async {
    try {
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final detailData = json.decode(response.body);
        return Pokemon.fromJson(detailData);
      } else {
        searchError = 'No se encontró el Pokémon con ID: $id';
      }
    } catch (e) {
      searchError = 'Error de conexión';
      print('Error searching Pokemon: $e');
    }
    notifyListeners();
    return null;
  }

  /// Reinicia la búsqueda
  void resetSearch() {
    searchedPokemon = null;
    searchError = null;
    notifyListeners();
  }
}
