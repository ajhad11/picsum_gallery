import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:picsum_gallery/features/gallery/domain/entities/image_entity.dart';
import 'package:picsum_gallery/features/gallery/presentation/providers/favorites_provider.dart';
import 'package:picsum_gallery/features/gallery/presentation/screens/gallery_detail_screen.dart';
import 'package:picsum_gallery/core/constants/app_constants.dart';

class ImageCard extends ConsumerWidget {
  final ImageEntity image;

  const ImageCard({super.key, required this.image});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.value?.contains(image.id) ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryDetailScreen(image: image),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Background Image with Hero
            Positioned.fill(
              child: Hero(
                tag: 'image_${image.id}',
                child: CachedNetworkImage(
                  imageUrl: image.downloadUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            // Favorite Toggle
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(image.id);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            // Author Overlay
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(160),
                  ],
                ),
              ),
              child: Text(
                image.author,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

