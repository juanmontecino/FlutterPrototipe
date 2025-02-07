import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CancionesProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Map<String, dynamic>> _canciones = [];
  bool _isLoading = false;
  String _error = '';
  String _generoActual = 'rock'; //generopor defecto

  //lista de generos disponibles
  final List<String> generos = [
    'rock',
    'pop',
    'jazz',
    'classical',
    'electronic',
    'hip-hop',
    'metal',
    'RKT',
    'indie'
  ];

  List<Map<String, dynamic>> get canciones => _canciones;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get generoActual => _generoActual;

  CancionesProvider() {
    cargarCanciones();
  }

  Future<void> cargarCanciones({String? genero}) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      if (genero != null) {
        _generoActual = genero;
      }

      _canciones = await _apiService.getCanciones(genero: _generoActual);
    } catch (e) {
      _error = e.toString();
      _canciones = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cambiarGenero(String nuevoGenero) async {
    if (nuevoGenero != _generoActual) {
      await cargarCanciones(genero: nuevoGenero);
    }
  }

  Future<void> cargarCancionesPorCantidad(int cantidad) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _canciones = await _apiService.getCancionesPorCantidad(cantidad);
    } catch (e) {
      _error = e.toString();
      _canciones = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refrescarCanciones() async {
    await cargarCanciones(genero: _generoActual);
  }
}