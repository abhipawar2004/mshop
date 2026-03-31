import 'dart:convert';
import 'dart:developer';

import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/api_routes.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/model/sorting_model/sorting_model.dart';
import '../../../services/location/location_service.dart';
import '../model/product_listing_type.dart';

class CategoryProductRepository {
  Future<Map<String, dynamic>> fetchProductsByType({
    required ProductListingType type,
    required String identifier,
    String? storeSlug,
    String? sortType,
    required int perPage,
    required int currentPage,
    bool? isSearchInStore,
    String? includeChildCategories,
  }) async {
    try {
      final latitude = LocationService.getStoredLocation()!.latitude;
      final longitude = LocationService.getStoredLocation()!.longitude;
      String apiUrl = '';

      final String searchApiUrl =
          '${ApiRoutes.searchApi}?search=$identifier&per_page=$perPage&page=$currentPage&latitude=$latitude&longitude=$longitude&sort=${sortType ?? SortType.relevance}';

      final String storeApiUrl =
          '${ApiRoutes.storeProductApi}?store=$storeSlug&per_page=$perPage&page=$currentPage&latitude=$latitude&longitude=$longitude&sort=${sortType ?? SortType.relevance}';

      if (isSearchInStore == true) {
        apiUrl =
            '${ApiRoutes.searchApi}?search=$identifier&store=$storeSlug&per_page=$perPage&page=$currentPage&latitude=$latitude&longitude=$longitude&sort=${sortType ?? SortType.relevance}';
      } else {
        apiUrl = switch (type) {
          ProductListingType.category =>
            '${ApiRoutes.categoryProductApi}?categories=$identifier&per_page=$perPage&page=$currentPage&latitude=$latitude&longitude=$longitude&sort=${sortType ?? SortType.relevance}&include_child_categories=${includeChildCategories ?? '1'}',
          ProductListingType.brand =>
            '${ApiRoutes.categoryProductApi}?brands=$identifier&per_page=$perPage&page=$currentPage&latitude=$latitude&longitude=$longitude&sort=${sortType ?? SortType.relevance}',
          ProductListingType.store => storeApiUrl,
          ProductListingType.search => searchApiUrl,
          ProductListingType.featuredSection => () {
              // Fallback "See All" sections created from home fallback use synthetic slugs.
              if (identifier == 'all-products') {
                return '${ApiRoutes.categoryProductApi}?per_page=$perPage&page=$currentPage&latitude=$latitude&longitude=$longitude&sort=${sortType ?? SortType.relevance}&include_child_categories=1';
              }

              if (identifier.startsWith('category-')) {
                final categorySlug = identifier.replaceFirst('category-', '');
                return '${ApiRoutes.categoryProductApi}?categories=$categorySlug&per_page=$perPage&page=$currentPage&latitude=$latitude&longitude=$longitude&sort=${sortType ?? SortType.relevance}&include_child_categories=1';
              }

              return '${ApiRoutes.specificFeatureSectionProductApi}$identifier/products?per_page=$perPage&page=$currentPage&latitude=$latitude&longitude=$longitude&sort=${sortType ?? SortType.relevance}';
            }(),
        };
      }

      log('🔵 PRODUCT LISTING API TYPE: $type');
      log('🔵 PRODUCT LISTING API URL: $apiUrl');
      if (type == ProductListingType.store) {
        log('🔵 STORE PRODUCT API - Store Slug: $storeSlug');
      }

      final response = await AppConstant.apiBaseHelper.getAPICall(apiUrl, {});

      log('🟢 PRODUCT LISTING API RESPONSE: ${jsonEncode(response.data)}');

      return response.data;
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
