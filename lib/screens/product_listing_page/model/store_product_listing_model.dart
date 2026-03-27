import 'package:hyper_local/screens/product_detail_page/model/product_detail_model.dart';

class StoreProductListingModel {
  bool? success;
  String? message;
  StoreProductListingData? data;

  StoreProductListingModel({this.success, this.message, this.data});

  StoreProductListingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? StoreProductListingData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class StoreProductListingData {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  List<ProductData>? data;

  StoreProductListingData({this.currentPage, this.lastPage, this.perPage, this.total, this.data});

  StoreProductListingData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(ProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['per_page'] = perPage;
    data['total'] = total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
