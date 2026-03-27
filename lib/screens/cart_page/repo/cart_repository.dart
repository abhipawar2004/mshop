import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/api_routes.dart';
import 'package:hyper_local/config/constant.dart';
import '../../../services/location/location_service.dart';
import '../model/get_cart_model.dart';

class CartRepository {

  Future<dynamic> addItemToCart ({
    required int productVariantId, required int storeId, required int quantity
  }) async {
    try{
      final response = await AppConstant.apiBaseHelper.postAPICall(
          ApiRoutes.addToCartApi,
          {
            'product_variant_id': productVariantId,
            'store_id': storeId,
            'quantity': quantity
          }
      );
      return response.data;
    }catch(e){
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> updateItemQuantity ({
    required int cartItemId, required int quantity}) async {
    try{
      final response = await AppConstant.apiBaseHelper.postAPICall(
          ApiRoutes.removeItemFromCartApi+cartItemId.toString(),
          {
            'quantity': quantity
          }
      );
      if(response.statusCode == 200) {
        return response.data;
      } else {
        return {};
      }
    }catch(e){
      throw ApiException('Failed to remove item from cart');
    }
  }

  Future<List<GetCartModel>> getCartItems({
    required int? addressId,
    String? promoCode,
    bool? rushDelivery,
    bool? useWallet
}) async {
    try{
      final location = LocationService.getStoredLocation();
      final queryParams = <String, String>{};
      if (addressId != null) queryParams['address_id'] = addressId.toString();
      if (promoCode != null && promoCode.isNotEmpty) queryParams['promo_code'] = promoCode;
      if (rushDelivery != null) queryParams['rush_delivery'] = rushDelivery.toString();
      if (useWallet != null) queryParams['use_wallet'] = useWallet.toString();
      queryParams['latitude'] = location!.latitude.toString();
      queryParams['longitude'] = location.longitude.toString();

      // Construct the URL with query parameters
      final uri = Uri.parse(ApiRoutes.getCartApi).replace(queryParameters: queryParams);

      final response = await AppConstant.apiBaseHelper.getAPICall(
          uri.toString(),
          {},
      );
      if(response.statusCode == 200) {
        final List<GetCartModel> getCart = [];
        getCart.add(GetCartModel.fromJson(response.data));
        return getCart;
      } else {
        return [];
      }
    }catch(e){
      throw ApiException('Failed to get cart items');
    }
  }

  Future<Map<String, dynamic>> removeItemFromCart ({required int cartItemId}) async {
    try{
      final response = await AppConstant.apiBaseHelper.deleteAPICall(
          ApiRoutes.removeItemFromCartApi+cartItemId.toString(),
          {}
      );
      if(response.statusCode == 200) {
        return response.data;
      } else {
        return {};
      }
    }catch(e){
      throw ApiException('Failed to remove item from cart');
    }
  }

  Future<Map<String, dynamic>> clearCart () async {
    try{
      final response = await AppConstant.apiBaseHelper.getAPICall(
          ApiRoutes.clearCartApi,
          {}
      );
      if(response.statusCode == 200) {
        return response.data;
      } else {
        return {};
      }
    }catch(e){
      throw ApiException('Failed to remove item from cart');
    }
  }

  Future<Map<String, dynamic>> syncCart({
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final payload = {
        'items': items,
      };

      debugPrint('[SYNC] Sending cart sync payload: ${jsonEncode(payload)}');

      final response = await AppConstant.apiBaseHelper.postAPICall(
        ApiRoutes.cartSyncApi,
        payload,
      );

      debugPrint('[SYNC] Response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw ApiException('Failed to sync cart: ${response.data.toString()}');
      }
    } catch (e) {
      debugPrint('[SYNC] Error: $e');
      throw ApiException('Failed to sync cart: $e');
    }
  }
}