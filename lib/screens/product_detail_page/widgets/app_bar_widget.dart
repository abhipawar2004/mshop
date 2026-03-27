import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/product_detail_page/widgets/image_slider_page.dart';
import 'package:hyper_local/screens/product_detail_page/widgets/product_video_player.dart';
import 'package:hyper_local/utils/widgets/animated_button.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import '../../../config/global.dart';
import '../../../services/auth_guard.dart';
import '../../wishlist_page/bloc/get_user_wishlist_bloc/get_user_wishlist_bloc.dart';
import '../../wishlist_page/bloc/get_user_wishlist_bloc/get_user_wishlist_state.dart';
import '../../wishlist_page/widgets/wishlist_bottom_sheet.dart';
import '../bloc/product_detail_bloc/product_detail_bloc.dart';
import '../bloc/product_detail_bloc/product_detail_state.dart';
import '../model/product_detail_model.dart';
import '../view/product_detail_page.dart';

class AppBarWidget extends StatefulWidget {
  final bool showTitle;
  final ProductInitialData? initialData;
  final ProductData? loadedProduct;
  const AppBarWidget({
    super.key,
    required this.showTitle,
    this.initialData,
    this.loadedProduct,
  });

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  int _currentPage = 0;
  final GlobalKey<_DrawerOverlayState> _drawerKey = GlobalKey<_DrawerOverlayState>();

