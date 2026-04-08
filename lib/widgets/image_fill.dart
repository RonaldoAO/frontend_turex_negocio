import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageFill extends StatelessWidget {
  final String url;
  const ImageFill({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        color: const Color(0xFF202733),
      ),
      errorWidget: (_, __, ___) => Container(
        color: const Color(0xFF202733),
        child: const Icon(Icons.image_not_supported, color: Colors.white54),
      ),
    );
  }
}
