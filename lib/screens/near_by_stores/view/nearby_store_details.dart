import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/model/sorting_model/sorting_model.dart';
import 'package:hyper_local/screens/near_by_stores/bloc/store_detail/store_detail_bloc.dart';
import 'package:hyper_local/screens/near_by_stores/model/near_by_store_model.dart';
import 'package:hyper_local/screens/product_detail_page/model/product_detail_model.dart';
import 'package:hyper_local/screens/product_listing_page/bloc/product_listing/product_listing_bloc.dart';
import 'package:hyper_local/screens/product_listing_page/model/product_listing_type.dart';
import 'package:hyper_local/screens/product_listing_page/widgets/custom_filter_sort_btn_widget.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import 'package:hyper_local/utils/widgets/custom_product_card.dart';
import 'package:hyper_local/utils/widgets/custom_refresh_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/utils/widgets/custom_shimmer.dart';
import 'package:hyper_local/utils/widgets/custom_sorting_bottom_sheet.dart';
import 'package:hyper_local/utils/widgets/custom_textfield.dart';
import 'package:hyper_local/utils/widgets/empty_states_page.dart';
import '../../../bloc/user_cart_bloc/user_cart_bloc.dart';
import '../../../bloc/user_cart_bloc/user_cart_event.dart';
import '../../../model/user_cart_model/cart_sync_action.dart';
import '../../../model/user_cart_model/user_cart.dart';
import '../../../utils/widgets/custom_variant_selector_bottom_sheet.dart';

class NearbyStoreDetails extends StatelessWidget {
  final String storeSlug;
  final String storeName;

  const NearbyStoreDetails({
    super.key,
    required this.storeSlug,
    required this.storeName,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => StoreDetailBloc()
            ..add(FetchStoreDetail(storeSlug: storeSlug)),
        ),
        BlocProvider(
          create: (_) => ProductListingBloc()
            ..add(
              FetchListingProducts(
                type: ProductListingType.store,
                storeSlug: storeSlug,
                identifier: storeSlug,
              ),
            ),
        ),
      ],
      child: _NearbyStoreDetailsView(
        storeSlug: storeSlug,
        storeName: storeName,
      ),
    );
  }
}

class _NearbyStoreDetailsView extends StatefulWidget {
  final String storeSlug;
  final String storeName;

  const _NearbyStoreDetailsView({
    required this.storeSlug,
    required this.storeName,
  });

  @override
  State<_NearbyStoreDetailsView> createState() => _NearbyStoreDetailsState();
}

