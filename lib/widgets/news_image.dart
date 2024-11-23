import 'package:flutter/material.dart';

class NewsImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;

  const NewsImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Image.network(
          imageUrl,
          height: height,
          width: width ?? constraints.maxWidth,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              height: height,
              width: width ?? constraints.maxWidth,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: height,
              width: width ?? constraints.maxWidth,
              color: Colors.grey[200],
              child: const Icon(
                Icons.broken_image_outlined,
                size: 48,
                color: Colors.grey,
              ),
            );
          },
        );
      },
    );
  }
}