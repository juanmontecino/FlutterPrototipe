import 'package:flutter/material.dart';
import '../mocks/news_mock.dart'; 
import '../widgets/news_card.dart'; 


class NewsSearchScreen extends StatefulWidget {
  const NewsSearchScreen({Key? key}) : super(key: key);

  @override
  _NewsSearchScreenState createState() => _NewsSearchScreenState();
}

class _NewsSearchScreenState extends State<NewsSearchScreen> {
  final _searchController = TextEditingController();
  final List<String> _categories = ['Todas', 'Tecnología', 'Finanzas', 'Deportes', 'Cultura'];
  String _selectedCategory = 'Todas';
  bool _onlyLatestNews = false;
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    // Inicialmente mostrar todos los artículos
    _searchResults = NewsArticleMock.mockData;
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el brillo actual del tema
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      style: TextStyle(
                        // Color del texto adaptativo
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Buscar noticias...',
                        hintStyle: TextStyle(
                          // Color del hint adaptativo
                          color: isDark ? Colors.white70 : Colors.grey[600],
                        ),
                        prefixIcon: Icon(Icons.search, 
                          color: isDark ? Colors.white70 : Colors.indigo),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, 
                            color: isDark ? Colors.white70 : Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch();
                          },
                        ),
                        filled: true,
                        fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? Colors.white70 : Colors.indigo,
                            width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? Colors.white70 : Colors.indigo,
                            width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark ? Colors.white : Colors.indigo,
                            width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onFieldSubmitted: (_) => _performSearch(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _performSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.indigo,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Icon(Icons.search, 
                      color: isDark ? Colors.black : Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Category chips
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                            _performSearch();
                          });
                        },
                        selectedColor: isDark ? Colors.indigo : Colors.indigo[100],
                        checkmarkColor: isDark ? Colors.white : Colors.indigo,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              GestureDetector(
                onTap: () {
                  setState(() {
                    _onlyLatestNews = !_onlyLatestNews;
                    _performSearch();
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      _onlyLatestNews ? Icons.check_circle : Icons.circle_outlined,
                      color: isDark ? Colors.white : Colors.indigo,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Solo noticias recientes',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Results section
              Expanded(
                child: _searchResults.isEmpty
                    ? Center(
                        child: Text(
                          'No se encontraron resultados',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return NewsCard(
                            article: _searchResults[index],
                            onTap: () {
                              // Implementar navegación al detalle de la noticia
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch() {
    final searchQuery = _searchController.text.toLowerCase();
    final now = DateTime.now();
    
    setState(() {
      _searchResults = NewsArticleMock.mockData.where((article) {
        // Filtrar por categoría
        if (_selectedCategory != 'Todas' && 
            article['category'] != _selectedCategory) {
          return false;
        }

        // Filtrar por búsqueda de texto
        final title = article['title'].toString().toLowerCase();
        final description = article['description'].toString().toLowerCase();
        final matchesSearch = searchQuery.isEmpty || 
            title.contains(searchQuery) || 
            description.contains(searchQuery);

        // Filtrar por noticias recientes (últimas 24 horas)
        if (_onlyLatestNews) {
          final publishDate = DateTime.parse(article['publishDate']);
          final difference = now.difference(publishDate);
          return matchesSearch && difference.inHours <= 24;
        }

        return matchesSearch;
      }).toList();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Mostrando ${_searchResults.length} resultado(s)' +
          (_selectedCategory != 'Todas' ? ' en ${_selectedCategory.toLowerCase()}' : '') +
          (_onlyLatestNews ? ' (solo recientes)' : '')
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}