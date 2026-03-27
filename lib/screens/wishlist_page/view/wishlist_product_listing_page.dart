import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_shimmer.dart';
import '../../../bloc/user_cart_bloc/user_cart_bloc.dart';
import '../../../bloc/user_cart_bloc/user_cart_event.dart';
import '../../../config/constant.dart';
import '../../../model/user_cart_model/cart_sync_action.dart';
import '../../../model/user_cart_model/user_cart.dart';
import '../../../utils/widgets/custom_product_card.dart';
import '../../../utils/widgets/custom_scaffold.dart';
import '../bloc/wishlist_product_bloc/wishlist_product_bloc.dart';
import '../model/wishlist_product_model.dart';
import 'package:hyper_local/l10n/app_localizations.dart';

class WishlistProductListingPage extends StatefulWidget {
  final int wishlistId;
  const WishlistProductListingPage({
    super.key,
    required this.wishlistId
  });

  @override
  State<WishlistProductListingPage> createState() => _WishlistProductListingPageState();
}

class _WishlistProductListingPageState extends State<WishlistProductListingPage> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistProductBloc>().add(
      FetchWishlistProductData(
        wishlistId: widget.wishlistId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showViewCart: true,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: false,
        title: BlocBuilder<WishlistProductBloc, WishlistProductState>(
          builder: (BuildContext context, WishlistProductState state) {

            if (state is WishlistProductLoaded) {
              return Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.wishlistName,
                        style: TextStyle(
                          fontSize: isTablet(context) ? 24 : 20.sp,
                          fontFamily: AppTheme.fontFamily,
                         ),
                      ),
                      Text(
                        '${state.totalProducts} items',
                        style: TextStyle(
                          fontSize: isTablet(context) ? 14 : 10.sp,
                          color: Colors.grey,
                          fontFamily: AppTheme.fontFamily,
                        ),
                      )
                    ],
                  ),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
      body: BlocConsumer<WishlistProductBloc, WishlistProductState>(
        listener: (BuildContext context, WishlistProductState state) {},
        builder: (BuildContext context, WishlistProductState state) {
          if (state is WishlistProductLoaded) {
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo is ScrollUpdateNotification &&
                    !state.hasReachedMax &&
                    scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 50) {}
                return false;
              },
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                child: Column(
                  children: [
                    Container(
                      height: 1,
                      color: Colors.grey.shade200,
                      width: double.infinity,
                    ),
                    productList(
                      productData: state.wishlistProductItems,
                      hasReachedMax: state.hasReachedMax,
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is WishlistProductLoading) {
            return CustomCircularProgressIndicator();
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget productList({
    required List<WishlistProductItems> productData,
    required bool hasReachedMax,
  }) {
    return Expanded(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _buildContent(productData, hasReachedMax),
      ),
    );
  }

  Widget _buildContent(
      List<WishlistProductItems> productData,
      bool hasReachedMax,
      ) {

    if (productData.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noProductsFound));
    }

    return _buildProductGrid(productData, hasReachedMax);
  }

  Widget _buildProductGrid(List<WishlistProductItems> productData, bool hasReachedMax) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: GridView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet(context) ? 4 : 3,
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 10.h,
          mainAxisExtent: 200.h,
        ),
        itemCount: productData.length,
        itemBuilder: (context, index) => _buildGridItem(productData, index),
      ),
    );
  }

  Widget _buildGridItem(List<WishlistProductItems> productData, int index) {

    final product = productData[index];
    return CustomProductCard(
      productId: product.product!.id!,
      productImage: product.product!.image!,
      productSlug: product.product!.slug!,
      productName: product.product!.title!,
      productPrice: product.variant!.price.toString(),
      specialPrice: product.variant!.specialPrice.toString(),
      productTags: [],
      estimatedDeliveryTime: product.product!.estimatedDeliveryTime.toString(),
      assetImage: '',
      ratings: double.parse(product.product!.ratings.toString()),
      ratingCount: product.product!.ratingCount!,
      onAddToCart: (){
        final item = UserCart(
            productId: product.id.toString(),
            variantId: product.variant!.id.toString(),
            variantName: product.product!.title.toString(),
            vendorId: product.variant!.storeId.toString(),
            name: product.product!.title.toString(),
            image: product.product!.image!,
            price: product.variant!.specialPrice!.toDouble(),
            originalPrice: product.variant!.price!.toDouble(),
            quantity: product.product!.quantityStepSize!,
            serverCartItemId: null,
            syncAction: CartSyncAction.add,
            updatedAt: DateTime.now(),
            minQty: product.product!.minimumOrderQuantity!,
            maxQty: product.product!.totalAllowedQuantity!,
            isOutOfStock: product.variant!.stock! <= 0,
            isSynced: false
        );
        context.read<CartBloc>().add(AddToCart(item: item,context:  context));
        /*context.read<AddToCartBloc>().add(
            AddItemToCart(
              productVariantId: product.variant!.id!,
              storeId: product.variant!.storeId!,
              quantity: product.product!.quantityStepSize!,
            ),
          );*/
      },
      isStoreOpen: product.product!.storeStatus!.isOpen ?? true,
      isWishListed: false,
      productVariantId: product.variant!.id!,
      storeId: product.variant!.storeId!,
      totalStocks: product.variant!.stock!,
      showWishlist: false,
      wishlistItemId: 0,
      imageFit: product.product!.imageFit ?? 'contain',
      quantityStepSize: product.product!.quantityStepSize!,
      minQty: product.product!.minimumOrderQuantity!,
      totalAllowedQuantity: product.product!.totalAllowedQuantity!,
    );

    /*return WishlistProductCard(
      productImage: product.product!.image!,
      productName: product.product!.title!,
      productSlug: product.product!.slug!,
      price: product.variant!.price.toString(),
      specialPrice: product.variant!.specialPrice.toString(),
      onMoveToAnotherWishlist: (){
        _showMoveToWishlistSheet(
            context,
            product.id!,
            product.variant!.id!,
            product.store!.id!,
            product.wishlistId!
        );
      },
    );*/
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

}