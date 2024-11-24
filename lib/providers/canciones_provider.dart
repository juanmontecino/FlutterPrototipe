import 'package:flutter/material.dart';
import '../mocks/canciones_mock.dart';

class CancionesProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _canciones = [];
  bool _isLoading = false;
  String _error = '';

  List<Map<String, dynamic>> get canciones => _canciones;
  bool get isLoading => _isLoading;
  String get error => _error;

  CancionesProvider() {
    cargarCanciones();
  }

  Future<void> cargarCanciones() async {
    try {
      _isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));
      _canciones = CancionMock.mockData;
      _error = '';
    } catch (e) {
      _error = 'Error al cargar las canciones';
      _canciones = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refrescarCanciones() async {
    _canciones = [];
    notifyListeners();
    await cargarCanciones();
  }
}
