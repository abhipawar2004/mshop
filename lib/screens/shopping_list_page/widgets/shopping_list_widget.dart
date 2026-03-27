import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/screens/product_detail_page/model/product_detail_model.dart';
import 'package:hyper_local/utils/widgets/custom_product_card.dart';

import '../../../bloc/user_cart_bloc/user_cart_bloc.dart';
import '../../../bloc/user_cart_bloc/user_cart_event.dart';
import '../../../model/user_cart_model/cart_sync_action.dart';
import '../../../model/user_cart_model/user_cart.dart';
import '../../../utils/widgets/custom_variant_selector_bottom_sheet.dart';

class ShoppingListWidget extends StatelessWidget {
  final List<ProductData> product;
  final String title;
  final int totalProducts;
  const ShoppingListWidget({
    super.key,
    required this.product,
    required this.title,
    required this.totalProducts
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              'Result for "$title"',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(height: 10.h,),
          SizedBox(
            height: 200.h,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 12.w),
              itemCount: totalProducts,
              itemBuilder: (context, index) {
                final productData = product[index];
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: SizedBox(
                    width: 140,
                    child: CustomProductCard(
                      productId: productData.id,
                      productImage: productData.mainImage,
                      productSlug: productData.slug,
                      productName: productData.title,
                      productPrice: productData.variants.first.price.toString(),
                      specialPrice: productData.variants.first.specialPrice.toString(),
                      productTags: [],
                      estimatedDeliveryTime: productData.estimatedDeliveryTime.toString(),
                      assetImage: '',
                      ratings: double.parse(productData.ratings.toString()),
                      ratingCount: productData.ratingCount,
                      onAddToCart: () {
                        if (productData.variants.length > 1) {
                          showVariantBottomSheet(
                            variantsList: productData.variants,
                            productData: productData,
                            productImage: productData.mainImage,
                            quantityStepSize: productData.quantityStepSize,
                            context: context,
                          );
                        } else {
                          final item = UserCart(
                              productId: productData.id.toString(),
                              variantId: productData.variants.firstWhere((variant) => variant.isDefault).id.toString(),
                              variantName: productData.variants.firstWhere((variant) => variant.isDefault).title.toString(),
                              vendorId: productData.variants.firstWhere((variant) => variant.isDefault).storeId.toString(),
                              name: productData.title,
                              image: productData.mainImage,
                              price: productData.variants.firstWhere((variant) => variant.isDefault).specialPrice.toDouble(),
                              originalPrice: productData.variants.firstWhere((variant) => variant.isDefault).price.toDouble(),
                              quantity: productData.quantityStepSize,
                              serverCartItemId: null,
                              syncAction: CartSyncAction.add,
                              updatedAt: DateTime.now(),
                              minQty: productData.minimumOrderQuantity,
                              maxQty: productData.totalAllowedQuantity,
                              isOutOfStock: productData.variants.firstWhere((variant) => variant.isDefault).stock <= 0,
                              isSynced: false
                          );

                          context.read<CartBloc>().add(AddToCart(item: item, context:  context));

                          /*context.read<AddToCartBloc>().add(
                            AddItemToCart(
                              productVariantId: productData.variants.first.id,
                              storeId: productData.variants.first.storeId,
                              quantity: productData.quantityStepSize,
                            ),
                          );*/
                        }
                      },
                      variantCount: productData.variants.length,
                      onVariantSelectorRequested: productData.variants.length > 1
                          ? () => showVariantBottomSheet(
                        variantsList: productData.variants,
                        productData: productData,
                        productImage: productData.mainImage,
                        quantityStepSize: productData.quantityStepSize,
                        context: context,
                      )
                          : null,
                      isStoreOpen: true,
                      isWishListed: productData.favorite != null,
                      productVariantId: productData.variants.firstWhere((variant) => variant.isDefault).id,
                      storeId: productData.variants.firstWhere((variant) => variant.isDefault).storeId,
                      wishlistItemId: productData.favorite?.first.id ?? 0,
                      totalStocks: productData.variants.firstWhere((variant) => variant.isDefault).stock,
                      imageFit: productData.imageFit,
                      quantityStepSize: productData.quantityStepSize,
                      minQty: productData.minimumOrderQuantity,
                      totalAllowedQuantity: productData.totalAllowedQuantity,
                    ),
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}
