import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/api_routes.dart';
import 'package:hyper_local/config/constant.dart';

class DeliveryBoyFeedbackRepo {

  Future<Map<String, dynamic>> addDeliveryFeedback({
    required int deliveryBoyId,
    required int orderId,
    required String title,
    required String description,
    required int rating,
  }) async {
    try{
      final response = await AppConstant.apiBaseHelper.postAPICall(
        ApiRoutes.addDeliveryBoyFeedbackApi,
          {
            'delivery_boy_id': deliveryBoyId,
            'order_id': orderId,
            'title': title,
            'description': description,
            'rating': rating
          }
      );

      if(response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException('Failed to add delivery boy feedback');
    }
  }

  Future<Map<String, dynamic>> updateDeliveryFeedback({
    required int feedbackId,
    required String title,
    required String description,
    required int rating,
  }) async {
    try{
      final response = await AppConstant.apiBaseHelper.postAPICall(
        ApiRoutes.updateDeliveryBoyFeedbackApi + feedbackId.toString(),
          {
            'title': title,
            'description': description,
            'rating': rating
          }
      );

      if(response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException('Failed to update delivery boy feedback');
    }
  }

  Future<Map<String, dynamic>> deleteDeliveryFeedback({
    required int feedbackId,
  }) async {
    try{
      final response = await AppConstant.apiBaseHelper.deleteAPICall(
        ApiRoutes.deleteDeliveryBoyFeedbackApi + feedbackId.toString(),
        {},
      );

      if(response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException('Failed to delete delivery boy feedback');
    }
  }

}