import 'package:flutter/material.dart';
import '../mocks/news_mock.dart';

class NewsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _news = [];
  bool _isLoading = false;
  String _error = '';

  List<Map<String, dynamic>> get news => _news;
  bool get isLoading => _isLoading;
  String get error => _error;

  NewsProvider() {
    loadNews();
  }

  Future<void> loadNews() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulamos una llamada a API
      await Future.delayed(const Duration(seconds: 1));
      _news = NewsArticleMock.mockData;
      _error = '';
      
    } catch (e) {
      _error = 'Error al cargar las noticias';
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