import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LibrosProvider with ChangeNotifier {
  List<Map<String, dynamic>> _libros = [];
  String _error = '';
  bool _isLoading = false;

  // URL directa como fallback
  final String apiUrl = dotenv.env['PATH'] ?? "http://localhost:3000/api/v1/libros";

  List<Map<String, dynamic>> get libros => _libros;
  String get error => _error;
  bool get isLoading => _isLoading;

  Future<void> cargarLibros() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      debugPrint('📚 Cargando libros desde: $apiUrl');
      
      final response = await http.get(Uri.parse(apiUrl));
      
      debugPrint('📝 Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('✅ Datos recibidos correctamente');

        if (data['libros'] != null && data['libros'] is List) {
          _libros = (data['libros'] as List).map((libro) {
            return {
              'id': libro['id']?.toString() ?? '0',
              'titulo': libro['titulo'] ?? 'Sin título',
              'autor': (libro['autores'] is List && libro['autores'].isNotEmpty)
                  ? libro['autores'][0]
                  : 'Autor desconocido',
              'descripcion': libro['descripcion'] ?? 'Sin descripción',
              'urlImagen': libro['imagenPortada']?.replaceFirst('http:', 'https:') ?? 
                  'https://via.placeholder.com/150',
            };
          }).toList();
          
          debugPrint('📚 Libros cargados: ${_libros.length}');
        } else {
          _libros = [];
          _error = 'No se encontraron libros en la respuesta.';
          debugPrint('⚠️ No se encontraron libros en la respuesta');
        }
      } else {
        _error = 'Error ${response.statusCode}: ${response.reasonPhrase}';
        _libros = [];
        debugPrint('❌ Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
      _error = 'Error de conexión: $e';
      _libros = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}