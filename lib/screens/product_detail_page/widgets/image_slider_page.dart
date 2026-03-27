import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/screens/product_detail_page/widgets/product_video_player.dart';
import 'package:photo_view/photo_view.dart';

class ImageSliderPage extends StatefulWidget {
  final List<String> images;
  final String? videoUrl;
  final int initialIndex;

  const ImageSliderPage({
    super.key,
    required this.images,
    this.videoUrl,
    this.initialIndex = 0,
  });

  @override
  State<ImageSliderPage> createState() => _ImageSliderPageState();
}

class _ImageSliderPageState extends State<ImageSliderPage> {
  late int currentIndex;
  late PageController _pageController;
  late PageController _thumbnailController;
  late int totalItems;
  late bool hasVideo;

  @override
  void initState() {
    super.initState();
    hasVideo = widget.videoUrl != null && widget.videoUrl!.isNotEmpty;
    totalItems = hasVideo ? widget.images.length + 1 : widget.images.length;
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _thumbnailController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });

    // Sync thumbnail slider smoothly
    if (_thumbnailController.hasClients) {
      _thumbnailController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Gallery (Video + Images)
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: totalItems,
            itemBuilder: (context, index) {
              // First item is video if available
              if (index == 0 && hasVideo) {
                return Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Center(
                    child: ProductVideoPlayer(
                      videoUrl: widget.videoUrl!,
                      isActive: currentIndex == 0,
                    ),
                  ),
                );
              }

              // Images start after video
              final imageIndex = hasVideo ? index - 1 : index;

              return PhotoView(
                imageProvider: CachedNetworkImageProvider(widget.images[imageIndex]),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
                heroAttributes: PhotoViewHeroAttributes(tag: widget.images[imageIndex]),
                backgroundDecoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
                loadingBuilder: (context, event) => const Center(
                  child: CircularProgressIndicator(color: Colors.black54),
                ),
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.error, color: Colors.red, size: 48),
                ),
              );
            },
          ),

          // Close Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ),

          // Thumbnail Preview Slider at Bottom
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: SizedBox(
              height: 100,
              child: Center(
                child: ListView.builder(
                  controller: _thumbnailController,
                  scrollDirection: Axis.horizontal,
                  itemCount: totalItems,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final bool isCurrent = index == currentIndex;

                    return GestureDetector(
                      onTap: () {
                        _pageController.jumpToPage(index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutQuart,
                        width: 100,
                        height: 80,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isCurrent
                                ? AppTheme.primaryColor
                                : Colors.grey.shade400,
                            width: isCurrent ? 1.2 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: _buildThumbnail(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(int index) {
    // First thumbnail is video indicator if available
    if (index == 0 && hasVideo) {
      return Container(
        color: Colors.black87,
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 40,
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'VIDEO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Image thumbnails
    final imageIndex = hasVideo ? index - 1 : index;

    return CachedNetworkImage(
      imageUrl: widget.images[imageIndex],
      fit: BoxFit.contain,
      placeholder: (context, url) => Container(
        color: Colors.grey[300],
        child: const Icon(Icons.image, color: Colors.grey),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[300],
        child: const Icon(Icons.error, color: Colors.red),
      ),
    );
  }
}