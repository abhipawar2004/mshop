import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/api_routes.dart';
import '../../../services/location/location_service.dart';

class ProductFAQRepository {
  final ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  Future<Map<String, dynamic>> fetchProductFAQ({required String productSlug}) async {
    try{
      final locationService = LocationService.getStoredLocation();
      final latitude = locationService!.latitude;
      final longitude = locationService.longitude;
      final response = await apiBaseHelper.getAPICall(
          '${ApiRoutes.productDetailApi}$productSlug/faqs?latitude=$latitude&longitude=$longitude', {}
      );
      return response.data;
    }catch(e){
      throw ApiException(e.toString());
    }
  }
}