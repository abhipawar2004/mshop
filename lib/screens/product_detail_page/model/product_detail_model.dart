
import 'dart:developer' as developer;

import '../../home_page/model/featured_section_product_model.dart';

class ProductDetailModel {
  late bool success;
  late String message;
  ProductData? data;

  ProductDetailModel({
    bool? success,
    String? message,
    this.data,
  }) {
    this.success = success ?? false;
    this.message = message ?? '';
  }

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    try {
      success = json['success'] ?? false;
      message = json['message'] ?? '';
      data = json['data'] != null
          ? ProductData.fromJson(json['data'] as Map<String, dynamic>)
          : null;
    } catch (e, stackTrace) {
      developer.log('Error parsing ProductDetailModel: $e', stackTrace: stackTrace);
      success = false;
      message = 'Failed to parse product data';
      data = null;
    }
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

class ProductData {
  late int id;
  late int categoryId;
  late int brandId;
  late int sellerId;
  late String title;
  late String slug;
  late String type;
  late String shortDescription;
  late String description;
  late String category;
  late String brand;
  late String seller;
  late String indicator;
  List<FavoriteItem>? favorite;
  late String estimatedDeliveryTime;
  late dynamic ratings;
  late int ratingCount;
  late String mainImage;
  late String imageFit;
  late String itemTotalInCart;
  late List<String> additionalImages;
  late int minimumOrderQuantity;
  late int quantityStepSize;
  late int totalAllowedQuantity;
  late int isReturnable;
  late List<String> tags;
  late List<CustomField> customFields;
  late String warrantyPeriod;
  late String guaranteePeriod;
  late String madeIn;
  late String isInclusiveTax;
  late String videoType;
  late String videoLink;
  late String status;
  late String featured;
  late String metadata;
  late String createdAt;
  late String updatedAt;
  StoreStatus? storeStatus;
  late List<ProductVariants> variants;
  late List<ProductAttributes> attributes;

  ProductData({
    int? id,
    int? categoryId,
    int? brandId,
    int? sellerId,
    String? title,
    String? slug,
    String? type,
    String? shortDescription,
    String? description,
    String? category,
    String? brand,
    String? seller,
    String? indicator,
    List<FavoriteItem>? favorite,
    String? estimatedDeliveryTime,
    double? ratings,
    int? ratingCount,
    String? mainImage,
    String? imageFit,
    String? itemTotalInCart,
    List<String>? additionalImages,
    int? minimumOrderQuantity,
    int? quantityStepSize,
    int? totalAllowedQuantity,
    int? isReturnable,
    List<String>? tags,
    List<CustomField>? customFields,
    String? warrantyPeriod,
    String? guaranteePeriod,
    String? madeIn,
    String? isInclusiveTax,
    String? videoType,
    String? videoLink,
    String? status,
    String? featured,
    String? metadata,
    String? createdAt,
    String? updatedAt,
    this.storeStatus,
    List<ProductVariants>? variants,
    List<ProductAttributes>? attributes,
  })
  {
    // Initialize all late fields in constructor body
    this.id = id ?? 0;
    this.categoryId = categoryId ?? 0;
    this.brandId = brandId ?? 0;
    this.sellerId = sellerId ?? 0;
    this.title = title ?? '';
    this.slug = slug ?? '';
    this.type = type ?? '';
    this.shortDescription = shortDescription ?? '';
    this.description = description ?? '';
    this.category = category ?? '';
    this.brand = brand ?? '';
    this.seller = seller ?? '';
    this.indicator = indicator ?? '';
    this.favorite;
    this.estimatedDeliveryTime = estimatedDeliveryTime ?? '';
    this.ratings = ratings ?? 0.0;
    this.ratingCount = ratingCount ?? 0;
    this.mainImage = mainImage ?? '';
    this.imageFit = imageFit ?? '';
    this.itemTotalInCart = itemTotalInCart ?? '';
    this.additionalImages = additionalImages ?? [];
    this.minimumOrderQuantity = minimumOrderQuantity ?? 0;
    this.quantityStepSize = quantityStepSize ?? 1;
    this.totalAllowedQuantity = totalAllowedQuantity ?? 0;
    this.isReturnable = isReturnable ?? 0;
    this.tags = tags ?? [];
    this.customFields = customFields ?? [];
    this.warrantyPeriod = warrantyPeriod ?? '';
    this.guaranteePeriod = guaranteePeriod ?? '';
    this.madeIn = madeIn ?? '';
    this.isInclusiveTax = isInclusiveTax ?? '';
    this.videoType = videoType ?? '';
    this.videoLink = videoLink ?? '';
    this.status = status ?? '';
    this.featured = featured ?? '';
    this.metadata = metadata ?? '';
    this.createdAt = createdAt ?? '';
    this.updatedAt = updatedAt ?? '';
    this.variants = variants ?? [];
    this.attributes = attributes ?? [];
  }

