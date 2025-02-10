import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_guide_2024/models/pokemon_model.dart';

class PokemonProvider extends ChangeNotifier {
  List<Pokemon> listPokemons = [];
  int currentPage = 0;
  bool isLoading = false;
  Pokemon? searchedPokemon;
  String? searchError;

  final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

  PokemonProvider() {
    Future.delayed(Duration.zero, () => getPokemons());
  }

  Future<void> getPokemons([int limit = 10]) async {
    if (isLoading) return;

    try {
      isLoading = true;
      notifyListeners();

      final url = Uri.parse('$baseUrl/api/v1/pokemons?limit=$limit&offset=${currentPage * limit}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['data'];

        if (results == null || results.isEmpty) {
          print('La API devolvió una lista vacía o null');
          return;
        }

        List<Pokemon> tempPokemons = [];

        for (var item in results) {
          final detailResponse = await http.get(Uri.parse('$baseUrl/api/v1/pokemons/${item["name"]}'));
          if (detailResponse.statusCode == 200) {
            final detailData = json.decode(detailResponse.body);

            if (detailData['data'] == null || detailData['data']['id'] == null) {
              print('Error: Datos incompletos para ${item["name"]}');
              continue;
            }

            final pokemon = Pokemon.fromJson(detailData['data']);
            tempPokemons.add(pokemon);
          }
        }

        listPokemons.addAll(tempPokemons);
        currentPage++;
        print('Total Pokémon en la lista: ${listPokemons.length}');
      } else {
        print('Error en la solicitud HTTP: Código ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener Pokémon: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Pokemon?> searchPokemonById(int id) async {
    try {
      final url = Uri.parse('$baseUrl/api/v1/pokemons/$id'); 
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final detailData = json.decode(response.body);

        print('Datos recibidos de la API para ID $id: $detailData');

        if (detailData == null || detailData['data'] == null) {
          print('La API devolvió datos nulos para ID: $id');
          searchError = 'No se encontró el Pokémon con ID: $id';
          notifyListeners();
          return null;
        }

        final pokemon = Pokemon.fromJson(detailData['data']);
        if (pokemon.stats.isEmpty) {
          print('Advertencia: ${pokemon.name} no tiene estadísticas (stats es vacío o null).');
        }

        searchedPokemon = pokemon;
        searchError = null;
        notifyListeners();
        return pokemon;
      } else {
        searchError = 'No se encontró el Pokémon con ID: $id';
      }
    } catch (e) {
      searchError = 'Error de conexión con el servidor';
      print('Error buscando Pokémon: $e');
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