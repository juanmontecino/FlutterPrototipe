import 'package:flutter/material.dart';
import '../helpers/date_helper.dart';

class NewsCard extends StatelessWidget {
  final Map<String, dynamic> article;
  final VoidCallback? onTap;

  const NewsCard({
    super.key,
    required this.article,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 8),
                  _buildTitle(),
                  const SizedBox(height: 8),
                  _buildDescription(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = article['imageUrl'] as String?;
    
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildPlaceholderImage();
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: _loadingBuilder,
          errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 48,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        CategoryChip(category: article['category'] as String),
        const Spacer(),
        Text(
          DateHelper.getTimeAgo(DateTime.parse(article['publishDate'] as String)),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      article['title'] as String,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      article['description'] as String,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _loadingBuilder(BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
      ),
    );
  }

  Widget _errorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    return const Center(
      child: Icon(Icons.error_outline, size: 40),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String category;

  const CategoryChip({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.indigo[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: Colors.indigo[900],
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}