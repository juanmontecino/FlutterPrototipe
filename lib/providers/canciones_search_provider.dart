import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api/v1';

  Future<List<Map<String, dynamic>>> getCanciones({String? genero}) async {
    try {
      final Uri url = genero != null 
          ? Uri.parse('$baseUrl/canciones?genero=$genero')
          : Uri.parse('$baseUrl/canciones');

      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> tracks = data['canciones'];
        return _procesarCanciones(tracks, genero ?? 'rock');
      } else {
        throw Exception('Error al obtener canciones: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCancionesPorCantidad(int cantidad) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/canciones/$cantidad'),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> tracks = data['canciones'];
        return _procesarCanciones(tracks, 'RKT');
      } else {
        throw Exception('Error al obtener canciones: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }


  List<Map<String, dynamic>> _procesarCanciones(List<dynamic> tracks, String genero) {
    return tracks.map<Map<String, dynamic>>((track) {
      String duracion = 'No disponible';
      if (track['duration'] != null && track['duration'] != '0') {
        int segundos = int.tryParse(track['duration'].toString()) ?? 0;
        if (segundos > 0) {
          int minutos = segundos ~/ 60;
          int segundosRestantes = segundos % 60;
          duracion = '$minutos:${segundosRestantes.toString().padLeft(2, '0')}';
        }
      }

      // Procesar artista
      String artista = 'Artista desconocido';
      if (track['artist'] != null) {
        if (track['artist'] is Map) {
          artista = track['artist']['name'] ?? 'Artista desconocido';
        } else if (track['artist'] is String) {
          artista = track['artist'];
        }
      }

      String imageUrl = 'https://via.placeholder.com/300';
      if (track['image'] != null && track['image'] is List) {
        final images = List<Map<String, dynamic>>.from(track['image']);
        if (images.isNotEmpty) {
          imageUrl = images.last['#text'] ?? imageUrl;
        }
      }

      String album = 'Álbum no disponible';
      if (track['album'] != null) {
        if (track['album'] is Map) {
          album = track['album']['title'] ?? 'Álbum no disponible';
        } else if (track['album'] is String) {
          album = track['album'];
        }
      }

      return {
        'id': track['mbid'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'titulo': track['name'] ?? 'Sin título',
        'artista': artista,
        'duracion': duracion,
        'album': album,
        'imageUrl': imageUrl,
        'genero': genero.toUpperCase(),
        'url': track['url'] ?? '',
        'año': track['date']?.toString() ?? 'Año no disponible'
      };
    }).toList();
  }
}