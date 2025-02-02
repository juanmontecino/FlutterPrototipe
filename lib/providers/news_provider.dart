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

  List<NewsArticle> get news => _news;
  bool get isLoading => _isLoading;
  String get error => _error;
  int get totalResults => _totalResults;

  final http.Client _client;

  NewsProvider({http.Client? client}) : _client = client ?? http.Client() {
    loadNews();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  Future<void> loadNews() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final response = await _client.get(
        Uri.parse('$_baseUrl/news'), // Ajusta el endpoint según tu API
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('API Response: ${response.body}'); // Añade este log
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
}
