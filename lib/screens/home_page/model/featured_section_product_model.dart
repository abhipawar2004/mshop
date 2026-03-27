import 'package:hyper_local/screens/home_page/model/banner_model.dart';
import 'package:hyper_local/screens/product_detail_page/model/product_detail_model.dart';

class FeaturedSectionProductModel {
  bool? success;
  String? message;
  FeatureSectionProductApiData? data;

  FeaturedSectionProductModel({this.success, this.message, this.data});

  FeaturedSectionProductModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? FeatureSectionProductApiData.fromJson(json['data']) : null;
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

class FeatureSectionProductApiData {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  List<FeatureSectionData>? data;

  FeatureSectionProductApiData({this.currentPage, this.lastPage, this.perPage, this.total, this.data});

  FeatureSectionProductApiData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['data'] != null) {
      data = <FeatureSectionData>[];
      json['data'].forEach((v) {
        data!.add(FeatureSectionData.fromJson(v));
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

class FeatureSectionData {
  int? id;
  String? title;
  String? slug;
  String? shortDescription;
  String? style;
  String? sectionType;
  int? sortOrder;
  String? status;
  String? scopeType;
  int? scopeId;
  String? scopeCategorySlug;
  String? scopeCategoryTitle;
  String? backgroundType;
  String? backgroundColor;
  String? desktop4kBackgroundImage;
  String? desktopFdhBackgroundImage;
  String? tabletBackgroundImage;
  String? mobileBackgroundImage;
  String? textColor;
  List<Categories>? categories;
  Categories? scopeCategory;
  List<ProductData>? products;
  int? productsCount;
  String? createdAt;
  String? updatedAt;

  FeatureSectionData(
      {this.id,
        this.title,
        this.slug,
        this.shortDescription,
        this.style,
        this.sectionType,
        this.sortOrder,
        this.status,
        this.scopeType,
        this.scopeId,
        this.scopeCategorySlug,
        this.scopeCategoryTitle,
        this.backgroundType,
        this.backgroundColor,
        this.desktop4kBackgroundImage,
        this.desktopFdhBackgroundImage,
        this.tabletBackgroundImage,
        this.mobileBackgroundImage,
        this.textColor,
        this.categories,
        this.scopeCategory,
        this.products,
        this.productsCount,
        this.createdAt,
        this.updatedAt});

  FeatureSectionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    shortDescription = json['short_description'];
    style = json['style'];
    sectionType = json['section_type'];
    sortOrder = json['sort_order'];
    status = json['status'];
    scopeType = json['scope_type'];
    scopeId = json['scope_id'];
    scopeCategorySlug = json['scope_category_slug'];
    scopeCategoryTitle = json['scope_category_title'];
    backgroundType = json['background_type'];
    backgroundColor = json['background_color'];
    desktop4kBackgroundImage = json['desktop_4k_background_image'];
    desktopFdhBackgroundImage = json['desktop_fdh_background_image'];
    tabletBackgroundImage = json['tablet_background_image'];
    mobileBackgroundImage = json['mobile_background_image'];
    textColor = json['text_color'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    scopeCategory = json['scope_category'] != null
        ? Categories.fromJson(json['scope_category'])
        : null;
    if (json['products'] != null) {
      products = <ProductData>[];
      json['products'].forEach((v) {
        products!.add(ProductData.fromJson(v));
      });
    }
    productsCount = json['products_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['short_description'] = shortDescription;
    data['style'] = style;
    data['section_type'] = sectionType;
    data['sort_order'] = sortOrder;
    data['status'] = status;
    data['scope_type'] = scopeType;
    data['scope_id'] = scopeId;
    data['scope_category_slug'] = scopeCategorySlug;
    data['scope_category_title'] = scopeCategoryTitle;
    data['background_type'] = backgroundType;
    data['background_color'] = backgroundColor;
    data['desktop_4k_background_image'] = desktop4kBackgroundImage;
    data['desktop_fdh_background_image'] = desktopFdhBackgroundImage;
    data['tablet_background_image'] = tabletBackgroundImage;
    data['mobile_background_image'] = mobileBackgroundImage;
    data['text_color'] = textColor;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (scopeCategory != null) {
      data['scope_category'] = scopeCategory!.toJson();
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['products_count'] = productsCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Categories {
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
  String? parentId;
  String? description;
  String? status;
  bool? requiresApproval;
  dynamic metadata;

  Categories(
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
        this.metadata});

  Categories.fromJson(Map<String, dynamic> json) {
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
    parentId = parseString(['parent_id']);
    description = json['description'];
    status = json['status'];
    requiresApproval = json['requires_approval'];
    metadata = json['metadata'];
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
    return data;
  }
}

class FavoriteItem {
  int? id;
  int? wishlistId;
  String? wishlistTitle;
  int? variantId;
  String? variantName;
  int? storeId;
  String? storeName;

  FavoriteItem({
    this.id,
    this.wishlistId,
    this.wishlistTitle,
    this.variantId,
    this.variantName,
    this.storeId,
    this.storeName,
  });

  FavoriteItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wishlistId = json['wishlist_id'];
    wishlistTitle = json['wishlist_title'];
    variantId = json['variant_id'];
    variantName = json['variant_name'];
    storeId = json['store_id'];
    storeName = json['store_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['wishlist_id'] = wishlistId;
    data['wishlist_title'] = wishlistTitle;
    data['variant_id'] = variantId;
    data['variant_name'] = variantName;
    data['store_id'] = storeId;
    data['store_name'] = storeName;
    return data;
  }
}

class StoreStatus {
  bool? isOpen;
  String? currentSlot;
  String? nextOpeningTime;

  StoreStatus({this.isOpen, this.currentSlot, this.nextOpeningTime});

  StoreStatus.fromJson(Map<String, dynamic> json) {
    isOpen = json['is_open'];
    currentSlot = parseString(['current_slot']);
    nextOpeningTime = json['next_opening_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_open'] = isOpen;
    data['current_slot'] = currentSlot;
    data['next_opening_time'] = nextOpeningTime;
    return data;
  }
}



class AttributesList {
  String? name;
  String? slug;
  String? swatcheType;
  List<String>? values;
  List<SwatchValues>? swatchValues;

  AttributesList(
      {this.name, this.slug, this.swatcheType, this.values, this.swatchValues});

  AttributesList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    swatcheType = json['swatche_type'];
    values = json['values'].cast<String>();
    if (json['swatch_values'] != null) {
      swatchValues = <SwatchValues>[];
      json['swatch_values'].forEach((v) {
        swatchValues!.add(SwatchValues.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['slug'] = slug;
    data['swatche_type'] = swatcheType;
    data['values'] = values;
    if (swatchValues != null) {
      data['swatch_values'] =
          swatchValues!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SwatchValues {
  String? value;
  String? swatch;

  SwatchValues({this.value, this.swatch});

  SwatchValues.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    swatch = json['swatch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['swatch'] = swatch;
    return data;
  }
}

