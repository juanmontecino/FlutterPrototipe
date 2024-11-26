import 'package:flutter/material.dart';

class LibroCoverImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final VoidCallback? onTap;

  const LibroCoverImage({
    super.key,
    required this.imageUrl,
    this.height = 150,
    this.width = 100,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(Icons.book, size: 40),
              );
            },
          ),
        ),
      ),
    );
  }
}