import 'package:flutter/material.dart';
import 'package:flutter_guide_2024/mocks/libros_mock.dart';

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

  Future<void> cargarLibros() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await Future.delayed(const Duration(seconds: 1));
      _libros = Libro.mockData.map((libro) => {
        ...libro,
        'leido': false 
      }).toList();
      _error = '';
    } catch (e) {
      _error = 'Error al cargar los libros';
      _libros = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Map<String, dynamic>? getLibroById(String id) {
 
    final stringId = id.toString();
    
    print('Buscando libro con ID: $stringId');
    print('Libros disponibles: ${_libros.map((l) => l['id'])}');

    try {
      return _libros.firstWhere(
        (libro) => libro['id'].toString() == stringId,
        orElse: () => throw Exception('Libro no encontrado')
      );
    } catch (e) {
      print('Error al buscar libro: $e');
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

  List<Map<String, dynamic>> filtrarLibros({
    String searchTerm = '', 
    String genero = 'Todos', 
    bool? leido
  }) {
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