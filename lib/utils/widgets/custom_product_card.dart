import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/screens/product_detail_page/view/product_detail_page.dart';
import 'package:hyper_local/services/auth_guard.dart';
import 'package:hyper_local/utils/widgets/animated_button.dart';
import 'package:hyper_local/utils/widgets/custom_delivery_time_widget.dart';
import 'package:hyper_local/utils/widgets/price_utils.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import '../../bloc/user_cart_bloc/user_cart_bloc.dart';
import '../../bloc/user_cart_bloc/user_cart_event.dart';
import '../../bloc/user_cart_bloc/user_cart_state.dart';
import '../../config/global.dart';
import '../../model/user_cart_model/user_cart.dart';
import '../../screens/wishlist_page/widgets/wishlist_bottom_sheet.dart';
import '../../screens/wishlist_page/bloc/get_user_wishlist_bloc/get_user_wishlist_bloc.dart';
import '../../screens/wishlist_page/bloc/get_user_wishlist_bloc/get_user_wishlist_state.dart';
import 'package:flutter/services.dart';
import '../../services/user_cart/cart_validation.dart';
import 'custom_toast.dart';

class CustomProductCard extends StatelessWidget {
  final int productId;
  final String productImage;
  final String productName;
  final String productSlug;
  final String productPrice;
  final List<String> productTags;
  final String specialPrice;
  final String estimatedDeliveryTime;
  final String? assetImage;
  final double ratings;
  final int ratingCount;
  final VoidCallback onAddToCart;
  final bool isStoreOpen;
  final bool isWishListed;
  final int productVariantId;
  final int storeId;
  final int wishlistItemId;
  final int totalStocks;
  final String imageFit;
  final bool showWishlist;
  final int? variantCount;
  final VoidCallback? onVariantSelectorRequested;
  final int quantityStepSize;
  final int minQty;
  final int totalAllowedQuantity;
  final String? indicator;

  const CustomProductCard({
    super.key,
    required this.productId,
    required this.productImage,
    required this.productName,
    required this.productSlug,
    required this.productPrice,
    required this.productTags,
    this.assetImage,
    required this.specialPrice,
    required this.estimatedDeliveryTime,
    required this.ratings,
    required this.ratingCount,
    required this.onAddToCart,
    required this.isStoreOpen,
    required this.isWishListed,
    required this.productVariantId,
    required this.storeId,
    required this.wishlistItemId,
    required this.totalStocks,
    required this.imageFit,
    this.showWishlist = true,
    this.variantCount,
    this.onVariantSelectorRequested,
    required this.quantityStepSize,
    required this.minQty,
    required this.totalAllowedQuantity,
    this.indicator,
  });

