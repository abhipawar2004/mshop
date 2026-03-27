import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/api_routes.dart';
import 'package:hyper_local/config/constant.dart';

class SellerFeedbackRepo {

  Future<Map<String, dynamic>> addSellerFeedback({
    required int orderItemId,
    required int sellerId,
    required String title,
    required String description,
    required int rating,
  }) async {
    try{
      final response = await AppConstant.apiBaseHelper.postAPICall(
          ApiRoutes.addSellerFeedbackApi,
          {
            'order_item_id': orderItemId,
            'seller_id': sellerId,
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
      throw ApiException('Failed to add Seller feedback');
    }
  }

  Future<Map<String, dynamic>> updateSellerFeedback({
    required int feedbackId,
    required String title,
    required String description,
    required int rating,
  }) async {
    try{
      final response = await AppConstant.apiBaseHelper.postAPICall(
          ApiRoutes.updateSellerFeedbackApi + feedbackId.toString(),
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
      throw ApiException('Failed to update Seller feedback');
    }
  }

  Future<Map<String, dynamic>> deleteSellerFeedback({
    required int feedbackId,
  }) async {
    try{
      final response = await AppConstant.apiBaseHelper.deleteAPICall(
        ApiRoutes.deleteSellerFeedbackApi + feedbackId.toString(),
        {},
      );

      if(response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException('Failed to delete Seller feedback');
    }
  }

}