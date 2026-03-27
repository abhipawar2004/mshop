import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/home_page/model/banner_model.dart';
import 'package:hyper_local/screens/product_listing_page/model/product_listing_type.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import 'package:hyper_local/utils/widgets/custom_shape_decoration.dart';

import '../../../config/constant.dart';

class AutoPlayCarouselSlider extends StatefulWidget {
  final List<Top> banners;
  final double height;
  final Duration autoPlayInterval;

  const AutoPlayCarouselSlider({
    super.key,
    required this.banners,
    this.height = 250,
    this.autoPlayInterval = const Duration(seconds: 4),
  });

  @override
  State<AutoPlayCarouselSlider> createState() => _AutoPlayCarouselSliderState();
}

class _AutoPlayCarouselSliderState extends State<AutoPlayCarouselSlider> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool isTabletMode = isTablet(context); // Your existing isTablet helper
    final height = isTabletMode ? 550.0 : 250.0;
    final double viewportFraction = isTabletMode ? 1.0 : 1.0; // Show ~2 items on tablet
    final bool enlargeCenterPage = isTabletMode; // Optional: slight enlarge on tablet

    return Column(
      children: [
        SizedBox(
          height: height,
          child: CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: widget.banners.length,
            itemBuilder: (context, index, realIndex) {
              final banner = widget.banners[index];
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(
                  horizontal: isTabletMode ? 8.0 : 6.0, // Slightly more spacing on tablet
                ),
                padding: const EdgeInsets.only(
                  top: 25.0,
                  bottom: 15.0,
                  left: 4,
                  right: 4,
                ),
                decoration: getCustomShapeDecoration(
                    radius: 25),
                child: GestureDetector(
                  onTap: () => _navigateToProductListing(banner, context),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CustomImageContainer(
                          imagePath: banner.bannerImage!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: getCustomShapeDecoration(radius: 25),
                      ),
                    ],
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: height,
              viewportFraction: viewportFraction,
              enlargeCenterPage: enlargeCenterPage,
              enlargeFactor: 0.15,
              enlargeStrategy: CenterPageEnlargeStrategy.scale,
              autoPlay: true,
              autoPlayInterval: widget.autoPlayInterval,
              autoPlayAnimationDuration: const Duration(milliseconds: 600),
              autoPlayCurve: Curves.easeInOut,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
        // const SizedBox(height: 12),
        // Dots Indicator – adjusted for multi-item view
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.banners.length,
                (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: _currentIndex == index ? 5 : 4,
              width: _currentIndex == index ? 5 : 4,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? Theme.of(context).colorScheme.tertiary
                    : Colors.grey[400],
                shape: BoxShape.circle
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToProductListing(Top banner, BuildContext context) {
    switch (banner.type) {
      case 'brand':
        GoRouter.of(context).push(
          AppRoutes.productListing,
          extra: {
            'isTheirMoreCategory': false,
            'title': banner.title,
            'logo': banner.bannerImage,
            'totalProduct': '',
            'type': ProductListingType.brand,
            'identifier': banner.brandSlug,
          }
        );
        break;

      case 'category':
        GoRouter.of(context).push(
            AppRoutes.productListing,
            extra: {
              'isTheirMoreCategory': false,
              'title': banner.title,
              'logo': banner.bannerImage,
              'totalProduct': '',
              'type': ProductListingType.category,
              'identifier': banner.categorySlug,
            }
        );
        break;

      case 'product':
        final slug = banner.productSlug?.toString() ?? '';
        if (slug.isEmpty) {
          return;
        }
        GoRouter.of(context).push(
          AppRoutes.productDetailPage,
          extra: {'productSlug': slug},
        );
        break;

      default:
      // Handle unknown types or simply do nothing
        log('Unknown banner type: ${banner.type}');
        return;
    }


  }
}