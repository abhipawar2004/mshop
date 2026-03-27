import 'package:flutter/foundation.dart';
import 'package:hyper_local/config/api_routes.dart';
import 'package:hyper_local/config/constant.dart';

class CartRemoteRepository {
  Future<Map<String, dynamic>> addItemToCart({
    required int productVariantId,
    required int storeId,
    required int quantity,
  }) async {
    debugPrint(
        '[API] ADD → variant:$productVariantId store:$storeId qty:$quantity');

    final response = await AppConstant.apiBaseHelper.postAPICall(
      ApiRoutes.addToCartApi,
      {
        'product_variant_id': productVariantId,
        'store_id': storeId,
        'quantity': quantity,
      },
    );

    return response.data;
  }

  Future<void> updateItemQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    debugPrint('[API] UPDATE → cartItemId:$cartItemId qty:$quantity');

    await AppConstant.apiBaseHelper.postAPICall(
      ApiRoutes.removeItemFromCartApi + cartItemId.toString(),
      {'quantity': quantity},
    );
  }

  Future<void> removeItemFromCart({
    required int cartItemId,
  }) async {
    debugPrint('[API] DELETE → cartItemId:$cartItemId');

    await AppConstant.apiBaseHelper.deleteAPICall(
      ApiRoutes.removeItemFromCartApi + cartItemId.toString(),
      {},
    );
  }
}
