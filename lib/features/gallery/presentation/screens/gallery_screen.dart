import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picsum_gallery/features/gallery/presentation/providers/gallery_provider.dart';
import 'package:picsum_gallery/features/gallery/presentation/widgets/image_card.dart';
import 'package:picsum_gallery/core/constants/app_constants.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(galleryImagesProvider.notifier).fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagesAsync = ref.watch(galleryImagesProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () => ref.read(galleryImagesProvider.notifier).refresh(),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(),
            _buildHeader(),
            imagesAsync.when(
              data: (images) => images.isEmpty 
                ? _buildEmptyState()
                : _buildImageGrid(images),
              loading: () => _buildInitialLoading(),
              error: (error, _) => _buildErrorState(),
            ),
            if (imagesAsync.isLoading && imagesAsync.hasValue)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: Colors.white,
      expandedHeight: _isSearching ? 80 : 120.0,
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search by author...',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                ref.read(galleryImagesProvider.notifier).setQuery(value);
              },
            )
          : null,
      actions: [
        IconButton(
          icon: Icon(
            ref.watch(galleryImagesProvider.notifier).favoritesOnly 
              ? Icons.favorite 
              : Icons.favorite_border,
            color: ref.watch(galleryImagesProvider.notifier).favoritesOnly 
              ? Colors.red 
              : Colors.black54,
          ),
          onPressed: () {
            ref.read(galleryImagesProvider.notifier).toggleFavoritesOnly();
          },
        ),
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              if (_isSearching) {
                _isSearching = false;
                _searchController.clear();
                ref.read(galleryImagesProvider.notifier).setQuery('');
              } else {
                _isSearching = true;
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.sort_rounded),
          onPressed: () => _showSortBottomSheet(),
        ),
      ],
      flexibleSpace: _isSearching 
        ? null 
        : FlexibleSpaceBar(
            title: const Text(
              'Gallery',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            centerTitle: true,
            background: Container(color: Colors.white),
          ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Sort By',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.numbers),
            title: const Text('ID (Numerical)'),
            onTap: () {
              ref.read(galleryImagesProvider.notifier).setSort('ID');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Author Name'),
            onTap: () {
              ref.read(galleryImagesProvider.notifier).setSort('Author');
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('No images found', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isFavoritesOnly = ref.watch(galleryImagesProvider.notifier).favoritesOnly;
    
    return SliverToBoxAdapter(
      child: _isSearching ? const SizedBox.shrink() : Padding(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.defaultPadding,
          24,
          AppConstants.defaultPadding,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isFavoritesOnly ? 'Your Favorites' : 'Daily Inspiration',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isFavoritesOnly 
                ? 'Images you have saved for later.' 
                : 'High quality images from top authors.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            _buildFilterChips(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final orientations = ['All', 'Landscape', 'Portrait', 'Square'];
    final currentOrientation = ref.watch(galleryImagesProvider.notifier).currentOrientation;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: orientations.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final label = orientations[index];
          final isSelected = currentOrientation == label;

          return FilterChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (selected) {
              ref.read(galleryImagesProvider.notifier).setOrientation(label);
            },
            backgroundColor: Colors.white,
            selectedColor: Theme.of(context).primaryColor.withOpacity(0.1),
            checkmarkColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
                width: 1,
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildImageGrid(List<dynamic> images) {
    return SliverPadding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => ImageCard(image: images[index]),
          childCount: images.length,
        ),
      ),
    );
  }

  Widget _buildInitialLoading() {
    return const SliverFillRemaining(
      child: Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  Widget _buildErrorState() {
    return SliverFillRemaining(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
              ),
              const SizedBox(height: 24),
              const Text(
                'Something went wrong',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'We couldn\'t load the gallery. Please check your connection.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref.read(galleryImagesProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

