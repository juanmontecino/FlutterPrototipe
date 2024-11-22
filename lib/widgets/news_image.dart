// lib/widgets/news_image.dart
import 'package:flutter/material.dart';

class NewsImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;

  const NewsImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      height: height,
      width: width,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          height: height,
          width: width,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: width,
          color: Colors.grey[200],
          child: const Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}