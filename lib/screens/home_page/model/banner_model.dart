class BannersModel {
  bool? success;
  String? message;
  BannerApiData? data;

  BannersModel({this.success, this.message, this.data});

  BannersModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? BannerApiData.fromJson(json['data']) : null;
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

class BannerApiData {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  BannersData? data;

  BannerApiData({this.currentPage, this.lastPage, this.perPage, this.total, this.data});

  BannerApiData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    data = json['data'] != null ? BannersData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    data['per_page'] = perPage;
    data['total'] = total;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BannersData {
  List<Top>? top;
  List<Carousel>? carousel;
  List<Sidebar>? sidebar;

  BannersData({this.top, this.carousel, this.sidebar});

  BannersData.fromJson(Map<String, dynamic> json) {
    if (json['top'] != null) {
      top = <Top>[];
      json['top'].forEach((v) {
        top!.add(Top.fromJson(v));
      });
    }
    if (json['carousel'] != null) {
      carousel = <Carousel>[];
      json['carousel'].forEach((v) {
        carousel!.add(Carousel.fromJson(v));
      });
    }
    if (json['sidebar'] != null) {
      sidebar = <Sidebar>[];
      json['sidebar'].forEach((v) {
        sidebar!.add(Sidebar.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (top != null) {
      data['top'] = top!.map((v) => v.toJson()).toList();
    }
    if (carousel != null) {
      data['carousel'] = carousel!.map((v) => v.toJson()).toList();
    }
    if (sidebar != null) {
      data['sidebar'] = sidebar!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Top {
  int? id;
  String? type;
  String? title;
  String? scopeType;
  int? scopeId;
  String? scopeCategorySlug;
  String? slug;
  String? customUrl;
  int? productId;
  String? productSlug;
  int? categoryId;
  String? categorySlug;
  int? brandId;
  String? brandSlug;
  String? position;
  String? visibilityStatus;
  int? displayOrder;
  dynamic metadata;
  String? bannerImage;

  Top({
    this.id,
    this.type,
    this.title,
    this.scopeType,
    this.scopeId,
    this.scopeCategorySlug,
    this.slug,
    this.customUrl,
    this.productId,
    this.productSlug,
    this.categoryId,
    this.categorySlug,
    this.brandId,
    this.brandSlug,
    this.position,
    this.visibilityStatus,
    this.displayOrder,
    this.metadata,
    this.bannerImage,
  });

  Top.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    type = parseString(json['type']);
    title = parseString(json['title']);
    scopeType = parseString(json['scope_type']);
    scopeId = parseInt(json['scope_id']);
    scopeCategorySlug = parseString(json['scope_category_slug']);
    slug = parseString(json['slug']);
    customUrl = parseString(json['custom_url']);
    productId = parseInt(json['product_id']);
    productSlug = parseString(json['product_slug']);
    categoryId = parseInt(json['category_id']);
    categorySlug = parseString(json['category_slug']);
    brandId = parseInt(json['brand_id']);
    brandSlug = parseString(json['brand_slug'].toString());
    position = parseString(json['position']);
    visibilityStatus = parseString(json['visibility_status']);
    displayOrder = parseInt(json['display_order']);
    metadata = json['metadata'];
    bannerImage = parseString(json['banner_image']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['title'] = title;
    data['scope_type'] = scopeType;
    data['scope_id'] = scopeId;
    data['scope_category_slug'] = scopeCategorySlug;
    data['slug'] = slug;
    data['custom_url'] = customUrl;
    data['product_id'] = productId;
    data['product_slug'] = productSlug;
    data['category_id'] = categoryId;
    data['category_slug'] = categorySlug;
    data['brand_id'] = brandId;
    data['brand_slug'] = brandSlug;
    data['position'] = position;
    data['visibility_status'] = visibilityStatus;
    data['display_order'] = displayOrder;
    data['metadata'] = metadata;
    data['banner_image'] = bannerImage;
    return data;
  }
}

class Carousel {
  int? id;
  String? type;
  String? title;
  String? scopeType;
  int? scopeId;
  String? scopeCategorySlug;
  String? slug;
  String? customUrl;
  int? productId;
  String? productSlug;
  int? categoryId;
  String? categorySlug;
  int? brandId;
  String? brandSlug;
  String? position;
  String? visibilityStatus;
  int? displayOrder;
  dynamic metadata;
  String? bannerImage;

  Carousel(
      {this.id,
        this.type,
        this.title,
        this.scopeType,
        this.scopeId,
        this.scopeCategorySlug,
        this.slug,
        this.customUrl,
        this.productId,
        this.productSlug,
        this.categoryId,
        this.categorySlug,
        this.brandId,
        this.brandSlug,
        this.position,
        this.visibilityStatus,
        this.displayOrder,
        this.metadata,
        this.bannerImage});

  Carousel.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    type = parseString(json['type']);
    title = parseString(json['title']);
    scopeType = parseString(json['scope_type']);
    scopeId = parseInt(json['scope_id']);
    scopeCategorySlug = parseString(json['scope_category_slug']);
    slug = parseString(json['slug']);
    customUrl = parseString(json['custom_url']);
    productId = parseInt(json['product_id']);
    productSlug = parseString(json['product_slug']);
    categoryId = parseInt(json['category_id']);
    categorySlug = parseString(json['category_slug']);
    brandId = parseInt(json['brand_id']);
    brandSlug = parseString(json['brand_slug']);
    position = parseString(json['position']);
    visibilityStatus = parseString(json['visibility_status']);
    displayOrder = parseInt(json['display_order']);
    metadata = json['metadata'];
    bannerImage = parseString(json['banner_image']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['title'] = title;
    data['scope_type'] = scopeType;
    data['scope_id'] = scopeId;
    data['scope_category_slug'] = scopeCategorySlug;
    data['slug'] = slug;
    data['custom_url'] = customUrl;
    data['product_id'] = productId;
    data['product_slug'] = productSlug;
    data['category_id'] = categoryId;
    data['category_slug'] = categorySlug;
    data['brand_id'] = brandId;
    data['brand_slug'] = brandSlug;
    data['position'] = position;
    data['visibility_status'] = visibilityStatus;
    data['display_order'] = displayOrder;
    data['metadata'] = metadata;
    data['banner_image'] = bannerImage;
    return data;
  }
}

class Sidebar {
  int? id;
  String? type;
  String? title;
  String? scopeType;
  int? scopeId;
  String? scopeCategorySlug;
  String? slug;
  String? customUrl;
  int? productId;
  String? productSlug;
  int? categoryId;
  String? categorySlug;
  int? brandId;
  String? brandSlug;
  String? position;
  String? visibilityStatus;
  int? displayOrder;
  String? metadata;
  String? bannerImage;

  Sidebar(
      {this.id,
        this.type,
        this.title,
        this.scopeType,
        this.scopeId,
        this.scopeCategorySlug,
        this.slug,
        this.customUrl,
        this.productId,
        this.productSlug,
        this.categoryId,
        this.categorySlug,
        this.brandId,
        this.brandSlug,
        this.position,
        this.visibilityStatus,
        this.displayOrder,
        this.metadata,
        this.bannerImage});

  Sidebar.fromJson(Map<String, dynamic> json) {
    id = parseInt(json['id']);
    type = parseString(json['type']);
    title = parseString(json['title']);
    scopeType = parseString(json['scope_type']);
    scopeId = parseInt(json['scope_id']);
    scopeCategorySlug = parseString(json['scope_category_slug']);
    slug = parseString(json['slug']);
    customUrl = parseString(json['custom_url']);
    productId = parseInt(json['product_id']);
    productSlug = parseString(json['product_slug']);
    categoryId = parseInt(json['category_id']);
    categorySlug = parseString(json['category_slug']);
    brandId = parseInt(json['brand_id']);
    brandSlug = parseString(json['brand_slug']);
    position = parseString(json['position']);
    visibilityStatus = parseString(json['visibility_status']);
    displayOrder = parseInt(json['display_order']);
    metadata = json['metadata'];
    bannerImage = parseString(json['banner_image']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['title'] = title;
    data['scope_type'] = scopeType;
    data['scope_id'] = scopeId;
    data['scope_category_slug'] = scopeCategorySlug;
    data['slug'] = slug;
    data['custom_url'] = customUrl;
    data['product_id'] = productId;
    data['product_slug'] = productSlug;
    data['category_id'] = categoryId;
    data['category_slug'] = categorySlug;
    data['brand_id'] = brandId;
    data['brand_slug'] = brandSlug;
    data['position'] = position;
    data['visibility_status'] = visibilityStatus;
    data['display_order'] = displayOrder;
    data['metadata'] = metadata;
    data['banner_image'] = bannerImage;
    return data;
  }
}


int? parseInt(dynamic value) {
  if (value == null || value == "") return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

double? parseDouble(dynamic value) {
  if (value == null || value == "") return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

String? parseString(dynamic value) {
  if (value == null || value == "") return null;
  return value.toString();
}
