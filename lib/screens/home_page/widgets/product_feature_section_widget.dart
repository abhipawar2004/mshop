import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/home_page/model/featured_section_product_model.dart';

import '../../../bloc/user_cart_bloc/user_cart_bloc.dart';
import '../../../bloc/user_cart_bloc/user_cart_event.dart';
import '../../../config/constant.dart';
import '../../../model/user_cart_model/cart_sync_action.dart';
import '../../../model/user_cart_model/user_cart.dart';
import '../../../utils/widgets/custom_product_card.dart';
import '../../../utils/widgets/custom_variant_selector_bottom_sheet.dart';
import '../../product_listing_page/model/product_listing_type.dart';

enum FeatureSectionStyle { withBackground, withoutBackground }
enum FeatureSectionBackgroundType { image, color, none}

FeatureSectionStyle _parseStyle(String s) {
  return s == 'with_background'
      ? FeatureSectionStyle.withBackground
      : FeatureSectionStyle.withoutBackground;
}

FeatureSectionBackgroundType _parseBgType(String? s) {
  final v = (s ?? '').trim().toLowerCase();
  switch (v) {
    case 'image':
      return FeatureSectionBackgroundType.image;
    case 'color':
      return FeatureSectionBackgroundType.color;
    default:
      return FeatureSectionBackgroundType.none;
  }
}

class ProductFeatureSectionWidget extends StatefulWidget {
  final FeatureSectionData featureSectionData;
  final String featureSectionTitle;
  final String featureSectionSlug;
  final String backgroundImage;
  final String backgroundImageTablet;
  final String featureSectionStyle;
  final String? backgroundColor;
  final String? backgroundType;


  const ProductFeatureSectionWidget({
    super.key,
    required this.featureSectionData,
    required this.featureSectionTitle,
    required this.backgroundImage,
    required this.backgroundImageTablet,
    required this.featureSectionSlug,
    required this.featureSectionStyle,
    this.backgroundColor,
    this.backgroundType,
  });

  @override
  State<ProductFeatureSectionWidget> createState() => _ProductFeatureSectionWidgetState();
}

