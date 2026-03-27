import 'package:hyper_local/screens/cart_page/model/promo_code_model.dart';

class GetCartModel {
  bool? success;
  String? message;
  CartData? data;

  GetCartModel({this.success, this.message, this.data});

  GetCartModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null && json['data'].isNotEmpty
        ? CartData.fromJson(json['data'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (data.isNotEmpty) {
      data['data'] = this.data?.toJson();
    } else {
      data['data'] = null;
    }
    return data;
  }
}

class CartData {
  int? id;
  String? uuid;
  int? userId;
  int? itemsCount;
  int? totalQuantity;
  List<CartItems>? items;
  PaymentSummary? paymentSummary;
  List<RemovedItems>? removedItems;
  int? removedCount;
  DeliveryZone? deliveryZone;
  String? createdAt;
  String? updatedAt;

  CartData(
      {this.id,
        this.uuid,
        this.userId,
        this.itemsCount,
        this.totalQuantity,
        this.items,
        this.paymentSummary,
        this.createdAt,
        this.updatedAt});

  CartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    userId = json['user_id'];
    itemsCount = json['items_count'];
    totalQuantity = json['total_quantity'];
    if (json['items'] != null) {
      items = <CartItems>[];
      json['items'].forEach((v) {
        items!.add(CartItems.fromJson(v));
      });
    }
    paymentSummary = json['payment_summary'] != null && json['payment_summary'] is Map
        ? PaymentSummary.fromJson(json['payment_summary'])
        : null;
    if (json['removed_items'] != null) {
      removedItems = <RemovedItems>[];
      json['removed_items'].forEach((v) {
        removedItems!.add(RemovedItems.fromJson(v));
      });
    }
    removedCount = json['removed_count'];
    deliveryZone = json['delivery_zone'] != null
        ? DeliveryZone.fromJson(json['delivery_zone'])
        : null;
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
    if (paymentSummary != null) {
      data['payment_summary'] = paymentSummary!.toJson();
    }
    if (removedItems != null) {
      data['removed_items'] =
          removedItems!.map((v) => v.toJson()).toList();
    }
    data['removed_count'] = removedCount;
    if (deliveryZone != null) {
      data['delivery_zone'] = deliveryZone!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class CartItems {
  int? id;
  int? cartId;
  int? productId;
  int? productVariantId;
  int? storeId;
  int? quantity;
  bool? saveForLater;
  Product? product;
  Variant? variant;
  Store? store;
  String? createdAt;
  String? updatedAt;

  CartItems(
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

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartId = json['cart_id'];
    productId = json['product_id'];
    productVariantId = json['product_variant_id'];
    storeId = json['store_id'];
    quantity = json['quantity'];
    saveForLater = json['save_for_later'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
    variant =
    json['variant'] != null ? Variant.fromJson(json['variant']) : null;
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

class Product {
  int? id;
  String? name;
  String? slug;
  int? minimumOrderQuantity;
  int? quantityStepSize;
  int? totalAllowedQuantity;
  bool? isAttachmentRequired;
  String? image;
  int? estimatedDeliveryTime;
  String? imageFit;
  StoreStatus? storeStatus;
  int? ratings;
  int? ratingCount;

  Product(
      {this.id,
        this.name,
        this.slug,
        this.minimumOrderQuantity,
        this.quantityStepSize,
        this.totalAllowedQuantity,
        this.isAttachmentRequired,
        this.image,
        this.estimatedDeliveryTime,
        this.imageFit,
        this.storeStatus,
        this.ratings,
        this.ratingCount});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    minimumOrderQuantity = json['minimum_order_quantity'];
    quantityStepSize = json['quantity_step_size'];
    totalAllowedQuantity = json['total_allowed_quantity'];
    isAttachmentRequired = json['is_attachment_required'];
    image = json['image'];
    estimatedDeliveryTime = json['estimated_delivery_time'];
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
    data['is_attachment_required'] = isAttachmentRequired;
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

class Variant {
  int? id;
  String? title;
  String? slug;
  String? image;
  num? price;
  num? specialPrice;
  int? stock;
  String? sku;

  Variant({
    this.id,
    this.title,
    this.slug,
    this.image,
    this.price,
    this.specialPrice,
    this.stock,
    this.sku
  });

  Variant.fromJson(Map<String, dynamic> json) {
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

class Store {
  int? id;
  String? name;
  String? slug;
  int? totalProducts;
  Status? status;

  Store({
    this.id,
    this.name,
    this.slug,
    this.totalProducts,
    this.status
  });

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    totalProducts = json['total_products'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
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

class Status {
  bool? isOpen;
  String? status;

  Status({this.isOpen, this.status});

  Status.fromJson(Map<String, dynamic> json) {
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

class PaymentSummary {
  int? itemsTotal;
  int? perStoreDropOffFee;
  bool? isRushDelivery;
  bool? isRushDeliveryAvailable;
  int? deliveryCharges;
  int? handlingCharges;
  dynamic deliveryDistanceCharges;
  dynamic deliveryDistanceKm;
  int? totalStores;
  dynamic totalDeliveryCharges;
  int? estimatedDeliveryTime;
  bool? useWallet;
  String? promoCode;
  String? promoDiscount;
  PromoCodeData? promoApplied;
  String? promoError;
  dynamic walletBalance;
  double? walletAmountUsed;
  dynamic payableAmount;

  PaymentSummary(
      {this.itemsTotal,
        this.perStoreDropOffFee,
        this.isRushDelivery,
        this.isRushDeliveryAvailable,
        this.deliveryCharges,
        this.handlingCharges,
        this.deliveryDistanceCharges,
        this.deliveryDistanceKm,
        this.totalStores,
        this.totalDeliveryCharges,
        this.estimatedDeliveryTime,
        this.useWallet,
        this.promoCode,
        this.promoDiscount,
        this.promoApplied,
        this.promoError,
        this.walletBalance,
        this.walletAmountUsed,
        this.payableAmount});

  PaymentSummary.fromJson(Map<String, dynamic> json) {
    itemsTotal = json['items_total'];
    perStoreDropOffFee = json['per_store_drop_off_fee'];
    isRushDelivery = json['is_rush_delivery'];
    isRushDeliveryAvailable = json['is_rush_delivery_available'];
    deliveryCharges = json['delivery_charges'];
    handlingCharges = json['handling_charges'];
    deliveryDistanceCharges = json['delivery_distance_charges'];
    deliveryDistanceKm = json['delivery_distance_km'];
    totalStores = json['total_stores'];
    totalDeliveryCharges = json['total_delivery_charges'];
    estimatedDeliveryTime = json['estimated_delivery_time'];
    useWallet = json['use_wallet'];
    promoCode = json['promo_code'];
    promoDiscount = json['promo_discount'].toString();
    final promoData = json['promo_applied'];
    if (promoData is Map<String, dynamic>) {
      promoApplied = PromoCodeData.fromJson(promoData);
    } else if (promoData is List && promoData.isNotEmpty) {
      promoApplied = PromoCodeData.fromJson(promoData.first);
    } else {
      promoApplied = null;
    }
    promoError = json['promo_error'];
    walletBalance = json['wallet_balance'];
    walletAmountUsed = double.parse(json['wallet_amount_used'].toString());
    payableAmount = json['payable_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['items_total'] = itemsTotal;
    data['per_store_drop_off_fee'] = perStoreDropOffFee;
    data['is_rush_delivery'] = isRushDelivery;
    data['is_rush_delivery_available'] = isRushDeliveryAvailable;
    data['delivery_charges'] = deliveryCharges;
    data['handling_charges'] = handlingCharges;
    data['delivery_distance_charges'] = deliveryDistanceCharges;
    data['delivery_distance_km'] = deliveryDistanceKm;
    data['total_stores'] = totalStores;
    data['total_delivery_charges'] = totalDeliveryCharges;
    data['estimated_delivery_time'] = estimatedDeliveryTime;
    data['use_wallet'] = useWallet;
    data['promo_code'] = promoCode;
    data['promo_discount'] = promoDiscount;
    if (promoApplied != null) {
      data['promo_applied'] = promoApplied!.toJson();
    }
    data['promo_error'] = promoError;
    data['wallet_balance'] = walletBalance;
    data['wallet_amount_used'] = walletAmountUsed;
    data['payable_amount'] = payableAmount;
    return data;
  }
}


class RemovedItems {
  String? productName;
  String? variantName;
  String? storeName;
  int? quantity;
  String? reason;

  RemovedItems(
      {this.productName,
        this.variantName,
        this.storeName,
        this.quantity,
        this.reason});

  RemovedItems.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    variantName = json['variant_name'];
    storeName = json['store_name'];
    quantity = json['quantity'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_name'] = productName;
    data['variant_name'] = variantName;
    data['store_name'] = storeName;
    data['quantity'] = quantity;
    data['reason'] = reason;
    return data;
  }
}

class DeliveryZone {
  bool? exists;
  String? zone;
  int? zoneCount;
  int? zoneId;
  int? handlingCharges;
  int? deliveryTimePerKm;
  bool? rushDeliveryEnabled;
  int? rushDeliveryTimePerKm;
  int? rushDeliveryCharges;
  int? regularDeliveryCharges;
  int? freeDeliveryAmount;
  int? distanceBasedDeliveryCharges;
  int? perStoreDropOffFee;
  int? bufferTime;
  bool? rushDeliveryAvailable;

  DeliveryZone(
      {this.exists,
        this.zone,
        this.zoneCount,
        this.zoneId,
        this.handlingCharges,
        this.deliveryTimePerKm,
        this.rushDeliveryEnabled,
        this.rushDeliveryTimePerKm,
        this.rushDeliveryCharges,
        this.regularDeliveryCharges,
        this.freeDeliveryAmount,
        this.distanceBasedDeliveryCharges,
        this.perStoreDropOffFee,
        this.bufferTime,
        this.rushDeliveryAvailable});

  DeliveryZone.fromJson(Map<String, dynamic> json) {
    exists = json['exists'];
    zone = json['zone'];
    zoneCount = json['zone_count'];
    zoneId = json['zone_id'];
    handlingCharges = json['handling_charges'];
    deliveryTimePerKm = json['delivery_time_per_km'];
    rushDeliveryEnabled = json['rush_delivery_enabled'];
    rushDeliveryTimePerKm = json['rush_delivery_time_per_km'];
    rushDeliveryCharges = json['rush_delivery_charges'];
    regularDeliveryCharges = json['regular_delivery_charges'];
    freeDeliveryAmount = json['free_delivery_amount'];
    distanceBasedDeliveryCharges = json['distance_based_delivery_charges'];
    perStoreDropOffFee = json['per_store_drop_off_fee'];
    bufferTime = json['buffer_time'];
    rushDeliveryAvailable = json['rush_delivery_available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exists'] = exists;
    data['zone'] = zone;
    data['zone_count'] = zoneCount;
    data['zone_id'] = zoneId;
    data['handling_charges'] = handlingCharges;
    data['delivery_time_per_km'] = deliveryTimePerKm;
    data['rush_delivery_enabled'] = rushDeliveryEnabled;
    data['rush_delivery_time_per_km'] = rushDeliveryTimePerKm;
    data['rush_delivery_charges'] = rushDeliveryCharges;
    data['regular_delivery_charges'] = regularDeliveryCharges;
    data['free_delivery_amount'] = freeDeliveryAmount;
    data['distance_based_delivery_charges'] = distanceBasedDeliveryCharges;
    data['per_store_drop_off_fee'] = perStoreDropOffFee;
    data['buffer_time'] = bufferTime;
    data['rush_delivery_available'] = rushDeliveryAvailable;
    return data;
  }
}
