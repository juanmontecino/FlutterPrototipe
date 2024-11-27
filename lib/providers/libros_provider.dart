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
      _libros = Libro.mockData;
      _error = '';
    } catch (e) {
      _error = 'Error al cargar los libros';
      _libros = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refrescarLibros() async {
    _libros = [];
    notifyListeners();
    await cargarLibros();
  }

  List<Map<String, dynamic>> searchLibros(String searchTerm) {
    return _libros.where((libro) => libro['titulo'].toLowerCase().contains(searchTerm.toLowerCase())).toList();
  }

  Map<String, dynamic>? getLibroById(String id) {
    try {
      return _libros.firstWhere((libro) => libro['id'] == id);
    } catch (e) {
      return null;
    }
  }
}