import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LibrosProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _libros = [];
  bool _isLoading = false;
  String _error = '';

  static final String _baseUrl = dotenv.env['API_URL']!;

  List<Map<String, dynamic>> get libros => _libros;
  bool get isLoading => _isLoading;
  String get error => _error;

  LibrosProvider() {
    cargarLibros();
  }

  Future<void> cargarLibros({String tema = 'ficcion', int page = 1}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/libros?tema=$tema&page=$page'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _libros = (data['libros'] as List).map((libro) => {
          'id': libro['id'],
          'titulo': libro['titulo'],
          'autor': libro['autores']?.first ?? 'Autor desconocido',
          'descripcion': libro['descripcion'] ?? 'Sin descripción',
          'urlImagen': libro['imagenPortada'] ?? 'https://via.placeholder.com/150',
          'genero': libro['genero'] ?? 'Ficción',
          'leido': false,
        }).toList();

        _error = '';
      } else {
        _error = 'Error al cargar los libros: ${response.statusCode}';
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
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/libros/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final libro = json.decode(response.body);
        return {
          'id': libro['id'],
          'titulo': libro['titulo'],
          'autor': libro['autores']?.first ?? 'Autor desconocido',
          'descripcion': libro['descripcion'] ?? 'Sin descripción',
          'urlImagen': libro['imagenPortada'] ?? 'https://via.placeholder.com/150',
          'genero': libro['genero'] ?? 'Ficción',
          'leido': false,
        };
      } else {
        print('Error al obtener libro: ${response.statusCode}');
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
