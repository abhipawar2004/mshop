import '../../../config/api_base_helper.dart';
import '../../../config/api_routes.dart';
import '../../../config/constant.dart';
import '../model/check_delivery_zone_model.dart';

class CheckDeliveryZoneRepository {
  Future<List<CheckDeliveryZoneModel>> checkDeliveryZone ({
    required String latitude,
    required String longitude,
  }) async {
    try{
      final response = await AppConstant.apiBaseHelper.getAPICall(
          '${ApiRoutes.checkDeliveryZoneApi}?latitude=$latitude&longitude=$longitude',
          {}
      );

      if(response.statusCode == 200 || response.statusCode == 201) {
        if(response.data['success'] == true && response.data['data'] != null) {
          List<CheckDeliveryZoneModel> data = [];
          data.add(CheckDeliveryZoneModel.fromJson(response.data));
          return data;
        } else {
          return [];
        }
      } else {
        return [];
      }
    }catch(e) {
      throw ApiException('Failed to check delivery zone');
    }
  }
}