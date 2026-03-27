import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/api_routes.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/screens/wallet_page/model/prepare_wallet_recharge_model.dart';

class WalletRepository {
  Future<List<PrepareWalletRechargeModel>> prepareRecharge({required String amount, required String paymentMethod, required String description}) async {
    try{
      final response = await AppConstant.apiBaseHelper.postAPICall(
        ApiRoutes.prepareWalletRechargeApi,
        {
          "amount": int.parse(amount),
          "payment_method": '${paymentMethod}Payment',
          "description": description
        }
      );
      if(response.status == 200){
        List<PrepareWalletRechargeModel> prepareWalletModel = [];
        prepareWalletModel.add(PrepareWalletRechargeModel.fromJson(response.data));
        return prepareWalletModel;
      } else {
        return [];
      }
    }catch(e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<Wallet>> fetchUserWallet() async {
    try{
      final response = await AppConstant.apiBaseHelper.getAPICall(
          ApiRoutes.userWalletApi,
          {}
      );
      if(response.statusCode == 200 && response.data['success'] == true){
        List<Wallet> walletData = [];
        walletData.add(Wallet.fromJson(response.data['data']));
        return walletData;
      } else {
        return [];
      }
    }catch(e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchWalletTransactions({required int perPage, required int page}) async {
    try{
      final response = await AppConstant.apiBaseHelper.getAPICall(
          '${ApiRoutes.walletTransactionsApi}?page=$page&per_page=$perPage',
          {}
      );
      if(response.statusCode == 200 && response.data['success'] == true){
        return response.data;
      } else {
        return {};
      }
    }catch(e) {
      throw ApiException(e.toString());
    }
  }
}