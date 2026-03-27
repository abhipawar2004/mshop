import 'banner_model.dart';

class SubCategoryModel {
  bool? success;
  String? message;
  SubCategoryApiData? data;

  SubCategoryModel({this.success, this.message, this.data});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? SubCategoryApiData.fromJson(json['data']) : null;
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

class SubCategoryApiData {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  List<SubCategoryData>? data;

  SubCategoryApiData({this.currentPage, this.lastPage, this.perPage, this.total, this.data});

  SubCategoryApiData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['data'] != null) {
      data = <SubCategoryData>[];
      json['data'].forEach((v) {
        data!.add(SubCategoryData.fromJson(v));
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

class SubCategoryData {
  int? id;
  String? title;
  String? slug;
  String? image;
  String? banner;
  String? icon;
  String? activeIcon;
  String? backgroundType;
  String? backgroundColor;
  String? backgroundImage;
  int? parentId;
  String? description;
  String? status;
  bool? requiresApproval;
  dynamic metadata;
  int? subcategoryCount;
  int? productCount;

  SubCategoryData(
      {this.id,
        this.title,
        this.slug,
        this.image,
        this.banner,
        this.icon,
        this.activeIcon,
        this.backgroundType,
        this.backgroundColor,
        this.backgroundImage,
        this.parentId,
        this.description,
        this.status,
        this.requiresApproval,
        this.metadata,
        this.subcategoryCount,
        this.productCount
      });

  SubCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    image = json['image'];
    banner = json['banner'];
    icon = json['icon'];
    activeIcon = json['active_icon'];
    backgroundType = json['background_type'];
    backgroundColor = json['background_color'];
    backgroundImage = json['background_image'];
    parentId = parseInt(json['parent_id']);
    description = json['description'];
    status = json['status'];
    requiresApproval = json['requires_approval'];
    metadata = json['metadata'];
    subcategoryCount = json['subcategory_count'];
    productCount = json['product_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['image'] = image;
    data['banner'] = banner;
    data['icon'] = icon;
    data['active_icon'] = activeIcon;
    data['background_type'] = backgroundType;
    data['background_color'] = backgroundColor;
    data['background_image'] = backgroundImage;
    data['parent_id'] = parentId;
    data['description'] = description;
    data['status'] = status;
    data['requires_approval'] = requiresApproval;
    data['metadata'] = metadata;
    data['subcategory_count'] = subcategoryCount;
    data['product_count'] = productCount;
    return data;
  }
}
