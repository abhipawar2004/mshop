import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import 'package:hyper_local/screens/product_detail_page/model/product_detail_model.dart';
import '../../../bloc/user_cart_bloc/user_cart_bloc.dart';
import '../../../bloc/user_cart_bloc/user_cart_event.dart';
import '../../../config/constant.dart';
import '../../../model/user_cart_model/cart_sync_action.dart';
import '../../../model/user_cart_model/user_cart.dart';
import '../../../utils/widgets/custom_product_card.dart';
import '../../../utils/widgets/custom_variant_selector_bottom_sheet.dart';

class YouMightAlsoLikeProductWidget extends StatelessWidget {
  final List<ProductData> productData;
  final int? addressId;
  final String? promoCode;
  final bool? rushDelivery;
  final bool? useWallet;
  final bool? isFromCartPage;

  const YouMightAlsoLikeProductWidget({
    super.key,
    required this.productData,
    this.addressId,
    this.promoCode,
    this.rushDelivery,
    this.useWallet,
    this.isFromCartPage
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 12.0.w,
              right: 12.0.w,
              top: 12.h,
              bottom: 12.h
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.youMightAlsoLike,
                  style: TextStyle(
                    fontSize: isTablet(context) ? 24 : 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200.h,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 12.0.w),
              scrollDirection: Axis.horizontal,
              itemCount: productData.length > 10 ? 10 : productData.length,
              itemBuilder: (context, index) {
                final product = productData[index];
                ProductVariants? defaultVariant;
                if (product.variants.isNotEmpty) {
                  defaultVariant = product.variants.firstWhere(
                    (variant) => variant.isDefault == true,
                    orElse: () => product.variants.first,
                  );
                }

                // Set price and specialPrice based on the default variant
                final price = defaultVariant != null
                    ? defaultVariant.price.toString()
                    : '0';
                final specialPrice = defaultVariant != null
                    ? defaultVariant.specialPrice.toString()
                    : '';
                return Padding(
                  padding: EdgeInsets.only(right: 12.0.w),
                  child: SizedBox(
                    width: isTablet(context) ? 80.w : 120.w,
                    child: CustomProductCard(
                      productId: product.id,
                      productImage: product.mainImage,
                      productSlug: product.slug,
                      productName: product.title,
                      productPrice: price,
                      specialPrice: specialPrice,
                      productTags: [],
                      estimatedDeliveryTime: product.estimatedDeliveryTime.toString(),
                      assetImage: '',
                      ratings: double.parse(product.ratings.toString()),
                      ratingCount: product.ratingCount,
                      onAddToCart: (){
                        if (product.variants.length > 1) {
                          showVariantBottomSheet(
                            variantsList: product.variants,
                            productData: product,
                            productImage: product.mainImage,
                            quantityStepSize: product.quantityStepSize,
                            context: context,
                            addressId: addressId,
                            promoCode: promoCode,
                            rushDelivery: rushDelivery,
                            useWallet: useWallet,
                            isFromCartPage: isFromCartPage
                          );
                        }
                        else {
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
                          context.read<CartBloc>().add(AddToCart(
                            item: item,
                            context:  context,
                            isFromCartPage: true,
                            useWallet: useWallet,
                            rushDelivery: rushDelivery,
                            addressId: addressId,
                            promoCode: promoCode
                          ));

                          /*context.read<AddToCartBloc>().add(
                            AddItemToCart(
                              productVariantId: product.variants.first.id,
                              storeId: product.variants.first.storeId,
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
                          addressId: addressId,
                          promoCode: promoCode,
                          rushDelivery: rushDelivery,
                          useWallet: useWallet,
                          isFromCartPage: isFromCartPage
                        ) : null,
                      isStoreOpen: product.storeStatus?.isOpen ?? true,
                      isWishListed: product.favorite != null,
                      productVariantId: product.variants.firstWhere((variant) => variant.isDefault).id,
                      storeId: product.variants.firstWhere((variant) => variant.isDefault).storeId,
                      wishlistItemId: product.favorite?.first.id ?? 0,
                      totalStocks: product.variants.firstWhere((variant) => variant.isDefault).stock,
                      imageFit: product.imageFit,
                      quantityStepSize: product.quantityStepSize,
                      minQty: product.minimumOrderQuantity,
                      totalAllowedQuantity: product.totalAllowedQuantity,
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
}
