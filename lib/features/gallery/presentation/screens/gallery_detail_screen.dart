import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picsum_gallery/features/gallery/domain/entities/image_entity.dart';
import 'package:picsum_gallery/features/gallery/presentation/providers/favorites_provider.dart';

class GalleryDetailScreen extends ConsumerWidget {
  final ImageEntity image;

  const GalleryDetailScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.value?.contains(image.id) ?? false;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full Image with Hero
          Center(
            child: Hero(
              tag: 'image_${image.id}',
              child: CachedNetworkImage(
                imageUrl: image.downloadUrl,
                width: double.infinity,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.broken_image,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),

          // Custom Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Favorite Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(image.id);
                },
              ),
            ),
          ),

          // Bottom Info Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withAlpha(200),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'by ${image.author}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _infoBadge(Icons.photo_size_select_actual, '${image.width} x ${image.height}'),
                      const SizedBox(width: 12),
                      _infoBadge(Icons.tag, 'ID: ${image.id}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
