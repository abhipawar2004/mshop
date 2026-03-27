import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/api_routes.dart';
import 'package:hyper_local/config/constant.dart';

import '../../../services/location/location_service.dart';

class ShoppingListRepository {
  Future<Map<String, dynamic>> createShoppingList({required String keywords}) async {
    try{
      final locationService = LocationService.getStoredLocation();
      final latitude = locationService!.latitude;
      final longitude = locationService.longitude;
      final response = await AppConstant.apiBaseHelper.getAPICall(
          '${ApiRoutes.shoppingListApi}?latitude=$latitude&longitude=$longitude&keywords=$keywords&per_page=40',
          {}
      );
      if(response.statusCode ==  200){
        return response.data;
      }
      return {};
    } catch(e) {
      throw ApiException(e.toString());
    }
  }
}