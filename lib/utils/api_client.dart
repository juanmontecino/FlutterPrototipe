import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/libro.dart';

class ApiClient {
  static Future<List<Libro>> fetchLibros(String libro) async {
    final response = await http.get(Uri.parse('/api/v1/libros?libro=$libro'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['libros'] as List)
          .map((item) => Libro.fromJson(item))
          .toList();
    } else {
      throw Exception('Error al obtener los libros');
    }
  }
}