  BoxFit get boxFit {
    switch (imageFit.toLowerCase()) {
      case 'cover':
        return BoxFit.cover;
      case 'contain':
      default:
        return BoxFit.contain;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      clipBehavior: Clip.antiAlias,
      transitionDuration: const Duration(milliseconds: 500),
      transitionType: ContainerTransitionType.fade,
      closedElevation: 0,
      openElevation: 0,
      closedShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      openShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      closedColor: Colors.transparent,
      openColor: Colors.transparent,
      tappable: false,
      useRootNavigator: true,
      closedBuilder: (context, openContainer) {
        return GestureDetector(
          onTap: openContainer,
          child: Opacity(
            opacity: totalStocks <= 0 ? 0.5 : 1,
            child: Container(
              // Remove fixed width, let it adapt to parent constraints
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image - flexible but constrained
                      productImageWidget(
                          productImage: productImage,
                          discountPercentage:
                              PriceUtils.calculateDiscountPercentage(
                                      double.parse(productPrice),
                                      double.parse(specialPrice))
                                  .toString(),
                          context: context),
                      // Content area with fixed spacing
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            productNameWidget(
                                productName: productName, context: context),
                            SizedBox(height: 2.h),
                            // Product Price
                            productPriceWidget(
                                price: productPrice,
                                specialPrice: specialPrice,
                                locale: 'en_IN',
                                context: context),
                            SizedBox(height: 3.h),
                            ratingWidget(context),
                            SizedBox(height: 6.h),
                            // Delivery Time
                            DeliveryTimeWidget(time: estimatedDeliveryTime),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      openBuilder: (context, closeContainer) {
        return ProductDetailPage(
          productSlug: productSlug,
          initialData: ProductInitialData(
            title: productName,
            mainImage: productImage,
          ),
          closeContainer: closeContainer,
        );
      },
    );
  }

  Widget productImageWidget({
    required String productImage,
    required String discountPercentage,
    required BuildContext context,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          // Main image container
          Container(
            margin: EdgeInsetsDirectional.only(end: 8.w, bottom: 8.h),
            width: double.infinity,
            height: 100.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: boxFit == BoxFit.contain
                ? const EdgeInsets.all(10.0)
                : EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: productImage.isNotEmpty
                  ? Hero(
                      tag: 'product-image-${productId.hashCode}',
                      child: CustomImageContainer(
                          imagePath: productImage, fit: boxFit),
                    )
                  : _buildAssetImageOrPlaceholder(),
            ),
          ),

          // Discount badge - top leading corner
          if (discountPercentage.isNotEmpty && discountPercentage != '0')
            PositionedDirectional(
              top: 0,
              start: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.discountCardColor,
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(8.r),
                    bottomEnd: Radius.circular(4.r),
                  ),
                ),
                child: Text(
                  '$discountPercentage% OFF',
                  style: TextStyle(
                    fontSize: isTablet(context) ? 12 : 8.sp,
                    color: Colors.white,
                    fontFamily: AppTheme.fontFamily,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          if (indicator != null &&
              (indicator == 'veg' || indicator == 'non_veg'))
            PositionedDirectional(
              bottom: 12.h,
              start: 5.w,
              child: Container(
                width: 14.sp,
                height: 14.sp,
                padding: EdgeInsets.all(2.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: indicator == 'veg' ? Colors.green : Colors.red,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: indicator == 'veg' ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

          // Plus button - bottom trailing
          /*PositionedDirectional(
            bottom: 8.h,
            end: 3.w,
            child: GestureDetector(
              onTap: totalStocks > 0
                  ? (Global.userData != null
                  ? isCartItemReachedMaxLimit(context)
                  ? () async {
                await HapticFeedback.lightImpact();
                if(context.mounted) {
                  ToastManager.show(
                    context: context,
                    message: 'You have reached maximum cart item limit',
                  );
                }
              }
                  : () async {
                await HapticFeedback.lightImpact();
                onAddToCart();
              }
                  : () async {
                await HapticFeedback.lightImpact();
                if(context.mounted) {
                  await AuthGuard.ensureLoggedIn(context);
                }
              })
                  : null,
              child: Opacity(
                opacity: totalStocks > 0 ? 1.0 : 0.5,
                child: Container(
                  height: 22.h,
                  width: 22.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: AppTheme.primaryColor, width: 1.5.w),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    TablerIcons.plus,
                    size: 18.r,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
          ),*/

          PositionedDirectional(
            bottom: 8.h,
            end: 3.w,
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                final cartItem = _getCartItem(state);
                final isInCart = cartItem != null;

                final Set<int> currentStoreIds = {};
                int currentTotalItems = 0;

                if (state is CartLoaded) {
                  currentStoreIds.addAll(
                    state.items
                        .map((item) => int.tryParse(item.vendorId))
                        .where((id) => id != null)
                        .cast<int>(),
                  );
                  currentTotalItems = state.totalItems;
                }

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  width: isInCart ? 80 : 26.h,
                  height: 26.h,
                  decoration: BoxDecoration(
                    color: isInCart ? AppTheme.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: AppTheme.primaryColor,
                      width: 1.5.w,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.85, end: 1.0)
                              .animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: isInCart
                        ? _QuantityStepperInner(
                            key: const ValueKey('stepper_inner'),
                            quantity: cartItem.quantity,
                            currentLocalQty: cartItem.quantity,
                            stepSize: quantityStepSize,
                            isStoreOpen: isStoreOpen,
                            stock: totalStocks,
                            minQty: minQty,
                            totalAllowedQuantity: totalAllowedQuantity,
                            onIncrement: () async {
                              await HapticFeedback.lightImpact();
                              if (variantCount != null &&
                                  variantCount! > 1 &&
                                  onVariantSelectorRequested != null) {
                                onVariantSelectorRequested!();
                              } else {
                                if (context.mounted) {
                                  final error =
                                      CartValidation.validateProductAddToCart(
                                    context: context,
                                    requestedQuantity:
                                        cartItem.quantity + quantityStepSize,
                                    minQty: minQty,
                                    maxQty: totalAllowedQuantity,
                                    stock: totalStocks,
                                    isStoreOpen: isStoreOpen,
                                  );

                                  if (error != null) {
                                    ToastManager.show(
                                        context: context,
                                        message: error,
                                        type: ToastType.error);
                                    return;
                                  } else {
                                    context.read<CartBloc>().add(
                                          UpdateCartQty(
                                              cartKey: cartItem.cartKey,
                                              quantity: cartItem.quantity + quantityStepSize,
                                              cartItemId: cartItem.serverCartItemId,
                                              context: context),
                                        );
                                  }
                                }
                              }
                            },
                            onDecrement: () async {
                              await HapticFeedback.lightImpact();
                              if (variantCount != null &&
                                  variantCount! > 1 &&
                                  onVariantSelectorRequested != null) {
                                onVariantSelectorRequested!();
                              } else {
                                // Normal decrement for single variant
                                if (cartItem.quantity > quantityStepSize) {
                                  if (context.mounted) {
                                    context.read<CartBloc>().add(
                                          UpdateCartQty(
                                              cartKey:  cartItem.cartKey,
                                              quantity:  cartItem.quantity - quantityStepSize,
                                              cartItemId:  cartItem.serverCartItemId,
                                              context:  context),
                                        );
                                  }
                                } else {
                                  if (context.mounted) {
                                    context.read<CartBloc>().add(
                                          RemoveFromCart(
                                              cartKey:  cartItem.cartKey,context: context),
                                        );
                                  }
                                }
                              }
                            },
                          )
                        : _AddButtonInner(
                            key: const ValueKey('add_button_inner'),
                            currentLocalQty: cartItem?.quantity ?? 0,
                            stepSize: quantityStepSize,
                            isStoreOpen: isStoreOpen,
                            stock: totalStocks,
                            minQty: minQty,
                            totalAllowedQuantity: totalAllowedQuantity,
                            onTap: totalStocks > 0
                                ? () async {
                                    await HapticFeedback.lightImpact();

                                    if (context.mounted) {
                                      final error =
                                      CartValidation.validateProductAddToCart(
                                        context: context,
                                        requestedQuantity: quantityStepSize,
                                        minQty: minQty,
                                        maxQty: totalAllowedQuantity,
                                        stock: totalStocks,
                                        isStoreOpen: isStoreOpen,
                                      );

                                      final cartError = CartValidation.validateBeforeAddToCart(
                                        context: context,
                                        currentCartItemCount: currentTotalItems,
                                        requestedAddQuantity: quantityStepSize,
                                        currentStoreIdsInCart: currentStoreIds,
                                        thisProductStoreId: storeId,
                                      );

                                      if (error != null || cartError != null) {
                                        ToastManager.show(
                                            context: context,
                                            message: cartError ?? error!,
                                            type: ToastType.error);
                                        return;
                                      }

                                      else {
                                        onAddToCart();
                                      }

                                      // final isLoggedIn =
                                      //     await AuthGuard.ensureLoggedIn(
                                      //         context);
                                      // if (!isLoggedIn) {
                                      //   return;
                                      // }

                                    }
                                  }
                                : null,
                            opacity: totalStocks > 0 ? 1.0 : 0.5,
                          ),
                  ),
                );
              },
            ),
          ),

          // Wishlist button - top trailing
          if (showWishlist)
            PositionedDirectional(
              top: 3.h,
              end: 12.w,
              child: BlocBuilder<UserWishlistBloc, UserWishlistState>(
                builder: (context, wishlistState) {
                  final bloc = context.read<UserWishlistBloc>();
                  final isWishListedFromBloc = bloc.isProductWishlisted(
                      productId, productVariantId, storeId);
                  final currentWishlistItemId = bloc.getWishlistItemId(
                      productId, productVariantId, storeId);
                  final hasBlocData =
                      bloc.hasProductData(productId, productVariantId, storeId);

                  final finalIsWishListed =
                      hasBlocData ? isWishListedFromBloc : isWishListed;
                  final finalWishlistItemId =
                      currentWishlistItemId ?? wishlistItemId;

                  return AnimatedButton(
                    onTap: () async {
                      if (Global.userData != null) {
                        context
                            .read<UserWishlistBloc>()
                            .add(GetUserWishlistRequest());
                        await showModalBottomSheet<String>(
                          context: context,
                          useSafeArea: true,
                          isScrollControlled: true,
                          useRootNavigator: true,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          constraints: BoxConstraints(maxHeight: 500.h),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (_) => AddToWishlistSheetBody(
                            productId: productId,
                            productVariantId: productVariantId,
                            storeId: storeId,
                            wishlistItemId: finalWishlistItemId,
                          ),
                        );
                      } else {
                        await AuthGuard.ensureLoggedIn(context);
                      }
                    },
                    child: Container(
                      height: 28.r,
                      width: 28.r,
                      decoration: BoxDecoration(
                        color: isDarkMode(context)
                            ? Colors.black.withValues(alpha: 0.9)
                            : Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        finalIsWishListed
                            ? AppConstant.wishListedIcon
                            : AppConstant.notWishListedIcon,
                        color: finalIsWishListed
                            ? AppTheme.primaryColor
                            : isDarkMode(context)
                                ? Colors.white54
                                : Colors.black26,
                        size: 15.r,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  UserCart? _getCartItem(CartState state) {
    if (state is CartLoaded) {
      try {
        return state.items.firstWhere(
          (item) =>
              int.parse(item.productId) == productId &&
              int.parse(item.variantId) == productVariantId &&
              int.parse(item.vendorId) == storeId,
        );
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Widget _buildAssetImageOrPlaceholder() {
    if (assetImage != null && assetImage!.isNotEmpty) {
      return CustomImageContainer(
        imagePath: assetImage!,
        fit: BoxFit.cover,
      );
    }
    return Container(
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey[400],
        size: 24.sp,
      ),
    );
  }

  Widget productTagsWidget({required List<String> tags}) {
    final List<String> validTags = tags.where((tag) => tag.isNotEmpty).toList();
    if (validTags.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        double availableWidth = constraints.maxWidth;
        double tagSpacing = 4.w;

        return Wrap(
          spacing: tagSpacing,
          runSpacing: 2.h,
          children: validTags.take(2).map((tag) {
            return Container(
              constraints: BoxConstraints(
                maxWidth: (availableWidth - tagSpacing) / 2,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 8.sp,
                  fontFamily: AppTheme.fontFamily,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget productNameWidget(
      {required String productName, required BuildContext context}) {
    return SizedBox(
      height: isTablet(context) ? 48 : 35,
      child: Text(
        productName,
        style: TextStyle(
          fontSize: isTablet(context) ? 20 : 11.5.sp,
          height: isTablet(context) ? 1.2 : 1.2,
          fontFamily: AppTheme.fontFamily,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget productPriceWidget({
    required String price,
    required String specialPrice,
    required String locale,
    required BuildContext context,
  }) {
    final double regular = double.tryParse(price) ?? 0.0;
    final double special = double.tryParse(specialPrice) ?? 0.0;

    final bool hasDiscount = special > 0 && special < regular;

    final String displayPrice = hasDiscount
        ? specialPrice
        : price;

    final formattedDisplay = formatPrice(double.parse(displayPrice), locale: locale);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // Main price (bold)
        Text(
          '${AppConstant.currency}$formattedDisplay',
          style: TextStyle(
            fontSize: isTablet(context) ? 20 : 14.sp,
            fontWeight: FontWeight.bold,
            fontFamily: AppTheme.fontFamily,
          ),
          overflow: TextOverflow.ellipsis,
        ),

        if (hasDiscount) ...[
          const SizedBox(width: 8),

          // Strikethrough original price (only when there's actual discount)
          Text(
            '${AppConstant.currency}${formatPrice(regular, locale: locale)}',
            style: TextStyle(
              fontSize: isTablet(context) ? 16 : 11.sp,
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.grey,
              decorationThickness: 2,
              color: Colors.grey,
              fontFamily: AppTheme.fontFamily,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget ratingWidget(BuildContext context) {
    return Row(
      children: [
        RatingBar.builder(
          initialRating: ratings,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 11.h,
          itemBuilder: (context, _) => Icon(
            AppTheme.ratingStarIconFilled,
            color: AppTheme.ratingStarColor,
          ),
          unratedColor: Colors.grey[350],
          onRatingUpdate: (rating) {},
          ignoreGestures: true,
        ),
        SizedBox(
          width: 5.w,
        ),
        Expanded(
          child: Text(
            '($ratingCount)',
            style: TextStyle(
              fontSize: isTablet(context) ? 18 : 8.sp,
              fontFamily: AppTheme.fontFamily,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}

class _AddButtonInner extends StatelessWidget {
  final VoidCallback? onTap;
  final double opacity;
  final int currentLocalQty;
  final int stepSize;
  final int minQty;
  final int totalAllowedQuantity;
  final int stock;
  final bool isStoreOpen;

  const _AddButtonInner({
    required Key key,
    required this.onTap,
    required this.opacity,
    required this.currentLocalQty,
    required this.stepSize,
    required this.minQty,
    required this.totalAllowedQuantity,
    required this.stock,
    required this.isStoreOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: () {
          final error = CartValidation.validateProductAddToCart(
            context: context,
            requestedQuantity: currentLocalQty + stepSize,
            minQty: minQty,
            maxQty: totalAllowedQuantity,
            stock: stock,
            isStoreOpen: isStoreOpen,
          );
          if (error != null) {
            ToastManager.show(
                context: context, message: error, type: ToastType.error);
            return;
          } else {
            onTap!();
          }
        },
        child: Icon(
          TablerIcons.plus,
          size: 18.r,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}

class _QuantityStepperInner extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int currentLocalQty;
  final int stepSize;
  final int minQty;
  final int totalAllowedQuantity;
  final int stock;
  final bool isStoreOpen;

  const _QuantityStepperInner({
    required Key key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.currentLocalQty,
    required this.stepSize,
    required this.minQty,
    required this.totalAllowedQuantity,
    required this.stock,
    required this.isStoreOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: onDecrement,
          child: Icon(
            TablerIcons.minus,
            size: 16.r,
            color: Colors.white,
          ),
        ),
        Text(
          quantity.toString(),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: onIncrement,
          child: Icon(
            TablerIcons.plus,
            size: 16.r,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
