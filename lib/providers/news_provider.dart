import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsSource {
  final String? id;
  final String name;

  NewsSource({
    this.id,
    required this.name,
  });

  factory NewsSource.fromJson(Map<String, dynamic> json) {
    return NewsSource(
      id: json['id'],
      name: json['name'],
    );
  }
}

class NewsArticle {
  final NewsSource source;
  final String? author;
  final String title;
  final String description;
  final String url;
  final String? urlToImage;
  final String publishedAt;
  final String? content;

  NewsArticle({
    required this.source,
    this.author,
    required this.title,
    required this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      source: NewsSource.fromJson(json['source'] ?? {'name': 'Desconocido'}),
      author: json['author'],
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] ?? DateTime.now().toIso8601String(),
      content: json['content'],
    );
  }
}

class NewsApiResponse {
  final String msg;
  final NewsData data;

  NewsApiResponse({
    required this.msg,
    required this.data,
  });

  factory NewsApiResponse.fromJson(Map<String, dynamic> json) {
    return NewsApiResponse(
      msg: json['msg'],
      data: NewsData.fromJson(json['data']),
    );
  }
}

class NewsData {
  final String status;
  final int totalResults;
  final List<NewsArticle> articles;

  NewsData({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: (json['articles'] as List)
          .map((article) => NewsArticle.fromJson(article))
          .toList(),
    );
  }
}

class NewsProvider extends ChangeNotifier {
  static const String _baseUrl = 'http://localhost:3000/api/v1/noticias';

  List<NewsArticle> _news = [];
  bool _isLoading = false;
  String _error = '';
  int _totalResults = 0;

  // Parámetros de búsqueda
  String _currentTema = 'argentina';
  DateTime? _desde;
  DateTime? _hasta;
  int _pageSize = 50;

  List<NewsArticle> get news => _news;
  bool get isLoading => _isLoading;
  String get error => _error;
  int get totalResults => _totalResults;
  String get currentTema => _currentTema;

  final http.Client _client;

  NewsProvider({http.Client? client}) : _client = client ?? http.Client() {
    loadNews();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Uri _buildUri({
    String? tema,
    DateTime? desde,
    DateTime? hasta,
    int? cantidad,
  }) {
    final queryParams = <String, String>{};

    // Añadir parámetros solo si tienen valor
    if (tema != null && tema.isNotEmpty) {
      queryParams['tema'] = tema;
    }

    if (desde != null) {
      queryParams['desde'] = _formatDate(desde);
    }

    if (hasta != null) {
      queryParams['hasta'] = _formatDate(hasta);
    }

    // Si se especifica cantidad, usar el endpoint específico
    if (cantidad != null) {
      return Uri.parse('$_baseUrl/news/$cantidad');
    }

    return Uri.parse('$_baseUrl/news').replace(queryParameters: queryParams);
  }

  Future<void> loadNews({
    String? tema,
    DateTime? desde,
    DateTime? hasta,
    int? cantidad,
  }) async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      // Actualizar el tema actual si se proporciona uno nuevo
      if (tema != null && tema.isNotEmpty) {
        _currentTema = tema;
      }

      // Actualizar fechas si se proporcionan
      if (desde != null) _desde = desde;
      if (hasta != null) _hasta = hasta;

      final uri = _buildUri(
        tema: _currentTema,
        desde: _desde,
        hasta: _hasta,
        cantidad: cantidad,
      );

      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final NewsApiResponse apiResponse =
            NewsApiResponse.fromJson(json.decode(response.body));

        if (apiResponse.data.status == 'ok') {
          _news = apiResponse.data.articles;
          _totalResults = apiResponse.data.totalResults;
        } else {
          throw Exception('API response status is not ok');
        }
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      _error = 'Error al cargar las noticias: ${e.toString()}';
      _news = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshNews() async {
    _news = [];
    notifyListeners();
    await loadNews();
  }

  // Método para cambiar el tema de búsqueda
  Future<void> setTema(String newTema) async {
    if (newTema != _currentTema) {
      await loadNews(tema: newTema);
    }
  }

  // Método para filtrar por rango de fechas
  Future<void> setDateRange(DateTime? startDate, DateTime? endDate) async {
    await loadNews(
      desde: startDate,
      hasta: endDate,
    );
  }

  // Método para cargar una cantidad específica de noticias
  Future<void> loadSpecificAmount(int cantidad) async {
    await loadNews(cantidad: cantidad);
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }
}
