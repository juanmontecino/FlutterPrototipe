import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import '../screens/news_detail_screen.dart';
import '../widgets/news_card.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

  Map<String, dynamic> _convertArticleToMap(NewsArticle article) {
    return {
      'imageUrl': article.urlToImage, // Imagen por defecto
      'category': article.source.name,
      'publishDate': article.publishedAt,
      'title': article.title,
      'description': article.description.isNotEmpty
          ? article.description
          : 'No hay descripción disponible', // Valor por defecto
    };
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.isLoading && newsProvider.news.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

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
                  onPressed: newsProvider.loadNews,
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
              if (newsProvider.totalResults > 0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total de noticias disponibles: ${newsProvider.totalResults}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
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
  }
}
