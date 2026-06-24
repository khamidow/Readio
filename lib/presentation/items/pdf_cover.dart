import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookCover extends StatelessWidget {
  final String imageUrl;

  const BookCover({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: 300,
        width: 300,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CupertinoActivityIndicator(color: Colors.redAccent,),
        ),
        errorWidget: (context, url, error) {
          print('Image error: $error for URL: $url');
          return const Icon(Icons.broken_image, size: 50);
        },
      ),
    );
  }
}