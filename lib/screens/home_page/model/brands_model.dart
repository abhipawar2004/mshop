import 'package:hyper_local/screens/home_page/model/banner_model.dart';

class BrandsModel {
  bool? success;
  String? message;
  BrandsApiData? data;

  BrandsModel({this.success, this.message, this.data});

  BrandsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? BrandsApiData.fromJson(json['data']) : null;
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

class BrandsApiData {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  List<BrandsData>? data;

  BrandsApiData({this.currentPage, this.lastPage, this.perPage, this.total, this.data});

  BrandsApiData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['data'] != null) {
      data = <BrandsData>[];
      json['data'].forEach((v) {
        data!.add(BrandsData.fromJson(v));
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

class BrandsData {
  int? id;
  String? title;
  String? slug;
  String? logo;
  String? status;
  String? scopeType;
  String? scopeId;
  String? scopeCategorySlug;
  String? scopeCategoryTitle;
  String? description;
  dynamic metadata;

  BrandsData(
      {this.id,
        this.title,
        this.slug,
        this.logo,
        this.status,
        this.scopeType,
        this.scopeId,
        this.scopeCategorySlug,
        this.scopeCategoryTitle,
        this.description,
        this.metadata});

  BrandsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    logo = json['logo'];
    status = json['status'];
    scopeType = json['scope_type'];
    scopeId = parseString(['scope_id']);
    scopeCategorySlug = json['scope_category_slug'];
    scopeCategoryTitle = json['scope_category_title'];
    description = json['description'];
    metadata = json['metadata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['logo'] = logo;
    data['status'] = status;
    data['scope_type'] = scopeType;
    data['scope_id'] = scopeId;
    data['scope_category_slug'] = scopeCategorySlug;
    data['scope_category_title'] = scopeCategoryTitle;
    data['description'] = description;
    data['metadata'] = metadata;
    return data;
  }
}
