import '../../../config/api_base_helper.dart';
import '../../../config/api_routes.dart';
import '../../../config/constant.dart';
import '../../../services/location/location_service.dart';

class SubCategoryRepository {

  Future<Map<String, dynamic>> fetchSubCategory({
      required String slug,
      required bool isForAllCategory,
      int? page,
      int? perPage,
      bool? isFiltered = false
  }) async {
    try{
      final locationService = LocationService.getStoredLocation();
      final latitude = locationService!.latitude;
      final longitude = locationService.longitude;
      String apiUrl = '';
      final perPageParam = perPage;
      final pageParam = page != null ? '&page=$page' : '';

      String filterParam = '';

      if(isFiltered == true) {
        filterParam = 'filter=top_category';
      } else {
        filterParam = '';
      }

      if(isForAllCategory) {
        apiUrl = '${ApiRoutes.allTabSubCategoryApi}?$filterParam&latitude=$latitude&longitude=$longitude&per_page=$perPageParam$pageParam';
      } else {
        apiUrl = '${ApiRoutes.subCategoryApi}?slug=$slug&latitude=$latitude&longitude=$longitude&per_page=$perPage$pageParam';
      }
      final response = await AppConstant.apiBaseHelper.getAPICall(
        apiUrl,
          {});
      return response.data;
    }catch(e){
      throw ApiException('Failed to fetch Banners');
    }
  }
}