  ProductData.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] ?? 0;
      categoryId = json['category_id'] ?? 0;
      brandId = json['brand_id'] ?? 0;
      sellerId = json['seller_id'] ?? 0;
      title = json['title'] ?? '';
      slug = json['slug'] ?? '';
      type = json['type'] ?? '';
      shortDescription = json['short_description'] ?? '';
      description = json['description'] ?? '';
      category = json['category'] ?? '';
      brand = json['brand'] ?? '';
      seller = json['seller'] ?? '';
      indicator = json['indicator'] ?? '';
      if (json['favorite'] != null) {
        favorite = <FavoriteItem>[];
        json['favorite'].forEach((v) {
          favorite!.add(FavoriteItem.fromJson(v));
        });
      } else {
        favorite = null;
      }
      estimatedDeliveryTime = json['estimated_delivery_time'].toString();
      ratings = double.parse(json['ratings'].toString());
      ratingCount = json['rating_count'] ?? 0;
      mainImage = json['main_image'] ?? '';
      imageFit = json['image_fit'] ?? '';
      itemTotalInCart = json['item_count_in_cart'].toString();

      // Handle potentially null lists with safe defaults
      additionalImages = json['additional_images'] != null
          ? List<String>.from(json['additional_images'])
          : [];

      minimumOrderQuantity = json['minimum_order_quantity'] ?? 0;
      quantityStepSize = json['quantity_step_size'] ?? 1;
      totalAllowedQuantity = json['total_allowed_quantity'] ?? 0;
      isReturnable = json['is_returnable'] ?? 0;

      // Handle tags - can be String or List
      if (json['tags'] != null) {
        if (json['tags'] is String) {
          tags = json['tags'].toString().split(',').map((e) => e.trim()).toList();
        } else if (json['tags'] is List) {
          tags = List<String>.from(json['tags']);
        } else {
          tags = [];
        }
      } else {
        tags = [];
      }

      customFields = switch (json['custom_fields']) {
        Map<String, dynamic> map => map.entries
            .map((e) => CustomField(key: e.key, value: e.value))
            .toList(),
        _ => <CustomField>[],
      };

      warrantyPeriod = json['warranty_period'] ?? '';
      guaranteePeriod = json['guarantee_period'] ?? '';
      madeIn = json['made_in'] ?? '';
      isInclusiveTax = json['is_inclusive_tax'] ?? '';
      videoType = json['video_type'] ?? '';
      videoLink = json['video_link'] ?? '';
      status = json['status'] ?? '';
      featured = json['featured'] ?? '';
      metadata = json['metadata'] ?? '';
      createdAt = json['created_at'] ?? '';
      updatedAt = json['updated_at'] ?? '';

      storeStatus = json['store_status'] != null
          ? StoreStatus.fromJson(json['store_status'] as Map<String, dynamic>)
          : null;

      variants = json['variants'] != null
          ? (json['variants'] as List)
          .map((v) => ProductVariants.fromJson(v as Map<String, dynamic>))
          .toList()
          : [];

