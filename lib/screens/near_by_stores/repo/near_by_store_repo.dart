import 'dart:convert';
import 'dart:developer';

import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/api_routes.dart';
import 'package:hyper_local/config/constant.dart';

import '../../../services/location/location_service.dart';
import '../model/store_detail_model.dart';

class NearByStoreRepo {
  Future<Map<String, dynamic>?> getNearByStores({
    int page = 1,
    int perPage = 15,
    required String searchQuery,
  }) async {
    try {
      final locationService = LocationService.getStoredLocation();
      if (locationService == null) {
        return null;
      }

      final latitude = locationService.latitude;
      final longitude = locationService.longitude;

      final Map<String, dynamic> query = {
        'latitude': latitude,
        'longitude': longitude,
        'page': page.toString(),
        'per_page': perPage.toString(),
        if (searchQuery.isNotEmpty) 'search': searchQuery
      };

      log('🔵 STORE API PAYLOAD: ${jsonEncode(query)}');
      log('🔵 STORE API URL: ${ApiRoutes.nearByStores}');

      final response = await AppConstant.apiBaseHelper.getAPICall(
        ApiRoutes.nearByStores,
        query,
      );

      log('🟢 STORE API RESPONSE: ${jsonEncode(response.data)}');

      // Extract .data and ensure it's a Map
      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        log('API SUCCESS: Stores fetched');
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<StoreDetailModel>> fetchStoreDetail(
      {required String storeSlug}) async {
    try {
      final locationService = LocationService.getStoredLocation();
      final latitude = locationService!.latitude;
      final longitude = locationService.longitude;

      final url =
          '${ApiRoutes.storeDetailApi}$storeSlug?latitude=$latitude&longitude=$longitude';

      log('🔵 STORE DETAIL API PAYLOAD: storeSlug=$storeSlug, latitude=$latitude, longitude=$longitude');
      log('🔵 STORE DETAIL API URL: $url');

      final response = await AppConstant.apiBaseHelper.getAPICall(url, {});

      log('🟢 STORE DETAIL API RESPONSE: ${jsonEncode(response.data)}');

      if (response.statusCode == 200) {
        List<StoreDetailModel> storeData = [];
        storeData.add(StoreDetailModel.fromJson(response.data));
        return storeData;
      } else {
        return [];
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
