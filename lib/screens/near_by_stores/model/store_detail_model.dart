import 'near_by_store_model.dart';

class StoreDetailModel {
  bool? success;
  String? message;
  StoreData? data;

  StoreDetailModel({this.success, this.message, this.data});

  StoreDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? StoreData.fromJson(json['data']) : null;
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

