// lib/screens/news_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';
import '../screens/news_detail_screen.dart';

class NewsListScreen extends StatelessWidget {
  const NewsListScreen({super.key});

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
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: newsProvider.news.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final article = newsProvider.news[index];
              return NewsCard(
                article: article,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailScreen(
                        article: article,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}