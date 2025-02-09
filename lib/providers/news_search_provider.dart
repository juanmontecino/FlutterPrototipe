import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_guide_2024/providers/news_provider.dart';

class NewsSearchProvider extends ChangeNotifier {
  final NewsProvider newsProvider;
  List<NewsArticle> _filteredNews = [];
  String _searchQuery = '';
  String _selectedCategory = 'Todas';
  bool _onlyLatestNews = false;
  bool _isSearching = false;
  bool _isInitialized = false;
  String _error = '';
  
  Timer? _debounceTimer;
  Future<void>? _initializationFuture;
  
  NewsSearchProvider({
    required this.newsProvider,
  }) {
    _initializationFuture = initialize();
  }

  List<NewsArticle> get filteredNews => _filteredNews;
  bool get isSearching => _isSearching;
  String get error => _error;
  String get selectedCategory => _selectedCategory;
  bool get onlyLatestNews => _onlyLatestNews;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _isSearching = true;
      notifyListeners();

      // Asegurarse de que el NewsProvider esté inicializado
      await newsProvider.ensureInitialized();

      if (newsProvider.news.isEmpty) {
        await newsProvider.loadNews();
      }

      _filteredNews = newsProvider.news;
      _isInitialized = true;
      
      newsProvider.addListener(_onNewsProviderUpdate);

    } catch (e) {
      _error = 'Error al inicializar la búsqueda: $e';
      rethrow;
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await _initializationFuture;
    }
  }

  void _onNewsProviderUpdate() {
    if (_isInitialized) {
      _performSearch();
    }
  }

  Future<void> setSearchQuery(String query) async {
    await ensureInitialized();
    _searchQuery = query.toLowerCase();
    _debounceSearch();
  }

  Future<void> setCategory(String category) async {
    await ensureInitialized();
    _selectedCategory = category;
    _performSearch();
  }

  Future<void> toggleLatestNews() async {
    await ensureInitialized();
    _onlyLatestNews = !_onlyLatestNews;
    _performSearch();
  }

  void _debounceSearch() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch();
    });
  }

  void _performSearch() {
    if (!_isInitialized) return;
    
    try {
      _isSearching = true;
      _error = '';
      notifyListeners();

      final now = DateTime.now();
      _filteredNews = newsProvider.news.where((article) {
        if (_selectedCategory != 'Todas' && 
            article.source.name != _selectedCategory) {
          return false;
        }

        final matchesSearch = _searchQuery.isEmpty ||
            article.title.toLowerCase().contains(_searchQuery) ||
            article.description.toLowerCase().contains(_searchQuery);

        if (_onlyLatestNews) {
          final publishDate = DateTime.parse(article.publishedAt);
          final difference = now.difference(publishDate);
          return matchesSearch && difference.inHours <= 168;
        }

        return matchesSearch;
      }).toList();

    } catch (e) {
      _error = 'Error al filtrar noticias: $e';
      _filteredNews = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _isInitialized = false;
    await initialize();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    newsProvider.removeListener(_onNewsProviderUpdate);
    super.dispose();
  }
}