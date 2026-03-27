import '../../../config/api_base_helper.dart';
import '../../../config/api_routes.dart';
import '../../../config/constant.dart';
import '../../../services/location/location_service.dart';

class BrandsRepository {

  Future<Map<String, dynamic>> fetchBrands(
      {required String categorySlug}) async {
    try{
      final locationService = LocationService.getStoredLocation();
      final latitude = locationService!.latitude;
      final longitude = locationService.longitude;
      String apiUrl = '';
      if(categorySlug.isNotEmpty){
        apiUrl = '${ApiRoutes.brandsApi}?scope_category_slug=$categorySlug&latitude=$latitude&longitude=$longitude';
      } else {
        apiUrl = '${ApiRoutes.brandsApi}?latitude=$latitude&longitude=$longitude';
      }
      final response = await AppConstant.apiBaseHelper.getAPICall(
          apiUrl,
          {}
      );
      return response.data;
    }catch(e){
      throw ApiException('Failed to fetch Banners');
    }
  }
}