import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/router/app_routes.dart';
import 'package:hyper_local/screens/cart_page/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:hyper_local/screens/cart_page/bloc/add_to_cart/add_to_cart_state.dart';
import 'package:hyper_local/screens/product_detail_page/bloc/product_detail_bloc/product_detail_bloc.dart';
import 'package:hyper_local/screens/product_detail_page/bloc/product_review_bloc/product_review_bloc.dart';
import 'package:hyper_local/screens/product_detail_page/bloc/similar_product_bloc/similar_product_bloc.dart';
import 'package:hyper_local/screens/product_detail_page/model/product_detail_model.dart';
import 'package:hyper_local/screens/product_detail_page/widgets/app_bar_widget.dart';
import 'package:hyper_local/screens/product_detail_page/widgets/product_detail_shimmer.dart';
import 'package:hyper_local/screens/product_detail_page/widgets/review_rating_card.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_delivery_time_widget.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:hyper_local/utils/widgets/dominant_colors.dart';
import 'package:hyper_local/utils/widgets/empty_states_page.dart';
import '../../../model/user_cart_model/cart_sync_action.dart';
import '../../../services/user_cart/cart_validation.dart';
import '../../../utils/widgets/custom_toast.dart';
import '../bloc/product_detail_bloc/product_detail_event.dart';
import '../bloc/product_detail_bloc/product_detail_state.dart';
import '../bloc/product_faq_bloc/product_faq_bloc.dart';
import '../widgets/rating_info_card.dart';
import '../widgets/similar_product_widget.dart';
import '../widgets/price_row_widget.dart';
import 'package:flutter/services.dart';
import 'package:hyper_local/bloc/user_cart_bloc/user_cart_bloc.dart';
import 'package:hyper_local/bloc/user_cart_bloc/user_cart_event.dart';
import 'package:hyper_local/bloc/user_cart_bloc/user_cart_state.dart';
import 'package:hyper_local/model/user_cart_model/user_cart.dart';

class ProductDetailPage extends StatefulWidget {
  final String productSlug;
  final ProductInitialData initialData;
  final VoidCallback? closeContainer;

