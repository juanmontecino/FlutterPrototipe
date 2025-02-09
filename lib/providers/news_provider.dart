import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  String? _baseUrl;
  List<NewsArticle> _news = [];
  bool _isLoading = false;
  String _error = '';
  int _totalResults = 0;
  bool _isInitialized = false;

  // Parámetros de búsqueda
  String _currentTema = 'argentina';
  DateTime? _desde;
  DateTime? _hasta;
  final int _pageSize = 50;

  List<NewsArticle> get news => _news;
  bool get isLoading => _isLoading;
  String get error => _error;
  int get totalResults => _totalResults;
  String get currentTema => _currentTema;
  bool get isInitialized => _isInitialized;

  final http.Client _client;

  NewsProvider({http.Client? client}) : _client = client ?? http.Client();

  Future<void> ensureInitialized() async {
    if (_isInitialized) return;

    try {
      // Cargar variables de entorno
      await dotenv.load();
      _baseUrl = dotenv.env['PATH'];
      
      if (_baseUrl == null) {
        throw Exception('URL base no encontrada en .env');
      }

      // Intentar cargar noticias iniciales
      await loadNews();
      _isInitialized = true;
    } catch (e) {
      _error = 'Error de inicialización: ${e.toString()}';
      print('Error en ensureInitialized: $_error'); // Para debugging
      rethrow;
    }
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
    if (_baseUrl == null) {
      throw Exception('Provider no inicializado');
    }

    final queryParams = <String, String>{};

    if (tema != null && tema.isNotEmpty) {
      queryParams['tema'] = tema;
    }

    if (desde != null) {
      queryParams['desde'] = _formatDate(desde);
    }

    if (hasta != null) {
      queryParams['hasta'] = _formatDate(hasta);
    }

    final baseEndpoint = '$_baseUrl/api/v1/noticias';
    
    if (cantidad != null) {
      return Uri.parse('$baseEndpoint/news/$cantidad');
    }

    return Uri.parse('$baseEndpoint/news').replace(queryParameters: queryParams);
  }

  Future<void> loadNews({
    String? tema,
    DateTime? desde,
    DateTime? hasta,
    int? cantidad,
  }) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      if (tema != null && tema.isNotEmpty) {
        _currentTema = tema;
      }

      if (desde != null) _desde = desde;
      if (hasta != null) _hasta = hasta;

      final uri = _buildUri(
        tema: _currentTema,
        desde: _desde,
        hasta: _hasta,
        cantidad: cantidad,
      );

      print('Requesting URL: $uri'); // Para debugging

      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}'); // Para debugging
      print('Response body: ${response.body}'); // Para debugging

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        
        // Verificar la estructura de la respuesta
        if (decodedData['data'] != null) {
          final NewsApiResponse apiResponse = NewsApiResponse.fromJson(decodedData);

          if (apiResponse.data.status == 'ok') {
            _news = apiResponse.data.articles;
            _totalResults = apiResponse.data.totalResults;
          } else {
            throw Exception('API response status is not ok');
          }
        } else {
          throw Exception('Formato de respuesta inválido');
        }
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      _error = 'Error al cargar las noticias: ${e.toString()}';
      print('Error en loadNews: $_error'); // Para debugging
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

  Future<void> setTema(String newTema) async {
    if (newTema != _currentTema) {
      await loadNews(tema: newTema);
    }
  }

  Future<void> setDateRange(DateTime? startDate, DateTime? endDate) async {
    await loadNews(
      desde: startDate,
      hasta: endDate,
    );
  }

  Future<void> loadSpecificAmount(int cantidad) async {
    await loadNews(cantidad: cantidad);
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }
}