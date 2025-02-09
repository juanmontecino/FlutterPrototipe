import 'package:flutter/material.dart';
import '../../widgets/news/news_image.dart';
import '../../helpers/date_helper.dart';

class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;

  const NewsDetailScreen({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['category'] ?? 'Noticia'),
        backgroundColor: Colors.indigo[900],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Diseño responsive basado en el ancho de la pantalla
          if (constraints.maxWidth > 800) {
            return _buildWideLayout(context, constraints);
          }
          return _buildNormalLayout(context);
        },
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight * 0.6, // 60% de la altura de la pantalla
            ),
            width: double.infinity,
            child: NewsImage(
              imageUrl: article['imageUrl'],
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: constraints.maxWidth * 0.8, // 80% del ancho de la pantalla
              child: _buildContent(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NewsImage(
            imageUrl: article['imageUrl'],
            height: 250,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article['title'],
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          DateHelper.getTimeAgo(
            DateTime.parse(article['publishDate']),
          ),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDark ? Colors.white70 : Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          article['description'],
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}