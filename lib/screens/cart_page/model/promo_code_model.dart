class PromoCodeModel {
  bool? success;
  String? message;
  List<PromoCodeData>? data;

  PromoCodeModel({this.success, this.message, this.data});

  PromoCodeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PromoCodeData>[];
      json['data'].forEach((v) {
        data!.add(PromoCodeData.fromJson(v));
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

class PromoCodeData {
  int? id;
  String? code;
  String? description;
  String? startDate;
  String? endDate;
  String? discountType;
  String? discountAmount;
  String? promoMode;
  int? usageCount;
  int? individualUse;
  int? maxTotalUsage;
  int? maxUsagePerUser;
  String? minOrderTotal;
  String? maxDiscountValue;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  PromoCodeData(
      {this.id,
        this.code,
        this.description,
        this.startDate,
        this.endDate,
        this.discountType,
        this.discountAmount,
        this.promoMode,
        this.usageCount,
        this.individualUse,
        this.maxTotalUsage,
        this.maxUsagePerUser,
        this.minOrderTotal,
        this.maxDiscountValue,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  PromoCodeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
    promoMode = json['promo_mode'];
    usageCount = json['usage_count'];
    individualUse = json['individual_use'];
    maxTotalUsage = json['max_total_usage'];
    maxUsagePerUser = json['max_usage_per_user'];
    minOrderTotal = json['min_order_total'];
    maxDiscountValue = json['max_discount_value'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['description'] = description;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['discount_type'] = discountType;
    data['discount_amount'] = discountAmount;
    data['promo_mode'] = promoMode;
    data['usage_count'] = usageCount;
    data['individual_use'] = individualUse;
    data['max_total_usage'] = maxTotalUsage;
    data['max_usage_per_user'] = maxUsagePerUser;
    data['min_order_total'] = minOrderTotal;
    data['max_discount_value'] = maxDiscountValue;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

