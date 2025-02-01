import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
<<<<<<< HEAD
=======
import 'package:flutter/foundation.dart' show kIsWeb;

final String apiUrl = kIsWeb 
    ? "http://localhost:3000/api/v1/libros" 
    : "http://10.0.2.2:3000/api/v1/libros";
>>>>>>> Santicchia

class LibrosProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _libros = [];
  bool _isLoading = false;
  String _error = '';

  static const String _baseUrl = 'http://10.0.2.2:3000/api/v1/libros'; 

  List<Map<String, dynamic>> get libros => _libros;
  bool get isLoading => _isLoading;
  String get error => _error;

  LibrosProvider() {
    cargarLibros();
  }

<<<<<<< HEAD
  Future<void> cargarLibros({
    String tema = 'ficcion', 
    int page = 1
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final response = await http.get(
        Uri.parse('$_baseUrl?tema=$tema&page=$page')
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _libros = (data['libros'] as List).map((libro) => {
          'id': libro['id'] ?? '',
          'titulo': libro['titulo'] ?? 'Título desconocido',
          'autor': libro['autores']?.first ?? 'Autor desconocido',
=======
  Future<void> cargarLibros({String tema = 'ficcion', int page = 1}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.get(Uri.parse('$apiUrl?tema=$tema&page=$page'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _libros = (data['libros'] as List).map((libro) => {
          'id': libro['id'].toString(),
          'titulo': libro['titulo'] ?? 'Sin título',
          'autor': (libro['autores'] is List && libro['autores'].isNotEmpty) 
              ? libro['autores'][0] 
              : 'Autor desconocido',
>>>>>>> Santicchia
          'descripcion': libro['descripcion'] ?? 'Sin descripción',
          'urlImagen': libro['imagenPortada'] ?? 'https://via.placeholder.com/150',
          'genero': libro['genero'] ?? 'Ficción',
          'leido': false
        }).toList();
<<<<<<< HEAD
        
        _error = '';
      } else {
        _error = 'Error al cargar los libros: ${response.statusCode}';
=======

        _error = '';
      } else {
        _error = 'Error ${response.statusCode}: ${response.body}';
>>>>>>> Santicchia
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
<<<<<<< HEAD
      final response = await http.get(Uri.parse('$_baseUrl/$id'));
      
      if (response.statusCode == 200) {
        final libro = json.decode(response.body);
        return {
          'id': libro['id'] ?? '',
          'titulo': libro['titulo'] ?? 'Título desconocido',
          'autor': libro['autores']?.first ?? 'Autor desconocido',
=======
      final response = await http.get(Uri.parse('$apiUrl/$id'));

      if (response.statusCode == 200) {
        final libro = json.decode(response.body);
        return {
          'id': libro['id'].toString(),
          'titulo': libro['titulo'] ?? 'Sin título',
          'autor': (libro['autores'] is List && libro['autores'].isNotEmpty) 
              ? libro['autores'][0] 
              : 'Autor desconocido',
>>>>>>> Santicchia
          'descripcion': libro['descripcion'] ?? 'Sin descripción',
          'urlImagen': libro['imagenPortada'] ?? 'https://via.placeholder.com/150',
          'genero': libro['genero'] ?? 'Ficción',
          'leido': false
        };
      } else {
<<<<<<< HEAD
        print('Error al obtener libro: ${response.statusCode}');
=======
        print('Error al obtener libro: ${response.statusCode} - ${response.body}');
>>>>>>> Santicchia
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

  List<Map<String, dynamic>> filtrarLibros({String searchTerm = '', String genero = 'Todos', bool? leido}) {
    return _libros.where((libro) {
      bool matchSearch = searchTerm.isEmpty ||
          libro['titulo'].toLowerCase().contains(searchTerm.toLowerCase()) ||
          libro['autor'].toLowerCase().contains(searchTerm.toLowerCase());

      bool matchGenero = genero == 'Todos' || libro['genero'] == genero;
      bool matchLeido = leido == null || libro['leido'] == leido;

      return matchSearch && matchGenero && matchLeido;
    }).toList();
  }
}