  void _toggleDrawer() {
    _drawerKey.currentState?.toggleDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 400,
      title: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (BuildContext context, ProductDetailState state) {
          if(state is ProductDetailLoaded) {
            final product = state.productData[0];
            return AnimatedOpacity(
              opacity: widget.showTitle ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedButton(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Directionality.of(context) == TextDirection.ltr ? Icon(TablerIcons.chevron_left, size: 25,) : Icon(TablerIcons.chevron_right, size: 25,),
          ),
        ),
      ),
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: widget.showTitle ? 1 : 0,
      shadowColor: Colors.grey.withValues(alpha: 0.3),
      actions: [
        BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            if (state is! ProductDetailLoaded) {
              return AnimatedButton(
                onTap: (){},
                child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Icon(AppConstant.notWishListedIcon, color: Theme.of(context).colorScheme.tertiary)
                ),
              );
            }

            final product = state.productData[0];
            final bool isWishlisted = product.favorite != null &&
                product.favorite!.isNotEmpty;
            final wishlistItemId = isWishlisted ? product.favorite!.first.id : 0;

            return BlocBuilder<UserWishlistBloc, UserWishlistState>(
              builder: (context, wishlistState) {
                final bloc = context.read<UserWishlistBloc>();
                final productId = product.id;
                final productVariantId = product.variants.firstWhere((variant) => variant.isDefault).id;
                final storeId = product.variants.firstWhere((variant) => variant.isDefault).storeId;

                final isWishListedFromBloc = bloc.isProductWishlisted(
                    product.id,
                    product.variants.firstWhere((variant) => variant.isDefault).id,
                    product.variants.firstWhere((variant) => variant.isDefault).storeId
                );
                final currentWishlistItemId = bloc.getWishlistItemId(
                    productId,
                    productVariantId,
                    storeId
                );

                final hasBlocData = bloc.hasProductData(productId, productVariantId, storeId);
                final finalIsWishListed = hasBlocData ? isWishListedFromBloc : isWishlisted;
                final finalWishlistItemId = currentWishlistItemId ?? wishlistItemId;

                return AnimatedButton(
                  onTap: () async {
                    if (Global.userData != null) {
                      context.read<UserWishlistBloc>().add(GetUserWishlistRequest());
                      await showModalBottomSheet<String>(
                        context: context,
                        useSafeArea: true,
                        isScrollControlled: true,
                        useRootNavigator: true,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        constraints: BoxConstraints(
                            maxHeight: 500.h
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (_) => AddToWishlistSheetBody(
                            productId: productId,
                            productVariantId: productVariantId,
                            storeId: storeId,
                            wishlistItemId: finalWishlistItemId!
                        ),
                      );
                    } else {
                      await AuthGuard.ensureLoggedIn(context);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Icon(
                      finalIsWishListed ? AppConstant.wishListedIcon : AppConstant.notWishListedIcon,
                      color: finalIsWishListed ? AppTheme.primaryColor : null,
                    ),
                  ),
                );
              },
            );
          },
        ),
        SizedBox(width: 10.w,),
        AnimatedButton(
          onTap: () {
            GoRouter.of(context).push(AppRoutes.search);
          },
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Icon(HeroiconsOutline.magnifyingGlass),
          ),
        ),
        SizedBox(width: 10.w),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Builder(
          builder: (context) {
            // Decide which data to use: loaded product first, then initialData
            final product = widget.loadedProduct;

            List<String> images = [];
            String videoUrl = '';
            String heroTag = 'product-image-placeholder';

            if (product != null) {
              // Full data loaded → use it
              if (product.mainImage.isNotEmpty) images.add(product.mainImage);
              images.addAll(product.additionalImages);
              videoUrl = product.videoLink;
              heroTag = 'product-image-${product.id.hashCode}';
            } else if (widget.initialData != null) {
              // Show immediately from card data
              images.add(widget.initialData!.mainImage);
              images.addAll(widget.initialData!.additionalImages);
              videoUrl = widget.initialData!.videoUrl;
              // Stable tag using title hash (or you can pass productId if available)
              heroTag = 'product-image-${widget.initialData!.title.hashCode}';
            } else {
              // Very rare fallback — show a placeholder
              return Container(color: Colors.grey[200]);
            }

            final int totalItems = videoUrl.isNotEmpty ? images.length + 1 : images.length;

            return Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: double.infinity,
                    autoPlay: false,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                  items: List.generate(totalItems, (index) {
                    // Video first if exists
                    if (index == 0 && videoUrl.isNotEmpty) {
                      return GestureDetector(
                        onTap: () => _openFullScreenSlider(context, images, videoUrl, 0),
                        child: Container(
                          color: Colors.black,
                          child: ProductVideoPlayer(
                            videoUrl: videoUrl,
                            isActive: _currentPage == index,
                          ),
                        ),
                      );
                    }

                    final int imageIndex = videoUrl.isNotEmpty ? index - 1 : index;
                    final String imagePath = images[imageIndex];

                    return GestureDetector(
                      onTap: () => _openFullScreenSlider(
                        context,
                        images,
                        videoUrl,
                        videoUrl.isNotEmpty ? index : index,
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Hero(
                          tag: heroTag,
                          child: CustomImageContainer(
                            imagePath: imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                if (totalItems > 1)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(totalItems, (i) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == i ? Colors.white : Colors.white.withValues(alpha: 0.5),
                          ),
                        );
                      }),
                    ),
                  ),
              
                if (product != null && (product.indicator.isNotEmpty && (product.indicator == 'veg' || product.indicator == 'non-veg')))
                   PositionedDirectional(
                    bottom: 15, // Adjusted to not overlap with dots
                    end: 15,
                    child: Container(
                      width: 24.sp,
                      height: 24.sp,
                      padding: EdgeInsets.all(4.sp),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8), // added background for visibility
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: product.indicator == 'veg' ? Colors.green : Colors.red,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Center(
                          child: Container(
                            width: 10.sp,
                            height: 10.sp,
                            decoration: BoxDecoration(
                              color: product.indicator == 'veg' ? Colors.green : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                if (product != null &&
                    (product.brand.isNotEmpty ||
                        product.seller.isNotEmpty ||
                        product.category.isNotEmpty ||
                        product.indicator.isNotEmpty))
                  DrawerOverlay(
                    key: _drawerKey,
                    onToggle: _toggleDrawer,
                    customFields: product.customFields,
                    brandName: capitalizeFirstLetter(removeUnderscores(product.brand)),
                    categoryName: capitalizeFirstLetter(removeUnderscores(product.category)),
                    indicator: capitalizeFirstLetter(removeUnderscores(product.indicator)),
                    sellerName: capitalizeFirstLetter(removeUnderscores(product.seller)),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _openFullScreenSlider(
      BuildContext context,
      List<String> images,
      String videoUrl,
      int initialIndex,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageSliderPage(
          images: images,
          videoUrl: videoUrl,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class DrawerOverlay extends StatefulWidget {
  final VoidCallback onToggle;
  final List<CustomField> customFields;
  final String brandName;
  final String categoryName;
  final String indicator;
  final String sellerName;

  const DrawerOverlay({
    super.key,
    required this.onToggle,
    required this.customFields,
    required this.brandName,
    required this.categoryName,
    required this.indicator,
    required this.sellerName,
  });

  @override
  State<DrawerOverlay> createState() => _DrawerOverlayState();
}

class _DrawerOverlayState extends State<DrawerOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _drawerController;
  late Animation<Offset> _drawerAnimation;
  late Animation<Offset> _buttonAnimation;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _drawerController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _isDrawerOpen = false;
        });
      }
    });

    // Button slides out to left (0 to -1)
    _buttonAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-2.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _drawerController,
      curve: Interval(0.0, 0.4, curve: Curves.easeInOut),
    ));

    // Drawer slides in from left (-1 to 0)
    _drawerAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _drawerController,
      curve: Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));

  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    if (_drawerController.isDismissed) {
      setState(() {
        _isDrawerOpen = true;
      });
      _drawerController.forward();
    } else {
      _drawerController.reverse();
    }
  }

  void _closeDrawer() {
    if (_drawerController.isCompleted || _drawerController.isAnimating) {
      _drawerController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerWidth = isTablet(context) ? 250.0 : MediaQuery.of(context).size.width * 0.4;
    return Stack(
      children: [
        // Dark overlay - only visible when drawer is open
        if (_isDrawerOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeDrawer,
              child: AnimatedBuilder(
                animation: _drawerController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _drawerController.value.clamp(0.0, 1.0),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.2),
                    ),
                  );
                },
              ),
            ),
          ),

