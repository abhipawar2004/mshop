
class DeliveryBoyTrackingModel {
  bool? success;
  String? message;
  DeliveryBoyTrackingData? data;

  DeliveryBoyTrackingModel({this.success, this.message, this.data});

  DeliveryBoyTrackingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? DeliveryBoyTrackingData.fromJson(json['data']) : null;
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

class DeliveryBoyTrackingData {
  DeliveryBoyModel? deliveryBoy;
  Route? route;
  Order? order;

  DeliveryBoyTrackingData({this.deliveryBoy, this.route, this.order});

  DeliveryBoyTrackingData.fromJson(Map<String, dynamic> json) {
    deliveryBoy = json['delivery_boy'] != null
        ? DeliveryBoyModel.fromJson(json['delivery_boy'])
        : null;
    route = json['route'] != null ? Route.fromJson(json['route']) : null;
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (deliveryBoy != null) {
      data['delivery_boy'] = deliveryBoy!.toJson();
    }
    if (route != null) {
      data['route'] = route!.toJson();
    }
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class DeliveryBoyModel {
  bool? success;
  String? message;
  DeliveryBoyData? data;

  DeliveryBoyModel({this.success, this.message, this.data});

  DeliveryBoyModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? DeliveryBoyData.fromJson(json['data']) : null;
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

class DeliveryBoyData {
  int? id;
  int? deliveryBoyId;
  DeliveryBoy? deliveryBoy;
  String? latitude;
  String? longitude;
  int? recordedAt;
  String? createdAt;
  String? updatedAt;

  DeliveryBoyData(
      {this.id,
        this.deliveryBoyId,
        this.deliveryBoy,
        this.latitude,
        this.longitude,
        this.recordedAt,
        this.createdAt,
        this.updatedAt});

  DeliveryBoyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deliveryBoyId = json['delivery_boy_id'];
    deliveryBoy = json['delivery_boy'] != null
        ? DeliveryBoy.fromJson(json['delivery_boy'])
        : null;
    latitude = json['latitude'];
    longitude = json['longitude'];
    recordedAt = json['recorded_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['delivery_boy_id'] = deliveryBoyId;
    if (deliveryBoy != null) {
      data['delivery_boy'] = deliveryBoy!.toJson();
    }
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['recorded_at'] = recordedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class DeliveryBoy {
  int? id;
  int? userId;
  int? deliveryZoneId;
  String? status;
  String? fullName;
  String? address;
  List<String>? driverLicense;
  String? driverLicenseNumber;
  String? vehicleType;
  List<String>? vehicleRegistration;
  String? verificationStatus;
  String? verificationRemark;
  String? createdAt;

  DeliveryBoy(
      {this.id,
        this.userId,
        this.deliveryZoneId,
        this.status,
        this.fullName,
        this.address,
        this.driverLicense,
        this.driverLicenseNumber,
        this.vehicleType,
        this.vehicleRegistration,
        this.verificationStatus,
        this.verificationRemark,
        this.createdAt});

  DeliveryBoy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    deliveryZoneId = json['delivery_zone_id'];
    status = json['status'];
    fullName = json['full_name'];
    address = json['address'];
    driverLicense = json['driver_license'].cast<String>();
    driverLicenseNumber = json['driver_license_number'];
    vehicleType = json['vehicle_type'];
    vehicleRegistration = json['vehicle_registration'].cast<String>();
    verificationStatus = json['verification_status'];
    verificationRemark = json['verification_remark'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['delivery_zone_id'] = deliveryZoneId;
    data['status'] = status;
    data['full_name'] = fullName;
    data['address'] = address;
    data['driver_license'] = driverLicense;
    data['driver_license_number'] = driverLicenseNumber;
    data['vehicle_type'] = vehicleType;
    data['vehicle_registration'] = vehicleRegistration;
    data['verification_status'] = verificationStatus;
    data['verification_remark'] = verificationRemark;
    data['created_at'] = createdAt;
    return data;
  }
}

class Route {
  double? totalDistance;
  List<int>? route;
  List<RouteDetails>? routeDetails;

  Route({this.totalDistance, this.route, this.routeDetails});

  Route.fromJson(Map<String, dynamic> json) {
    totalDistance = json['total_distance'];
    route = json['route'].cast<int>();
    if (json['route_details'] != null) {
      routeDetails = <RouteDetails>[];
      json['route_details'].forEach((v) {
        routeDetails!.add(RouteDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_distance'] = totalDistance;
    data['route'] = route;
    if (routeDetails != null) {
      data['route_details'] =
          routeDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RouteDetails {
  int? storeId;
  String? storeName;
  double? distanceFromCustomer;
  String? address;
  String? city;
  String? landmark;
  String? state;
  String? zipcode;
  String? country;
  String? countryCode;
  double? latitude;
  double? longitude;
  dynamic distanceFromPrevious;

  RouteDetails(
      {this.storeId,
        this.storeName,
        this.distanceFromCustomer,
        this.address,
        this.city,
        this.landmark,
        this.state,
        this.zipcode,
        this.country,
        this.countryCode,
        this.latitude,
        this.longitude,
        this.distanceFromPrevious});

  RouteDetails.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    storeName = json['store_name'];
    distanceFromCustomer = double.tryParse(json['distance_from_customer'].toString());
    address = json['address'];
    city = json['city'];
    landmark = json['landmark'];
    state = json['state'];
    zipcode = json['zipcode'];
    country = json['country'];
    countryCode = json['country_code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    distanceFromPrevious = json['distance_from_previous'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_id'] = storeId;
    data['store_name'] = storeName;
    data['distance_from_customer'] = distanceFromCustomer;
    data['address'] = address;
    data['city'] = city;
    data['landmark'] = landmark;
    data['state'] = state;
    data['zipcode'] = zipcode;
    data['country'] = country;
    data['country_code'] = countryCode;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distance_from_previous'] = distanceFromPrevious;
    return data;
  }
}

class Order {
  int? id;
  String? uuid;
  String? slug;
  int? userId;
  String? email;
  String? currencyCode;
  String? currencyRate;
  String? paymentMethod;
  String? paymentStatus;
  String? status;
  String? invoice;
  String? fulfillmentType;
  int? estimatedDeliveryTime;
  dynamic deliveryTimeSlotId;
  int? deliveryBoyId;
  String? deliveryBoyName;
  int? deliveryBoyPhone;
  String? deliveryBoyProfile;
  bool? isDeliveryFeedbackGiven;
  dynamic deliveryFeedback;
  String? walletBalance;
  dynamic promoCode;
  String? promoDiscount;
  dynamic giftCard;
  String? giftCardDiscount;
  String? deliveryCharge;
  String? subtotal;
  String? totalPayable;
  String? finalTotal;
  String? shippingName;
  String? shippingAddress1;
  dynamic shippingAddress2;
  String? shippingLandmark;
  String? shippingZip;
  String? shippingPhone;
  String? shippingAddressType;
  String? shippingLatitude;
  String? shippingLongitude;
  String? shippingCity;
  String? shippingState;
  String? shippingCountry;
  String? shippingCountryCode;
  String? orderNote;
  List<Items>? items;
  String? createdAt;
  String? updatedAt;

  Order(
      {this.id,
        this.uuid,
        this.slug,
        this.userId,
        this.email,
        this.currencyCode,
        this.currencyRate,
        this.paymentMethod,
        this.paymentStatus,
        this.status,
        this.invoice,
        this.fulfillmentType,
        this.estimatedDeliveryTime,
        this.deliveryTimeSlotId,
        this.deliveryBoyId,
        this.deliveryBoyName,
        this.deliveryBoyPhone,
        this.deliveryBoyProfile,
        this.isDeliveryFeedbackGiven,
        this.deliveryFeedback,
        this.walletBalance,
        this.promoCode,
        this.promoDiscount,
        this.giftCard,
        this.giftCardDiscount,
        this.deliveryCharge,
        this.subtotal,
        this.totalPayable,
        this.finalTotal,
        this.shippingName,
        this.shippingAddress1,
        this.shippingAddress2,
        this.shippingLandmark,
        this.shippingZip,
        this.shippingPhone,
        this.shippingAddressType,
        this.shippingLatitude,
        this.shippingLongitude,
        this.shippingCity,
        this.shippingState,
        this.shippingCountry,
        this.shippingCountryCode,
        this.orderNote,
        this.items,
        this.createdAt,
        this.updatedAt});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    slug = json['slug'];
    userId = json['user_id'];
    email = json['email'];
    currencyCode = json['currency_code'];
    currencyRate = json['currency_rate'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    status = json['status'];
    invoice = json['invoice'];
    fulfillmentType = json['fulfillment_type'];
    estimatedDeliveryTime = json['estimated_delivery_time'];
    deliveryTimeSlotId = json['delivery_time_slot_id'];
    deliveryBoyId = json['delivery_boy_id'];
    deliveryBoyName = json['delivery_boy_name'];
    deliveryBoyPhone = json['delivery_boy_phone'];
    deliveryBoyProfile = json['delivery_boy_profile'];
    isDeliveryFeedbackGiven = json['is_delivery_feedback_given'];
    deliveryFeedback = json['delivery_feedback'];
    walletBalance = json['wallet_balance'];
    promoCode = json['promo_code'];
    promoDiscount = json['promo_discount'];
    giftCard = json['gift_card'];
    giftCardDiscount = json['gift_card_discount'];
    deliveryCharge = json['delivery_charge'];
    subtotal = json['subtotal'];
    totalPayable = json['total_payable'];
    finalTotal = json['final_total'];
    shippingName = json['shipping_name'];
    shippingAddress1 = json['shipping_address_1'];
    shippingAddress2 = json['shipping_address_2'];
    shippingLandmark = json['shipping_landmark'];
    shippingZip = json['shipping_zip'];
    shippingPhone = json['shipping_phone'];
    shippingAddressType = json['shipping_address_type'];
    shippingLatitude = json['shipping_latitude'];
    shippingLongitude = json['shipping_longitude'];
    shippingCity = json['shipping_city'];
    shippingState = json['shipping_state'];
    shippingCountry = json['shipping_country'];
    shippingCountryCode = json['shipping_country_code'];
    orderNote = json['order_note'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['slug'] = slug;
    data['user_id'] = userId;
    data['email'] = email;
    data['currency_code'] = currencyCode;
    data['currency_rate'] = currencyRate;
    data['payment_method'] = paymentMethod;
    data['payment_status'] = paymentStatus;
    data['status'] = status;
    data['invoice'] = invoice;
    data['fulfillment_type'] = fulfillmentType;
    data['estimated_delivery_time'] = estimatedDeliveryTime;
    data['delivery_time_slot_id'] = deliveryTimeSlotId;
    data['delivery_boy_id'] = deliveryBoyId;
    data['delivery_boy_name'] = deliveryBoyName;
    data['delivery_boy_phone'] = deliveryBoyPhone;
    data['delivery_boy_profile'] = deliveryBoyProfile;
    data['is_delivery_feedback_given'] = isDeliveryFeedbackGiven;
    data['delivery_feedback'] = deliveryFeedback;
    data['wallet_balance'] = walletBalance;
    data['promo_code'] = promoCode;
    data['promo_discount'] = promoDiscount;
    data['gift_card'] = giftCard;
    data['gift_card_discount'] = giftCardDiscount;
    data['delivery_charge'] = deliveryCharge;
    data['subtotal'] = subtotal;
    data['total_payable'] = totalPayable;
    data['final_total'] = finalTotal;
    data['shipping_name'] = shippingName;
    data['shipping_address_1'] = shippingAddress1;
    data['shipping_address_2'] = shippingAddress2;
    data['shipping_landmark'] = shippingLandmark;
    data['shipping_zip'] = shippingZip;
    data['shipping_phone'] = shippingPhone;
    data['shipping_address_type'] = shippingAddressType;
    data['shipping_latitude'] = shippingLatitude;
    data['shipping_longitude'] = shippingLongitude;
    data['shipping_city'] = shippingCity;
    data['shipping_state'] = shippingState;
    data['shipping_country'] = shippingCountry;
    data['shipping_country_code'] = shippingCountryCode;
    data['order_note'] = orderNote;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Items {
  int? id;
  int? orderId;
  int? productId;
  int? productVariantId;
  int? storeId;
  int? sellerId;
  String? sellerName;
  String? title;
  String? variantTitle;
  String? giftCardDiscount;
  String? adminCommissionAmount;
  String? sellerCommissionAmount;
  String? commissionSettled;
  String? discountedPrice;
  String? promoDiscount;
  String? discount;
  String? taxAmount;
  String? taxPercent;
  String? sku;
  int? quantity;
  String? price;
  String? subtotal;
  String? status;
  dynamic otp;
  int? otpVerified;
  bool? isUserReviewGiven;
  dynamic userReview;
  Product? product;
  Variant? variant;
  Store? store;
  String? createdAt;
  String? updatedAt;

  Items(
      {this.id,
        this.orderId,
        this.productId,
        this.productVariantId,
        this.storeId,
        this.sellerId,
        this.sellerName,
        this.title,
        this.variantTitle,
        this.giftCardDiscount,
        this.adminCommissionAmount,
        this.sellerCommissionAmount,
        this.commissionSettled,
        this.discountedPrice,
        this.promoDiscount,
        this.discount,
        this.taxAmount,
        this.taxPercent,
        this.sku,
        this.quantity,
        this.price,
        this.subtotal,
        this.status,
        this.otp,
        this.otpVerified,
        this.isUserReviewGiven,
        this.userReview,
        this.product,
        this.variant,
        this.store,
        this.createdAt,
        this.updatedAt});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    productVariantId = json['product_variant_id'];
    storeId = json['store_id'];
    sellerId = json['seller_id'];
    sellerName = json['seller_name'];
    title = json['title'];
    variantTitle = json['variant_title'];
    giftCardDiscount = json['gift_card_discount'];
    adminCommissionAmount = json['admin_commission_amount'];
    sellerCommissionAmount = json['seller_commission_amount'];
    commissionSettled = json['commission_settled'];
    discountedPrice = json['discounted_price'];
    promoDiscount = json['promo_discount'];
    discount = json['discount'];
    taxAmount = json['tax_amount'];
    taxPercent = json['tax_percent'];
    sku = json['sku'];
    quantity = json['quantity'];
    price = json['price'];
    subtotal = json['subtotal'];
    status = json['status'];
    otp = json['otp'];
    otpVerified = json['otp_verified'];
    isUserReviewGiven = json['is_user_review_given'];
    userReview = json['user_review'];
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
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['product_variant_id'] = productVariantId;
    data['store_id'] = storeId;
    data['seller_id'] = sellerId;
    data['seller_name'] = sellerName;
    data['title'] = title;
    data['variant_title'] = variantTitle;
    data['gift_card_discount'] = giftCardDiscount;
    data['admin_commission_amount'] = adminCommissionAmount;
    data['seller_commission_amount'] = sellerCommissionAmount;
    data['commission_settled'] = commissionSettled;
    data['discounted_price'] = discountedPrice;
    data['promo_discount'] = promoDiscount;
    data['discount'] = discount;
    data['tax_amount'] = taxAmount;
    data['tax_percent'] = taxPercent;
    data['sku'] = sku;
    data['quantity'] = quantity;
    data['price'] = price;
    data['subtotal'] = subtotal;
    data['status'] = status;
    data['otp'] = otp;
    data['otp_verified'] = otpVerified;
    data['is_user_review_given'] = isUserReviewGiven;
    data['user_review'] = userReview;
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
  bool? isReturnable;
  int? returnableDays;
  bool? isCancelable;
  dynamic cancelableTill;
  String? image;
  int? requiresOtp;

  Product(
      {this.id,
        this.name,
        this.slug,
        this.isReturnable,
        this.returnableDays,
        this.isCancelable,
        this.cancelableTill,
        this.image,
        this.requiresOtp});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    isReturnable = json['is_returnable'];
    returnableDays = json['returnable_days'];
    isCancelable = json['is_cancelable'];
    cancelableTill = json['cancelable_till'];
    image = json['image'];
    requiresOtp = json['requires_otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['is_returnable'] = isReturnable;
    data['returnable_days'] = returnableDays;
    data['is_cancelable'] = isCancelable;
    data['cancelable_till'] = cancelableTill;
    data['image'] = image;
    data['requires_otp'] = requiresOtp;
    return data;
  }
}

class Variant {
  int? id;
  String? title;
  String? slug;
  String? image;

  Variant({this.id, this.title, this.slug, this.image});

  Variant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['image'] = image;
    return data;
  }
}

class Store {
  int? id;
  String? name;
  String? slug;

  Store({this.id, this.name, this.slug});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}