  const ProductDetailPage({
    super.key,
    required this.productSlug,
    required this.initialData,
    this.closeContainer
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  Map<String, SwatchValues> selectedVariants = {};
  bool _showTitle = false;

  List<String> productSlugList = [];

  @override
  void initState() {
    super.initState();
    productSlugList.add(widget.productSlug);
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Attach once when the tree is built
    PrimaryScrollController.of(context).addListener(_onScroll);
  }

  void _onScroll() {
    final offset = PrimaryScrollController.of(context).offset;
    final show = offset > 200;
    if (_showTitle != show) {
      setState(() => _showTitle = show);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Map<String, String> getSelectedVariantsForApi() {
    return selectedVariants.map((key, value) => MapEntry(key, value.value));
  }

  UserCart? _getCartItem(CartState state, int productId, int productVariantId, int storeId) {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductDetailBloc()..add(FetchProductDetail(productSlug: widget.productSlug)),
        ),
        BlocProvider(
          create: (_) => ProductReviewBloc()..add(FetchProductReview(productSlug: widget.productSlug)),
        ),
        BlocProvider(
          create: (_) => ProductFAQBloc()..add(FetchProductFAQ(productSlug: widget.productSlug)),
        ),
        BlocProvider(
          create: (_) => SimilarProductBloc()..add(FetchSimilarProduct(excludeProductSlug: [widget.productSlug])),
        ),
      ],
      child: CustomScaffold(
        showViewCart: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        body: BlocListener<AddToCartBloc, AddToCartState>(
          listener: (BuildContext context, AddToCartState state) {},
          child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (BuildContext context, ProductDetailState state) {

              if(state is ProductDetailLoading) {
                // Show shimmer loading with AppBar
                return NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      AppBarWidget(
                        showTitle: false,
                        initialData: widget.initialData,
                        loadedProduct: null,
                      )
                    ];
                  },
                  body: ProductDetailShimmer(),
                );
              }
              else if (state is ProductDetailLoaded) {
                final product = state.productData[0];

                ProductVariants activeVariant = product.variants.firstWhere(
                      (v) => v.isDefault,
                );

                if(selectedVariants.isNotEmpty) {
                  final selectedTitle = selectedVariants.values.first.value.toString();

                  activeVariant = product.variants.firstWhere(
                        (v) {
                      final attrValue = v.attributes.values.first.toString();
                      return attrValue.toLowerCase().trim() ==
                          selectedTitle.toLowerCase().trim();
                    },
                    orElse: () => product.variants.firstWhere((v) => v.isDefault),
                  );
                }

                return NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      AppBarWidget(
                          showTitle: _showTitle,
                        initialData: widget.initialData,
                        loadedProduct: product,
                      )
                    ];
                  },
                  body: CustomScrollView(
                    clipBehavior: Clip.antiAlias,
                    physics: ClampingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Container(
                              color: Theme.of(context).colorScheme.surface,
                              padding: const EdgeInsets.only(top: 15, left: 12, right: 12, bottom: 8),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          product.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: isTablet(context) ? 24 : 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsGeometry.directional(top: 4, start: 4,),
                                        child: DeliveryTimeWidget(time: product.estimatedDeliveryTime.toString()),
                                      ),
                                    ],
                                  ),

                                  // Inline version — no Positioned needed
                                  if (int.parse(product.itemTotalInCart) > 0)
                                    Align(
                                      alignment: AlignmentGeometry.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 8.h),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryColor.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(5.r),
                                          ),
                                          child: Text(
                                            '🛍️ ${product.itemTotalInCart} ${AppLocalizations.of(context)!.inCart}',
                                            style: TextStyle(
                                              color: AppTheme.primaryColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              RatingBar.builder(
                                                initialRating: double.parse(product.ratings.toString()),
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 18,
                                                itemBuilder: (context, _) => Icon(
                                                  AppTheme.ratingStarIconFilled,
                                                  color: AppTheme.ratingStarColor,
                                                ),
                                                ignoreGestures: true,
                                                onRatingUpdate: (rating){},
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${product.ratings}/5 ',
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.8),
                                                ),
                                              ),
                                              Text('(${product.ratingCount})')
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                          PriceRowWidget(
                                            originalPrice: activeVariant.price.toDouble(),
                                            salePrice: activeVariant.specialPrice.toDouble(),
                                            fontSize: 12.sp,
                                            originalFontSize: 10.sp,
                                            discountFontSize: 8.sp,
                                            fontWeight: FontWeight.w700,
                                            originalPriceColor: Colors.grey.shade600,
                                            discountBackgroundColor: Colors.green.shade600,
                                            discountTextColor: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // VARIANTS
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: product.attributes.length,
                                    itemBuilder: (context, index) {
                                      return variantWidget(
                                        label: product.attributes[index].name,
                                        variantType: product.attributes[index].swatcheType,
                                        selectedValue: selectedVariants[product.attributes[index].name],
                                        onSelected: (SwatchValues value) {
                                          setState(() {
                                            selectedVariants[product.attributes[index].name] = value;
                                          });
                                        },
                                        productAttributes: product.attributes[index].swatchValues,
                                      );
                                    },
                                  ),
                                  Divider(color: Theme.of(context).colorScheme.outline,),

