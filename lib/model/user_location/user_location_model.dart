import 'package:hive_flutter/hive_flutter.dart';

import '../../config/constant.dart';

part 'user_location_model.g.dart';

@HiveType(typeId: 0)
class UserLocation extends HiveObject {
  @HiveField(0)
  double latitude;

  @HiveField(1)
  double longitude;

  @HiveField(2)
  String fullAddress;

  @HiveField(3)
  String area;

  @HiveField(4)
  String city;

  @HiveField(5)
  String state;

  @HiveField(6)
  String country;

  @HiveField(7)
  String pincode;

  @HiveField(8)
  String landmark;

  @HiveField(9)
  late String id;

  UserLocation({
    required this.latitude,
    required this.longitude,
    required this.fullAddress,
    required this.area,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.landmark,
    String? id
  }) {
    this.id = id ?? generateId(latitude, longitude, fullAddress);
  }
}
