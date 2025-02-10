import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/news_provider.dart';
import 'news_detail_screen.dart';
import '../../widgets/news/news_card.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  Future<void>? _initializationFuture;

  @override
  void initState() {
    super.initState();
    // Inicializar el future después de que el widget esté montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializationFuture = context.read<NewsProvider>().ensureInitialized();
      setState(() {});
    });
  }

  Map<String, dynamic> _convertArticleToMap(NewsArticle article) {
    return {
      'imageUrl': article.urlToImage ?? 'https://via.placeholder.com/600x400', // URL por defecto
      'category': article.source.name,
      'publishDate': article.publishedAt,
      'title': article.title,
      'description': article.description.isNotEmpty
          ? article.description
          : 'No hay descripción disponible',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error de inicialización: ${snapshot.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _initializationFuture = context
                          .read<NewsProvider>()
                          .ensureInitialized();
                    });
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        return Consumer<NewsProvider>(
          builder: (context, newsProvider, child) {
            // Verificar si hay un error en el provider
            if (newsProvider.error.isNotEmpty && newsProvider.news.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(newsProvider.error),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => newsProvider.loadNews(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: newsProvider.refreshNews,
              child: Column(
                children: [
                  if (newsProvider.isLoading)
                    const LinearProgressIndicator(),
                  if (newsProvider.totalResults > 0)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total de noticias disponibles: ${newsProvider.totalResults}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  if (newsProvider.news.isEmpty && !newsProvider.isLoading)
                    const Expanded(
                      child: Center(
                        child: Text('No hay noticias disponibles'),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: newsProvider.news.length,
                        itemBuilder: (context, index) {
                          final article = newsProvider.news[index];
                          return NewsCard(
                            article: _convertArticleToMap(article),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDetailScreen(
                                    article: _convertArticleToMap(article),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}