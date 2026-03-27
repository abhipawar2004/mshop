import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/api_routes.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:image_picker/image_picker.dart';

class ProductFeedbackRepo {

  Future<Map<String, dynamic>> addProductFeedback({
    required int orderItemId,
    required String title,
    required String description,
    required int rating,
    required List<XFile> images,
  }) async {
    try{
      final form = await formDataWithImages(
        fields: {
          'order_item_id': orderItemId,
          'title': title,
          'comment': description,
          'rating': rating,
        },
        images: images,
        imageFieldLabel: 'review_images'
      );
      final response = await AppConstant.apiBaseHelper.postAPICall(
          ApiRoutes.addProductFeedbackApi,
          form
      );

      if(response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException('Failed to add Product feedback');
    }
  }

  Future<Map<String, dynamic>> updateProductFeedback({
    required int feedbackId,
    required String title,
    required String description,
    required int rating,
  }) async {
    try{
      final response = await AppConstant.apiBaseHelper.postAPICall(
          ApiRoutes.updateProductFeedbackApi + feedbackId.toString(),
        {
          'title': title,
          'comment': description,
          'rating': rating
        },
      );

      if(response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException('Failed to update Product feedback');
    }
  }

  Future<Map<String, dynamic>> deleteProductFeedback({
    required int feedbackId,
  }) async {
    try{
      final response = await AppConstant.apiBaseHelper.deleteAPICall(
        ApiRoutes.deleteProductFeedbackApi + feedbackId.toString(),
        {},
      );

      if(response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException('Failed to delete Product feedback');
    }
  }
}