      attributes = json['attributes'] != null
          ? (json['attributes'] as List)
          .map((v) => ProductAttributes.fromJson(v as Map<String, dynamic>))
          .toList()
          : [];
    } catch (e, stackTrace) {
      developer.log('Error parsing ProductData: $e', stackTrace: stackTrace);
      // Set all properties to safe defaults in case of error
      _initializeDefaults();
    }
  }

  void _initializeDefaults() {
    id = 0;
    categoryId = 0;
    brandId = 0;
    sellerId = 0;
    title = '';
    slug = '';
    type = '';
    shortDescription = '';
    description = '';
    category = '';
    brand = '';
    seller = '';
    indicator = '';
    favorite = [];
    estimatedDeliveryTime = '';
    ratings = 0;
    ratingCount = 0;
    mainImage = '';
    imageFit = '';
    additionalImages = [];
    minimumOrderQuantity = 0;
    quantityStepSize = 1;
    totalAllowedQuantity = 0;
    isReturnable = 0;
    tags = [];
    customFields = [];
    warrantyPeriod = '';
    guaranteePeriod = '';
    madeIn = '';
    isInclusiveTax = '';
    videoType = '';
    videoLink = '';
    status = '';
    featured = '';
    metadata = '';
    createdAt = '';
    updatedAt = '';
    storeStatus = null;
    variants = [];
    attributes = [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['brand_id'] = brandId;
    data['seller_id'] = sellerId;
    data['title'] = title;
    data['slug'] = slug;
    data['type'] = type;
    data['short_description'] = shortDescription;
    data['description'] = description;
    data['category'] = category;
    data['brand'] = brand;
    data['seller'] = seller;
    data['indicator'] = indicator;
    if (favorite != null) {
      data['favorite'] = favorite!.map((v) => v.toJson()).toList();
    }
    data['estimated_delivery_time'] = estimatedDeliveryTime.toString();
    data['ratings'] = ratings;
    data['rating_count'] = ratingCount;
    data['main_image'] = mainImage;
    data['image_fit'] = imageFit;
    data['additional_images'] = additionalImages;
    data['minimum_order_quantity'] = minimumOrderQuantity;
    data['quantity_step_size'] = quantityStepSize;
    data['total_allowed_quantity'] = totalAllowedQuantity;
    data['is_returnable'] = isReturnable;
    data['tags'] = tags;
    data['warranty_period'] = warrantyPeriod;
    data['guarantee_period'] = guaranteePeriod;
    data['made_in'] = madeIn;
    data['is_inclusive_tax'] = isInclusiveTax;
    data['video_type'] = videoType;
    data['video_link'] = videoLink;
    data['status'] = status;
    data['featured'] = featured;
    data['metadata'] = metadata;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (storeStatus != null) {
      data['store_status'] = storeStatus!.toJson();
    }
    data['variants'] = variants.map((v) => v.toJson()).toList();
    data['attributes'] = attributes.map((v) => v.toJson()).toList();
    return data;
  }
}

class StoreStatus {
  late bool isOpen;
  CurrentSlot? currentSlot;
  late String nextOpeningTime;

  StoreStatus({
    bool? isOpen,
    this.currentSlot,
    String? nextOpeningTime,
  }) {
    this.isOpen = isOpen ?? false;
    this.nextOpeningTime = nextOpeningTime ?? '';
  }

  StoreStatus.fromJson(Map<String, dynamic> json) {
    try {
      isOpen = json['is_open'] ?? false;
      currentSlot = json['current_slot'] != null
          ? CurrentSlot.fromJson(json['current_slot'] as Map<String, dynamic>)
          : null;
      nextOpeningTime = json['next_opening_time'] ?? '';
    } catch (e, stackTrace) {
      developer.log('Error parsing StoreStatus: $e', stackTrace: stackTrace);
      isOpen = false;
      currentSlot = null;
      nextOpeningTime = '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_open'] = isOpen;
    if (currentSlot != null) {
      data['current_slot'] = currentSlot!.toJson();
    }
    data['next_opening_time'] = nextOpeningTime;
    return data;
  }
}

class CustomField {
  final String key;
  final dynamic value;

  CustomField({
    required this.key,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
    'key': key,
    'value': value,
  };
}

class CurrentSlot {
  late String from;
  late String to;

  CurrentSlot({
    String? from,
    String? to,
  }) {
    this.from = from ?? '';
    this.to = to ?? '';
  }

