import 'package:hyper_local/screens/home_page/model/banner_model.dart';

class AuthModel {
  bool? success;
  String? message;
  String? accessToken;
  String? tokenType;
  Data? data;

  AuthModel(
      {this.success,
        this.message,
        this.accessToken,
        this.tokenType,
        this.data});

  AuthModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['access_token'] = accessToken;
    data['token_type'] = tokenType;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? country;
  String? iso2;
  int? walletBalance;
  String? referralCode;
  String? friendsCode;
  int? rewardPoints;
  String? profileImage;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.name,
        this.email,
        this.mobile,
        this.country,
        this.iso2,
        this.walletBalance,
        this.referralCode,
        this.friendsCode,
        this.rewardPoints,
        this.profileImage,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    country = parseString(['country']);
    iso2 = parseString(['iso_2']);
    walletBalance = parseInt(['wallet_balance']);
    referralCode = parseString(['referral_code']);
    friendsCode = parseString(['friends_code']);
    rewardPoints = parseInt(['reward_points']);
    profileImage = parseString(['profile_image']);
    emailVerifiedAt = parseString(['email_verified_at']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['country'] = country;
    data['iso_2'] = iso2;
    data['wallet_balance'] = walletBalance;
    data['referral_code'] = referralCode;
    data['friends_code'] = friendsCode;
    data['reward_points'] = rewardPoints;
    data['profile_image'] = profileImage;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
