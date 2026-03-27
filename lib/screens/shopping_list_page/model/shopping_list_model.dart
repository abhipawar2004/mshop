import '../../product_detail_page/model/product_detail_model.dart';

class ShoppingListModel {
  bool? success;
  String? message;
  List<ShoppingListData>? data;

  ShoppingListModel({this.success, this.message, this.data});

  ShoppingListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ShoppingListData>[];
      json['data'].forEach((v) {
        data!.add(ShoppingListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShoppingListData {
  String? keyword;
  int? totalProducts;
  int? currentPage;
  int? lastPage;
  int? perPage;
  List<ProductData>? products;

  ShoppingListData(
      {this.keyword,
        this.totalProducts,
        this.currentPage,
        this.lastPage,
        this.perPage,
        this.products});

  ShoppingListData.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'];
    totalProducts = json['total_products'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    if (json['products'] != null) {
      products = <ProductData>[];
      json['products'].forEach((v) {
        products!.add(ProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['keyword'] = keyword;
    data['total_products'] = totalProducts;
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['per_page'] = perPage;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}