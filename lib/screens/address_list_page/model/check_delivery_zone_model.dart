class CheckDeliveryZoneModel {
  bool? success;
  String? message;
  DeliveryZoneData? data;

  CheckDeliveryZoneModel({this.success, this.message, this.data});

  CheckDeliveryZoneModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? DeliveryZoneData.fromJson(json['data']) : null;
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

class DeliveryZoneData {
  bool? isDeliverable;
  int? zoneCount;
  String? zone;
  dynamic zoneId;
  Coordinates? coordinates;

  DeliveryZoneData(
      {this.isDeliverable,
        this.zoneCount,
        this.zone,
        this.zoneId,
        this.coordinates});

  DeliveryZoneData.fromJson(Map<String, dynamic> json) {
    isDeliverable = json['is_deliverable'];
    zoneCount = json['zone_count'];
    zone = json['zone'];
    zoneId = json['zone_id'];
    coordinates = json['coordinates'] != null
        ? Coordinates.fromJson(json['coordinates'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_deliverable'] = isDeliverable;
    data['zone_count'] = zoneCount;
    data['zone'] = zone;
    data['zone_id'] = zoneId;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.toJson();
    }
    return data;
  }
}

class Coordinates {
  double? latitude;
  double? longitude;

  Coordinates({this.latitude, this.longitude});

  Coordinates.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
