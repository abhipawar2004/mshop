import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hyper_local/config/api_base_helper.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/security.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart' as dio;
import '../../../config/api_routes.dart';
import '../../cart_page/widgets/cart_product_item.dart';
import '../model/order_detail_model.dart';
import '../model/delivery_tracking_model.dart';

class OrderRepository {
  Future<Map<String, dynamic>> createOrder({
    required String paymentType,
    required String promoCode,
    required String giftCard,
    required int addressId,
    required bool rushDelivery,
    required bool useWallet,
    required String orderNote,
    Map<String, dynamic>? paymentDetails,
    required Map<int, CartItemAttachment?> attachments,
  }) async {
    try {
      final formData = dio.FormData();

      String? paymenttype;
      if(paymentType.isNotEmpty && paymentType != 'wallet'){
        paymenttype = paymentType == 'cod' ? paymentType : '${paymentType}Payment';
      } else if(paymentType == 'wallet') {
        paymenttype = paymentType;
      } else {
        paymenttype = '';
      }

      formData.fields.addAll([
        MapEntry('payment_type', paymenttype),
        MapEntry('promo_code', promoCode),
        MapEntry('gift_card', giftCard),
        MapEntry('address_id', addressId.toString()),
        MapEntry('rush_delivery', rushDelivery ? '1' : '0'),
        MapEntry('use_wallet', useWallet ? '1' : '0'),
        MapEntry('order_note', orderNote),
        if (paymentType != 'flutterwave') MapEntry('redirect_url', AppConstant.baseUrl),
        // Add paymentDetails if needed (flatten them)
        ...?paymentDetails?.entries.map((e) => MapEntry(e.key, e.value.toString())),

      ]);



      for (final entry in attachments.entries) {
        final productId = entry.key;
        final att = entry.value;

        if (att != null && att.filePath.isNotEmpty) {
          await File(att.filePath).readAsBytes();

          formData.files.add(
            MapEntry(
              'attachments[$productId][]',
              await MultipartFile.fromFile(
                att.filePath,
                filename: att.fileName,
                // Optional but recommended:
                // contentType: dio.MediaType.parse(lookupMimeType(att.fileName) ?? 'application/octet-stream'),
              ),
            ),
          );
        }
      }

      final dioClient = dio.Dio(
        dio.BaseOptions(
          baseUrl: AppConstant.baseUrl, // adjust to your base
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          headers: headers,
        ),
      );

      final response = await dioClient.post(
        ApiRoutes.createOrderApi,
        data: formData,
      );

        if (response.statusCode == 200) {
          return response.data;
        } else {
          return {};
        }
      // return {};
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchMyOrderList({required int perPage, required int page}) async {
    try{
      final response = await AppConstant.apiBaseHelper.getAPICall(
        '${ApiRoutes.getMyOrderApi}?page=$page&per_page=$perPage',
        {}
      );
      if(response.statusCode == 200 ){
        return response.data;
      }
      return {};
    }catch(e) {
      throw ApiException('Failed to get my orders list');
    }
  }

  Future<List<OrderDetailModel>> getOrderDetail({required String orderSlug,}) async {
    try{
      final response = await AppConstant.apiBaseHelper.getAPICall(
        ApiRoutes.orderDetailApi+orderSlug,
        {},
      );

      if(response.statusCode == 200) {
        final List<OrderDetailModel> orderData = [];
        orderData.add(OrderDetailModel.fromJson(response.data));
        return orderData;
      } else {
        return [];
      }

    }catch(e){
      throw ApiException(e.toString());
    }
  }

  Future<DeliveryBoyTrackingModel?> getDeliveryTracking({required String orderSlug,}) async {
    try{
      final response = await AppConstant.apiBaseHelper.getAPICall(
        '${ApiRoutes.orderDetailApi}$orderSlug/delivery-boy-location',
        {},
      );

      if(response.statusCode == 200) {
        return DeliveryBoyTrackingModel.fromJson(response.data);
      } else {
        return null;
      }
    }catch(e){
      throw ApiException(e.toString());
    }
  }

  Future<String> downloadInvoicePdf(String invoiceUrl) async {
    try {
      final response = await AppConstant.apiBaseHelper.getAPICall(
        invoiceUrl,
        {}
      );
      if(response.data != null) {
        if (Platform.isAndroid) {
          await Permission.storage.request();
        }
        // Get the appropriate directory
        Directory? directory;
        if (Platform.isAndroid) {
          // For Android - use Downloads directory
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            directory = await getExternalStorageDirectory();
          }
        } else if (Platform.isIOS) {
          // For iOS - use Documents directory (accessible in Files app)
          directory = await getApplicationDocumentsDirectory();
        }
        final fileName = 'invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final filePath = '${directory!.path}/$fileName';
        await AppConstant.apiBaseHelper.downloadFile(
          url: invoiceUrl,
          cancelToken: CancelToken(),
          savePath: filePath,
          updateDownloadedPercentage: (received, total) { // Two parameters
            if (total != -1) {
              final percentage = (received / total * 100);
              log('Download: ${percentage.toStringAsFixed(0)}%');
            }
          },
        );
        return filePath;
      } else {
        return '';
      }
    } catch (e) {
      throw ApiException('Failed to download invoice: $e');
    }
  }

  Future<Map<String, dynamic>> returnOrderItemRequest({
    required int orderItemId,
    required String reason,
    List<XFile> images = const [],
  }) async {
    try{

      final form = await formDataWithImages(
        fields: {
          'reason': reason,
        },
        images: images,
        imageFieldLabel: 'images'
      );

      log('Return Order Item Request ${form.files}');

      final response = await AppConstant.apiBaseHelper.postAPICall(
        '${ApiRoutes.returnOrderItemApi}$orderItemId/return',
        form
      );
      if(response.statusCode == 200) {
        return response.data;
      }
      return {};
    }catch(e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> cancelReturnRequest({
    required int orderItemId,
  }) async {
    try{
      final response = await AppConstant.apiBaseHelper.postAPICall(
          '${ApiRoutes.cancelReturnRequestApi}$orderItemId/return-cancel',
          {}
      );

      if(response.statusCode == 200) {
        return response.data;
      }
      return {};
    }catch(e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> cancelOrderItem({
    required int orderItemId,
  }) async {
    try{
      final response = await AppConstant.apiBaseHelper.postAPICall(
          '${ApiRoutes.cancelOrderItemApi}$orderItemId/cancel',
          {}
      );

      if(response.statusCode == 200) {
        return response.data;
      }
      return {};
    }catch(e) {
      throw ApiException(e.toString());
    }
  }
}