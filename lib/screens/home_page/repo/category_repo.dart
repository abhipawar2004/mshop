import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/api_routes.dart';

import '../../../config/constant.dart';
import '../../../services/location/location_service.dart';

class CategoryRepository {
  Future<Map<String, dynamic>> fetchCategory({
    required int perPage, required int currentPage
}) async {
    try{
      final locationService = LocationService.getStoredLocation();
      final latitude = locationService!.latitude;
      final longitude = locationService.longitude;
      final response = await AppConstant.apiBaseHelper.getAPICall(
        '${ApiRoutes.categoryApi}?per_page=$perPage&page=$currentPage&latitude=$latitude&longitude=$longitude',
        {}
      );
      return response.data;
    }catch(e){
      throw ApiException('Failed to fetch categories');
    }
  }
}