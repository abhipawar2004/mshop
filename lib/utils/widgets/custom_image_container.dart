
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'cache_manager.dart';

class CustomImageContainer extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool? isForCategoryTab;

  const CustomImageContainer({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor,
    this.placeholder,
    this.errorWidget,
    this.isForCategoryTab = false,
  });

  bool _isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {

    // log('IMAGE ____ $imagePath');

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: _isNetworkImage(imagePath)
            ? CachedNetworkImage(
                imageUrl: imagePath,
                cacheManager: customCacheManager,
                width: width,
                height: height,
                fit: fit,
                filterQuality: FilterQuality.high,
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                useOldImageOnUrlChange: true,
                imageBuilder: (context, imageProvider){
                  return Image(image: imageProvider, fit: fit);
                },
                placeholder: (context, url) => placeholder ??
                    Center(
                      child: Image.asset('assets/images/placeholder.png'),
                    ),
                errorWidget: (context, url, error) {
                  return errorWidget ??
                      Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 50,
                        ),
                      );
                },
              )
            : Image.asset(
                imagePath,
                width: width,
                height: height,
                fit: fit,
                errorBuilder: (context, error, stackTrace) {
                  return errorWidget ??
                      Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 100,
                        ),
                      );
                },
              ),
      ),
    );
  }
}
