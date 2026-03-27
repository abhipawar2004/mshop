import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/api_routes.dart';
import 'package:hyper_local/config/constant.dart';

import '../../../services/location/location_service.dart';

class UserWishlistRepository {
  Future<Map<String, dynamic>> getUserWishlist({
    required int currentPage,
    required int perPage,
}) async {
    try{
      final response = await AppConstant.apiBaseHelper.getAPICall(
          '${ApiRoutes.getWishlistApi}?page=$currentPage&per_page=$perPage',
          {}
      );
      if(response.statusCode == 200){
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> createWishlist({
    required String title}) async {
    try{
      final response = await AppConstant.apiBaseHelper.postAPICall(
        ApiRoutes.createWishlistApi,
        {'title': title},
      );
      if(response.statusCode == 200){
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> addItemInWishlist({
    required String wishlistTitle,
    required int productId,
    required int productVariantId,
    required int storeId,
  }) async {
    try{
      final response = await AppConstant.apiBaseHelper.postAPICall(
        ApiRoutes.addItemInWishlistApi,
        {
          'wishlist_title': wishlistTitle,
          'product_id': productId,
          'product_variant_id': productVariantId,
          'store_id': storeId
        },
      );
      if(response.statusCode == 200){
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> updateWishlist({
    required String title, required int wishlistId}) async {
    try{
      final response = await AppConstant.apiBaseHelper.putAPICall(
        ApiRoutes.updateWishlistApi+wishlistId.toString(),
        {'title': title},
      );
      if(response.statusCode == 200){
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> deleteWishlist({
    required int wishlistId}) async {
    try{
      final response = await AppConstant.apiBaseHelper.deleteAPICall(
        ApiRoutes.deleteWishlistApi+wishlistId.toString(),
        {},
      );
      if(response.statusCode == 200){
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> removeItemFromWishlist({
    required int itemId}) async {
    try{
      final response = await AppConstant.apiBaseHelper.deleteAPICall(
        ApiRoutes.removeItemFromWishlistApi+itemId.toString(),
        {},
      );
      if(response.statusCode == 200){
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> moveItemToAnotherWishlist({
    required int itemId,
    required int wishlistId,
  }) async {
    try{
      final response = await AppConstant.apiBaseHelper.putAPICall(
        '${ApiRoutes.moveItemToAnotherWishlistApi}$itemId/move',
        {'target_wishlist_id': wishlistId},
      );
      if(response.statusCode == 200){
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchWishlistProduct({
    required int wishlistId,
    required int currentPage,
    required int perPage,
  }) async {
    try{
      final locationService = LocationService.getStoredLocation();
      final latitude = locationService!.latitude;
      final longitude = locationService.longitude;

      final response = await AppConstant.apiBaseHelper.getAPICall(
        '${ApiRoutes.wishlistProductApi}$wishlistId?page=$currentPage&per_page=$perPage&latitude=$latitude&longitude=$longitude',
        {}
      );

      if(response.statusCode == 200) {
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException(e.toString());
    }
  }
}