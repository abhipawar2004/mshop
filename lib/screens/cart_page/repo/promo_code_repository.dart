import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/constant.dart';

import '../../../config/api_routes.dart';

class PromoCodeRepository {
  Future<Map<String, dynamic>> fetchPromoCode() async {
    try{
      final response = await AppConstant.apiBaseHelper.getAPICall(
          ApiRoutes.getPromoCodeApi,
          {}
      );
      return response.data;
    } catch(e) {
      throw ApiException('Failed to get promo code');
    }
  }

  Future<Map<String, dynamic>> validatePromoCode({
    required int cartAmount, required int deliveryCharges, required String promoCode
  }) async {
    try{
      final response = await AppConstant.apiBaseHelper.getAPICall(
        '${ApiRoutes.validatePromoCodeApi}?promo_code=$promoCode&cart_amount=$cartAmount&delivery_charge=$deliveryCharges',
        {}
      );
      return response.data;
    } catch(e) {
      throw ApiException('Failed to get promo code');
    }
  }
}