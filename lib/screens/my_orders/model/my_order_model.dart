class MyOrdersListModel {
  bool? success;
  String? message;
  MyOrdersListData? data;

  MyOrdersListModel({this.success, this.message, this.data});

  MyOrdersListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? MyOrdersListData.fromJson(json['data'])
        : null;
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

class MyOrdersListData {
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;
  List<MyOrdersData>? data;

  MyOrdersListData(
      {this.currentPage, this.lastPage, this.perPage, this.total, this.data});

  MyOrdersListData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
    if (json['data'] != null) {
      data = <MyOrdersData>[];
      json['data'].forEach((v) {
        data!.add(MyOrdersData.fromJson(v));
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

class MyOrdersData {
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
  String? deliveryTimeSlotId;
  int? deliveryBoyId;
  String? deliveryBoyName;
  int? deliveryBoyPhone;
  String? deliveryBoyProfile;
  bool? isDeliveryFeedbackGiven;
  List<DeliveryBoyFeedbacks>? deliveryFeedback;
  String? walletBalance;
  String? promoCode;
  String? promoDiscount;
  String? giftCard;
  String? giftCardDiscount;
  String? deliveryCharge;
  String? subtotal;
  String? totalPayable;
  String? finalTotal;
  String? shippingName;
  String? shippingAddress1;
  String? shippingAddress2;
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
  List<SellerFeedbacks>? sellerFeedbacks;
  List<MyOrdersItems>? items;
  String? createdAt;
  String? updatedAt;

  MyOrdersData({
    this.id,
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
    this.updatedAt,
    this.sellerFeedbacks,
  });

  MyOrdersData.fromJson(Map<String, dynamic> json) {
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

    if (json['delivery_feedback'] != null && json['delivery_feedback'] is List) {
      if ((json['delivery_feedback'] as List).isNotEmpty) {
        deliveryFeedback = (json['delivery_feedback'] as List)
            .map((v) => DeliveryBoyFeedbacks.fromJson(v))
            .toList();
      } else {
        deliveryFeedback = [];
      }
    } else {
      deliveryFeedback = null;
    }

    walletBalance = json['wallet_balance'].toString();
    promoCode = json['promo_code'];
    promoDiscount = json['promo_discount'];
    giftCard = json['gift_card'];
    giftCardDiscount = json['gift_card_discount'];
    deliveryCharge = json['delivery_charge'].toString();
    subtotal = json['subtotal'].toString();
    totalPayable = json['total_payable'].toString();
    finalTotal = json['final_total'].toString();
    shippingName = json['shipping_name'];
    shippingAddress1 = json['shipping_address_1'].toString();
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
      items = <MyOrdersItems>[];
      json['items'].forEach((v) {
        items!.add(MyOrdersItems.fromJson(v));
      });
    }

    if (json['seller_feedbacks'] != null) {
      sellerFeedbacks = <SellerFeedbacks>[];
      json['seller_feedbacks'].forEach((v) {
        sellerFeedbacks!.add(SellerFeedbacks.fromJson(v));
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

    if (deliveryFeedback != null) {
      data['delivery_feedback'] =
          deliveryFeedback!.map((v) => v.toJson()).toList();
    }

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

    if (sellerFeedbacks != null) {
      data['seller_feedbacks'] =
          sellerFeedbacks!.map((v) => v.toJson()).toList();
    }

    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class DeliveryBoyFeedbacks {
  int? id;
  String? title;
  String? slug;
  String? description;
  int? rating;
  String? createdAt;

  DeliveryBoyFeedbacks({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.rating,
    this.createdAt,
  });

  DeliveryBoyFeedbacks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    rating = json['rating'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['description'] = description;
    data['rating'] = rating;
    data['created_at'] = createdAt;
    return data;
  }
}

class SellerFeedbacks {
  int? sellerId;
  bool? isFeedbackGiven;
  SellerFeedbackData? feedback;

  SellerFeedbacks({this.sellerId, this.isFeedbackGiven, this.feedback});

  SellerFeedbacks.fromJson(Map<String, dynamic> json) {
    sellerId = json['seller_id'];
    isFeedbackGiven = json['is_feedback_given'];
    if (json['feedback'] is Map<String, dynamic>) {
      feedback = SellerFeedbackData.fromJson(json['feedback']);
    } else {
      feedback = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seller_id'] = sellerId;
    data['is_feedback_given'] = isFeedbackGiven;
    if (feedback != null) {
      data['feedback'] = feedback!.toJson();
    }
    return data;
  }
}

class SellerFeedbackData {
  int? id;
  int? userId;
  int? sellerId;
  int? orderId;
  int? orderItemId;
  int? storeId;
  int? rating;
  String? title;
  String? slug;
  String? description;
  String? createdAt;
  String? updatedAt;

  SellerFeedbackData(
      {this.id,
        this.userId,
        this.sellerId,
        this.orderId,
        this.orderItemId,
        this.storeId,
        this.rating,
        this.title,
        this.slug,
        this.description,
        this.createdAt,
        this.updatedAt});

  SellerFeedbackData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    sellerId = json['seller_id'];
    orderId = json['order_id'];
    orderItemId = json['order_item_id'];
    storeId = json['store_id'];
    rating = json['rating'];
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['seller_id'] = sellerId;
    data['order_id'] = orderId;
    data['order_item_id'] = orderItemId;
    data['store_id'] = storeId;
    data['rating'] = rating;
    data['title'] = title;
    data['slug'] = slug;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}


class MyOrdersItems {
  int? id;
  int? orderId;
  int? productId;
  int? productVariantId;
  int? storeId;
  int? sellerId;
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
  String? otp;
  int? otpVerified;
  bool? isUserReviewGiven;
  UserReview? userReview;
  Product? product;
  Variant? variant;
  Store? store;
  String? createdAt;
  String? updatedAt;

  MyOrdersItems(
      {this.id,
      this.orderId,
      this.productId,
      this.productVariantId,
      this.storeId,
      this.sellerId,
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

  MyOrdersItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    productVariantId = json['product_variant_id'];
    storeId = json['store_id'];
    sellerId = json['seller_id'];
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
    userReview = json['user_review'] != null
        ? UserReview.fromJson(json['user_review'])
        : null;
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
    if (userReview != null) {
      data['user_review'] = userReview!.toJson();
    }
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

class UserReview {
  int? id;
  int? productId;
  int? rating;
  String? title;
  String? slug;
  String? comment;
  List<String>? reviewImages;
  User? user;
  String? createdAt;

  UserReview(
      {this.id,
      this.productId,
      this.rating,
      this.title,
      this.slug,
      this.comment,
      this.reviewImages,
      this.user,
      this.createdAt});

  UserReview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    rating = json['rating'];
    title = json['title'];
    slug = json['slug'];
    comment = json['comment'];
    reviewImages = json['review_images'].cast<String>();
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['rating'] = rating;
    data['title'] = title;
    data['slug'] = slug;
    data['comment'] = comment;
    data['review_images'] = reviewImages;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

class User {
  int? id;
  String? name;

  User({this.id, this.name});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? slug;
  String? image;
  int? requiresOtp;

  Product({this.id, this.name, this.slug, this.image, this.requiresOtp});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    requiresOtp = json['requires_otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
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