class _ProductFeatureSectionWidgetState extends State<ProductFeatureSectionWidget> {
  @override
  Widget build(BuildContext context) {
    final products = widget.featureSectionData.products ?? [];
    if (products.isEmpty) return const SizedBox.shrink();

    final style = _parseStyle(widget.featureSectionStyle);
    final isTabletTablet = isTablet(context);

    final bgUrl = isTabletTablet
        ? (widget.backgroundImageTablet.isNotEmpty == true
        ? widget.backgroundImageTablet
        : widget.backgroundImage)
        : widget.backgroundImage;
    final hasBgImage = bgUrl.isNotEmpty;
    final hasBgColor = widget.backgroundColor != null;
    final bgType = _parseBgType(widget.backgroundType);

    switch (style) {
      case FeatureSectionStyle.withBackground:
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Stack(
            children: [
              if (bgType == FeatureSectionBackgroundType.image && hasBgImage)
                Positioned(
                  top: 15,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: double.infinity,
                    // height: 200,
                    height: isTabletTablet ? 350 : 200,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: bgUrl,
                    ),
                  ),
                )
              // 2) Else fallback solid color if provided
              else if (bgType == FeatureSectionBackgroundType.color && hasBgColor)
                Positioned(
                  top: 15,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    // height: _isTablet ? 300 : 200,
                    color: hexStringToColor(widget.backgroundColor),
                  ),
                ),
              // else if (bgType == FeatureSectionBackgroundType.none && hasBgImage)
              //   Positioned(
              //       top: 15,
              //       left: 0,
              //       right: 0,
              //       child: SizedBox(
              //         width: double.infinity,
              //         height: 200,
              //         child: CachedNetworkImage(
              //           fit: BoxFit.cover,
              //           imageUrl: bgUrl,
              //         ),
              //       ),
              //     )
              // else if (bgType == FeatureSectionBackgroundType.color && hasBgColor)
              //   // Fallback: if URL missing but color exists, use color
              //   Positioned(
              //       top: 15,
              //       left: 0,
              //       right: 0,
              //       child: Container(
              //         width: double.infinity,
              //         height: 200,
              //         color: hexStringToColor(widget.backgroundColor),
              //       ),
              //     ),
              SizedBox(
                // height: 350.h,
                height: isTabletTablet ? 210.sp : 350.sp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: isTabletTablet ? 70.h : 80.w),
                    _buildWithBGHeader(context, isTablet(context)),
                    // SizedBox(height: 10,)
                    _buildProductsList(context, isTablet(context)),
                  ],
                ),
              ),
            ],
          ),
        );

      case FeatureSectionStyle.withoutBackground:
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SizedBox(
            height: 235.h,
            // height: _isTablet ? 280.h : 235.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWithoutBGHeader(context, isTablet(context)),
                SizedBox(height: 8,),
                _buildProductsList(context, isTablet(context)),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildWithBGHeader(BuildContext context, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(
        left: isTablet ? 20.0 : 10.0,
        right: isTablet ? 20.0 : 10.0,
        bottom: 10.0.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8.r),
            onTap: () {
              GoRouter.of(context).push(
                AppRoutes.productListing,
                extra: {
                  'isTheirMoreCategory': false,
                  'title': widget.featureSectionData.title,
                  'logo': '',
                  'totalProduct': 10,
                  'type': ProductListingType.featuredSection,
                  'identifier': widget.featureSectionSlug,
                },
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 10.w : 6.w,
                vertical: isTablet ? 4.h : 2.h,
              ),
              decoration: BoxDecoration(
                color: isDarkMode(context) ? Colors.black.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(15.r)
              ),
              child: Text(
                AppLocalizations.of(context)!.seeAll,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                  fontSize: isTablet ? 18 : 14
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWithoutBGHeader(BuildContext context, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(
        left: isTablet ? 20.0 : 10.0,
        right: isTablet ? 20.0 : 10.0,
        bottom: 10.0.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Always show title here; for advanced overlays you can style differently per style if needed.
          Text(
            widget.featureSectionData.title ?? '',
            style: TextStyle(
              fontSize: isTablet ? 24 : 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(8.r),
            onTap: () {
              GoRouter.of(context).push(
                AppRoutes.productListing,
                extra: {
                  'isTheirMoreCategory': false,
                  'title': widget.featureSectionData.title,
                  'logo': '',
                  'totalProduct': 10,
                  'type': ProductListingType.featuredSection,
                  'identifier': widget.featureSectionSlug,
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 10.w : 6.w,
                vertical: isTablet ? 4.h : 2.h,
              ),
              child: Text(
                'See All',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                  fontSize: isTablet ? 18 : 14
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductsList(BuildContext context, bool isTablet) {
    final products = widget.featureSectionData.products!;
    return SizedBox(
      height: 195.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(
          left: isTablet ? 20 : 10,
          right: isTablet ? 20 : 10,
        ),
        itemCount: products.length > 8 ? 8 : products.length,
        itemBuilder: (context, index) {
          final data = products[index];
          return Padding(
            padding: EdgeInsets.only(right: isTablet ? 12.0 : 8.0),
            child: SizedBox(
              width: isTablet ? 75.w : 115.w,
              child: CustomProductCard(
                productId: data.id,
                productImage: data.mainImage,
                productName: data.title,
                productSlug: data.slug,
                productPrice: data.variants.firstWhere((variant) => variant.isDefault).price.toString(),
                specialPrice: data.variants.firstWhere((variant) => variant.isDefault).specialPrice.toString(),
                productTags: [],
                estimatedDeliveryTime: data.estimatedDeliveryTime,
                ratings: double.parse(data.ratings.toString()),
                ratingCount: data.ratingCount,
                onAddToCart: () {
                  if (data.variants.length > 1) {
                    showVariantBottomSheet(
                      variantsList: data.variants,
                      productData: data,
                      productImage: data.mainImage,
                      quantityStepSize: data.quantityStepSize,
                      context: context,
                    );
                  } else {
                    final item = UserCart(
                        productId: data.id.toString(),
                        variantId: data.variants.firstWhere((variant) => variant.isDefault).id.toString(),
                        variantName: data.variants.firstWhere((variant) => variant.isDefault).title.toString(),
                        vendorId: data.variants.firstWhere((variant) => variant.isDefault).storeId.toString(),
                        name: data.title,
                        image: data.mainImage,
                        price: data.variants.firstWhere((variant) => variant.isDefault).specialPrice.toDouble(),
                        originalPrice: data.variants.firstWhere((variant) => variant.isDefault).price.toDouble(),
                        quantity: data.quantityStepSize,
                        serverCartItemId: null,
                        syncAction: CartSyncAction.add,
                        updatedAt: DateTime.now(),
                        minQty: data.minimumOrderQuantity,
                        maxQty: data.totalAllowedQuantity,
                        isOutOfStock: data.variants.firstWhere((variant) => variant.isDefault).stock <= 0,
                        isSynced: false
                    );
                    context.read<CartBloc>().add(AddToCart(item: item, context: context));
                  }
                },
                variantCount: data.variants.length,
                onVariantSelectorRequested: data.variants.length > 1
                      ? () => showVariantBottomSheet(
                    variantsList: data.variants,
                    productData: data,
                    productImage: data.mainImage,
                    quantityStepSize: data.quantityStepSize,
                    context: context,
                  ) : null,
                isStoreOpen: data.storeStatus?.isOpen ?? true,
                isWishListed: data.favorite != null,
                productVariantId: data.variants.firstWhere((variant) => variant.isDefault).id,
                storeId: data.variants.firstWhere((variant) => variant.isDefault).storeId,
                wishlistItemId: data.favorite?.first.id ?? 0,
                totalStocks: data.variants.firstWhere((variant) => variant.isDefault).stock,
                imageFit: data.imageFit,
                quantityStepSize: data.quantityStepSize,
                minQty: data.minimumOrderQuantity,
                totalAllowedQuantity: data.totalAllowedQuantity,
                indicator: data.indicator,
              ),
            ),
          );
        },
      ),
    );
  }
}
