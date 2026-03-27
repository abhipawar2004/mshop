class SaveForLaterModel {
  bool? success;
  String? message;
  SaveForLaterData? data;

  SaveForLaterModel({this.success, this.message, this.data});

  SaveForLaterModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? SaveForLaterData.fromJson(json['data']) : null;
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

class SaveForLaterData {
  int? id;
  String? uuid;
  int? userId;
  int? itemsCount;
  int? totalQuantity;
  List<SavedItems>? items;
  String? createdAt;
  String? updatedAt;

  SaveForLaterData(
      {this.id,
        this.uuid,
        this.userId,
        this.itemsCount,
        this.totalQuantity,
        this.items,
        this.createdAt,
        this.updatedAt});

  SaveForLaterData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    userId = json['user_id'];
    itemsCount = json['items_count'];
    totalQuantity = json['total_quantity'];
    if (json['items'] != null) {
      items = <SavedItems>[];
      json['items'].forEach((v) {
        items!.add(SavedItems.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['user_id'] = userId;
    data['items_count'] = itemsCount;
    data['total_quantity'] = totalQuantity;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class SavedItems {
  int? id;
  int? cartId;
  int? productId;
  int? productVariantId;
  int? storeId;
  int? quantity;
  bool? saveForLater;
  SavedProduct? product;
  SavedProductVariant? variant;
  Store? store;
  String? createdAt;
  String? updatedAt;

  SavedItems(
      {this.id,
        this.cartId,
        this.productId,
        this.productVariantId,
        this.storeId,
        this.quantity,
        this.saveForLater,
        this.product,
        this.variant,
        this.store,
        this.createdAt,
        this.updatedAt});

  SavedItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartId = json['cart_id'];
    productId = json['product_id'];
    productVariantId = json['product_variant_id'];
    storeId = json['store_id'];
    quantity = json['quantity'];
    saveForLater = json['save_for_later'];
    product =
    json['product'] != null ? SavedProduct.fromJson(json['product']) : null;
    variant =
    json['variant'] != null ? SavedProductVariant.fromJson(json['variant']) : null;
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cart_id'] = cartId;
    data['product_id'] = productId;
    data['product_variant_id'] = productVariantId;
    data['store_id'] = storeId;
    data['quantity'] = quantity;
    data['save_for_later'] = saveForLater;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    if (variant != null) {
      data['variant'] = variant!.toJson();
    }
    if (store != null) {
      data['store'] = store!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class SavedProduct {
  int? id;
  String? name;
  String? slug;
  int? minimumOrderQuantity;
  int? quantityStepSize;
  int? totalAllowedQuantity;
  String? image;
  String? estimatedDeliveryTime;
  String? imageFit;
  StoreStatus? storeStatus;
  int? ratings;
  int? ratingCount;

  SavedProduct(
      {this.id,
        this.name,
        this.slug,
        this.minimumOrderQuantity,
        this.quantityStepSize,
        this.totalAllowedQuantity,
        this.image,
        this.estimatedDeliveryTime,
        this.imageFit,
        this.storeStatus,
        this.ratings,
        this.ratingCount});

  SavedProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    minimumOrderQuantity = json['minimum_order_quantity'];
    quantityStepSize = json['quantity_step_size'];
    totalAllowedQuantity = json['total_allowed_quantity'];
    image = json['image'];
    estimatedDeliveryTime = json['estimated_delivery_time'].toString();
    imageFit = json['image_fit'];
    storeStatus = json['store_status'] != null
        ? StoreStatus.fromJson(json['store_status'])
        : null;
    ratings = json['ratings'];
    ratingCount = json['rating_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['minimum_order_quantity'] = minimumOrderQuantity;
    data['quantity_step_size'] = quantityStepSize;
    data['total_allowed_quantity'] = totalAllowedQuantity;
    data['image'] = image;
    data['estimated_delivery_time'] = estimatedDeliveryTime;
    data['image_fit'] = imageFit;
    if (storeStatus != null) {
      data['store_status'] = storeStatus!.toJson();
    }
    data['ratings'] = ratings;
    data['rating_count'] = ratingCount;
    return data;
  }
}

class StoreStatus {
  bool? isOpen;
  String? status;

  StoreStatus({this.isOpen, this.status});

  StoreStatus.fromJson(Map<String, dynamic> json) {
    isOpen = json['is_open'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_open'] = isOpen;
    data['status'] = status;
    return data;
  }
}

class SavedProductVariant {
  int? id;
  String? title;
  String? slug;
  String? image;
  int? price;
  int? specialPrice;
  int? stock;
  String? sku;

  SavedProductVariant(
      {this.id,
        this.title,
        this.slug,
        this.image,
        this.price,
        this.specialPrice,
        this.stock,
        this.sku});

  SavedProductVariant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    image = json['image'];
    price = json['price'];
    specialPrice = json['special_price'];
    stock = json['stock'];
    sku = json['sku'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['image'] = image;
    data['price'] = price;
    data['special_price'] = specialPrice;
    data['stock'] = stock;
    data['sku'] = sku;
    return data;
  }
}

class Store {
  int? id;
  String? name;
  String? slug;
  int? totalProducts;
  StoreStatus? status;

  Store({this.id, this.name, this.slug, this.totalProducts, this.status});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    totalProducts = json['total_products'];
    status = json['status'] != null
        ? StoreStatus.fromJson(json['status'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['total_products'] = totalProducts;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}