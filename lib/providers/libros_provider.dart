import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

class LibrosProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _libros = [];
  bool _isLoading = false;
  String _error = '';

  List<Map<String, dynamic>> get libros => _libros;
  bool get isLoading => _isLoading;
  String get error => _error;

  LibrosProvider() {
    cargarLibros();
  }

  String get apiUrl {
    return dotenv.env['PATH'] ?? 'http://localhost:3000';
  }

  Future<void> cargarLibros() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.get(Uri.parse('$apiUrl/api/v1/libros'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['items'] != null) {
          _libros = (data['items'] as List).map((libro) {
            final volumeInfo = libro['volumeInfo'] ?? {};

            return {
              'id': libro['id'].toString(),
              'titulo': volumeInfo['title'] ?? 'Sin título',
              'autor': (volumeInfo['authors'] is List && volumeInfo['authors'].isNotEmpty)
                  ? volumeInfo['authors'][0]
                  : 'Autor desconocido',
              'descripcion': volumeInfo['description'] ?? 'Sin descripción',
              'urlImagen': (volumeInfo['imageLinks'] != null)
                  ? volumeInfo['imageLinks']['thumbnail']
                  : 'https://via.placeholder.com/150',
              'leido': false
            };
          }).toList();

          _error = '';
        } else {
          _libros = [];
          _error = 'No hay libros disponibles.';
        }
      } else {
        _error = 'Error ${response.statusCode}: ${response.body}';
        _libros = [];
      }
    } catch (e) {
      _error = 'Error de conexión: $e';
      _libros = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> getLibroById(String id) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/api/v1/libros/$id'));

      if (response.statusCode == 200) {
        final libro = json.decode(response.body);
        return {
          'id': libro['id'].toString(),
          'titulo': libro['titulo'] ?? 'Sin título',
          'autor': (libro['autores'] is List && libro['autores'].isNotEmpty)
              ? libro['autores'][0]
              : 'Autor desconocido',
          'descripcion': libro['descripcion'] ?? 'Sin descripción',
          'urlImagen': libro['imagenPortada'] ?? 'https://via.placeholder.com/150',
          'leido': false
        };
      } else {
        print('Error al obtener libro: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error de conexión: $e');
      return null;
    }
  }

  void marcarLibroComoLeido(String id, bool leido) {
    final index = _libros.indexWhere((libro) => libro['id'] == id);
    if (index != -1) {
      _libros[index]['leido'] = leido;
      notifyListeners();
    }
  }
}
