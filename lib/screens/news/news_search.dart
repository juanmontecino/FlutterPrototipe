import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/news_search_provider.dart';
import '../../widgets/news/news_card.dart';
import '../../providers/news_provider.dart';
import 'news_detail_screen.dart';

class NewsSearchScreen extends StatefulWidget {
  const NewsSearchScreen({super.key});

  @override
  State<NewsSearchScreen> createState() => _NewsSearchScreenState();
}

class _NewsSearchScreenState extends State<NewsSearchScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    // Inicializar la búsqueda
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsSearchProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Consumer<NewsSearchProvider>(
      builder: (context, searchProvider, _) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await searchProvider.refresh();
            },
            child: SafeArea(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchBar(searchProvider, isDark),
                          const SizedBox(height: 16),
                        
                          _buildLatestNewsToggle(searchProvider, isDark),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  _buildSearchResults(searchProvider, isDark),
                ],
              ),
            ),
          ),
          floatingActionButton: _buildScrollToTopButton(),
        );
      },
    );
  }

  Widget _buildSearchBar(NewsSearchProvider searchProvider, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _searchController,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: 'Buscar noticias...',
              hintStyle: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
              prefixIcon: Icon(
                Icons.search,
                color: isDark ? Colors.white70 : Colors.indigo,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: isDark ? Colors.white70 : Colors.grey,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      searchProvider.setSearchQuery('');
                    },
                  )
                : null,
              filled: true,
              fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.white70 : Colors.indigo,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.white70 : Colors.indigo,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark ? Colors.white : Colors.indigo,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (value) => searchProvider.setSearchQuery(value),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => searchProvider.refresh(),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Colors.white : Colors.indigo,
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Icon(
            Icons.refresh,
            color: isDark ? Colors.black : Colors.white,
          ),
        ),
      ],
    );
  }



  Widget _buildLatestNewsToggle(NewsSearchProvider searchProvider, bool isDark) {
    return GestureDetector(
      onTap: () => searchProvider.toggleLatestNews(),
      child: Row(
        children: [
          Icon(
            searchProvider.onlyLatestNews
                ? Icons.check_circle
                : Icons.circle_outlined,
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
    );
  }

  Widget _buildSearchResults(NewsSearchProvider searchProvider, bool isDark) {
    if (searchProvider.isSearching) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (searchProvider.error.isNotEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: isDark ? Colors.white70 : Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                searchProvider.error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => searchProvider.refresh(),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (searchProvider.filteredNews.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: isDark ? Colors.white70 : Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'No se encontraron resultados',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final article = searchProvider.filteredNews[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: NewsCard(
              article: {
                'title': article.title,
                'description': article.description,
                'imageUrl': article.urlToImage ?? '',
                'category': article.source.name,
                'publishDate': article.publishedAt,
              },
              onTap: () => _navigateToDetail(context, article),
            ),
          );
        },
        childCount: searchProvider.filteredNews.length,
      ),
    );
  }

  Widget? _buildScrollToTopButton() {
    return _scrollController.hasClients && _scrollController.offset > 1000
        ? FloatingActionButton(
            mini: true,
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: const Icon(Icons.arrow_upward),
          )
        : null;
  }

  void _navigateToDetail(BuildContext context, NewsArticle article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(
          article: {
            'title': article.title,
            'description': article.description,
            'imageUrl': article.urlToImage ?? '',
            'category': article.source.name,
            'publishDate': article.publishedAt,
            'content': article.content,
          },
        ),
      ),
    );
  }
}