        if (_isDrawerOpen)
          PositionedDirectional(
            top: 0,
            bottom: 0,
            start: 0,
            child: SlideTransition(
              textDirection: Localizations.localeOf(context).languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              position: _drawerAnimation,
              child: Row(
                children: [
                  // Main drawer
                  Container(
                    width: drawerWidth,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 70,),

                          // Menu content
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Key features',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  // ── Dynamic key features section ─────────────────────────────────────
                                  ..._buildDynamicKeyFeatures(),

                                  // ── Optional fallback items when we have very few custom fields ──────
                                  if (widget.customFields.length <= 2) ...[
                                    if (widget.brandName.isNotEmpty) ...[
                                      customDivider(),
                                      _buildMenuItem('Brand', widget.brandName),
                                    ],
                                    if (widget.categoryName.isNotEmpty && widget.customFields.length <= 1) ...[
                                      customDivider(),
                                      _buildMenuItem('Category', widget.categoryName),
                                    ],
                                    if (widget.indicator.isNotEmpty && widget.customFields.length <= 1) ...[
                                      customDivider(),
                                      _buildMenuItem('Indicator', widget.indicator),
                                    ],
                                    if (widget.sellerName.isNotEmpty && widget.customFields.length <= 1) ...[
                                      customDivider(),
                                      _buildMenuItem('Seller', widget.sellerName),
                                    ],
                                  ],

                                 /* if(widget.brandName.isNotEmpty)...[
                                    customDivider(),
                                    _buildMenuItem('Brand', widget.brandName),
                                  ],
                                  if(widget.categoryName.isNotEmpty)...[
                                    customDivider(),
                                    _buildMenuItem('Category', widget.categoryName),
                                  ],
                                  if(widget.indicator.isNotEmpty)...[
                                    customDivider(),
                                    _buildMenuItem('Indicator', widget.indicator),
                                  ],
                                  if(widget.sellerName.isNotEmpty)...[
                                    customDivider(),
                                    _buildMenuItem('Seller', widget.sellerName),
                                  ],*/

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.bottomEnd,
                    margin: EdgeInsets.only(bottom: 60),
                    child: GestureDetector(
                      onTap: _closeDrawer,
                      child: Container(
                        height: 60,
                        width: 25,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadiusDirectional.only(
                            topEnd: Radius.circular(10),
                            bottomEnd: Radius.circular(10),
                          ),
                        ),
                        child: Icon(
                          TablerIcons.chevron_left,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Trigger button - slides out when drawer opens
        PositionedDirectional(
          bottom: 60,
          start: 0,
          child: SlideTransition(
            textDirection: Localizations.localeOf(context).languageCode == 'ar'
                ? TextDirection.rtl
                : TextDirection.ltr,
            position: _buttonAnimation,
            child: GestureDetector(
              onTap: toggleDrawer,
              child: Container(
                height: 60,
                width: 25,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadiusDirectional.only(
                    topEnd: Radius.circular(10),
                    bottomEnd: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Directionality.of(context) == TextDirection.ltr ? TablerIcons.chevron_right : TablerIcons.chevron_left,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildDynamicKeyFeatures() {
    final fields = widget.customFields;
    if (fields.isEmpty) return [];

    // Decide how many custom fields to show
    final maxCustom = 3;
    final showCount = fields.length >= maxCustom ? maxCustom : fields.length;

    final List<Widget> items = [];

    // Add the chosen number of custom fields
    for (int i = 0; i < showCount; i++) {
      final field = fields[i];
      final value = field.value?.toString() ?? '';
      if (value.isNotEmpty) {
        items.add(customDivider());
        items.add(_buildMenuItem(field.key, value));
      }
    }

    return items;
  }

  Widget _buildMenuItem(String label, String value) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
          SizedBox(width: 16),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }

  Widget customDivider () {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Container(
        height: 0.5,
        padding: EdgeInsets.symmetric(horizontal: 20,),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.centerStart, // Starts fade from leading edge
            end: AlignmentDirectional.centerEnd,
            colors: [
              Colors.white54,
              Colors.white54,
              Colors.white38,
              Colors.white38,
              Colors.white24,
              Colors.white24,
              Colors.white12,
              Colors.white12,
              Colors.white10,
              Colors.transparent,
              Colors.transparent,
              Colors.transparent,
            ]
          )
        ),
      ),
    );
  }
}