class _NearbyStoreDetailsState extends State<_NearbyStoreDetailsView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isSearchInStore = false;
  bool isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<ProductListingBloc>().state;
      if (state is ProductListingLoaded && !state.hasReachedMax) {
        context.read<ProductListingBloc>().add(
          FetchMoreListingProducts(
            type: ProductListingType.store,
            storeSlug: widget.storeSlug,
            identifier: _searchController.text.trim(),
            isSearchInStore: isSearchInStore,
          ),
        );
      }
    }
  }

  void _applySorting(SortOption sortOption) {
    context.read<ProductListingBloc>().add(
      FetchSortedListingProducts(
        type: ProductListingType.store,
        storeSlug: widget.storeSlug,
        identifier: _searchController.text.trim(),
        sortType: sortOption.apiValue,
        isSearchInStore: isSearchInStore,
      ),
    );
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    isSearchInStore = query.isNotEmpty;

    context.read<ProductListingBloc>().add(
      FetchListingProducts(
        type: ProductListingType.store,
        storeSlug: widget.storeSlug,
        identifier: query,
        isSearchInStore: isSearchInStore,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        elevation: 0,
        title: _buildSearchBar(),
        titleSpacing: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: isDarkMode(context) ? Colors.grey.shade800 : Colors.grey.shade300, height: 1),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 45,
      margin: const EdgeInsetsGeometry.directional(end: 12),
      child: CustomTextFormField(
        controller: _searchController,
        hintText: 'Search in ${widget.storeName}',

        suffixIcon: _searchController.text.isNotEmpty ? Icons.close : Icons.search,
        onSuffixIconTap: () {
          setState(() {
            if (isSubmitted) {
              isSubmitted = false;
              isSearchInStore = false;
              _searchController.clear();
              _performSearch();
            } else if (_searchController.text.isNotEmpty) {
              isSearchInStore = true;
              isSubmitted = true;
              _performSearch();
            }
          });
          FocusScope.of(context).unfocus();
        },
        onFieldSubmitted: (_) {
          setState(() {
            isSearchInStore = _searchController.text.trim().isNotEmpty;
            isSubmitted = true;
          });
          _performSearch();
        },
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<StoreDetailBloc, StoreDetailState>(
      listener: (context, state) {},
      builder: (context, storeState) {
        if (storeState is StoreDetailLoading) {
          return CustomCircularProgressIndicator();
        }
        if (storeState is StoreDetailFailed) {
          return NoProductPage(onRetry: _performSearch);
        }
        if (storeState is StoreDetailLoaded) {
          return _buildScrollableContent(storeState.storeData);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildScrollableContent(StoreData store) {
    return CustomRefreshIndicator(
      onRefresh: () async {
        context.read<ProductListingBloc>().add(
          FetchMoreListingProducts(
            type: ProductListingType.store,
            storeSlug: widget.storeSlug,
            identifier: _searchController.text.trim(),
            isSearchInStore: isSearchInStore,
          ),
        );
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStoreHeader(store, store.distance ?? 0.0, store.avgStoreRating ?? '0.0', store.totalStoreFeedback!),
            const SizedBox(height: 68),
            _buildStoreInfo(store, store.distance ?? 0.0),
            Container(
              height: 5,
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
            SizedBox(height: 10,),
            BlocBuilder<ProductListingBloc, ProductListingState>(
              builder: (context, state) => _buildProductsSection(state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreHeader(StoreData store, double distance, String rating, int totalStoreFeedback) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          child: Container(
            height: isTablet(context) ? 280 : 170,
            width: double.infinity,
            color: Colors.grey[200],
            child: store.banner?.isNotEmpty == true
                ? CustomImageContainer(imagePath: store.banner!, fit: BoxFit.cover)
                : Container(
              decoration: const BoxDecoration(color: AppTheme.primaryColor),
              child: const Center(
                child: Icon(Icons.store, size: 50, color: Colors.white70),
              ),
            ),
          ),
        ),
        PositionedDirectional(
          start: 16,
          bottom: -60,
          child: Container(
            width: isTablet(context) ? 120 : 90,
            height: isTablet(context) ? 120 : 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipOval(
              child: store.logo?.isNotEmpty == true
                  ? CustomImageContainer(imagePath: store.logo!, fit: BoxFit.cover)
                  : Container(
                color: Colors.blue.shade50,
                child: const Icon(Icons.store, size: 28, color: AppTheme.primaryColor),
              ),
            ),
          ),
        ),
        PositionedDirectional(
          end: 12,
          bottom: -40,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(AppTheme.ratingStarIconFilled, size: 16, color: AppTheme.ratingStarColor),
                const SizedBox(width: 4),
                Text('$rating/5 ($totalStoreFeedback)', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStoreInfo(StoreData store, double distance) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(store.name ?? "Unknown Store",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(child: Text(store.address ?? "No address", style: TextStyle(fontSize: 13, color: Colors.grey[600]))),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                child: Text('${distance.toStringAsFixed(1)} km',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green.shade700)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: store.status?.isOpen == true ? 'Open Now' : 'Closed',
                        style: TextStyle(fontSize: 13, color: store.status?.isOpen == true ? Colors.green : Colors.red),
                      ),
                      if (store.timing != null && store.timing!.isNotEmpty)
                        TextSpan(text: ' · ${store.timing}', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildProductsSection(ProductListingState state) {
    if (state is ProductListingFailed) {
      return SizedBox(
        height: isTablet(context) ? 1000 : 500,
        child: Center(child: NoProductPage())
      );
    }

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Row(
              children: [
                CustomFilterSortBtnWidget(
                  onTap: _showSortBottomSheet,
                  buttonName: 'Sort',
                  iconData: HeroiconsOutline.arrowsUpDown,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (state is ProductListingLoading) SizedBox(height: isTablet(context) ? 1000 : 500, child: Center(child: const CustomCircularProgressIndicator())),
          if (state is ProductListingLoaded)
            _buildProductContent(state.productList, state.isFilterLoading, state.hasReachedMax),
        ],
      ),
    );
  }

  Widget _buildProductContent(List<ProductData> productData, bool isFilterLoading, bool hasReachedMax) {
    if (isFilterLoading) {
      return SizedBox(height: isTablet(context) ? 1000 : 500, child: Center(child: CustomCircularProgressIndicator()));
    }
    if (productData.isEmpty) {
      return NoProductPage(onRetry: _performSearch);
    }
    return _buildProductGrid(productData, hasReachedMax);
  }

  Widget _buildProductGrid(List<ProductData> productData, bool hasReachedMax) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet(context) ? 4 : 3,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: 0.75,
          mainAxisExtent: 212.h,
        ),
        itemCount: hasReachedMax ? productData.length : productData.length + 3,
        itemBuilder: (context, index) => _buildGridItem(productData, index, hasReachedMax),
      ),
    );
  }

  Widget _buildGridItem(List<ProductData> productData, int index, bool hasReachedMax) {
    if (index >= productData.length) return productShimmer();
    final product = productData[index];
    final variant = product.variants.isNotEmpty ? product.variants.first : ProductVariants();

    return CustomProductCard(
      productId: product.id,
      productImage: product.mainImage,
      productName: product.title,
      productSlug: product.slug,
      productPrice: variant.price.toString(),
      specialPrice: variant.specialPrice.toString(),
      productTags: [],
      estimatedDeliveryTime: product.estimatedDeliveryTime,
      ratings: product.ratings?.toDouble() ?? 0.0,
      ratingCount: product.ratingCount,
      onAddToCart: () {
        if (product.variants.length > 1) {
          showVariantBottomSheet(
            variantsList: product.variants,
            productData: product,
            productImage: product.mainImage,
            quantityStepSize: product.quantityStepSize,
            context: context,
          );
        } else {
          final item = UserCart(
              productId: product.id.toString(),
              variantId: product.variants.firstWhere((variant) => variant.isDefault).id.toString(),
              variantName: product.variants.firstWhere((variant) => variant.isDefault).title.toString(),
              vendorId: product.variants.firstWhere((variant) => variant.isDefault).storeId.toString(),
              name: product.title,
              image: product.mainImage,
              price: product.variants.firstWhere((variant) => variant.isDefault).specialPrice.toDouble(),
              originalPrice: product.variants.firstWhere((variant) => variant.isDefault).price.toDouble(),
              quantity: product.quantityStepSize,
              serverCartItemId: null,
              syncAction: CartSyncAction.add,
              updatedAt: DateTime.now(),
              minQty: product.minimumOrderQuantity,
              maxQty: product.totalAllowedQuantity,
              isOutOfStock: product.variants.firstWhere((variant) => variant.isDefault).stock <= 0,
              isSynced: false
          );
          context.read<CartBloc>().add(AddToCart(item: item, context:  context));

          /*context.read<AddToCartBloc>().add(
            AddItemToCart(
              productVariantId: variant.id,
              storeId: variant.storeId,
              quantity: product.quantityStepSize,
            ),
          );*/
        }
      },
      variantCount: product.variants.length,
      onVariantSelectorRequested: product.variants.length > 1
          ? () => showVariantBottomSheet(
        variantsList: product.variants,
        productData: product,
        productImage: product.mainImage,
        quantityStepSize: product.quantityStepSize,
        context: context,
      )
          : null,
      isStoreOpen: product.storeStatus?.isOpen ?? true,
      isWishListed: product.favorite != null,
      productVariantId: variant.id,
      storeId: variant.storeId,
      wishlistItemId: product.favorite?.first.id ?? 0,
      totalStocks: variant.stock,
      imageFit: product.imageFit,
      quantityStepSize: product.quantityStepSize,
      minQty: product.minimumOrderQuantity,
      totalAllowedQuantity: product.totalAllowedQuantity,
    );
  }

  Widget productShimmer() {
    return Column(
      children: [
        ShimmerWidget.rectangular(height: 130, width: 130, borderRadius: 15, isBorder: true,),
        SizedBox(height: 10),
        ShimmerWidget.rectangular(isBorder: false, height: 15, width: 130, borderRadius: 15),
      ],
    );
  }

  void _showSortBottomSheet() {
    final currentState = context.read<ProductListingBloc>().state;
    final currentSortType = currentState is ProductListingLoaded ? currentState.currentSortType : SortType.relevance;

    CustomSortBottomSheet.show(
      context: context,
      currentSortType: currentSortType,
      onSortSelected: _applySorting,
    );
  }
}














/*
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/model/sorting_model/sorting_model.dart';
import 'package:hyper_local/screens/near_by_stores/model/near_by_store_model.dart';
import 'package:hyper_local/screens/product_detail_page/model/product_detail_model.dart';
import 'package:hyper_local/screens/product_listing_page/bloc/nested_category/nested_category_bloc.dart';
import 'package:hyper_local/screens/product_listing_page/bloc/product_listing/product_listing_bloc.dart';
import 'package:hyper_local/screens/product_listing_page/model/product_listing_type.dart';
import 'package:hyper_local/screens/product_listing_page/widgets/custom_filter_sort_btn_widget.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_product_card.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/utils/widgets/custom_shimmer.dart';
import 'package:hyper_local/utils/widgets/custom_sorting_bottom_sheet.dart';
import 'package:hyper_local/utils/widgets/empty_states_page.dart';

class NearbyStoreDetails extends StatefulWidget {
  final StoraData store;

  const NearbyStoreDetails({super.key, required this.store});

  @override
  State<NearbyStoreDetails> createState() => _NearbyStoreDetailsState();
}

class _NearbyStoreDetailsState extends State<NearbyStoreDetails> {
  final TextEditingController _searchController = TextEditingController();
  bool isDataFirstTime = false;

  @override
  void initState() {
    // TODO: implement initState
    isDataFirstTime = false;
    // Use new unified event
    context.read<ProductListingBloc>().add(
      FetchListingProducts(
        type: ProductListingType.store,
        identifier: widget.store.slug!,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applySorting(SortOption sortOption) {
    // Sorting uses new unified event
    context.read<ProductListingBloc>().add(
          FetchSortedListingProducts(
            type: ProductListingType.store,
            identifier: widget.store.slug!,
            sortType: sortOption.apiValue,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: _buildSearchBar(),
          titleSpacing: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.grey.shade300,
              height: 1,
            ),
          ),
        ),
        body: _buildBody());
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                hintText: "Search in ${widget.store.name}",
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                // TODO: implement product search
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final store = widget.store;

    final double distance = store.distance ?? 0.0;
    final String rating = store.avgProductsRating ?? "0.0";
    final int reviewCount = 5823;
    final bool isOpen = store.status!.isOpen ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Banner Image
                ClipRRect(
                  child: Container(
                    height: 170,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: store.banner?.isNotEmpty == true
                        ? CachedNetworkImage(
                            imageUrl: store.banner!,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade300,
                                    Colors.lightBlue.shade400
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Center(
                                child: Icon(Icons.store,
                                    size: 50, color: Colors.white70),
                              ),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade300,
                                    Colors.lightBlue.shade400
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Center(
                                child: Icon(Icons.store,
                                    size: 50, color: Colors.white70),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade300,
                                  Colors.lightBlue.shade400
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Center(
                              child: Icon(Icons.store,
                                  size: 50, color: Colors.white70),
                            ),
                          ),
                  ),
                ),

                // Circular Logo (Bottom Left Overlay)
                Positioned(
                  left: 16,
                  bottom: -60,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.white,
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignCenter),
                    ),
                    child: ClipOval(
                      child: store.logo?.isNotEmpty == true
                          ? CachedNetworkImage(
                              imageUrl: store.logo!,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                color: Colors.blue.shade50,
                                child: const Icon(Icons.store,
                                    size: 28, color: Colors.blue),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                color: Colors.blue.shade50,
                                child: const Icon(Icons.store,
                                    size: 28, color: Colors.blue),
                              ),
                            )
                          : Container(
                              color: Colors.blue.shade50,
                              child: const Icon(Icons.store,
                                  size: 28, color: Colors.blue),
                            ),
                    ),
                  ),
                ),

                // Rating Badge (Top Right)
                Positioned(
                  right: 12,
                  bottom: -40,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.black),
                        const SizedBox(width: 4),
                        Text(
                          '$rating/5',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          ' ($reviewCount)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),

        SizedBox(
          height: 15.h,
        ),

        // Store Information
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Store Name
              Text(
                store.name ?? "Unknown Store",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Address with Distance Badge
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      store.address ?? "No address",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Distance Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${distance.toStringAsFixed(1)} km',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ),

              // store timing

              Row(
                children: [
                  Icon(TablerIcons.address_book,
                      size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      store.address ?? "No address",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // PRODUCT DETAILS
        Expanded(child: _buildProductDetails())
      ],
    );
  }

  Widget _buildProductDetails() {
    log('is building');

    return BlocConsumer<ProductListingBloc, ProductListingState>(
      listener: (BuildContext context, ProductListingState state) {
        if (state is ProductListingLoading) {
          setState(() {
            isDataFirstTime = true;
          });
        }
      },
      builder: (BuildContext context, ProductListingState state) {
        print('OFUEFBIOFUB  $state');
        if (state is ProductListingLoaded) {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo is ScrollUpdateNotification &&
                  !state.hasReachedMax &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 200) {
                context.read<ProductListingBloc>().add(
                      FetchMoreListingProducts(
                        type: ProductListingType.store,
                        identifier: widget.store.slug!,
                      ),
                    );
              }
              return false;
            },
            child: Padding(
              padding: EdgeInsets.only(top: 2.5.h),
              child: Container(
                // color: Colors.white,
                color: Theme.of(context).colorScheme.primary,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 12.0,
                      ),
                      child: Row(
                        children: [
                          */
/*CustomFilterSortBtnWidget(
                                      onTap: () {
                                        _showFilterBottomSheet();
                                      },
                                      buttonName: 'Filters',
                                      iconData:
                                          HeroiconsOutline.adjustmentsHorizontal),
                                  SizedBox(
                                    width: 10.w,
                                  ),CustomFilterSortBtnWidget(
                                      onTap: () {
                                        _showFilterBottomSheet();
                                      },
                                      buttonName: 'Filters',
                                      iconData:
                                          HeroiconsOutline.adjustmentsHorizontal),
                                  SizedBox(
                                    width: 10.w,
                                  ),*/
/*

                          CustomFilterSortBtnWidget(
                              onTap: () {
                                _showSortBottomSheet();
                              },
                              buttonName: 'Sort',
                              iconData: HeroiconsOutline.arrowsUpDown),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey.shade200,
                      width: double.infinity,
                    ),
                    productList(
                        productData: state.productList,
                        isFilterLoading: state.isFilterLoading,
                        hasReachedMax: state.hasReachedMax,
                        isLoading: state.isLoading),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is ProductListingLoading) {
          return CustomCircularProgressIndicator();
        } else if (state is ProductListingFailed) {
          return NoProductPage();
        }
        return SizedBox.shrink();
      },
    );
  }

  void _showSortBottomSheet() {
    // Get current sort type from bloc state
    final currentState = context.read<ProductListingBloc>().state;
    final currentSortType = currentState is ProductListingLoaded
        ? currentState.currentSortType
        : SortType.relevance;

    CustomSortBottomSheet.show(
      context: context,
      currentSortType: currentSortType,
      onSortSelected: (SortOption selectedSort) {
        // Directly call API - bloc will handle state update automatically
        _applySorting(selectedSort);
      },
    );
  }

  Widget productList({
    required List<ProductData> productData,
    required bool isFilterLoading,
    required bool hasReachedMax,
    required bool isLoading,
  }) {
    return Expanded(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _buildContent(productData, isFilterLoading, hasReachedMax),
      ),
    );
  }

  Widget _buildContent(
      List<ProductData> productData, bool isFilterLoading, bool hasReachedMax) {
    print('Build Product Content ${productData == []}');
    if (isFilterLoading) {
      return Container(
        color: Colors.white.withOpacity(0.7),
        child: Center(child: CustomCircularProgressIndicator()),
      );
    }

    if (productData.isEmpty) {
      return Container(
        child: Center(child: Text('No products found')),
      );
    }

    return _buildProductGrid(productData, hasReachedMax);
  }

  Widget _buildProductGrid(List<ProductData> productData, bool hasReachedMax) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: GridView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 10.h,
          mainAxisExtent: 212.h,
        ),
        itemCount: hasReachedMax ? productData.length : productData.length + 3,
        itemBuilder: (context, index) => _buildGridItem(productData, index),
      ),
    );
  }

  Widget _buildGridItem(List<ProductData> productData, int index) {
    if (index >= productData.length) {
      return productShimmer();
    }

    final product = productData[index];
    return CustomProductCard(
      productImage: product.mainImage,
      productName: product.title,
      productSlug: product.slug,
      productPrice: product.variants.first.specialPrice.toString(),
      discountPrice: product.variants.first.price.toString(),
      discountPercentage: '',
      estimatedDeliveryTime: product.estimatedDeliveryTime.toString(),
      assetImage: '',
      productTags: product.tags,
      ratings: double.parse(product.ratings),
      ratingCount: product.ratingCount,
      onAddToCart: () {},
      isStoreOpen: product.storeStatus?.isOpen ?? true,
    );
  }

  Widget productShimmer() {
    return Column(
      children: [
        ShimmerWidget.rectangular(
          isBorder: true,
          height: 130,
          width: 130,
          borderRadius: 15,
        ),
        const SizedBox(height: 10.0),
        ShimmerWidget.rectangular(
          isBorder: true,
          height: 15,
          width: 130,
          borderRadius: 15,
        ),
      ],
    );
  }

  Widget categoryList() {
    return BlocBuilder<NestedCategoryBloc, NestedCategoryState>(
      builder: (context, state) {
        if (state is NestedCategoryLoaded) {
          // Ensure we have a selected category
          // if (selectedSubcategory.id == null) {
          //   selectedSubcategory = state.subCategoryData.first;
          //   _currentSelectedIndex = 0;
          // }
          return Container(
            width: 90.w,
            color: Theme.of(context).colorScheme.surface,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: state.subCategoryData.length,
              itemBuilder: (context, index) {
                final subcategory = state.subCategoryData[index];
                final isSelected = true;

                return Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 12.0,
                      ),
                      child: GestureDetector(
                        // onTap: () {
                        //   if (widget.type == ProductListingType.category && subcategory.subcategoryCount! > 0) {
                        //     GoRouter.of(context).push(AppRoutes.productListing, extra: {
                        //       'isTheirMoreCategory': subcategory.subcategoryCount! > 0,
                        //       'title': subcategory.title,
                        //       'logo': subcategory.image,
                        //       'totalProduct': subcategory.productCount,
                        //       'type': ProductListingType.category,
                        //       'identifier': subcategory.slug,
                        //     });
                        //   } else {
                        //     // Update selection and trigger slide
                        //     setState(() {
                        //       selectedSubcategory = subcategory;
                        //       _currentSelectedIndex = index; // This makes the indicator slide
                        //     });
                        //
                        //     context.read<ProductListingBloc>().add(
                        //       FetchSortedListingProducts(
                        //         type: ProductListingType.category,
                        //         identifier: subcategory.slug ?? '',
                        //         sortType: 'default',
                        //       ),
                        //     );
                        //   }
                        // },
                        child: Column(
                          children: [
                            Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                imageUrl: subcategory.image!,
                                height: isSelected ? 45 : 40,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              subcategory.title ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                          ),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 350),
                            width: 4.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.r),
                                bottomLeft: Radius.circular(8.r),
                              ),
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
*/