                                  // Expandable description
                                  ExpansionTile(
                                    expansionAnimationStyle: AnimationStyle(
                                      duration: const Duration(milliseconds: 350),
                                      curve: Curves.easeInOutCubic,
                                      reverseDuration: const Duration(milliseconds: 250),
                                    ),
                                    title: Text(
                                      l10n.viewProductDetails,
                                      style: TextStyle(
                                        fontSize: isTablet(context) ? 18 : 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).colorScheme.tertiary,
                                      ),
                                    ),
                                    collapsedIconColor: Theme.of(context).colorScheme.tertiary,
                                    iconColor: Theme.of(context).colorScheme.tertiary,
                                    initiallyExpanded: false,
                                    tilePadding: EdgeInsets.symmetric(horizontal: 0.w),
                                    childrenPadding: EdgeInsets.symmetric(horizontal: 0.w,),
                                    shape: const Border(),
                                    children: [
                                      Divider(
                                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                                        thickness: 1,
                                      ),
                                      SizedBox(height: 12,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                                        child: Column(
                                          children: _buildSpecTableRows(context, product, l10n),
                                        ),
                                      ),
                                      Html(
                                        data: product.description,
                                        shrinkWrap: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 9.h),

                            // Store Name
                            sellerStoreName(
                              storeName: product.variants.first.storeName,
                              storeSlug: product.variants.first.storeSlug,
                              sellerName: product.seller,
                            ),

                            // Customer Review
                            BlocBuilder<ProductReviewBloc, ProductReviewState>(
                              builder: (BuildContext context, ProductReviewState state) {
                                if(state is ProductReviewLoaded) {
                                  if (state.productReview.first.data.totalReviews > 0 || state.productReview.first.data.reviews.isNotEmpty) {
                                    return Column(
                                      children: [
                                        Card(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0.r),
                                          ),
                                          margin: EdgeInsets.only(left: 0.w, right: 0.w, top: 12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 10.w,
                                                  right: 10.w,
                                                  top: 10.w,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      l10n.customerReviews,
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).colorScheme.tertiary,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        GoRouter.of(context).push(
                                                            AppRoutes.reviewRatingPage,
                                                            extra: {
                                                              'productSlug': product.slug
                                                            }
                                                        );
                                                      },
                                                      child: Text(
                                                        l10n.seeAll,
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: AppTheme.primaryColor,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              if (state.productReview.first.data.totalReviews > 0)
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                                                  child: RatingInfoCard(reviewModel: state.productReview.first),
                                                ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 0.w,
                                                  vertical: 12.w,
                                                ),
                                                child: LayoutBuilder(
                                                  builder: (context, constraints) {
                                                    return SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      physics: BouncingScrollPhysics(),
                                                      padding: EdgeInsets.only(right: 12.w),
                                                      child: IntrinsicHeight(
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                          children: state.productReview.first.data.reviews
                                                              .take(5)
                                                              .toList()
                                                              .asMap()
                                                              .entries
                                                              .map((entry) {
                                                            int index = entry.key;
                                                            var review = entry.value;
                                                            return SizedBox(
                                                              width: 280.w,
                                                              child: ReviewRatingCard(
                                                                rating: review.rating.toDouble(),
                                                                date: review.createdAt,
                                                                reviewText: review.comment,
                                                                index: index,
                                                                images: review.reviewImages,
                                                                maxLines: 10,
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 9.h),
                                      ],
                                    );
                                  }
                                  return SizedBox.shrink();
                                }
                                return SizedBox.shrink();
                              },
                            ),

                            BlocBuilder<ProductFAQBloc, ProductFAQState>(
                              builder: (BuildContext context, ProductFAQState state) {
                                if(state is ProductFAQLoaded){
                                  final faqData = state.productData.first.data;
                                  return faqData.isNotEmpty
                                      ? Column(
                                    children: [
                                      Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(0.r),
                                        ),
                                        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 10.w,
                                                right: 10.w,
                                                top: 10.w,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    l10n.questionAndAnswers,
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.bold,
                                                      color: Theme.of(context).colorScheme.tertiary,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      GoRouter.of(context).push(
                                                          AppRoutes.faqPage,
                                                          extra: {
                                                            'productSlug': product.slug
                                                          }
                                                      );
                                                    },
                                                    child: Text(
                                                      l10n.seeAll,
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: AppTheme.primaryColor,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 0.w,
                                                vertical: 12.w,
                                              ),
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                physics: BouncingScrollPhysics(),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: List.generate(
                                                    faqData.length > 5 ? 5 : faqData.length,
                                                        (index) {
                                                      final qa = faqData[index];
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                          right: index == (faqData.length - 1) ? 0.w : 12.w,
                                                          left: index == 0 ? 12.w : 0.w,
                                                        ),
                                                        child: GestureDetector(
                                                          onTap: (){
                                                            GoRouter.of(context).push(
                                                                AppRoutes.faqPage,
                                                                extra: {
                                                                  'productSlug': product.slug
                                                                }
                                                            );
                                                          },
                                                          child: _buildQAItem(
                                                            question: qa.question,
                                                            answer: qa.answer,
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
                                      ),
                                    ],
                                  )
                                      : SizedBox.shrink();
                                }
                                return SizedBox.shrink();
                              },
                            ),

                            SizedBox(height: 9.h),

                            BlocBuilder<SimilarProductBloc, SimilarProductState>(
                                builder: (context, state) {
                                  if(state is SimilarProductLoaded) {
                                    return SimilarProductWidget(product: state.similarProduct);
                                  }
                                  return SizedBox.shrink();
                                }
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              if(state is ProductDetailFailed) {
                return NoProductPage();
              }
              return CustomCircularProgressIndicator();
            },
          ),
        ),
        bottomNavigationBar: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            if (state is! ProductDetailLoaded) {
              return SizedBox.shrink();
            }

            final product = state.productData[0];
            ProductVariants activeVariant = product.variants.firstWhere((v) => v.isDefault);

            if (selectedVariants.isNotEmpty) {
              final selectedTitle = selectedVariants.values.first.value.toString();
              activeVariant = product.variants.firstWhere(
                    (v) {
                  final attrValue = v.attributes.values.first.toString();
                  return attrValue.toLowerCase().trim() == selectedTitle.toLowerCase().trim();
                },
                orElse: () => product.variants.firstWhere((v) => v.isDefault),
              );
            }

            return Container(
              height: 80,
              decoration: BoxDecoration(
                color: isDarkMode(context) ? Theme.of(context).colorScheme.onPrimary : Colors.white,
                boxShadow: [
                  // Main bottom shadow
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: Offset(0, 4),
                  ),
                  // Ambient/soft shadow for depth
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: Offset(0, 2),
                  ),
                  // Optional: subtle top ambient lift (removes flat look)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PriceRowWidget(
                          originalPrice: activeVariant.price.toDouble(),
                          salePrice: activeVariant.specialPrice.toDouble(),
                          fontSize: 12.sp,
                          originalFontSize: 10.sp,
                          discountFontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                          originalPriceColor: Colors.grey.shade600,
                        ),
                      ),

                      Text(
                        l10n.inclusiveOfAllTax,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 8,),
                  if (activeVariant.stock > 0)
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 120,
                            minWidth: 80,
                          ),
                          child: BlocBuilder<CartBloc, CartState>(
                            builder: (context, cartState) {
                              final int productId = product.id;
                              int productVariantId = activeVariant.id;
                              final int storeId = activeVariant.storeId;

                              // Ensure we use the selected variant if available
                              if (selectedVariants.isNotEmpty) {
                                final selectedTitle = selectedVariants.values.first.value.toString();
                                try {
                                  final selectedVariant = product.variants.firstWhere(
                                        (v) {
                                      final attrValue = v.attributes.values.first.toString();
                                      return attrValue.toLowerCase().trim() == selectedTitle.toLowerCase().trim();
                                    },
                                  );
                                  productVariantId = selectedVariant.id;
                                } catch (_) {}
                              }

                              final cartItem = _getCartItem(cartState, productId, productVariantId, storeId);
                              final isInCart = cartItem != null;

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                                height: 45,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: isInCart ? AppTheme.primaryColor : Colors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(
                                      scale: Tween<double>(begin: 0.85, end: 1.0).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                                child: isInCart ? Container(
                                  key: const ValueKey('stepper_inner'),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await HapticFeedback.lightImpact();
                                          if (cartItem.quantity > product.quantityStepSize) {
                                            if (context.mounted) {
                                              context.read<CartBloc>().add(
                                                UpdateCartQty(
                                                    cartKey: cartItem.cartKey,
                                                    quantity:  cartItem.quantity - product.quantityStepSize,
                                                    cartItemId:  cartItem.serverCartItemId,
                                                    context:  context
                                                ),
                                              );
                                            }
                                          } else {
                                            if (context.mounted) {
                                              context.read<CartBloc>().add(
                                                RemoveFromCart(cartKey: cartItem.cartKey, context: context),
                                              );
                                            }
                                          }
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                                          child: Icon(
                                            TablerIcons.minus,
                                            size: 20.r,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        cartItem.quantity.toString(),
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await HapticFeedback.lightImpact();
                                          // Check max limit if needed
                                          if (context.mounted) {
                                            final error =
                                            CartValidation.validateProductAddToCart(
                                              context: context,
                                              requestedQuantity:
                                              cartItem.quantity + product.quantityStepSize,
                                              minQty: product.minimumOrderQuantity,
                                              maxQty: product.totalAllowedQuantity,
                                              stock: activeVariant.stock,
                                              isStoreOpen: product.storeStatus!.isOpen,
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
                                                    quantity:  cartItem.quantity + product.quantityStepSize,
                                                    cartItemId:  cartItem.serverCartItemId,
                                                    context:  context),
                                              );
                                            }
                                          }
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                                          child: Icon(
                                            TablerIcons.plus,
                                            size: 20.r,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    : SizedBox(
                                  key: const ValueKey('add_button_inner'),
                                  height: 45,
                                  width: double.infinity,
                                  child: CustomButton(
                                    onPressed: () {
                                      // 1️⃣ Auth check
                                      /*if (Global.userData == null) {
                                        AuthGuard.ensureLoggedIn(context);
                                        return;
                                      }*/

                                      final l10n = AppLocalizations.of(context)!;
                                      final isStoreOpen = product.storeStatus?.isOpen ?? true;

                                      // 2️⃣ Resolve selected variant
                                      ProductVariants? selectedVariant;

                                      if (product.attributes.isNotEmpty) {
                                        if (selectedVariants.isEmpty) {
                                          ToastManager.show(
                                            context: context,
                                            message: l10n.pleaseSelectVariant,
                                            type: ToastType.error,
                                          );
                                          return;
                                        }

                                        final selectedTitle = selectedVariants.values.first.value;

                                        selectedVariant = product.variants.firstWhere(
                                              (v) => normalize(v.title) == normalize(selectedTitle),
                                          orElse: () => product.variants.firstWhere((v) => v.isDefault),
                                        );
                                      }
                                      else {
                                        selectedVariant = product.variants.firstWhere((v) => v.isDefault);
                                      }

                                      // 3️⃣ SINGLE STORE VALIDATION (before quantity checks)
                                      final cartBloc = context.read<CartBloc>();

                                      // 4️⃣ PRODUCT VALIDATION
                                      final requestedQty = cartItem != null
                                          ? cartItem.quantity + product.quantityStepSize
                                          : product.quantityStepSize;

                                      final productError = CartValidation.validateProductAddToCart(
                                        context: context,
                                        requestedQuantity: requestedQty,
                                        minQty: product.minimumOrderQuantity,
                                        maxQty: product.totalAllowedQuantity,
                                        stock: selectedVariant.stock,
                                        isStoreOpen: isStoreOpen,
                                      );

                                      if (productError != null) {
                                        ToastManager.show(
                                          context: context,
                                          message: productError,
                                          type: ToastType.error,
                                        );
                                        return;
                                      }

                                      // 5️⃣ Create cart item
                                      final item = UserCart(
                                        productId: product.id.toString(),
                                        variantId: selectedVariant.id.toString(),
                                        variantName: selectedVariant.title,
                                        vendorId: selectedVariant.storeId.toString(),
                                        name: product.title,
                                        image: product.mainImage,
                                        price: selectedVariant.specialPrice.toDouble(),
                                        originalPrice: selectedVariant.price.toDouble(),
                                        quantity: product.quantityStepSize,
                                        serverCartItemId: null,
                                        syncAction: CartSyncAction.add,
                                        updatedAt: DateTime.now(),
                                        minQty: product.minimumOrderQuantity,
                                        maxQty: product.totalAllowedQuantity,
                                        isOutOfStock: selectedVariant.stock <= 0,
                                        isSynced: false,
                                      );

                                      // 6️⃣ Add to cart
                                      cartBloc.add(AddToCart(item: item, context:  context));
                                    },
                                    child: Text(
                                      l10n.add,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                             );
                            },
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10. r),
                        border: Border.all(color: AppTheme.primaryColor, width: 1.w),
                      ),
                      child: Text(
                        l10n.outOfStock,
                        style: TextStyle(
                          color: AppTheme.errorColor,
                        ),
                      ),
                    ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildSpecTableRows(
      BuildContext context,
      ProductData product,
      AppLocalizations l10n,
      ) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.tertiary;
    final labelColor = textColor.withValues(alpha: 0.75);
    final valueColor = textColor.withValues(alpha: 0.95);

    final List<MapEntry<String, String>> specs = [];

    if (product.brand.isNotEmpty) {
      specs.add(MapEntry(l10n.brand, product.brand));
    }
    if (product.category.isNotEmpty) {
      specs.add(MapEntry(l10n.category, product.category));
    }
    specs.add(MapEntry(
      l10n.packOf,
      '${product.quantityStepSize} ${product.quantityStepSize > 1 ? 'Units' : 'Unit'}',
    ));

    if (product.madeIn.isNotEmpty) {
      specs.add(MapEntry(l10n.madeIn, product.madeIn));
    }
    if (product.indicator.isNotEmpty) {
      specs.add(MapEntry(
        l10n.indicator,
        removeUnderscores(capitalizeFirstLetter(product.indicator)),
      ));
    }

    // Guarantee & Warranty
    final guarantee = product.guaranteePeriod.toString();
    if (guarantee.isNotEmpty && guarantee != '0') {
      specs.add(MapEntry(l10n.guaranteePeriod, guarantee));
    }

    final warranty = product.warrantyPeriod.toString();
    if (warranty.isNotEmpty && warranty != '0') {
      specs.add(MapEntry(l10n.warrantyPeriod, warranty));
    }

    // Returnable
    final isReturnable = product.isReturnable == 1 || product.isReturnable.toString() == '1';
    specs.add(MapEntry(
      l10n.returnable,
      isReturnable ? l10n.yes : l10n.na,
    ));

    // ── All custom fields ─────────────────────────────────────────────────
    for (final field in product.customFields) {
      final valueStr = field.value?.toString().trim() ?? '';
      if (valueStr.isNotEmpty) {
        specs.add(MapEntry(field.key, valueStr));
      }
    }

    if (specs.isEmpty) {
      return [
        SizedBox.shrink()
      ];
    }

    // Build striped table rows
    return List.generate(specs.length, (index) {
      final entry = specs[index];
      final isEven = index % 2 == 0;
      final isLast = index == specs.length - 1;

      return Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: isEven
              ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
              : theme.colorScheme.onPrimary.withValues(alpha: 0.3),
          border: isLast ? Border(
            bottom: BorderSide(
              color: theme.colorScheme.secondary.withValues(alpha: 0.4),
              width: 0.8,
            ),
            left: BorderSide(
              color: theme.colorScheme.secondary.withValues(alpha: 0.4),
              width: 0.8,
            ),
            right: BorderSide(
              color: theme.colorScheme.secondary.withValues(alpha: 0.4),
              width: 0.8,
            ),
          ) : Border(
            top: BorderSide(
              color: theme.colorScheme.secondary.withValues(alpha: 0.4),
              width: 0.8,
            ),
            left: BorderSide(
              color: theme.colorScheme.secondary.withValues(alpha: 0.4),
              width: 0.8,
            ),
            right: BorderSide(
              color: theme.colorScheme.secondary.withValues(alpha: 0.4),
              width: 0.8,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label column
            SizedBox(
              width: 140.w,
              child: Text(
                entry.key,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
              ),
            ),

            SizedBox(width: 16.w),

            // Value column
            Expanded(
              child: Text(
                entry.value,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: valueColor,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget variantWidget({
    required String label,
    required String variantType,
    required SwatchValues? selectedValue,
    required Function(SwatchValues) onSelected,
    required List<SwatchValues> productAttributes,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$label: ',
                style: TextStyle(
                  fontSize: isTablet(context) ? 20 : 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.8),
                ),
              ),
              Text(
                selectedValue?.value ?? '',
                style: TextStyle(
                  fontSize: isTablet(context) ? 20 : 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.6),
                ),
              )
            ],
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: variantType == 'color' ? 35.h : 25.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productAttributes.length,
              itemBuilder: (BuildContext context, int index) {
                final currentValue = productAttributes[index];
                final isSelected = selectedValue == currentValue;
                final color = getColorFromHex(currentValue.swatch);
                return GestureDetector(
                  onTap: () => onSelected(currentValue),
                  child: Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: variantType == 'color'
                        ? Container(
                      width: 35.w,
                      height: 45.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryColor : Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                      ),
                    )
                        : Container(
                      padding: EdgeInsets.symmetric(horizontal: 15,),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor : Theme.of(context).colorScheme.outline.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        currentValue.value,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? Colors.white : Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildQAItem({
    required String question,
    required String answer,
  }) {
    return Container(
      width: 250.w,
      height: 135.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Question Section (Top Partition)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(11.r),
                topRight: Radius.circular(11.r),
              ),
            ),
            child: Text(
              question,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                height: 1.3,
              ),
            ),
          ),
          // Divider
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w300,
                  height: 1.4,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sellerStoreName ({
    required String storeName,
    required String storeSlug,
    required String sellerName,
  }){
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: (){
        GoRouter.of(context).push(
          AppRoutes.nearbyStoreDetails,
          extra: {
            'store-slug': storeSlug,
            'store-name': storeName,
          },
        );
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.r),
        ),
        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.soldBy} ',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: isTablet(context) ? 20 : 14.sp,
                ),
              ),
              Expanded(
                child: Text(
                  storeName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: isTablet(context) ? 20 : 14.sp,
                  ),
                ),
              ),
              Directionality.of(context) == TextDirection.ltr
                  ? const Icon(TablerIcons.chevron_right, color: Colors.grey)
                  : const Icon(TablerIcons.chevron_left, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

}

class RatingBarWidget extends StatelessWidget {
  final int score;
  final double percentage;
  const RatingBarWidget({required this.score, required this.percentage, super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$score',
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color:  Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${percentage.toInt()}%',
          style:  TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 14),
        ),
      ],
    );
  }
}

class ProductInitialData {
  final String title;
  final String mainImage;
  final List<String> additionalImages;
  final String videoUrl;

  ProductInitialData({
    required this.title,
    required this.mainImage,
    this.additionalImages = const [],
    this.videoUrl = '',
  });
}