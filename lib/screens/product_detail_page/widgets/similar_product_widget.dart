import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/screens/product_detail_page/model/product_detail_model.dart';
import '../../../bloc/user_cart_bloc/user_cart_bloc.dart';
import '../../../bloc/user_cart_bloc/user_cart_event.dart';
import '../../../config/constant.dart';
import '../../../model/user_cart_model/cart_sync_action.dart';
import '../../../model/user_cart_model/user_cart.dart';
import '../../../utils/widgets/custom_product_card.dart';
import '../../../utils/widgets/custom_variant_selector_bottom_sheet.dart';

class SimilarProductWidget extends StatelessWidget {
  final List<ProductData> product;
  const SimilarProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15, ),
              child: Text(
                'Similar Products',
                style: TextStyle(
                  fontSize: isTablet(context) ? 20 : 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // padding: EdgeInsets.only(left: 15.0, right: 15.0),
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(left: 15, right: 15,),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet(context) ? 4 : 3,
                mainAxisSpacing: 8.0.w,
                crossAxisSpacing: 8.0.h,
                childAspectRatio: isTablet(context) ? 0.6 : 0.45,
              ),
              itemCount: product.length > 12 ? 12 : product.length,
              itemBuilder: (context, index) {
                final productData = product[index];
                return CustomProductCard(
                  productId: productData.id,
                  productImage: productData.mainImage,
                  productSlug: productData.slug,
                  productName: productData.title,
                  productPrice: productData.variants[0].price.toString(),
                  specialPrice: productData.variants[0].specialPrice.toString(),
                  productTags: [],
                  estimatedDeliveryTime: productData.estimatedDeliveryTime.toString(),
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
                      context.read<CartBloc>().add(AddToCart(item: item, context: context));

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
                  isStoreOpen: productData.storeStatus?.isOpen ?? true,
                  isWishListed: productData.favorite != null,
                  productVariantId: productData.variants.firstWhere((variant) => variant.isDefault).id,
                  storeId: productData.variants.firstWhere((variant) => variant.isDefault).storeId,
                  wishlistItemId: productData.favorite?.first.id ?? 0,
                  totalStocks: productData.variants.firstWhere((variant) => variant.isDefault).stock,
                  imageFit: productData.imageFit,
                  quantityStepSize: productData.quantityStepSize,
                  minQty: productData.minimumOrderQuantity,
                  totalAllowedQuantity: productData.totalAllowedQuantity,
                  indicator: productData.indicator,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
