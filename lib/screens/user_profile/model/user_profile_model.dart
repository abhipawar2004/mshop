class UserProfileModel {
  bool? success;
  String? message;
  UserData? data;

  UserProfileModel({this.success, this.message, this.data});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
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

class UserData {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? country;
  String? iso2;
  dynamic walletBalance;
  String? referralCode;
  String? friendsCode;
  int? rewardPoints;
  String? profileImage;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  UserData(
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

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    country = json['country'];
    iso2 = json['iso_2'];
    walletBalance = json['wallet_balance'];
    referralCode = json['referral_code'];
    friendsCode = json['friends_code'];
    rewardPoints = json['reward_points'];
    profileImage = json['profile_image'];
    emailVerifiedAt = json['email_verified_at'];
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