  CurrentSlot.fromJson(Map<String, dynamic> json) {
    try {
      from = json['from'] ?? '';
      to = json['to'] ?? '';
    } catch (e, stackTrace) {
      developer.log('Error parsing CurrentSlot: $e', stackTrace: stackTrace);
      from = '';
      to = '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}

class ProductVariants {
  late int id;
  late String title;
  late String slug;
  late String image;
  late int weight;
  late int height;
  late int breadth;
  late int length;
  late bool availability;
  late String barcode;
  late bool isDefault;
  late int price;
  late int specialPrice;
  late int storeId;
  late String storeSlug;
  late String storeName;
  late int stock;
  late String sku;
  late Map<String, dynamic> attributes;

  ProductVariants({
    int? id,
    String? title,
    String? slug,
    String? image,
    int? weight,
    int? height,
    int? breadth,
    int? length,
    bool? availability,
    String? barcode,
    bool? isDefault,
    int? price,
    int? specialPrice,
    int? storeId,
    String? storeSlug,
    String? storeName,
    int? stock,
    String? sku,
    Map<String, dynamic>? attributes,
  }) {
    this.id = id ?? 0;
    this.title = title ?? '';
    this.slug = slug ?? '';
    this.image = image ?? '';
    this.weight = weight ?? 0;
    this.height = height ?? 0;
    this.breadth = breadth ?? 0;
    this.length = length ?? 0;
    this.availability = availability ?? false;
    this.barcode = barcode ?? '';
    this.isDefault = isDefault ?? false;
    this.price = price ?? 0;
    this.specialPrice = specialPrice ?? 0;
    this.storeId = storeId ?? 0;
    this.storeSlug = storeSlug ?? '';
    this.storeName = storeName ?? '';
    this.stock = stock ?? 0;
    this.sku = sku ?? '';
    this.attributes = attributes ?? {};
  }

  ProductVariants.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    title = json['title'] ?? '';
    slug = json['slug'] ?? '';
    image = json['image'] ?? '';
    weight = json['weight'] ?? 0;
    height = json['height'] ?? 0;
    breadth = json['breadth'] ?? 0;
    length = json['length'] ?? 0;
    availability = json['availability'] ?? false;
    barcode = json['barcode'] ?? '';
    isDefault = json['is_default'] ?? false;
    price = json['price'] ?? 0;
    specialPrice = json['special_price'] ?? 0;
    storeId = json['store_id'] ?? 0;
    storeSlug = json['store_slug'] ?? '';
    storeName = json['store_name'] ?? '';
    stock = json['stock'] ?? 0;
    sku = json['sku'] ?? '';

    // Dynamic attributes
    if (json['attributes'] is Map) {
      attributes = Map<String, dynamic>.from(json['attributes']);
    } else if (json['attributes'] is List) {
      // Convert list → map or keep empty
      attributes = {};
    } else {
      attributes = {};
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['image'] = image;
    data['weight'] = weight;
    data['height'] = height;
    data['breadth'] = breadth;
    data['length'] = length;
    data['availability'] = availability;
    data['barcode'] = barcode;
    data['is_default'] = isDefault;
    data['price'] = price;
    data['special_price'] = specialPrice;
    data['store_id'] = storeId;
    data['store_slug'] = storeSlug;
    data['store_name'] = storeName;
    data['stock'] = stock;
    data['sku'] = sku;
    data['attributes'] = attributes;
    return data;
  }
}

class ProductAttributes {
  late String name;
  late String slug;
  late String swatcheType;
  late List<String> values;
  late List<SwatchValues> swatchValues;

  ProductAttributes({
    String? name,
    String? slug,
    String? swatcheType,
    List<String>? values,
    List<SwatchValues>? swatchValues,
  }) {
    this.name = name ?? '';
    this.slug = slug ?? '';
    this.swatcheType = swatcheType ?? '';
    this.values = values ?? [];
    this.swatchValues = swatchValues ?? [];
  }

  ProductAttributes.fromJson(Map<String, dynamic> json) {
    try {
      name = json['name'] ?? '';
      slug = json['slug'] ?? '';
      swatcheType = json['swatche_type'] ?? '';
      values = json['values'] != null
          ? List<String>.from(json['values'])
          : [];
      swatchValues = json['swatch_values'] != null
          ? (json['swatch_values'] as List)
          .map((v) => SwatchValues.fromJson(v as Map<String, dynamic>))
          .toList()
          : [];
    } catch (e, stackTrace) {
      developer.log('Error parsing ProductAttributes: $e', stackTrace: stackTrace);
      name = '';
      slug = '';
      swatcheType = '';
      values = [];
      swatchValues = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['slug'] = slug;
    data['swatche_type'] = swatcheType;
    data['values'] = values;
    data['swatch_values'] = swatchValues.map((v) => v.toJson()).toList();
    return data;
  }
}

class SwatchValues {
  late String value;
  late String swatch;

  SwatchValues({
    String? value,
    String? swatch,
  }) {
    this.value = value ?? '';
    this.swatch = swatch ?? '';
  }

  SwatchValues.fromJson(Map<String, dynamic> json) {
    try {
      value = json['value'] ?? '';
      swatch = json['swatch'] ?? '';
    } catch (e, stackTrace) {
      developer.log('Error parsing SwatchValues: $e', stackTrace: stackTrace);
      value = '';
      swatch = '';
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['swatch'] = swatch;
    return data;
  }
}