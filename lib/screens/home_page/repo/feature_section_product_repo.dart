import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hyper_local/config/api_base_helper.dart';

import '../../../config/api_routes.dart';
import '../../../config/constant.dart';
import '../../../services/location/location_service.dart';

class FeatureSectionProductRepository {
  Future<Map<String, dynamic>> fetchFeatureSectionProduct({
    required String slug,
    required int perPage,
    required int page,
  }) async {
    try {
      final locationService = LocationService.getStoredLocation();
      final latitude = locationService!.latitude;
      final longitude = locationService.longitude;
      final requestPayload = <String, dynamic>{
        'scope_category_slug': slug,
        'latitude': latitude,
        'longitude': longitude,
        'page': page,
        'per_page': perPage,
      };
      String apiUrl = '';
      if (slug.isNotEmpty) {
        apiUrl =
            '${ApiRoutes.featureSectionProductApi}?scope_category_slug=$slug&latitude=$latitude&longitude=$longitude&page=$page&per_page=$perPage';
      } else {
        apiUrl =
            '${ApiRoutes.featureSectionProductApi}?latitude=$latitude&longitude=$longitude&page=$page&per_page=$perPage';
      }

      if (kDebugMode) {
        log('========== HOME PRODUCT API REQUEST ==========',
            name: 'HOME_PRODUCT_API');
        log('url: $apiUrl', name: 'HOME_PRODUCT_API');
        log('payload: ${jsonEncode(requestPayload)}', name: 'HOME_PRODUCT_API');
        log('==============================================',
            name: 'HOME_PRODUCT_API');
      }

      final response = await AppConstant.apiBaseHelper.getAPICall(apiUrl, {});

      if (kDebugMode) {
        log('========== HOME PRODUCT API RESPONSE =========',
            name: 'HOME_PRODUCT_API');
        log('status: ${response.statusCode}', name: 'HOME_PRODUCT_API');
        log('body: ${jsonEncode(response.data)}', name: 'HOME_PRODUCT_API');
        log('==============================================',
            name: 'HOME_PRODUCT_API');
      }

      final responseData = response.data;
      final featuredTotal =
          int.tryParse(responseData['data']?['total']?.toString() ?? '0') ?? 0;

      if (responseData['success'] == true && featuredTotal == 0) {
        final fallbackUrl = slug.isNotEmpty
            ? '${ApiRoutes.categoryProductApi}?categories=$slug&per_page=$perPage&page=$page&latitude=$latitude&longitude=$longitude&include_child_categories=1'
            : '${ApiRoutes.categoryProductApi}?per_page=$perPage&page=$page&latitude=$latitude&longitude=$longitude';

        if (kDebugMode) {
          log('========== HOME PRODUCT FALLBACK REQUEST ==========',
              name: 'HOME_PRODUCT_API');
          log('url: $fallbackUrl', name: 'HOME_PRODUCT_API');
          log('===================================================',
              name: 'HOME_PRODUCT_API');
        }

        final fallbackResponse =
            await AppConstant.apiBaseHelper.getAPICall(fallbackUrl, {});
        final fallbackData = fallbackResponse.data;
        final fallbackProducts =
            (fallbackData['data']?['data'] as List<dynamic>?) ?? <dynamic>[];

        if (kDebugMode) {
          log('========== HOME PRODUCT FALLBACK RESPONSE =========',
              name: 'HOME_PRODUCT_API');
          log('status: ${fallbackResponse.statusCode}',
              name: 'HOME_PRODUCT_API');
          log('body: ${jsonEncode(fallbackData)}', name: 'HOME_PRODUCT_API');
          log('===================================================',
              name: 'HOME_PRODUCT_API');
        }

        if (fallbackData['success'] == true && fallbackProducts.isNotEmpty) {
          return {
            'success': true,
            'message': fallbackData['message'] ?? responseData['message'],
            'data': {
              'current_page': fallbackData['data']?['current_page'] ?? page,
              'last_page': fallbackData['data']?['last_page'] ?? page,
              'per_page': fallbackData['data']?['per_page'] ?? perPage,
              // Keep this as a section list with one synthetic section for Home UI.
              'total': 1,
              'data': [
                {
                  'id': -1,
                  'title': slug.isNotEmpty ? 'Products' : 'All Products',
                  'slug': slug.isNotEmpty ? 'category-$slug' : 'all-products',
                  'style': 'without_background',
                  'background_type': 'none',
                  'background_color': null,
                  'mobile_background_image': '',
                  'tablet_background_image': '',
                  'products': fallbackProducts,
                  'products_count': fallbackProducts.length,
                }
              ]
            }
          };
        }
      }

      return responseData;
    } catch (e) {
      if (kDebugMode) {
        log('HOME PRODUCT API ERROR: $e', name: 'HOME_PRODUCT_API');
      }
      throw ApiException(e.toString());
    }
  }
}
